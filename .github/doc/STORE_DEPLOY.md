# 应用商店自动发布说明

本仓库在推送版本 tag（如 `v1.0.0`）时会触发 Release 工作流，构建各平台产物并可选地自动上传到以下商店：

- **Snap Store**（Linux）
- **Google Play**（Android）
- **Microsoft Store**（Windows）
- **App Store / TestFlight**（iOS，可选 macOS）

默认情况下**仅会构建并上传到 GitHub Release**；要启用某商店的自动上传，需在 GitHub 仓库中配置对应 **Variables / Secrets**，并在需要时打开对应开关变量。

---

## 一、GitHub 配置入口

- **Secrets**：仓库 → **Settings** → **Secrets and variables** → **Actions** → **Repository secrets**
- **Variables**：仓库 → **Settings** → **Secrets and variables** → **Actions** → **Variables** → **Repository variables**

以下所有 `Secrets` 均在 **Repository secrets** 中添加；所有开关与可选配置在 **Variables** 中添加（除非特别说明）。

---

## 二、Snap Store（Linux）

### 前置条件

- 在 [Snapcraft](https://snapcraft.io) 注册并创建应用（应用名需与 `snap/snapcraft.yaml` 中 `name` 一致，当前为 `pdf-reader`）。
- 已安装 [snapcraft](https://snapcraft.io/docs/installing-snapcraft) 并登录过商店。

### 1. 生成并配置登录凭据

在**本机**已登录 Snapcraft 的环境下执行（将 `pdf-reader` 换成你的 snap 名）：

```bash
snapcraft export-login --snaps=pdf-reader --acls=package_access,package_push,package_update,package_release exported.txt
```

把 `exported.txt` 的**完整内容**复制到 GitHub Secrets：

| Secret 名称         | 说明 |
|---------------------|------|
| `SNAPCRAFT_TOKEN`   | `exported.txt` 的完整内容 |

### 2. 启用自动发布

在 **Variables** 中新增：

| 变量名             | 值    |
|--------------------|-------|
| `ENABLE_SNAP_STORE` | `true` |

推送 tag 后，工作流会构建 snap 并执行 `snapcraft upload --release=stable`，将包发布到 Snap Store。

---

## 三、Google Play（Android）

### 前置条件

- 已有一个 Google Play 开发者账号，并在 Play Console 中创建好应用（包名需与 `android/app/build.gradle.kts` 中 `applicationId` 一致：`com.pdf_reader.pdf_reader`）。
- 已启用 [Google Play Developer API](https://developers.google.com/android-publisher)。

### 1. 创建服务账号并获取 JSON

1. 在 [Google Cloud Console](https://console.cloud.google.com/) 中为项目启用 **Google Play Android Developer API**。
2. **IAM 与管理** → **服务账号** → 创建服务账号，并为其创建 JSON 密钥。
3. 在 [Play Console](https://play.google.com/console) 中：**用户与权限** → **邀请新用户** → 使用该服务账号邮箱，并授予**发布**相关权限（如“发布应用至生产环境 / 测试轨道”等）。
4. 将下载的 JSON 密钥文件**整份内容**（单行或多行均可）保存到 GitHub Secret。

| Secret 名称                         | 说明 |
|-------------------------------------|------|
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`  | 服务账号 JSON 密钥的完整内容 |

### 2. 启用自动发布

在 **Variables** 中新增：

| 变量名                 | 值    |
|------------------------|-------|
| `ENABLE_GOOGLE_PLAY`   | `true` |

当前工作流会将 AAB 上传到 **internal** 轨道并设为 **completed**。如需改为 `production` 或 `beta`，可修改 `.github/workflows/release.yml` 中 `Publish AAB to Google Play` 的 `track` 与 `status`。

---

## 四、Microsoft Store（Windows）

### 前置条件

- 已在 [Partner Center](https://partner.microsoft.com) 创建应用，并至少完成过一次提交。
- 已将 Azure AD 与 Partner Center 关联，并创建了用于 API 的 Azure AD 应用（获取 Tenant ID、Client ID、Client Secret）。

### 1. 获取并配置凭据

在 Partner Center：

- **账户设置** → **管理用户** → **添加 Azure AD 应用程序**，创建或选择应用并赋予 **管理员** 等权限。
- 记下该应用的 **Tenant ID**、**Client ID**。
- 为该应用 **添加新密钥**，复制 **密钥值**（即 Client Secret，只显示一次）。

在 Partner Center 应用概览页获取 **产品 ID（Partner Center ID）**；在 **账户设置** → **法律信息** 等处获取 **Seller ID**。

在 GitHub **Secrets** 中新增：

| Secret 名称               | 说明 |
|---------------------------|------|
| `MS_STORE_SELLER_ID`      | Partner Center Seller ID |
| `MS_STORE_PRODUCT_ID`     | 应用的产品 ID（Partner Center ID） |
| `MS_STORE_TENANT_ID`      | Azure AD Tenant ID |
| `MS_STORE_CLIENT_ID`      | Azure AD 应用 Client ID |
| `MS_STORE_CLIENT_SECRET`  | Azure AD 应用密钥（Client Secret） |

### 2. 启用自动发布

在 **Variables** 中新增：

| 变量名                       | 值    |
|------------------------------|-------|
| `ENABLE_MICROSOFT_STORE`     | `true` |

工作流会使用当前 tag 构建的 MSIX，先上传到 GitHub Release，再以该 Release 中 MSIX 的下载地址作为 `packageUrl` 提交到 Microsoft Store。请确保该 Release 及 MSIX 下载链接对外可访问（例如仓库为 public，或使用 token 可访问的 URL，视 action 实现而定）。

---

## 五、App Store / TestFlight（iOS，以及可选 macOS）

### 前置条件

- 已加入 Apple Developer Program，并在 App Store Connect 中创建好应用（Bundle ID 与 Xcode 中一致，当前为 `com.pdfreader.pdfReader`）。
- 已配置好代码签名（证书 + 描述文件）。推荐使用 [fastlane match](https://docs.fastlane.tools/actions/match/) 在私有 Git 仓库中统一管理。

### 1. App Store Connect API 密钥

1. 在 [App Store Connect](https://appstoreconnect.apple.com) → **用户与访问** → **密钥** 中创建 **App Store Connect API** 密钥，并下载 `.p8` 文件（仅能下载一次）。
2. 记下 **密钥 ID**、**颁发者 ID**；`.p8` 文件内容即为私钥。

在 GitHub **Secrets** 中新增：

| Secret 名称                             | 说明 |
|-----------------------------------------|------|
| `APPLE_APP_STORE_CONNECT_KEY_ID`        | API 密钥 ID |
| `APPLE_APP_STORE_CONNECT_ISSUER_ID`     | 颁发者 ID（Issuer ID） |
| `APPLE_APP_STORE_CONNECT_KEY`           | `.p8` 文件的**完整内容**（含 `-----BEGIN PRIVATE KEY-----` 与 `-----END PRIVATE KEY-----`） |
| `APPLE_TEAM_ID`                          | Apple Developer Team ID（用于签名与 Appfile） |

若使用 **fastlane match**，还需：

| Secret 名称     | 说明 |
|-----------------|------|
| `MATCH_PASSWORD` | match 加密仓库的密码 |
| `MATCH_GIT_URL`  | 存放证书的私有 Git 仓库 URL（需在 workflow 中可访问，例如使用 SSH 或带 token 的 HTTPS） |

### 2. 启用自动发布

在 **Variables** 中新增：

| 变量名               | 值    |
|----------------------|-------|
| `ENABLE_APP_STORE`   | `true` |

当 `ENABLE_APP_STORE` 为 `true` 时：

- **iOS**：工作流会使用 Fastlane 执行签名构建并上传到 TestFlight（见 `fastlane/Fastfile` 中 `ios release` lane）。若使用 match，需在 Fastfile 中取消 `match(type: "appstore", readonly: true)` 的注释，并确保 `MATCH_PASSWORD`、`MATCH_GIT_URL` 已配置且 CI 能访问 match 仓库。
- **macOS**：当前仅设置了与 iOS 相同的 `ENABLE_APP_STORE` 环境；macOS 上架还需在 Fastfile 中完善 `macos release` lane（notarization、deliver 等），详见 [Fastlane macOS 文档](https://docs.fastlane.tools/getting-started/macos/setup/)。

### 3. 本地与 CI 行为说明

- 未设置 `ENABLE_APP_STORE` 或为 `false` 时：仅构建无签名 IPA 并上传到 GitHub Release，**不会**执行 TestFlight/App Store 上传。
- 设置 `ENABLE_APP_STORE` 为 `true` 时：会依赖上述 Secrets 进行签名与上传；若缺少 match 或证书配置，需先在 Fastfile 中启用 match 或改用本地/CI 安装的证书与描述文件。

---

## 六、汇总：需在 GitHub 配置的项

### Variables（开关，按需添加）

| 变量名                   | 值    | 作用           |
|--------------------------|-------|----------------|
| `ENABLE_SNAP_STORE`      | `true` | 启用 Snap Store 发布 |
| `ENABLE_GOOGLE_PLAY`     | `true` | 启用 Google Play 发布 |
| `ENABLE_MICROSOFT_STORE` | `true` | 启用 Microsoft Store 发布 |
| `ENABLE_APP_STORE`       | `true` | 启用 iOS/macOS App Store / TestFlight 发布 |

### Secrets（按商店添加）

- **Snap**：`SNAPCRAFT_TOKEN`
- **Google Play**：`GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- **Microsoft Store**：`MS_STORE_SELLER_ID`、`MS_STORE_PRODUCT_ID`、`MS_STORE_TENANT_ID`、`MS_STORE_CLIENT_ID`、`MS_STORE_CLIENT_SECRET`
- **Apple**：`APPLE_APP_STORE_CONNECT_KEY_ID`、`APPLE_APP_STORE_CONNECT_ISSUER_ID`、`APPLE_APP_STORE_CONNECT_KEY`、`APPLE_TEAM_ID`；若用 match：`MATCH_PASSWORD`、`MATCH_GIT_URL`

未配置某商店的 Secret 或未将对应 Variable 设为 `true` 时，该商店的自动上传不会执行，其余构建与 GitHub Release 不受影响。
