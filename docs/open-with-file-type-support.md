# 「用本应用打开」文件类型支持

本文档记录各平台“用本应用打开”支持的文件类型、当前实现方式，以及已知问题。

## 功能概述

支持的文件类型可在系统文件管理器 / Finder 中通过「打开方式」选择本应用打开，理想行为是：应用启动后**直接打开该文件**进入预览页，而不是仅进入应用主页。

- **支持格式**：PDF、EPUB、Word/Excel/PPT（含 .doc/.docx/.xls/.xlsx/.ppt/.pptx）、纯文本、Markdown
- **平台**：Android、iOS、macOS

---

## 当前实现

### 1. Android

**状态：已按预期工作**（选择「用本应用打开」后会直接打开文件）

#### 配置

- **`android/app/src/main/AndroidManifest.xml`**
  - 在 MainActivity 上增加 `ACTION_VIEW` 的 intent-filter，声明支持的 MIME 类型与 `file`/`content` scheme。

#### 原生逻辑（`MainActivity.kt`）

- 在 **`super.onCreate()` 之前** 读取 `intent.action == ACTION_VIEW` 且 `intent.data != null`，将 URI 存入 `initialFileUri`（若在 `super.onCreate()` 之后保存，Flutter 会先调用 `getInitialFileUri` 得到 null）。
- `onNewIntent` 中同样保存 VIEW intent 的 data，供应用已运行时再次「打开方式」。
- MethodChannel `com.pdf_reader/pdf_reader` 提供方法 **`getInitialFileUri`**：返回并清空 `initialFileUri`；若无则再读当前 `intent` 并清空 intent，避免重复打开。

#### Flutter 侧（`lib/pages/home_page.dart`）

- 首帧后 `_openInitialFileIfAny()`：先延迟 100ms，再调用 `getInitialFileUri`；若为空则再延迟 200ms 重试一次，拿到 URI 后 `ReaderFile.fromPath(uri)` 并 `_onTapFile(file)` 打开预览。

---

### 2. iOS

**状态：实现完整，依赖轮询与 launchOptions**

#### 配置

- **`ios/Runner/Info.plist`**
  - `CFBundleDocumentTypes` 声明 PDF、EPUB、Word、Excel、PPT、纯文本、Markdown 等 UTType。

#### 原生逻辑（`AppDelegate.swift`）

- `didFinishLaunchingWithOptions` 中从 **`launchOptions?[.url]`** 读取启动时传入的 URL，写入 `initialFileUrl`（path）。
- `application(_:open:options:)` 中保存传入的 `url.path` 到 `initialFileUrl`。
- 注册 MethodChannel `com.pdf_reader/pdf_reader`，仅处理 **`getInitialFileUri`**，返回并清空 `initialFileUrl`（仅在有值时才清空）。

#### Flutter 侧

- 在 `_openInitialFileIfAny()` 中，对 iOS 与 macOS 一起做**轮询**：若首次 `getInitialFileUri` 为空，则按延迟 [100, 200, 400] ms 多次调用，以应对系统晚于首帧交付文件的情况。

---

### 3. macOS

**状态：应用能出现在「打开方式」列表中并启动，但无法直接打开文件（已知问题）**

#### 配置

- **`macos/Runner/Info.plist`**
  - `CFBundleDocumentTypes` 与 iOS 相同，声明上述文件类型。

#### 原生逻辑

**AppDelegate.swift**

- **`applicationWillFinishLaunching`**：从 **`CommandLine.arguments`** 读取参数（下标 1 起），支持 `file://` 与普通路径，取第一个「存在且为文件」的路径写入 `initialFilePath`（应对文档称“首次打开方式启动时可能不调 openFiles”的情况）。
- **`application(_:openFile:)`**（单文件）、**`application(_:openFiles:)`**、**`application(_:open urls:)`**：统一在 `_handleOpenFile(path:)` 中写入 `initialFilePath` 并通过 `initialFileEventSink` 在主线程推送给 Flutter；`openFiles` 中调用 **`NSApp.reply(toOpenOrPrint: .success)`**。

**MainFlutterWindow.swift**

- **MethodChannel** `com.pdf_reader/pdf_reader`：处理 **`getInitialFileUri`**，返回并清空 `initialFilePath`（仅在有值时清空）。
- **EventChannel** `com.pdf_reader/pdf_reader_events`：`OpenFileStreamHandler` 在 `onListen` 时把当前 `initialFilePath` 通过 `eventSink` 发一次（主线程），并设置 `initialFileEventSink`，此后原生在 `_handleOpenFile` 里通过该 sink 主动推送路径；`onCancel` 时清空 sink。

