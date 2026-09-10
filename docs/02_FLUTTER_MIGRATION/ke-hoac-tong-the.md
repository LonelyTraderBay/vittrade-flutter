# Kế hoạch tổng thể cho AI triển khai

Updated: 2026-09-10
Scope: Flutter-only VitTrade app trong `flutter_app/`.

Tài liệu này là dashboard trạng thái và hướng dẫn cho các lượt AI tiếp theo.
Mỗi lượt làm việc nên chọn một work packet nhỏ, hoàn tất code, test và
verification cho packet đó, rồi mới chuyển sang packet tiếp theo.

Việc còn lại thực tế: [`ke-hoach-san-sang-production.md`](ke-hoach-san-sang-production.md).
Doc picker: [`docs/INDEX.md`](../INDEX.md).
Completed playbooks (redesign / IA / A+ / migration plans): [`docs/_archive/`](../_archive/README.md).

## Completed migrations (removed 2026-07-02 · archived 2026-07-23)

Các kế hoạch/prompt execution lớn đã **đóng**. Bản chi tiết nằm dưới
[`docs/_archive/`](../_archive/README.md); git history vẫn đủ:

| Wave | Status | Summary |
| --- | --- | --- |
| AI Sequential Execution Backlog (S0–S8) | Closed 2026-05-30 | Frontend hardening queue done; 2 `[!]` packets (Address Add / P2P Payment Add emulator text-entry). Full local: 1841 tests pass. |
| Enterprise UI/UX sync + body/header audits | Closed 2026-06 | Body audit 409 A / 5 Tool; header strict issues 0; back navigation clean. |
| Whole-App UI Optimization + density | Closed 2026-06-20 | 100% complete; P0/P1 density backlog zero. |
| Home UI Deep Standardization (Phases 0–7) | Closed 2026-07-01 | `total_debt=0`; P2P 173→0; Trade/Markets/Earn/Shared migrated; VitSegmentedTabBar/VitSegmentedChoice rollout. |
| Shared components / typography / button / token plans | Absorbed | Rules live in `DESIGN.md`, `flutter_app/lib/app/theme/`, and `Guidelines.md`. |
| E900 / Post-E900 file-size refactor waves | Closed | Large-file debt reduced; 4 files still >1200 lines (ongoing, not blocking UI). |
| Card Tile migration execution plan/checklist | Closed 2026-07-07 | 993/993 files pass; compliance report + manifest/audit CSV kept as live CI baseline. |
| VitTrade UI Redesign v2.5 pending-batch trackers | Closed 2026-07-10 | 66/66 batch done; archived → `_archive/2026-redesign-v2.5/`. |
| IA / UI-UX full reorg (P0–P6) | Closed 2026-07-22 | Playbook archived → `_archive/2026-ia-ux-reorg/`; wireframes stay active. |
| A+ enterprise roadmap (67 done) | Closed | Assessment/manifest archived → `_archive/2026-a-plus-closed/`; `GD4-Async-Playbook.md` stays living. |

Active sources thay thế: `AGENTS.md`, `DESIGN.md`, `ke-hoach-san-sang-production.md`,
`AI_PROMPT_SHELL.md`, audit tools under `flutter_app/tool/`, `docs/_archive/`.

## 1. Kết luận hiện tại

Về **sắp xếp file và folder**, dự án hiện đã đạt **enterprise Flutter layout
baseline**:

- Source of truth đã tập trung trong `flutter_app/`.
- Runtime source nằm dưới `flutter_app/lib/`.
- `lib/` có đủ các vùng trách nhiệm chính: `app/`, `core/`, `features/`,
  `shared/` và `main.dart`.
- Toàn bộ `35/35` feature modules đang có đủ `domain/`, `data/` và
  `presentation/` (composition phone + tablet đầy đủ cho mọi route).
- Router facade nằm đúng tại `flutter_app/lib/app/router/app_router.dart`.
- Shared layout/design primitives đã được tách dưới `shared/`.
- Test suite đã bám theo app, feature, shared và quality guardrails.

Tuy nhiên, dự án **chưa nên được gọi là production enterprise-grade hoàn chỉnh**.
Lý do chính không còn nằm ở top-level folder layout, mà nằm ở các phần hardening
bên trong:

- Production backend path vẫn chủ yếu fail-closed vì chưa có backend contracts
  và remote repositories thật cho các critical modules — pilot auth đã chứng
  minh công thức (`RemoteAuthRepository` + playbook), phần còn lại là thao tác
  cơ học chờ contract ký.
- Release signing/hosted release CI vẫn là external ops blocker; pipeline
  release + obfuscate đã có sẵn, nhưng chưa có signing secrets thật và artifact
  phát hành xác nhận.
