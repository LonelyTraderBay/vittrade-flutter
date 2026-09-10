# Kế hoạch sẵn sàng production - VitTrade Flutter FE

Updated: 2026-09-10 (đồng bộ sau toolchain align 3.47.2, ADR-014 dark-only,
pilot remote auth — xem CHANGELOG)

Phạm vi tài liệu này là **Frontend Flutter** của VitTrade. Tài liệu này không
thay thế checklist production của Backend, DevOps, pháp lý, bảo mật hạ tầng,
hoặc vận hành sàn giao dịch. Backend/API thật vẫn phải có tài liệu hợp đồng,
môi trường staging/production, kiểm thử bảo mật và quy trình release riêng.

## Kết luận hiện tại

VitTrade Flutter **chưa production-ready hoàn chỉnh** theo nghĩa phát hành thật
cho người dùng cuối — lý do còn lại thu hẹp về **phía ngoài FE**: chưa có
Backend/API thật (0/34 feature có remote repository sản xuất; pilot auth đã
chứng minh công thức), chưa cấu hình signing secrets + tag phát hành, chưa cắm
crash/analytics vendor, chưa có store track.

Tầng **khung FE đã đóng và có khóa** (guardrail + CI 7 job + preflight):

```text
Body component audit: 409 A, 0 B, 0 C, 0 D, 5 Tool
Header strict audit: strict_visual_issues=0, screen_level_mismatches=0
Back navigation audit: strict_back_issues=0
Home-entry back audit: 44 passed, 0 failed
flutter analyze: pass (0 issue)
flutter test --reporter=compact: 3.984 pass / 30 fail golden font Windows
  (baseline môi trường — golden chỉ đọc composition, không phải lỗi logic)
Debug APK trên Android emulator: build/install/launch pass
preflight_check.dart: P1/P2/P3 PASS sạch (P4 = 30 golden baseline trên Windows)
```

## Bảng trạng thái thực tế

| Hạng mục | Trạng thái | Kết luận thực tế |
| --- | --- | --- |
| UI/UX body consistency | `[x]` Hoàn tất | 409 màn hình chuẩn đạt A, 5 màn hình Tool giữ ngoại lệ hợp lệ. |
| Header/router/navigation | `[x]` Hoàn tất | Header strict, route coverage, navigation edge, back navigation đều sạch. |
| Product copy guardrails | `[x]` Hoàn tất gate hiện tại | Arena/Predictions/P2P/Trade copy guardrails đã có test và pass. |
| Accessibility semantics critical flows | `[x]` Hoàn tất gate hiện tại | Có test cho withdraw, address add, P2P payment add, token approval, admin dashboards. |
| High-risk text-entry smoke tests | `[x]` Hoàn tất gate hiện tại | Address Add và P2P Payment Add enterText harness đã có và pass. |
| Architecture guardrails | `[~]` Đang kiểm soát | Guardrail pass, nhưng vẫn còn nợ kỹ thuật part-file/file lớn cần giảm dần. |
| Network foundation | `[x]` Hoàn tất | `ApiClient` Dio + chuỗi interceptor đầy đủ (auth-token → session-refresh → safe-retry GET → error-map `ApiFailure`/`OfflineFailure` tiếng Việt) + certificate pinning fail-closed (SEC-S46); timeout 3 mức. |
| Mock/remote repository switch | `[~]` Pilot xong | `AppConfig` + `guardedRepository` (mock/remote/fail-closed). `RemoteAuthRepository` + 9 test hợp đồng + playbook 5 bước đã chứng minh công thức; 0/34 feature còn lại có remote — chờ backend contract (ratchet guardrail cấm nối sớm). |
| Backend API contracts/DTO | `[ ]` Chưa sẵn sàng production | Chưa có Swagger/OpenAPI ký thật. FE có sẵn ADR-010 (DTO provisional, pilot auth) + Auth-Backend-Contract-Skeleton.md. |
| Auth/session/token security | `[x]` Hoàn tất khung | SecureStore (`flutter_secure_storage` giới hạn trong `core/storage/`), interceptor `Authorization: Bearer`, refresh-token flow nối `AuthSessionController` ↔ ApiClient, logout-forced khi refresh fail. Token demo — giá trị thật thay khi backend về, cơ chế không đổi. |
| Android release signing | `[~]` Partial | Gradle đọc `key.properties`/env; workflow `release.yml` đã có pipeline signing (decode keystore base64 từ secrets). Còn thiếu: cấu hình 4 secrets thật + tag phát hành đầu tiên. |
| CI quality gates | `[x]` Hoàn tất cho debug gate | CI 7 job (static, guardrails, tests, build-android, golden-windows, secret-scan, gate) + preflight_check.dart mô phỏng trọn chuỗi tại local. |
| CI release build | `[x]` Hoàn tất pipeline | `flutter-release.yml` + `release.yml`: build release theo tag, `--obfuscate --split-debug-info=build/symbols/prod`, signing secrets. Chưa chạy thật lần nào (chờ secrets + tag). |
| Observability/crash reporting | `[~]` Seam xong, vendor chưa cắm | ADR-008: `ErrorReporter`/`AnalyticsReporter` interface + `LocalLogErrorReporter` (ring-buffer); kill-switch bảo trì + force-update gate đã có route. Cắm Sentry/Crashlytics chỉ đổi 1 chỗ. |
| Store/internal distribution | `[ ]` Chưa có bằng chứng | Chưa có Play/internal track, versioning/release notes pipeline. |

