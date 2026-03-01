import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  /// 从“用本应用打开”或双击文件传入的路径，供 Flutter 通过 getInitialFileUri 获取
  static var initialFilePath: String?
  /// 有文件传入时主动推送给 Flutter（解决系统晚于首帧才调用 openFiles 的情况）
  static var initialFileEventSink: ((String) -> Void)?

  override func applicationWillFinishLaunching(_ notification: Notification) {
    super.applicationWillFinishLaunching(notification)
    // 首次通过「打开方式」启动时，系统可能通过命令行参数传文件路径而非 openFiles
    let args = CommandLine.arguments
    if args.count > 1 {
      for i in 1..<args.count {
        var path = args[i]
        if path.hasPrefix("file://") {
          path = (path as NSString).substring(from: 7).removingPercentEncoding ?? path
        }
        path = (path as NSString).standardizingPath
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir), !isDir.boolValue {
          AppDelegate.initialFilePath = path
          break
        }
      }
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  private func _handleOpenFile(path: String) {
    AppDelegate.initialFilePath = path
    if let sink = AppDelegate.initialFileEventSink {
      DispatchQueue.main.async { sink(path) }
    }
  }

  override func application(_ sender: NSApplication, openFile filename: String) -> Bool {
    _handleOpenFile(path: filename)
    return true
  }

  override func application(_ sender: NSApplication, openFiles filenames: [String]) {
    guard let first = filenames.first else {
      NSApp.reply(toOpenOrPrint: .failure)
      return
    }
    _handleOpenFile(path: first)
    NSApp.reply(toOpenOrPrint: .success)
  }

  override func application(_ application: NSApplication, open urls: [URL]) {
    guard let first = urls.first else { return }
    _handleOpenFile(path: first.path)
  }
}
