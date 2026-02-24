package com.pdf_reader.pdf_reader

import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.Locale

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.pdf_reader/pdf_reader"
        private const val REQUEST_PICK_TREE = 9001
        private val SUPPORTED_EXT = setOf(
            "pdf", "doc", "docx", "ppt", "pptx", "txt", "md", "markdown"
        )
    }

    private var pendingPickResult: MethodChannel.Result? = null

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
}