## Bằng chứng từ code hiện tại

- App source: `flutter_app/lib/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- API client foundation: `flutter_app/lib/core/network/api_client.dart`
- Environment config: `flutter_app/lib/core/config/app_environment.dart`
- Mock/remote switch guard: `flutter_app/lib/core/data/repository_guard.dart`
- Android signing config: `flutter_app/android/app/build.gradle.kts`
- CI workflow: `.github/workflows/flutter-ci.yml`
- Body audit artifact:
  `docs/02_FLUTTER_MIGRATION/audits/VitTrade-Body-Component-Consistency-Audit.csv`
- Header audit artifact:
  `docs/02_FLUTTER_MIGRATION/audits/VitTrade-Top-Header-Visual-Archetype-Audit.csv`
- Back navigation audit:
  `docs/02_FLUTTER_MIGRATION/audits/VitTrade-Header-Back-Navigation-Behavior-Audit.csv`
- Home-entry back navigation audit:
  `docs/02_FLUTTER_MIGRATION/audits/VitTrade-Home-Entry-Back-Navigation-Audit.csv`

## Những điểm trong bản cũ không còn đúng

1. Không đúng khi ghi toàn bộ các giai đoạn là `Chưa bắt đầu`.
   Nhiều phần đã hoàn tất hoặc partial trong code hiện tại.

2. Không đúng khi xem Network foundation là chưa có.
   Repo đã có `ApiClient` dùng Dio với timeout, base URL và JSON response.

3. Không đúng khi xem mock/remote switch là chưa có.
   Repo đã có `AppConfig` đọc Dart defines và `guardedRepository` để fail-closed
   khi mock bị tắt mà remote repository chưa được cấu hình.

4. Không đúng khi xem Android signing là chưa bắt đầu.
   `build.gradle.kts` đã hỗ trợ `key.properties` và các biến:

   ```text
   VITTRADE_KEYSTORE_PATH
   VITTRADE_KEYSTORE_PASSWORD
   VITTRADE_KEY_ALIAS
   VITTRADE_KEY_PASSWORD
   ```

5. Không đúng khi xem các smoke/accessibility/product-copy tests là chưa có.
   Các test này đã tồn tại và pass trong lần kiểm tra gần nhất.

6. Không đúng (từ 2026-09-10) khi xem Network foundation là thiếu error
   mapper/auth interceptor/refresh token — cả ba đã hoàn thiện kèm test
   (`api_client_error_mapping_test`, `api_client_auth_session_test`,
   `api_client_retry_test`).

7. Không đúng khi xem Auth/session/token là chưa bắt đầu — SecureStore,
   Authorization interceptor và refresh-token flow đã wired
   (`auth_controller_providers.dart`).

8. Không đúng khi xem CI release là chưa có — `flutter-release.yml` và
   `release.yml` đã build release có obfuscate + signing theo tag; việc còn
   lại là cấu hình secrets thật và tag phiên bản đầu tiên.

## Chiến lược FE-first: giữ Mock Data để demo, chuẩn bị sẵn BE

Hiện tại dự án đang phát triển theo hướng **Frontend trước, Backend sau**. Đây
là hướng hợp lý miễn là mock data không bị dùng tùy tiện. Mục tiêu là:

1. App vẫn chạy ổn định để demo cho đối tác khi chưa có server thật.
2. Mock data phải mô phỏng hợp đồng API tương lai, không chỉ là dữ liệu trang
   trí để render UI.
3. Khi Backend sẵn sàng, FE chỉ cắm remote repository vào, không viết lại UI.
4. Production config tuyệt đối không được fallback về mock data.

### Chế độ chạy bắt buộc phải phân biệt rõ

| Chế độ | Mục đích | Mock data | Kỳ vọng |
| --- | --- | --- | --- |
| Demo/local | Demo cho đối tác, phát triển offline | Bật | App chạy ổn, dữ liệu đẹp, có đủ tình huống thật. |
| Staging | Test với Backend thật trước release | Tắt | Gọi API staging, phát hiện contract mismatch. |
| Production | Phát hành thật | Tắt tuyệt đối | Không còn module P0 dùng mock hoặc fixture. |

Lệnh chạy demo:

```powershell
flutter run -d emulator-5554 `
  --dart-define=APP_ENV=development `
  --dart-define=ENABLE_MOCK_DATA=true
