# "Open With" File Type Support

This document describes the file types supported for "Open with this app" on each platform, the current implementation, and known issues.

## Overview

Supported file types can be opened from the system file manager / Finder via "Open With" → this app. The intended behavior is: after the app launches, **open that file directly** to the preview screen, rather than only showing the app home screen.

- **Supported formats**: PDF, EPUB, Word/Excel/PPT (including .doc/.docx/.xls/.xlsx/.ppt/.pptx), plain text, Markdown
- **Platforms**: Android, iOS, macOS

---

## Current Implementation

### 1. Android

**Status: Working as expected** (selecting "Open with this app" opens the file directly)

#### Configuration

- **`android/app/src/main/AndroidManifest.xml`**
  - Add `ACTION_VIEW` intent-filter on MainActivity, declaring supported MIME types and `file`/`content` scheme.

#### Native logic (`MainActivity.kt`)

- **Before `super.onCreate()`**, read when `intent.action == ACTION_VIEW` and `intent.data != null`, store the URI in `initialFileUri` (if saved after `super.onCreate()`, Flutter will call `getInitialFileUri` first and get null).
- In `onNewIntent`, also save the VIEW intent's data for when the user chooses "Open with" again while the app is already running.
- MethodChannel `com.pdf_reader/pdf_reader` provides **`getInitialFileUri`**: returns and clears `initialFileUri`; if none, read current `intent` and clear it to avoid opening twice.

#### Flutter side (`lib/pages/home_page.dart`)

- After first frame, `_openInitialFileIfAny()`: delay 100ms, then call `getInitialFileUri`; if empty, delay 200ms and retry once; with URI, use `ReaderFile.fromPath(uri)` and `_onTapFile(file)` to open preview.

---

### 2. iOS

**Status: Implementation complete, relies on polling and launchOptions**

#### Configuration

- **`ios/Runner/Info.plist`**
  - `CFBundleDocumentTypes` declares PDF, EPUB, Word, Excel, PPT, plain text, Markdown, etc. (UTType).

#### Native logic (`AppDelegate.swift`)

- In `didFinishLaunchingWithOptions`, read the launch URL from **`launchOptions?[.url]`**, write to `initialFileUrl` (path).
- In `application(_:open:options:)`, save the given `url.path` to `initialFileUrl`.
- Register MethodChannel `com.pdf_reader/pdf_reader`, handle only **`getInitialFileUri`**, return and clear `initialFileUrl` (clear only when it has a value).

#### Flutter side

- In `_openInitialFileIfAny()`, for iOS and macOS use **polling**: if the first `getInitialFileUri` is empty, call again with delays [100, 200, 400] ms to handle the case where the system delivers the file after the first frame.

---

### 3. macOS

**Status: App appears in "Open With" and launches, but does not open the file directly (known issue)**

#### Configuration

- **`macos/Runner/Info.plist`**
  - `CFBundleDocumentTypes` same as iOS, declaring the file types above.

#### Native logic

**AppDelegate.swift**

- **`applicationWillFinishLaunching`**: read arguments from **`CommandLine.arguments`** (from index 1), support `file://` and plain paths, take the first "existing file" path and write to `initialFilePath` (for the case where "Open With" on first launch may not call openFiles).
- **`application(_:openFile:)`** (single file), **`application(_:openFiles:)`**, **`application(_:open urls:)`**: all use `_handleOpenFile(path:)` to write `initialFilePath` and push to Flutter on the main thread via `initialFileEventSink`; in `openFiles`, call **`NSApp.reply(toOpenOrPrint: .success)`**.

**MainFlutterWindow.swift**

- **MethodChannel** `com.pdf_reader/pdf_reader`: handle **`getInitialFileUri`**, return and clear `initialFilePath` (clear only when it has a value).
- **EventChannel** `com.pdf_reader/pdf_reader_events`: `OpenFileStreamHandler` on `onListen` sends current `initialFilePath` once via `eventSink` (main thread) and sets `initialFileEventSink`; later the native side pushes the path through this sink in `_handleOpenFile`; on `onCancel` clear the sink.