#### Flutter 侧

- **macOS 专用**：在 `initState` 中订阅 **EventChannel** `com.pdf_reader/pdf_reader_events`，收到路径后 `_onMacOsOpenFileEvent` → `ReaderFile.fromPath` → `_onTapFile`；`dispose` 中取消订阅。
- **轮询**：macOS 上对 `getInitialFileUri` 的轮询延迟为 [100, 200, 400, 800, 1600] ms，作为 EventChannel 未收到时的后备。

---

## 已知问题：macOS 无法直接打开文件

### 现象

- 在 Finder 中通过**右键 → 打开方式 → 选择本应用**打开支持类型的文件（如 PDF）时：
  - **首次启动**与**应用已在运行时**两种情况均会进入应用，但只停留在**主页/文件列表页**，**不会自动打开该文件**进入预览。

### 已尝试的修复（均未解决）

1. **Intent/路径保存时机**  
   - 已在 `applicationWillFinishLaunching` 中从 `CommandLine.arguments` 读取路径并写入 `initialFilePath`。

2. **多种系统 API**  
   - 已实现 `application(_:openFile:)`、`application(_:openFiles:)`、`application(_:open urls:)`，并在 `openFiles` 中正确调用 `NSApp.reply(toOpenOrPrint: .success)`。

3. **EventChannel 主动推送**  
   - 原生在收到文件路径时通过 `initialFileEventSink` 在主线程推送给 Flutter；Flutter 在 `onListen` 时也会收到当前已有的 `initialFilePath`。

4. **轮询后备**  
   - Flutter 对 `getInitialFileUri` 进行多次延迟轮询（最晚约 3 秒内），以应对系统晚于首帧交付路径的情况。

5. **主线程**  
   - 所有向 Flutter 的推送均通过 `DispatchQueue.main.async` 执行。

### 可能原因（待进一步排查）

- 在 Flutter macOS 嵌入下，**NSApplication 的 delegate 是否被正确设置**为当前 AppDelegate，或系统是否真的调用了上述 `openFile`/`openFiles`/`open urls`（可加原生日志确认）。
- 通过「打开方式」首次启动时，系统是否**不经过上述 delegate**，而仅通过其他机制（如 Apple Event）传参，且 Flutter 应用未接入该路径。
- **EventChannel 建立时机**与系统交付文件时机之间的竞态：若系统在 Flutter 订阅 EventChannel 之前就调用了 delegate，且未走 `CommandLine.arguments`，则可能既未被轮询到也未收到推送。

### 建议的后续排查

- 在 `applicationWillFinishLaunching`、`_handleOpenFile`、`application(_:openFile:)`、`application(_:openFiles:)`、`application(_:open urls:)` 及 `OpenFileStreamHandler.onListen` 中增加**日志/断点**，确认：
  - 通过「打开方式」启动或打开时，上述哪些方法被调用、调用顺序及传入参数。
  - `CommandLine.arguments` 在首次「打开方式」启动时的实际内容。
- 确认 Flutter macOS 工程中 **NSApplication.shared.delegate** 是否为当前 AppDelegate，以及是否有其他层拦截了打开文档事件。
- 查阅 Flutter 官方或社区中「macOS 打开文档 / Open With」的推荐实现方式（如是否需要 Document-based app 或额外配置）。

---

## 涉及文件一览

| 平台   | 文件 |
|--------|------|
| 共用   | `lib/pages/home_page.dart`（MethodChannel/EventChannel 调用、轮询、打开逻辑） |
| Android | `android/app/src/main/AndroidManifest.xml`，`android/.../MainActivity.kt` |
| iOS   | `ios/Runner/Info.plist`，`ios/Runner/AppDelegate.swift` |
| macOS | `macos/Runner/Info.plist`，`macos/Runner/AppDelegate.swift`，`macos/Runner/MainFlutterWindow.swift` |

---

## Channel 约定

- **MethodChannel** `com.pdf_reader/pdf_reader`  
  - 方法 **`getInitialFileUri`**：无参，返回 `String?`（文件 URI 或路径），调用后原生侧应清空已返回的值，避免重复打开。
- **EventChannel** `com.pdf_reader/pdf_reader_events`（仅 macOS）  
  - 原生在收到「打开文件」或已有初始路径时，通过 `FlutterEventSink` 发送路径字符串；Flutter 端监听后构造 `ReaderFile` 并打开预览。