```

Lệnh chạy staging sau khi Backend sẵn sàng:

```powershell
flutter run -d emulator-5554 `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://staging-api.vittrade.vn `
  --dart-define=ENABLE_MOCK_DATA=false
```

Lệnh production/release sau này:

```powershell
flutter build appbundle --release `
  --dart-define=APP_ENV=production `
  --dart-define=API_BASE_URL=https://api.vittrade.vn `
  --dart-define=ENABLE_MOCK_DATA=false
```

### Luồng kiến trúc bắt buộc

Không để Page/Widget gọi trực tiếp API, mock repository hoặc fixture.

Luồng đúng:

```text
Page / Widget
 -> Controller / Riverpod Provider
 -> Repository contract
 -> MockRepository hoặc RemoteRepository
 -> ApiClient
 -> Backend API
```

Mẫu cấu trúc feature theo quy ước thực tế của repo (ADR-010 — DTO đặt trong
`data/dto/`, không phải `data/models/`; tham chiếu sống: `features/auth/`):

```text
flutter_app/lib/features/<feature>/
├── domain/
│   ├── entities/
│   └── repositories/
│       └── <feature>_repository.dart
├── data/
│   ├── dto/
│   │   ├── <feature>_dto.dart        # + .g.dart sinh từ build_runner
│   │   └── <feature>_dto_mappers.dart
│   ├── providers/
│   │   └── <feature>_repository_provider.dart   # qua guardedRepository
│   └── repositories/
│       ├── mock_<feature>_repository.dart
│       ├── remote_<feature>_repository.dart     # theo playbook khi BE ký
│       └── fail_closed_<feature>_repository.dart
└── presentation/
    ├── controllers/
    ├── phone/pages/ + tablet/pages/ (+ web nếu được duyệt)
    └── widgets/