- File-size debt đã trả gần hết: `36` feature files trên 600 dòng và `2` file
  trên 1200 dòng (khóa bởi guardrail `architecture_size_style_debt`, ngưỡng
  ratchet không được tăng).
- Một số file `part` vẫn nằm trong `presentation/pages/`; chấp nhận được cho
  giai đoạn port/refactor, nhưng về lâu dài cần tiếp tục đẩy widget nhỏ sang
  `presentation/widgets/`, state sang `presentation/controllers/`, và value
  objects sang `domain/`.
- Core backend boundary đã đủ khung production: DTO mapping (ADR-010, pilot
  auth), typed errors (`ApiFailure`/`OfflineFailure` tiếng Việt),
  timeout/offline policy, auth/session injection qua interceptor — còn thiếu
  đúng một thứ: backend thật để 34 feature còn lại theo playbook.

Verdict ngắn: **đạt chuẩn cấu trúc nền enterprise-grade Flutter; chưa đạt chuẩn
production enterprise-grade hoàn chỉnh.**

## 2. Cấu trúc chuẩn hiện tại

```text
flutter_app/
|-- lib/
|   |-- main.dart
|   |-- app/
|   |   |-- providers/
|   |   |-- router/
|   |   `-- theme/
|   |-- core/
|   |   |-- config/        # AppConfig dart-defines (env, mock, kill-switch)
|   |   |-- data/          # repository guard + OfflineFailure
|   |   |-- navigation/    # back-navigation an toàn
|   |   |-- network/       # ApiClient + chuỗi interceptor (SEC-S46)
|   |   |-- observability/ # ErrorReporter/AnalyticsReporter seams (ADR-008)
|   |   |-- product_flow/  # hợp đồng high-risk flow
|   |   |-- storage/       # KeyValueStore/SecureStore seams (GĐ4-F1)
|   |   `-- utils/
|   |-- features/
|   |   `-- <feature>/
|   |       |-- domain/
|   |       |-- data/
|   |       `-- presentation/
|   |           |-- controllers/   # khi feature có state/controller riêng
|   |           |-- phone/pages/
|   |           |-- tablet/pages/
|   |           `-- widgets/       # khi feature có widget local reusable
|   `-- shared/
|       |-- layout/
|       `-- widgets/
`-- test/
```

Quy tắc giữ nguyên:

- App bootstrap, theme, router facade, route groups và shell composition nằm
  trong `app/`.
- Config, network boundary, typed errors, repository guard và cross-cutting
  utilities nằm trong `core/`.
- Mỗi business capability nằm trong `features/<feature>/`.
- Screen/page nằm trong `features/<feature>/presentation/{phone,tablet}/pages/`
  (web chỉ auth + home; surface được chốt một lần ở bootstrap — xem ADR-013).
- State/controller cho presentation nằm trong
  `features/<feature>/presentation/controllers/`.
- Widget tái sử dụng trong cùng feature nằm trong
  `features/<feature>/presentation/widgets/`.
- Repository contracts, entities và value objects nằm trong `domain/`.
- Mock/remote implementations, fixtures và Riverpod provider wiring nằm trong
  `data/`.
- Shared app shell, layout primitives và reusable UI primitives nằm trong
  `shared/`.

## 3. Evidence snapshot

Kiểm tra thực hiện ngày 2026-05-30 trên working tree hiện tại.

| Hạng mục | Kết quả | Nhận xét |
| --- | ---: | --- |
| Feature modules | `23` | Tất cả feature có đủ `domain/data/presentation`. |
| `lib` Dart files | `1087` | Runtime source lớn, đã tập trung trong Flutter app package. |
| `features` Dart files | `1006` | Phần lớn runtime code nằm trong feature modules. |
| `app` Dart files | `54` | Router, theme, providers và bootstrap nằm đúng vùng. |
| `core` Dart files | `5` | Đúng boundary, nhưng còn mỏng cho backend production thật. |
| `shared` Dart files | `21` | Shared layout/widget đã tách riêng. |
| `test` Dart files | `423` | Test inventory rộng và bám theo feature/quality. |
| Static route entries | `417` | Route coverage artifact đang current. |
| Real pages | `414` | Không còn route placeholder trong truth table. |
| Redirect aliases | `3` | Được phân loại riêng, không tính nhầm là screen thật. |
| Page/widget direct data imports | `0` | Đạt: pages/widgets không import trực tiếp `features/*/data`. |
| Controller mock/remote imports | `0` | Đạt: controllers không import mock/remote repositories trực tiếp. |
| Controller data-provider exposure | `0` | Đạt baseline hiện tại. |
| Non-controller feature data imports | `27` | Debt được guard; không được tăng. |
| `Color(0x...)` trong `lib` + `test` | `210` | Đang được khóa bằng guardrail. |
| `Color(0x...)` trong runtime `lib` | `186` | Tất cả nằm trong theme registry. |
| `Color(0x...)` ngoài `lib/app/theme/` | `0` | Đạt: không còn hardcoded color ngoài theme. |
| `Colors.*` trong runtime `lib` | `0` | Đạt: không còn Material color direct usage. |
| Feature files trên 600 dòng | `239` | Còn file-size debt; không được tăng. |
| Feature files trên 1200 dòng | `4` | Mốc M3 đã đạt, nhưng vẫn cần giảm tiếp. |