#### Flutter side

- **macOS only**: in `initState` subscribe to **EventChannel** `com.pdf_reader/pdf_reader_events`; on path received, `_onMacOsOpenFileEvent` → `ReaderFile.fromPath` → `_onTapFile`; unsubscribe in `dispose`.
- **Polling**: on macOS, polling delays for `getInitialFileUri` are [100, 200, 400, 800, 1600] ms as a fallback when EventChannel does not receive.

---

## Known Issue: macOS Does Not Open File Directly

### Symptom

- When opening a supported file (e.g. PDF) from Finder via **right-click → Open With → this app**:
  - Both **first launch** and **app already running** show the app, but only the **home / file list** is shown; **the file is not opened** to the preview screen.

### Attempted Fixes (none resolved)

1. **Intent/path save timing**  
   - Already read path from `CommandLine.arguments` in `applicationWillFinishLaunching` and write to `initialFilePath`.

2. **Multiple system APIs**  
   - Implemented `application(_:openFile:)`, `application(_:openFiles:)`, `application(_:open urls:)`, and in `openFiles` call `NSApp.reply(toOpenOrPrint: .success)`.

3. **EventChannel push**  
   - Native pushes path to Flutter on the main thread via `initialFileEventSink` when a file path is received; Flutter also receives current `initialFilePath` on `onListen`.

4. **Polling fallback**  
   - Flutter polls `getInitialFileUri` with multiple delays (up to ~3 seconds) to handle late delivery of the path.

5. **Main thread**  
   - All pushes to Flutter are done via `DispatchQueue.main.async`.

### Possible Causes (to be investigated)

- Under Flutter macOS embedding, **whether NSApplication’s delegate** is correctly set to the current AppDelegate, or whether the system actually calls the above `openFile`/`openFiles`/`open urls` (add native logs to confirm).
- On first "Open With" launch, the system might **not use these delegates** and only pass the file via another mechanism (e.g. Apple Event), which the Flutter app may not be wired to.
- **Race** between EventChannel setup and when the system delivers the file: if the system calls the delegate before Flutter subscribes to the EventChannel and does not go through `CommandLine.arguments`, the path may be missed by both polling and the event sink.

### Suggested Next Steps

- Add **logs/breakpoints** in `applicationWillFinishLaunching`, `_handleOpenFile`, `application(_:openFile:)`, `application(_:openFiles:)`, `application(_:open urls:)`, and `OpenFileStreamHandler.onListen` to confirm:
  - Which of these are called when opening via "Open With", in what order, and with what arguments.
  - The actual contents of `CommandLine.arguments` on first "Open With" launch.
- Verify that **NSApplication.shared.delegate** in the Flutter macOS project is the current AppDelegate and that no other layer intercepts document-open events.
- Check Flutter docs or community for recommended approaches for "macOS open document / Open With" (e.g. Document-based app or extra configuration).

---

## File Reference

| Platform | Files |
|----------|-------|
| Shared   | `lib/pages/home_page.dart` (MethodChannel/EventChannel calls, polling, open logic) |
| Android  | `android/app/src/main/AndroidManifest.xml`, `android/.../MainActivity.kt` |
| iOS      | `ios/Runner/Info.plist`, `ios/Runner/AppDelegate.swift` |
| macOS    | `macos/Runner/Info.plist`, `macos/Runner/AppDelegate.swift`, `macos/Runner/MainFlutterWindow.swift` |

---

## Channel Conventions

- **MethodChannel** `com.pdf_reader/pdf_reader`  
  - Method **`getInitialFileUri`**: no args, returns `String?` (file URI or path). After the call, the native side should clear the returned value to avoid opening the same file twice.
- **EventChannel** `com.pdf_reader/pdf_reader_events` (macOS only)  
  - Native sends the path string via `FlutterEventSink` when it receives an "open file" or already has an initial path; Flutter listens, builds `ReaderFile`, and opens the preview.
