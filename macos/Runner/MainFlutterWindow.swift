import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    _registerOpenWithChannel(controller: flutterViewController)

    super.awakeFromNib()
  }

  private func _registerOpenWithChannel(controller: FlutterViewController) {
    let messenger = controller.engine.binaryMessenger

    let methodChannel = FlutterMethodChannel(
      name: "com.pdf_reader/pdf_reader",
      binaryMessenger: messenger
    )
    methodChannel.setMethodCallHandler { call, result in
      if call.method == "getInitialFileUri" {
        let path = AppDelegate.initialFilePath
        if path != nil {
          AppDelegate.initialFilePath = nil
        }
        result(path)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    let eventChannel = FlutterEventChannel(
      name: "com.pdf_reader/pdf_reader_events",
      binaryMessenger: messenger
    )
    eventChannel.setStreamHandler(OpenFileStreamHandler())
  }
}

private class OpenFileStreamHandler: NSObject, FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    AppDelegate.initialFileEventSink = { path in
      DispatchQueue.main.async {
        events(path)
        AppDelegate.initialFilePath = nil
      }
    }
    if let path = AppDelegate.initialFilePath {
      AppDelegate.initialFilePath = nil
      DispatchQueue.main.async { events(path) }
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    AppDelegate.initialFileEventSink = nil
    return nil
  }
}