## 4. Verification mới nhất

| Ngày | Command | Result | Ghi chú |
| --- | --- | --- | --- |
| 2026-05-30 | `dart format --output=none --set-exit-if-changed .` | Passed, `1512` files, `0` changed | S8-02 full local verification; generated `flutter_app/build/` was cleaned before rerun. |
| 2026-05-30 | `flutter analyze` | Passed, no issues found | S8-02 full local verification. |
| 2026-05-30 | `flutter test --reporter=compact` | Passed, `1841` tests | S8-02 full local verification. |
| 2026-05-30 | `dart run tool/route_coverage_audit.dart --check` | Passed | S8-02 full local verification; route coverage artifact is current. |
| 2026-05-30 | `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, `10` tests | S8-01 audit refresh; confirms feature layers, presentation/data boundary, color guardrails, part-file debt, and large-file thresholds. |
| 2026-05-30 | S7 core navigation smoke | Passed | Artifacts: `flutter_app/run-artifacts/core-smoke-20260530T202735/`. |
| 2026-05-30 | S7 high-risk smoke | Partially passed | Artifacts: `flutter_app/run-artifacts/high-risk-smoke-20260530T204000/`; Address Add and P2P Payment Add completion blocked by emulator text-entry. |

Architecture guardrail và route audit đã chạy lại trong S8-01 để xác nhận audit
snapshot khớp code hiện tại. S8-02 full local checks đã xanh; các blocker còn
lại đều là backend/release external hoặc manual QA text-entry completion.

## 5. Nguồn bắt buộc

Đọc theo thứ tự này khi bắt đầu một task dài:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
6. `docs/02_FLUTTER_MIGRATION/standards/Flutter-Native-Design-Standard.md`
7. `docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md`
8. `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`
9. `docs/03_DESIGN_SYSTEM/Guidelines.md`
10. `DESIGN.md` (root)
11. `docs/02_FLUTTER_MIGRATION/ke-hoach-san-sang-production.md` (remaining work)

Khi tài liệu và code lệch nhau, source Flutter trong `flutter_app/lib/` và tests
trong `flutter_app/test/` là nguồn kiểm chứng trước.

## 6. Lệnh kiểm tra chuẩn

Chạy từ `flutter_app/`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Với batch nhỏ, chạy focused tests trước. Sau đó chạy full checks nếu thay đổi
đụng tới shared layout, router, repository contracts, theme tokens hoặc quality
guardrails.

## 7. Dashboard tiến độ

| Phase | Mục tiêu | Status | Metric chính | Next action |
| --- | --- | --- | --- | --- |
| Phase 0 | Khóa baseline | `[x]` | Guardrails xanh trong lượt kiểm tra mới nhất | Chạy lại trước mỗi refactor lớn. |
| Phase 1 | Presentation/Data boundary | `[x]` | Page/widget data imports `0`, controller mock/remote imports `0` | Giữ không tăng; không cho page gọi data provider trực tiếp. |
| Phase 2 | Tách file lớn | `[x]` | `>600` = `239`, `>1200` = `4` | Tiếp tục giảm bốn file còn trên 1200 dòng trước khi đóng file-size queue. |
| Phase 3 | Chuẩn hóa design tokens | `[x]` | Color ngoài theme `0`, `Colors.*` runtime `0` | Giữ token governance; thêm token semantic nếu cần. |
| Phase 4 | Remote production data path | `[!]` | Critical modules vẫn fail-closed khi chưa có backend contract thật | Ưu tiên backend contract, DTO, remote repo, typed error và tests. |
| Phase 5 | Router/release/QA hardening | `[!]` | Route audit xanh; S7 core smoke pass; high-risk smoke còn 2 text-entry blockers | Release signing/CI secrets và Address Add/P2P Payment Add completion cần owner ngoài repo hoặc manual QA. |

Final queue closeout:

- Sequential backlog local frontend hardening is complete after S8-03: no
  packet remains `[ ]` or `[~]`.
- Remaining `[!]` packets are `S2-06 - Wallet smoke evidence` and
  `S7-03 - Execute high-risk smoke`, both blocked on manual/emulator text-entry
  completion for Address Add and P2P Payment Add.
- Backend blockers remain external for Auth, Wallet, Trade, P2P, Predictions,
  and Arena remote repositories/contracts.
- Release blockers remain external for Android signing secrets and observed
  hosted CI/store artifact validation.

Status legend:

- `[x]` Done: đã implement, đã verify, metric liên quan không đỏ.
- `[~]` In progress: đã có một phần implementation hoặc batch pass nhưng chưa đạt
  acceptance cuối.
- `[ ]` Todo: chưa làm hoặc chưa có bằng chứng verification mới.
- `[!]` Blocked: cần backend contract, quyết định sản phẩm, credentials hoặc input
  ngoài repo.

## 8. Các debt cần xử lý tiếp

### 8.1 Production backend readiness

Mục tiêu: production không phụ thuộc mock data.

Ưu tiên:

1. Auth
2. Wallet
3. Trade
4. P2P
5. Predictions
6. Arena
7. Earn, Profile, Notifications và module phụ

Mỗi module cần:

- Backend contract doc hoặc contract tests.
- Remote repository thật.
- DTO mapping rõ ràng.
- Typed error mapping.
- Timeout/offline handling.
- Auth/session injection.
- Repository tests.
- Provider chỉ wire remote khi contract thật đã sẵn sàng.

Acceptance:

- `enableMockData == false` không dùng mock.
- Module chưa có backend thật phải fail-closed bằng empty/error state rõ ràng.
- High-risk flows vẫn có preview/confirm, fee/risk/limit/next-step copy.

### 8.2 File-size debt

Mục tiêu: giảm file lớn mà không phá public route/page imports.

Quy tắc:

- Page facade public vẫn giữ tên import hiện tại nếu router/test đang dùng.
- Section/widget nhỏ chuyển dần sang `presentation/widgets/`.
- State, view model, derived data chuyển sang `presentation/controllers/`.
- Entity/value object lớn chuyển sang file nhỏ trong `domain/`.
- Mock fixtures hoặc sample datasets lớn chuyển sang `data/fixtures/`.

Acceptance:

- `architecture_baseline_guardrails_test.dart` pass.
- Số file `>600` và `>1200` không tăng.
- Không mất public exports đang được route/page/test dùng.

### 8.3 Router và release hardening

Public router facade phải giữ:

- `createAppRouter`
- `appRouter`
- `AppRoutePaths`
- `AppRouteNames`

Quy tắc:

- Duy trì route groups hiện tại.
- Không tạo placeholder/skeleton route mới để làm đầy số lượng.
- Route coverage thay đổi có chủ đích phải cập nhật artifact Flutter-native liên
  quan.
- Không dùng lại React/Vite/web screenshot tooling đã obsolete.

Acceptance:

- Route audit pass.
- Router tests và focused navigation tests pass.
- Product copy guardrails, signing guardrails và release metadata checks pass.

## 9. Product boundaries phải giữ

Prediction Markets và Open Arena phải tách rời.

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL / positions | Points pool / completion |
| History | Orders / receipts | Ledger entries |
| Leaderboard | Trading context | Fair play / completion |

Allowed bridges: topic/category, event context, creator discovery,
search/discovery và profile surfaces với section tách biệt rõ ràng.

Arena copy phải points-only. Không dùng payout, wallet, profit hoặc stake-return
language cho Arena.

Prediction Markets có thể dùng positions, probability, receipt, rewards và P/L;
tránh hype hoặc casino language.

## 10. Mẫu work packet cho AI

Copy mẫu này khi giao task mới:

```md
## Work Packet: <phase>/<module>/<flow>

Goal:
- <mục tiêu cụ thể, đo được>

Scope:
- Files/routes/features được phép chạm:
- Files/routes/features không được chạm:

Read first:
- <docs hoặc source cần đọc>

Implementation:
- <các bước code chính>

Tests:
- <focused tests cần thêm/sửa>
- <lệnh test cần chạy>

Acceptance:
- <metric hoặc behavior phải đạt>

Stop/ask if:
- <điều kiện cần xác nhận thay vì đoán>
```

## 11. Definition of Done cho mỗi AI batch

Một batch chỉ được coi là xong khi:

- Code nằm đúng module/layer theo enterprise Flutter layout.
- Tests liên quan được thêm hoặc cập nhật.
- Focused tests pass.
- Guardrail liên quan pass.
- `dart format .` đã chạy nếu có sửa Dart.
- Không tăng architecture debt, hardcoded color debt hoặc large-file debt ngoài
  scope đã được ghi rõ.
- Final summary nêu rõ files đã chạm, tests đã chạy, metric thay đổi và rủi ro
  còn lại nếu có.