```

Nguyên tắc quan trọng:

- Entity/domain là dữ liệu app dùng ổn định trong UI.
- DTO là dữ liệu Backend trả về, có thể thay đổi theo contract API.
- Mapper chuyển DTO sang Entity; UI không dùng DTO trực tiếp.
- MockRepository và RemoteRepository phải cùng implement một repository
  contract.
- `guardedRepository` là cổng chuyển mock/remote; không tạo logic rẽ nhánh trong
  Page.

### Chuẩn hóa mock data để demo cho đối tác

Mock data vẫn cần giữ để demo. Nhưng mock phải giống API thật:

- [ ] ID rõ ràng: `walletId`, `assetId`, `orderId`, `transactionId`.
- [ ] Status enum rõ ràng:
  `pending`, `reviewing`, `completed`, `failed`, `cancelled`.
- [ ] Timestamp dùng ISO 8601.
- [ ] Tiền/tài sản dùng string hoặc minor-unit integer, tránh `double` cho giá
  trị tài chính nếu dữ liệu sẽ đi qua API.
- [ ] Có đủ trạng thái demo:
  loading, empty, error, offline, submitting, success.
- [ ] Có dữ liệu rủi ro:
  thiếu KYC, vượt limit, insufficient balance, suspicious address, network
  unavailable, pending review.
- [ ] Dữ liệu demo phải đẹp và có ngữ cảnh thật:
  user đã KYC, có tài sản, có pending withdrawal, có P2P order, có trade
  history, có notification, có security warning.

Ví dụ dữ liệu mock không nên dùng:

```dart
amount: 1000.5
```

Nên chuẩn bị theo hướng API-safe:

```json
{
  "amount": "1000.50",
  "asset": "USDT",
  "network": "TRC20",
  "status": "pending",
  "createdAt": "2026-06-11T10:00:00Z"
}
```

### Chuẩn bị API contract trước khi Backend code xong

Không chờ Backend xong mới sửa FE. FE cần tạo tài liệu contract trước để hai
bên thống nhất.

Tạo các file:

```text
docs/API_CONTRACTS/auth.md
docs/API_CONTRACTS/wallet.md
docs/API_CONTRACTS/p2p.md
docs/API_CONTRACTS/trade.md
docs/API_CONTRACTS/markets.md
docs/API_CONTRACTS/profile.md
```

Mỗi endpoint cần ghi đủ:

- [ ] Method và path.
- [ ] Auth required hay không.
- [ ] Request body.
- [ ] Response body.
- [ ] Error codes.
- [ ] Pagination/filter/sort nếu có.
- [ ] Permission/KYC/region requirement.
- [ ] Rate limit nếu là luồng nhạy cảm.
- [ ] UI state mapping khi lỗi.

Ví dụ Wallet P0 endpoints:

```text
GET  /wallet/overview
GET  /wallet/assets
GET  /wallet/transactions
POST /wallet/deposits/address
POST /wallet/withdrawals/preview
POST /wallet/withdrawals/confirm
POST /wallet/transfers/preview
POST /wallet/transfers/confirm
GET  /wallet/address-book
POST /wallet/address-book
GET  /wallet/token-approvals
POST /wallet/token-approvals/revoke-preview
POST /wallet/token-approvals/revoke-confirm
```

Ví dụ withdrawal preview response cần có tối thiểu:

```text
asset
network
amount
fee
receiveAmount
minLimit
maxLimit
riskLevel
requires2FA
estimatedArrival
nextSteps
```

### Error model thống nhất với Backend

Backend nên trả lỗi theo format ổn định:

```json
{
  "code": "INSUFFICIENT_BALANCE",
  "message": "Insufficient balance",
  "traceId": "req_123",
  "details": {
    "available": "120.00",
    "required": "150.00"
  }
}
```

FE cần map lỗi sang UI:

| API error | UI cần hiển thị |
| --- | --- |
| `401` | Hết phiên, refresh token hoặc về Login. |
| `403` | Không đủ quyền, KYC hoặc region bị hạn chế. |
| `404` | Dữ liệu không còn tồn tại hoặc route detail invalid. |
| `409` | Trạng thái đã thay đổi, yêu cầu reload preview. |
| `422` | Validation error theo field. |
| `429` | Quá nhiều request, hiển thị cooldown. |
| `500` | Lỗi hệ thống, có traceId để support. |
| `INSUFFICIENT_BALANCE` | Thiếu số dư, hiển thị available/required. |
| `LIMIT_EXCEEDED` | Vượt hạn mức ngày/tháng. |
| `NETWORK_UNAVAILABLE` | Offline state. |

### Module ưu tiên khi chuẩn bị BE

Không làm toàn bộ 400+ màn hình cùng lúc. Ưu tiên theo rủi ro tài chính và khả
năng demo sản phẩm.

P0:

1. Auth / Session.
2. Profile / KYC / Security.
3. Wallet overview, assets, history.
4. Deposit, Withdraw, Transfer.
5. Address Book.
6. Token Approval.
7. Markets basic data.
8. Trade basic order/history.
9. P2P payment method, order, escrow, dispute.

P1:

1. Earn.
2. Launchpad.
3. Predictions.
4. Arena.
5. Referral.
6. Admin dashboard.
7. Cross-module portfolio.

### Thứ tự công việc cho AI để không bỏ sót

AI hoặc developer khi thực hiện phần chuẩn bị BE phải làm theo thứ tự dưới đây,
không nhảy thẳng vào sửa UI:

1. Chọn một module P0 duy nhất.
2. Đọc repository contract/domain entities/controller hiện có của module đó.
3. Liệt kê toàn bộ mock repository methods đang dùng.
4. Tạo hoặc cập nhật `docs/API_CONTRACTS/<module>.md`.
5. Định nghĩa DTO theo contract API.
6. Viết mapper DTO -> Entity.
7. Tạo `remote_<module>_repository.dart` skeleton.
8. Cắm provider qua `guardedRepository`.
9. Giữ MockRepository để demo local.
10. Thêm test cho:
    - DTO parsing.
    - mapper null/missing-field safety.
    - repository provider mock/remote switch.
    - production config fail-closed.
    - error mapper nếu module có high-risk flow.
11. Chạy focused tests của module.
12. Chạy `flutter analyze`.
13. Cập nhật lại tài liệu này với trạng thái module.

Definition of Done cho mỗi module:

- [ ] Demo/local vẫn chạy với `ENABLE_MOCK_DATA=true`.
- [ ] Staging mode có remote repository skeleton hoặc implementation.
- [ ] Production mode không silently fallback về mock.
- [ ] API contract có request/response/error đầy đủ.
- [ ] DTO/mapper có test.
- [ ] Controller không import mock hoặc remote repository trực tiếp.
- [ ] UI không đổi behavior khi chuyển mock sang remote cùng schema.

## P0 - Việc bắt buộc trước khi gọi là production-ready

### P0.1 - Chốt hợp đồng API thật với Backend

- [ ] Có Swagger/OpenAPI hoặc Postman collection chính thức cho từng module.
- [ ] Có schema response/error/pagination/rate-limit thống nhất.
- [ ] Có mapping quyền truy cập, KYC, region restriction, account status.
- [ ] Có contract cho các luồng high-risk:
  withdrawal, deposit, transfer, address add, token approval, P2P payment
  method, P2P escrow/release/dispute, security changes.
- [ ] Có staging endpoint ổn định để FE chạy `ENABLE_MOCK_DATA=false`.

Deliverable:

```text
docs/API_CONTRACTS hoặc link nguồn chính thức của Backend
flutter_app/lib/features/<feature>/data/models/
flutter_app/lib/features/<feature>/data/repositories/remote_*_repository.dart
```

### P0.2 - Hoàn thiện remote repositories

Hiện trạng (2026-09-10): **pilot đã xong** — `RemoteAuthRepository` +
9 test hợp đồng + playbook 5 bước
(`docs/05_ARCHITECTURE/remote-repository-playbook.md`). Guardrail
`repository_guard_coverage` cố ý cấm nối `remote:` vào provider P0 chờ
backend thật (nối sớm làm production fail với thông báo sai nghĩa). Mỗi
feature còn lại làm theo playbook khi contract ký — thao tác cơ học, không
thiết kế lại.

- [ ] Tạo remote repository cho các module P0:
  Auth, Wallet, Trade, P2P, Markets, Profile.
- [ ] Mỗi repository phải implement contract domain hiện có, không để UI gọi
  trực tiếp data/mock layer.
- [ ] Dùng `guardedRepository` để chuyển mock/remote theo environment.
- [ ] Khi `APP_ENV=production`, `ENABLE_MOCK_DATA` phải false và app không được
  silently fallback về mock data.
- [ ] Có test cho production config fail-closed khi thiếu remote implementation.

### P0.3 - Error mapper và offline/network state thật

Hiện trạng: **hoàn tất** — `core/network/api_error_mapper.dart` map
400/401/403/404/409/422/429/5xx + timeout/mất mạng → `ApiFailure`/
`OfflineFailure` tiếng Việt; retry có kiểm soát qua `safe_retry` (GET tạm
thời); test trong `api_client_error_mapping_test.dart` /
`api_client_retry_test.dart`.

- [x] Map lỗi HTTP phổ biến: 400, 401, 403, 404, 409, 422, 429, 500, timeout.
- [x] Chuyển lỗi network thành state UI rõ ràng:
  loading, empty, error, offline, submitting, success.
- [x] Không expose raw exception hoặc stack trace ra UI người dùng.
- [x] Có retry policy có kiểm soát cho các request an toàn.
- [x] Có test cho error mapper và controller state transition.

### P0.4 - Auth/session/token security

Hiện trạng: **hoàn tất khung (GĐ4-F1, P0.4)** — secure storage qua seam
`SecureStore`, interceptor `Authorization: Bearer`, refresh 401 qua
`sessionRefreshInterceptor` nối `AuthSessionController.tryRefreshAccessToken`,
refresh fail → logout toàn cục; masking PII có guardrail `secret_material`.
Token hiện là giá trị demo — backend thật chỉ đổi giá trị ghi vào store.

- [x] Thêm secure token storage phù hợp Flutter mobile.
- [x] Thêm Dio interceptor gắn `Authorization: Bearer <token>`.
- [x] Bắt 401 và xử lý refresh token theo contract Backend.
- [x] Nếu refresh fail, clear session và điều hướng về login an toàn.
- [x] Không log token, refresh token, email/phone/address đầy đủ.
- [x] Có test cho 401, refresh success, refresh fail, logout forced
  (`api_client_auth_session_test.dart`).

### P0.5 - Release CI/CD thật

Hiện trạng (2026-09-10): **pipeline đã có** — `release.yml` (tag → build AAB
flavor prod, decode keystore từ `VITTRADE_KEYSTORE_BASE64`, ký, obfuscate +
`--split-debug-info=build/symbols/prod`) và `flutter-release.yml`; thêm
`ios-demo-build.yml` cho IPA demo Sideloadly. Việc còn lại là vận hành:
cấu hình 4 secrets thật, bump version + CHANGELOG, tag `v<x.y.z>` đầu tiên.

- [x] Thêm job release riêng, chỉ chạy trên tag hoặc protected branch.
- [ ] Cấu hình GitHub/GitLab secrets cho signing:
  `VITTRADE_KEYSTORE_BASE64`, `VITTRADE_KEYSTORE_PASSWORD`,
  `VITTRADE_KEY_ALIAS`, `VITTRADE_KEY_PASSWORD` (pipeline sẵn, chờ giá trị).
- [x] Build release APK/AAB:

```powershell
flutter build appbundle --release `
  --dart-define=APP_ENV=production `
  --dart-define=API_BASE_URL=https://api.vittrade.<domain> `
  --dart-define=ENABLE_MOCK_DATA=false
