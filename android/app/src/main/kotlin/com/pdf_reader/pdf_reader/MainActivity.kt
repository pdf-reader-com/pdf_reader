package com.pdf_reader.pdf_reader

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.OpenableColumns
import android.provider.Settings
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.Locale
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        // 必须在 super.onCreate() 之前保存，否则 Flutter 引擎启动后 Dart 会先调用 getInitialFileUri 得到 null
        if (intent?.action == Intent.ACTION_VIEW && intent?.data != null) {
            initialFileUri = intent!!.data!!.toString()
        }
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action == Intent.ACTION_VIEW && intent.data != null) {
            initialFileUri = intent.data!!.toString()
        }
    }

    companion object {
        private const val CHANNEL = "com.pdf_reader/pdf_reader"
        private const val REQUEST_PICK_TREE = 9001
        private val SUPPORTED_EXT = setOf(
            "pdf", "epub", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "md", "markdown"
        )
    }

    private var pendingPickResult: MethodChannel.Result? = null

    /** 从“用本应用打开”或冷启动传入的文件 URI，供 Flutter 通过 getInitialFileUri 获取 */
    private var initialFileUri: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickDirectory" -> {
                    if (pendingPickResult != null) {
                        result.error("BUSY", "Pick already in progress", null)
                        return@setMethodCallHandler
                    }
                    pendingPickResult = result
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
                    startActivityForResult(intent, REQUEST_PICK_TREE)
                }
                "listFilesFromTreeUri" -> {
                    val uriStr = call.argument<String>("uri") ?: run {
                        result.error("INVALID", "uri is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(uriStr)
                        val list = listFilesFromTreeUri(uri)
                        result.success(list)
                    } catch (e: Exception) {
                        result.error("LIST_FAILED", e.message, null)
                    }
                }
                "openContentUriToTemp" -> {
                    val uriStr = call.argument<String>("uri") ?: run {
                        result.error("INVALID", "uri is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val path = openContentUriToTemp(uriStr)
                        result.success(path)
                    } catch (e: Exception) {
                        result.error("OPEN_FAILED", e.message, null)
                    }
                }
                "getInitialFileUri" -> {
                    val uri = initialFileUri
                        ?: intent?.takeIf { it.action == Intent.ACTION_VIEW }?.data?.toString()
                    initialFileUri = null
                    if (uri != null && intent?.action == Intent.ACTION_VIEW) {
                        setIntent(Intent())
                    }
                    result.success(uri)
                }
                "hasAllFilesAccess" -> {
                    result.success(hasAllFilesAccess())
                }
                "requestAllFilesAccess" -> {
                    if (hasAllFilesAccess()) {
                        result.success(true)
                        return@setMethodCallHandler
                    }
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION).apply {
                            data = Uri.fromParts("package", packageName, null)
                        }
                        startActivity(intent)
                        result.success(null) // 仅表示已打开设置页，不表示用户已授权
                    } catch (e: Exception) {
                        result.error("OPEN_SETTINGS_FAILED", e.message, null)
                    }
                }
                "listAllFilesFromStorage" -> {
                    if (!hasAllFilesAccess()) {
                        result.error("NO_ACCESS", "All files access not granted", null)
                        return@setMethodCallHandler
                    }
                    val executor = Executors.newSingleThreadExecutor()
                    executor.execute {
                        try {
                            val list = listAllFilesFromStorageSync()
                            runOnUiThread { result.success(list) }
                        } catch (e: Exception) {
                            runOnUiThread { result.error("SCAN_FAILED", e.message, null) }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_PICK_TREE) {
            val result = pendingPickResult
            pendingPickResult = null
            if (resultCode != RESULT_OK || data?.data == null) {
                result?.success(null)
                return
            }
            val treeUri = data.data!!
            contentResolver.takePersistableUriPermission(
                treeUri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )
            result?.success(treeUri.toString())
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun listFilesFromTreeUri(treeUri: Uri): List<Map<String, Any?>> {
        val list = mutableListOf<Map<String, Any?>>()
        val docFile = DocumentFile.fromTreeUri(this, treeUri) ?: return list
        collectFiles(docFile, list)
        return list
    }

    private fun collectFiles(
        dir: DocumentFile,
        out: MutableList<Map<String, Any?>>
    ) {
        val files = dir.listFiles() ?: return
        for (file in files) {
            if (file.isDirectory) {
                collectFiles(file, out)
            } else {
                val name = file.name ?: continue
                val ext = name.substringAfterLast('.', "").lowercase(Locale.ROOT)
                if (ext !in SUPPORTED_EXT) continue
                val uri = file.uri
                out.add(
                    mapOf(
                        "path" to uri.toString(),
                        "name" to name,
                        "size" to file.length(),
                        "lastModified" to (file.lastModified() ?: 0L),
                        "extension" to ".$ext"
                    )
                )
            }
        }
    }

    private fun openContentUriToTemp(uriStr: String): String {
        val uri = Uri.parse(uriStr)
        val fileName = resolveFileName(uri) ?: "document"
        val cacheDir = File(cacheDir, "content_uri_cache").apply { mkdirs() }
        val tempFile = File(cacheDir, "${System.currentTimeMillis()}_$fileName")
        contentResolver.openInputStream(uri)?.use { input ->
            FileOutputStream(tempFile).use { output ->
                input.copyTo(output)
            }
        } ?: throw IllegalStateException("Cannot open URI: $uriStr")
        return tempFile.absolutePath
    }

    private fun resolveFileName(uri: Uri): String? {
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                val idx = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (idx >= 0) return cursor.getString(idx)
            }
        }
        return uri.lastPathSegment
    }

    private fun hasAllFilesAccess(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else {
            false
        }
    }

    /** 在已具备全盘权限时递归扫描外部存储，返回与 listFilesFromTreeUri 相同格式的列表（path 为绝对路径） */
    private fun listAllFilesFromStorageSync(): List<Map<String, Any?>> {
        val out = mutableListOf<Map<String, Any?>>()
        val root = Environment.getExternalStorageDirectory()
        if (root.exists() && root.isDirectory) {
            collectFilesFromFile(root, out)
        }
        return out
    }

    private fun collectFilesFromFile(dir: File, out: MutableList<Map<String, Any?>>) {
        val files = dir.listFiles() ?: return
        for (file in files) {
            if (file.isDirectory) {
                collectFilesFromFile(file, out)
            } else {
                val name = file.name ?: continue
                val ext = name.substringAfterLast('.', "").lowercase(Locale.ROOT)
                if (ext !in SUPPORTED_EXT) continue
                out.add(
                    mapOf(
                        "path" to file.absolutePath,
                        "name" to name,
                        "size" to file.length(),
                        "lastModified" to file.lastModified(),
                        "extension" to ".$ext"
                    )
                )
            }
        }
    }
}
