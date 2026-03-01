import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  /// 从“用本应用打开”传入的文件 URL，供 Flutter 通过 getInitialFileUri 获取
  static var initialFileUrl: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let url = launchOptions?[.url] as? URL {
      AppDelegate.initialFileUrl = url.path
    }
    GeneratedPluginRegistrant.register(with: self)
    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    _registerOpenWithChannel()
    return didFinish
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    AppDelegate.initialFileUrl = url.path
    return true
  }

  private func _registerOpenWithChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else { return }
    let channel = FlutterMethodChannel(
      name: "com.pdf_reader/pdf_reader",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "getInitialFileUri" {
        let url = AppDelegate.initialFileUrl
        if url != nil {
          AppDelegate.initialFileUrl = nil
        }
        result(url)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