```

- [ ] Upload artifact nội bộ hoặc Play internal testing.
- [ ] Gắn versionCode/versionName theo release process.

### P0.6 - Production smoke test trên build thật

- [ ] Cài release build lên emulator/device thật.
- [ ] Smoke test các route P0:
  Home, Login, Wallet, Deposit, Withdraw, Transfer, Address Add,
  Token Approval, P2P Home, P2P Payment Add, P2P Order, Trade,
  Markets, Profile/Security.
- [ ] Chạy lại responsive QA ở 360 px, 440 px, 480 px.
- [ ] Chạy logcat/crash buffer sau khi đi qua high-risk flows.

## P1 - Việc nên hoàn tất trước beta/internal release

### P1.1 - Giảm nợ kiến trúc part-file/file lớn

Hiện trạng: architecture guardrail đang pass, nhưng codebase vẫn còn nhiều
`part`/`part of` và file lớn. Đây là nợ kỹ thuật được kiểm soát, chưa phải blocker
production nếu gate không tăng.

- [ ] Không tăng số lượng file vượt ngưỡng guardrail.
- [ ] Khi chạm module lớn, ưu tiên tách widget độc lập trong
  `presentation/widgets/`.
- [ ] Không tạo thêm local scaffold/layout nếu shared primitive đã đủ.
- [ ] Duy trì test `architecture_baseline_guardrails_test.dart`.

### P1.2 - Mở rộng accessibility và semantics

- [ ] Mở rộng semantics cho mọi action tài chính, không chỉ critical flows.
- [ ] Kiểm tra screen reader labels cho tab, search, filter, amount input,
  confirmation sheet.
- [ ] Chạy manual TalkBack smoke test trên Android.

### P1.3 - Performance profiling

- [ ] Profile startup trên emulator và ít nhất một device thật.
- [ ] Kiểm tra jank các màn hình high-density:
  Trade, Market list, Wallet, P2P order, Prediction event.
- [ ] Ghi nhận frame timing/memory baseline.

### P1.4 - Observability và vận hành

- [ ] Thêm crash reporting phù hợp chính sách dự án (seam `ErrorReporter`/
  `AnalyticsReporter` sẵn theo ADR-008 — cắm vendor ở 1 chỗ, không đụng file khác).
- [x] Định nghĩa log policy: không log PII/token/address đầy đủ (guardrail
  `secret_material` + `LocalLogErrorReporter` ring-buffer không PII).
- [ ] Thêm build metadata vào app: version, environment, commit SHA.
- [x] Có cơ chế remote kill switch/maintenance state nếu Backend yêu cầu
  (`MAINTENANCE_MODE` redirect toàn app + `MIN_SUPPORTED_BUILD` force-update
  gate; `RuntimeConfigSource` là chỗ cắm remote-config server-side).

## P2 - Việc cải thiện sau beta

- [ ] Visual regression screenshot matrix tự động theo route ưu tiên.
- [ ] Contract test tự động từ OpenAPI.
- [ ] E2E smoke test qua Appium/Flutter Driver hoặc framework tương đương.
- [ ] Tối ưu dần part-file debt và file lớn theo từng module.
- [ ] Thêm performance budget vào CI nếu thời gian build/test cho phép.

## Checklist lệnh kiểm tra hiện tại

Một lệnh duy nhất mô phỏng trọn chuỗi CI tại local (format, analyze, 21 audit
`--check`, full test — chạy trên bản checkout sạch tái tạo từ git index):

```powershell
dart run tool\preflight_check.dart          # thêm --fast để bỏ test giữa chừng
```

Kỳ vọng trên máy Windows: P1/P2/P3 PASS; P4 chỉ fail đúng 30 golden font
(baseline môi trường). Chi tiết từng lệnh (chạy từ `flutter_app/`):

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool\body_component_consistency_audit.dart
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
dart run tool\navigation_edge_audit.dart --check
dart run tool\back_navigation_behavior_audit.dart
dart run tool\home_entry_back_navigation_audit.dart
flutter analyze
flutter test --reporter=compact
flutter build apk --debug
```

Các test production-readiness quan trọng:

```powershell
flutter test test\quality\architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test\quality\high_risk_text_entry_harness_test.dart --reporter=compact
flutter test test\quality\accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test\quality\product_copy_guardrails_test.dart test\quality\prediction_product_copy_guardrails_test.dart --reporter=compact
flutter test test\quality\responsive_visual_qa_matrix_test.dart --reporter=compact
```

## Điều kiện để đổi trạng thái sang production-ready

Chỉ đánh dấu production-ready khi tất cả điều kiện sau đều đúng:

- [ ] `flutter analyze` pass.
- [ ] `flutter test --reporter=compact` pass.
- [ ] Body/header/router/navigation audits pass và artifacts current.
- [ ] Release APK/AAB build thành công với signing thật.
- [ ] `APP_ENV=production`, `ENABLE_MOCK_DATA=false`, `API_BASE_URL` trỏ về
  production/staging thật theo mục tiêu release.
- [ ] Không còn module P0 nào dùng mock data trong production config.
- [ ] Auth/session/token handling đã có secure storage, interceptor và refresh.
- [ ] High-risk financial flows đã gọi API thật và giữ preview/confirmation.
- [ ] Crash/log policy không rò rỉ PII/token.
- [ ] Có smoke test trên release build.

## Trạng thái cuối cùng của tài liệu này

Tài liệu này là **kế hoạch production-readiness thực tế sau khi FE UI/UX đã đạt
A-grade body component gate**. Việc tiếp theo không phải tiếp tục audit UI body,
mà là hoàn thiện các phần còn thiếu để app Flutter kết nối Backend thật và phát
hành release artifact an toàn.
