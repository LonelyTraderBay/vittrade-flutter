# Báo cáo Đánh giá & Lộ trình lên chuẩn A+ — VitTrade Flutter Frontend

> **Tài liệu kỹ thuật cho buổi họp đội.** Đánh giá hiện trạng so với chuẩn Frontend Flutter Enterprise-Grade và lộ trình chi tiết tới A+.
>
> **Ngày:** 2026-07-15 · **Phạm vi:** toàn bộ `flutter_app/` (2.216 file Dart, ~467k dòng, 28 feature module) trên working tree hiện tại (có 104 file chưa commit).
> **Phương pháp:** 44 agent read-only chạy song song (9 chiều audit + 1 audit kiểm thử + 10 kiến trúc sư khắc phục A+), mỗi finding nặng qua phản biện độc lập, mọi khuyến nghị đọc lại code thật tới cấp file/dòng. **Không sửa code trong quá trình đánh giá.**

---

## 0. Tóm tắt điều hành

**Kết luận: dự án đã là "Enterprise-Grade có điều kiện" (xếp loại chung B). Phần lõi kỹ thuật đạt chuẩn thật; khoảng cách tới A+ nằm ở i18n/a11y, độ nghiêm công cụ, và một cụm "nợ mock-phase" sẽ thành lỗi thật khi backend thay mock.**

Ba điều cần nói với đội ngay:

1. **Nền móng rất tốt, không phải làm lại từ đầu.** 28/28 module đúng layout domain/data/presentation; tầng domain 100% sạch import Flutter; an toàn tài chính được cài vào *kiến trúc* (mock không thể bật ở production, repository fail-closed ném lỗi thay vì hiển thị số dư giả); và hệ governance tự động hoá 4 tầng (chuẩn → tool audit → guardrail test → CI step) thuộc nhóm hiếm thấy. Đây là tài sản, phải giữ.

2. **Mẫu hình xuyên suốt: cái gì được guardrail gác thì xuất sắc, cái gì ngoài tầm guardrail thì trôi.** Vòng phụ thuộc trade-family tồn tại vì layering chỉ gác bằng regex-ratchet (không có import-graph lint); 3/9 luồng high-risk bị hở vì allowlist là danh sách file cứng; tiền tệ hiển thị lệch nhau vì chưa có guardrail cấm formatter cục bộ. **Bước tiến hoá lên A+ chính là chuyển hệ guardrail từ "opt-in theo danh sách" sang "mặc định bị gác, ngoại lệ phải khai báo".**

3. **Có 2 finding P0 (mức chặn) và một "vách đá nợ mock-phase".** P0: 3/9 contract high-risk không được guardrail nào gác; module lớn nhất app (earn) không có unit test tầng data/domain. "Vách đá": 0 `autoDispose` toàn app, chưa có idiom lỗi async, 9/25 feature bỏ qua fail-closed guard — tất cả vô hại với mock hôm nay nhưng thành lỗi thật ngay khi backend về. **Việc rẻ nhất và giá trị nhất là đóng các mục này *trước* khi tích hợp backend**, vì retrofit sau đắt hơn nhiều lần.

**Quyết định lớn nhất cần chốt trong buổi họp:** đường đi i18n (đây là lý do chính kéo điểm xuống D) — cam kết **vi-VN-only có văn bản** hay **đầu tư gen-l10n + ratchet**. Xem mục 6 và phần "Quyết định cần chốt".

---

## 1. Bảng điểm & khoảng cách tới A+

| # | Chiều | Hiện tại | Rào cản chính lên A+ | Nhóm việc nặng nhất |
| --- | --- | :---: | --- | --- |
| 4 | Bảo mật & an toàn tài chính | **A** | Masking chưa test/tập trung; guardrail Arena chỉ tiếng Anh | Cải thiện |
| 1 | Kiến trúc & ranh giới module | **B** | 2 vòng phụ thuộc trade-family; không import-graph lint | Viết lại + Cải thiện |
| 2 | Quản lý state (Riverpod 3) | **B** | 0 autoDispose; chưa có idiom async; setState-trên-bản-sao | Viết lại + Tối ưu |
| 3 | Xử lý lỗi & phục hồi | **B** | Không error boundary; 9/25 feature hở fail-closed | Cải thiện + Viết lại |
| 5 | Hiệu năng | **B** | Leak provider màn đặt lệnh; không benchmark hồi quy | Tối ưu + Cải thiện |
| 7 | Deps, tooling & CI/CD | **B** | Analyzer mỏng; CI tuần tự không coverage; không release eng | Cải thiện + Tối ưu |
| 8 | Nợ code | **B** | 310 formatter cục bộ + drift tiền tệ đang sống | Tối ưu + Cải thiện |
| 9 | Tài liệu & quản trị | **B** | INDEX.md sai với đĩa; thiếu ADR/CONTRIBUTING | Cải thiện |
| 10 | Độ sâu kiểm thử | **B-** | 2 P0 (high-risk allowlist, earn); 21/28 thiếu test data | Cải thiện |
| 6 | i18n & a11y | **D** | Không i18n framework; 4 lỗi a11y P1 | Viết lại (quyết định SP) |

**Cách đọc tài liệu — mỗi hạng mục hành động được gắn 3 nhãn:**

- **Loại việc:** `Cải thiện` (bổ sung/vá cái đang thiếu, giữ thiết kế) · `Tối ưu` (đang đúng nhưng chưa hiệu quả/gọn) · `Viết lại` (pattern hiện tại sai hướng, thay bằng pattern khác).
- **Ưu tiên:** `P0` (chặn enterprise-readiness) · `P1` (nợ lớn) · `P2` (nên làm) · `P3` (nice-to-have).
- **Effort:** `S` (<0.5 ngày) · `M` (0.5–2 ngày) · `L` (>2 ngày / cần thiết kế).

---

# PHẦN CHI TIẾT — 10 chiều, hành động cụ thể tới cấp file

## 1. Kiến trúc & ranh giới module — Hiện tại: B → Mục tiêu: A+

> **Lưu ý cập nhật từ code thật:** union repository 6 chiều của `trade_core` **đang được gỡ dở** trong working tree (Phase 5, chưa commit) — phần này gần xong. Nhưng vẫn còn **2 vòng phụ thuộc hai chiều thật** đã xác nhận cả hai chiều (xem bên dưới).

**A+ cho chiều này nghĩa là gì:** 0 vòng phụ thuộc hai chiều giữa các feature ở tầng domain/entity (đồ thị import theo module là DAG). CI có một guardrail dựng đồ thị import cấp feature và fail khi xuất hiện cycle hoặc cạnh cấm (vd `trade_core` import ngược sibling). Chỉ còn **1** quy ước đặt tên part-file được tài liệu hoá trong AGENTS.md và có guardrail chặn quy ước lạ. Hằng số route được shard theo feature, không còn file đơn khối mọi feature phải chạm.

**Khoảng cách chính hiện nay:** Union repository 6 chiều của `trade_core` đang được gỡ dở trong working tree (Phase 5, chưa commit), nhưng còn **2 vòng phụ thuộc hai chiều thật**: (a) tầng entity/read-model `trade_core ↔ {trade_terminal, trade_bots, trade_compliance, trade_copy}`, (b) `trade ↔ trade_terminal` mới sinh ra do đợt tách. Không có công cụ import-graph nào — `analysis_options.yaml` chỉ có `flutter_lints`, còn `architecture_baseline_guardrails_test.dart` là ratchet đếm-regex nên cycle vô hình với CI. Kèm theo: ≥5 quy ước part-file cùng tồn tại, 1029 dòng hằng số route đơn khối, và một borderline `core` chạm `flutter/widgets`.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | Gỡ 2 vòng phụ thuộc còn lại của trade family | Viết lại | P1 | L | `trade_core/presentation/controllers/{trade_read_model,trade_controller}.dart`; `trade_terminal/presentation/pages/tools/*.dart`; `trade/domain/repositories/trade_repository.dart` | Cycle domain khoá cứng 6 module lại với nhau; không test/build/thay mock độc lập từng module được | test guardrail cycle mới (A2) xanh; `flutter analyze` |
| A2 | Guardrail import-graph phát hiện cycle trong CI | Cải thiện | P1 | M | thêm `test/quality/module_dependency_cycle_guardrail_test.dart` (tái dùng `_sourceMatches`) | Regression cycle lọt CI; A1 làm xong lại vỡ âm thầm | `flutter test test/quality/module_dependency_cycle_guardrail_test.dart` |
| A3 | Shard hằng số route theo feature | Tối ưu | P2 | M | `app/router/app_route_names.dart` (480 dòng), `app_route_paths.dart` (549 dòng) | File đơn khối mọi feature phải chạm → nghẽn merge, lệch với 21 file `route_groups/*` | `flutter test test/quality/route_coverage_guardrails_test.dart`; `flutter analyze` |
| A4 | Chuẩn hoá về 1 quy ước part-file | Cải thiện | P2 | S | `*_part_NN.dart`, `*_page_sections/_common.dart`, tên mô tả, `*_repository_methods/_fixtures.dart`, `*_entities.dart` | Onboarding chậm, khó grep/đoán vị trí code | thêm assert vào `architecture_baseline_guardrails_test.dart`; `flutter analyze` |
| A5 | Xử lý `core` chạm `flutter/widgets` | Tối ưu | P3 | S | `core/navigation/back_navigation.dart:1` | Rò rỉ ranh giới "core = non-UI", tiền lệ cho import UI khác vào core | grep import UI trong `lib/core/`; `flutter analyze` |
| A6 | Cập nhật exception guardrail `trade` đã lỗi thời + re-baseline | Cải thiện | P2 | S | `architecture_baseline_guardrails_test.dart:11-17,255` | Comment/baseline sai lệch thực tế → guardrail mất ý nghĩa, khó review PR tách module | `flutter test test/quality/architecture_baseline_guardrails_test.dart` |

**Chi tiết từng hạng mục**

### A1. Gỡ 2 vòng phụ thuộc hai chiều còn lại của trade family — [Viết lại] · [P1] · [Effort L]
- **Hiện trạng:**
  - *Union repository (đang gỡ dở):* Tại HEAD (`6da5cfc3`) `trade_core/domain/repositories/trade_repository.dart` là union 6 chiều. Working tree hiện tại đã xoá file này (` D` trong git status) và cấp cho `trade` repository riêng 2 chiều: `flutter_app/lib/features/trade/domain/repositories/trade_repository.dart:13-14` — `abstract interface class TradeRepository implements SpotTradeRepository, TradeFuturesMarginRepository`. **Phần này gần xong, chỉ cần commit sạch.**
  - *Cycle 1 — entity/read-model (còn nguyên):* `trade_core/presentation/controllers/trade_read_model.dart:2-5` và `trade_controller.dart:2-6` **export** entity của 4 sibling (`trade_terminal`, `trade_bots`, `trade_compliance`, `trade_copy`); chiều ngược lại `trade_terminal/domain/entities/trade_terminal_entities.dart:1` (và 3 sibling còn lại) **import** `trade_core/domain/entities/trade_core_entities.dart`. → `trade_core ↔ 4 sibling` hai chiều.
  - *Cycle 2 — trade ↔ trade_terminal (mới, do đợt tách):* chiều `trade → trade_terminal` qua repo trên; chiều `trade_terminal → trade` qua 5 trang tool import widget của `trade`: `trade_terminal/presentation/pages/tools/{advanced_analytics_page,advanced_tools_demo_page,advanced_trading_demo_page,execution_quality_demo_page,risk_management_demo_page}.dart` đều `import 'package:vit_trade_flutter/features/trade/presentation/widgets/hub/trade_product_navigation.dart'` (vd `advanced_analytics_page.dart:18`), **dù `trade_core` đã có bản `trade_core/presentation/widgets/trade_product_navigation.dart`**.
- **Cần làm:**
  - *Cycle 1:* Bỏ mọi `export` sibling-entity khỏi 2 barrel `trade_core/.../trade_read_model.dart` và `trade_controller.dart`. Entity thật sự dùng chung phải nằm ở leaf `trade_core/domain/entities/` và chỉ chảy 1 chiều `sibling → trade_core`; trang nào cần entity của sibling thì import trực tiếp module đó, hoặc dựng một read-model facade đặt **trên** mọi feature (tầng `app/providers/`), không đặt trong `trade_core`.
  - *Cycle 2:* Hợp nhất `trade_product_navigation` về bản dùng chung ở `trade_core/presentation/widgets/` (đối chiếu nội dung 2 file trước khi gộp — có thể trùng), rồi trỏ 5 trang tool của `trade_terminal` sang bản `trade_core`, cắt cạnh `trade_terminal → trade`. Sau đó `trade → trade_terminal` là DAG 1 chiều hợp lệ.
  - Pattern đích: mỗi feature chỉ phụ thuộc `trade_core` (leaf dùng chung) một chiều; không feature nào import ngược lên module tổng hợp.
- **Kiểm chứng:** `flutter test test/quality/module_dependency_cycle_guardrail_test.dart` (test mới ở A2) xanh với 0 cycle; `flutter analyze` không lỗi; grep xác nhận `trade_core` không còn `export 'package:vit_trade_flutter/features/(trade_terminal|trade_bots|trade_compliance|trade_copy)/'` và `trade_terminal` không còn import `features/trade/`.

### A2. Guardrail import-graph phát hiện cycle trong CI — [Cải thiện] · [P1] · [Effort M]
- **Hiện trạng:** Enforcement kiến trúc duy nhất là `test/quality/architecture_baseline_guardrails_test.dart` — toàn bộ là ratchet **đếm regex**: số import data phi-controller `lessThanOrEqualTo(39)` (dòng 255), phơi data-provider trong controller `<= 0` (273), trần part-file page `<= 218` (307), file lớn `> 600` dòng `<= 239` (367). Không hàm nào dựng đồ thị import hay phát hiện chu trình. `analysis_options.yaml` chỉ `include: package:flutter_lints/flutter.yaml`, không có `import_lint`/`dart_code_metrics`/plugin layer. (Task gốc xếp P2; nâng lên P1 vì A+ bar yêu cầu tường minh và đây là chốt giữ cho A1 khỏi vỡ lại.)
- **Cần làm:** Thêm `test/quality/module_dependency_cycle_guardrail_test.dart` (thuần Dart, không thêm dependency — tái dùng `_sourceMatches`/duyệt `Directory('lib/features')` như file hiện có): parse mọi dòng `import/export 'package:vit_trade_flutter/features/<X>/...'`, dựng cạnh `feature→feature`, chạy DFS phát hiện chu trình và `expect(cycles, isEmpty)`. Giai đoạn đầu để **allowlist** 2 cycle đã biết (entity-layer + trade↔trade_terminal) rồi ratchet giảm dần khi A1 tiến triển; bổ sung assert cạnh cấm cứng: `trade_core` không được import/export bất kỳ `features/<sibling>/`.
- **Kiểm chứng:** `flutter test test/quality/module_dependency_cycle_guardrail_test.dart`; chạy trong khối `vt-verify` cùng `flutter test test/quality/`.

### A3. Shard hằng số route theo feature — [Tối ưu] · [P2] · [Effort M]
- **Hiện trạng:** `app/router/app_route_names.dart` (480 dòng, `part of 'app_router.dart'`, `final class AppRouteNames` với hàng trăm `static const String scNNN...`, xem dòng 3-30) và `app_route_paths.dart` (549 dòng) là 2 file đơn khối mọi feature phải sửa khi thêm màn. Trong khi đăng ký route đã shard đẹp theo feature ở `app/router/route_groups/*.dart` (21 file: `trade_routes.dart`, `earn_routes.dart`, ...). Bất đối xứng: registration sharded, constants monolith.
- **Cần làm:** Tách hằng số theo cùng ranh giới với `route_groups/`: đưa các `scNNN` name + path của mỗi nhóm vào chính file `route_groups/<feature>_routes.dart` tương ứng (hoặc `route_groups/<feature>_route_ids.dart` cạnh nó), giữ `AppRouteNames`/`AppRoutePaths` như facade tổng hợp (re-export) để không phá call-site hiện tại. Làm dần từng nhóm để tránh churn lớn.
- **Kiểm chứng:** `flutter test test/quality/route_coverage_guardrails_test.dart` và `navigation_route_guardrails_test.dart` xanh (đảm bảo không rơi route); `flutter analyze`.

### A4. Chuẩn hoá về 1 quy ước part-file — [Cải thiện] · [P2] · [Effort S]
- **Hiện trạng:** Trong trade family có ≥5 quy ước part-file cùng tồn tại: (1) đánh số `*_part_01.dart`/`*_part_02.dart` (vd `convert_page_part_01.dart`, `margin_trading_page_part_04.dart`); (2) hậu tố vai trò `*_page_sections.dart`/`*_page_common.dart` (vd `orders_history_page_sections.dart`); (3) tên mô tả nhiều từ (`leverage_header_hero_risk.dart`, `margin_trading_order_summary.dart`); (4) tách fixture/method `*_repository_methods.dart`/`*_repository_fixtures.dart`; (5) part entity `trade_shared_entities.dart`/`trade_advanced_tools_entities.dart`.
- **Cần làm:** Chốt 1 quy ước trong AGENTS.md (đề xuất: `*_part_NN.dart` cho tách cơ học tạm thời — vốn đã là "nợ có theo dõi" ở test dòng 293-313; tên vai trò `_sections`/`_common` cho part ổn định tái dùng). Bổ sung assert trong `architecture_baseline_guardrails_test.dart` chặn part-file có suffix ngoài whitelist mới. Không đổi hàng loạt ngay — chỉ chặn phát sinh mới rồi migrate dần.
- **Kiểm chứng:** `flutter test test/quality/architecture_baseline_guardrails_test.dart` (assert mới); `flutter analyze`; grep liệt kê suffix part-file còn lại.

### A5. Xử lý `core/navigation/back_navigation.dart` chạm `flutter/widgets` — [Tối ưu] · [P3] · [Effort S]
- **Hiện trạng:** `core/navigation/back_navigation.dart:1` `import 'package:flutter/widgets.dart'` (và `go_router` dòng 2) vì `goBackOrFallback`/`resolveSafeBackPath` cần `BuildContext`. Đây là borderline vi phạm quy ước "core = non-UI".
- **Cần làm:** Chọn 1 trong 2 và ghi rõ vào AGENTS.md: (a) chấp nhận navigation là mối bận tâm core "UI-adjacent", thêm doc comment giải thích BuildContext là bắt buộc và whitelist file này trong guardrail core; hoặc (b) di chuyển sang tầng dùng chung có phép chạm widget (vd `app/router/` hoặc `core/presentation/`), giữ phần thuần chuỗi (`_normalizeInternalPath`, `resolveSafeBackPath`) ở core non-UI. Không đổi API công khai `goBackOrFallback` để tránh phá call-site.
- **Kiểm chứng:** grep `import 'package:flutter/` trong `lib/core/` xác nhận chỉ còn file được whitelist; `flutter analyze`; `flutter test test/quality/back_navigation_behavior_guardrail_test.dart`.

### A6. Cập nhật exception guardrail `trade` đã lỗi thời + re-baseline — [Cải thiện] · [P2] · [Effort S]
- **Hiện trạng:** `architecture_baseline_guardrails_test.dart:11-17` bỏ qua `trade` khỏi kiểm tra "đủ 3 tầng domain/data/presentation" với lý do "`trade` is intentionally presentation-only". Nhưng working tree đã cấp cho `trade` cả `domain/` và `data/` riêng (git status: `A features/trade/domain/repositories/trade_repository.dart`, `A features/trade/data/...`) — comment và tập `presentationOnlyModules = {'trade'}` nay lỗi thời. Baseline import data phi-controller `<= 39` (dòng 255) cũng cần soát lại sau khi Phase 5 commit.
- **Cần làm:** Khi commit đợt tách: bỏ `trade` khỏi `presentationOnlyModules` (giờ nó có đủ tầng), cập nhật khối comment lịch sử Phase 5, và re-baseline con số `39`/`218`/`239` theo trạng thái sau commit (giảm nếu cross-feature import đã trend down đúng như comment dự báo).
- **Kiểm chứng:** `flutter test test/quality/architecture_baseline_guardrails_test.dart` xanh với baseline mới; đối chiếu số đếm thực bằng chính output của test khi fail.

**Thứ tự đề xuất trong chiều:** A2 (dựng guardrail cycle ở chế độ allowlist trước) → A1 (gỡ 2 cycle, ratchet A2 về 0) → A6 (commit sạch Phase 5 + re-baseline) → A3 (shard route constants) → A4 (chuẩn hoá part-file) → A5 (dọn ranh giới core navigation).


---

All findings verified against real code. Here is the documentation block.

## 2. Quản lý state (Riverpod 3) — Hiện tại: B → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** (1) Mọi provider có vòng đời rõ ràng — `autoDispose` là mặc định được lint/guardrail ép, provider `family` chỉ key bằng giá trị bất biến (id), không rò rỉ element theo thao tác người dùng. (2) Idiom async chuẩn hoá một kiểu duy nhất (`AsyncNotifier` + `AsyncValue.guard` / `.when`) và trạng thái loading/error/empty xuất hiện ở các flow rủi ro cao, không chỉ 2 module. (3) Không có "hai nguồn sự thật": mọi mutation domain đi qua Notifier và ghi ngược về repository, không tồn tại bản sao `late List` + `setState`. (4) Chỉ một pattern controller cho toàn app; state machine (`TradeHighRiskFlowStatus`) thực sự chuyển trạng thái ở production.

**Khoảng cách chính hiện nay:** 0 `autoDispose` trên toàn `lib` (đã xác minh: grep trả 0 kết quả) và `Provider.family` key bằng draft object không có `==`/`hashCode` → rò 1 element mỗi keystroke ở màn đặt lệnh. State machine 10 trạng thái tồn tại nhưng controller là `const` immutable nên không bao giờ rời `ready`. Mutation chủ đạo là `setState` trên bản sao cục bộ ở ≥18 trang (không phải 3), gây mất dữ liệu khi điều hướng. Idiom async chỉ có ở 2/28 module (home, news). Ba kiểu lấy controller cùng tồn tại làm nhoè convention.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S2.1 | Vá rò element `Provider.family` theo keystroke | Viết lại | P1 | M | `app/providers/trade_controller_providers.dart:47–116`; `features/trade/presentation/widgets/hub/trade_page_part_01.dart:76–85,141`; `features/trade_core/domain/entities/trade_core_spot_entities.dart:375–389` | Rò bộ nhớ tuyến tính theo số ký tự gõ vào ô số lượng ở màn spot/futures/leverage; app dài phiên phình RAM | Widget test bơm N keystroke + assert số element trong `ProviderContainer`; DevTools memory |
| S2.2 | Dựng lại tầng async cho flow rủi ro cao | Viết lại | P1 | L | `features/trade/presentation/controllers/trade_order_controller_models.dart:7–64`; `features/trade_core/presentation/controllers/trade_read_model.dart:7–42`; `app/providers/trade_controller_providers.dart` | State machine 10 trạng thái là "code chết"; không có loading/confirm/success/error thật khi nối backend | `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart`; test transition ready→submitting→success |
| S2.3 | Gỡ "hai nguồn sự thật" (bản sao `late List`+`setState`) | Viết lại | P1 | L | ≥18 trang, tiêu biểu: `markets/.../watchlist_page.dart:60–96,145–162`; `wallet/.../address_book_page.dart:58–67,205–214,245–250`; `p2p/.../p2p_fraud_prevention_page.dart:61` | Sửa/xoá/favorite mất khi điều hướng; không write-back; UI lệch với provider | So với mẫu `app/providers/notifications_controller_providers.dart:59–106`; test điều hướng đi–về giữ nguyên mutation |
| S2.4 | Ép convention `autoDispose` + cấm sao chép provider bằng lint/guardrail | Cải thiện | P1 | S | `flutter_app/analysis_options.yaml:10–12`; `test/quality/architecture_baseline_guardrails_test.dart` | Không có rào chắn → pattern rò và dual-source tái diễn ở PR mới | `flutter analyze`; `flutter test test/quality/architecture_baseline_guardrails_test.dart` |
| S2.5 | Bỏ `AsyncValue.requireValue` tiềm ẩn StateError | Cải thiện | P2 | S | `app/providers/home_controller_providers.dart:11–14` | `requireValue` ném `StateError` nếu đọc lúc loading/error từ consumer khác `home_page` | `flutter test test/features/home/home_controller_test.dart` |
| S2.6 | Hợp nhất về 1 pattern controller | Viết lại | P2 | M | `trade_controller_providers.dart` (Provider bọc controller immutable) vs `notifications_controller_providers.dart` (NotifierProvider) vs các trang `setState` | Ba idiom song song làm khó review/onboard, che khuất composition-root | Grep còn ≤1 kiểu tạo controller stateful; review kiến trúc |

**Chi tiết từng hạng mục**

### S2.1. Vá rò element `Provider.family` theo keystroke — [Viết lại] · [P1] · [Effort M]
- **Hiện trạng:** `tradeOrderControllerProvider`, `tradeFuturesOrderControllerProvider`, `tradeLeverageControllerProvider` là `Provider.family` KHÔNG `autoDispose` (`trade_controller_providers.dart:47,102,63`), key là record chứa draft (`TradeOrderControllerRequest = ({String pairId, TradeOrderDraft draft})`, dòng 19–25). `TradeOrderDraft` (`trade_core_spot_entities.dart:375–389`) không override `==`/`hashCode` → so sánh theo identity. Trong `_TradePageState.build` (`trade_page_part_01.dart:76–85`) mỗi lần build tạo MỘT `TradeOrderDraft` mới rồi `ref.watch(tradeOrderControllerProvider((pairId:..., draft: draft)))`; ô số lượng gọi `onChanged: () => setState(() {})` (dòng 141) nên mỗi keystroke → rebuild → draft mới → record key mới ≠ cũ → Riverpod tạo thêm 1 family element và giữ mãi (không `autoDispose`).
- **Cần làm:** Chọn một trong hai pattern đích, ưu tiên (a): (a) Đổi key `family` sang chỉ `pairId` (bất biến) và chuyển draft (side/type/price/amount) vào state của một `Notifier` (xem S2.2/S2.6) — draft không còn là khoá cache; (b) Nếu tạm giữ draft trong key: thêm `autoDispose` cho cả 3 family VÀ cấp value-equality cho `TradeOrderDraft`/`TradeFuturesOrderDraft`/`TradeFuturesLeverageRequest` (`==`+`hashCode`, hoặc chuyển sang record/`Equatable`) để keystroke lặp giá trị không sinh element mới; element không dùng vẫn được thu hồi khi widget rời cây. Bắt buộc rà thêm `tradeScreenProvider`/`tradeFuturesProvider` (dòng 27–34) cùng chiến lược `autoDispose`.
- **Kiểm chứng:** Widget test `pumpWidget(TradePage)` → `enterText` 20 lần → đọc số element của `container.getAllProviderElements()` cho family, assert không tăng tuyến tính. Bổ sung `flutter analyze` sau khi bật lint ở S2.4.

### S2.2. Dựng lại tầng async cho flow rủi ro cao — [Viết lại] · [P1] · [Effort L]
- **Hiện trạng:** `TradeOrderController` là class `const` bất biến với đúng một field `state` (`trade_order_controller_models.dart:23–30`); `TradeOrderViewState.status` mặc định `TradeHighRiskFlowStatus.ready` (dòng 12) và KHÔNG bao giờ được gán lại. `submit()` (dòng 61–63) gọi thẳng `_repository.submitOrder(...)` trả receipt đồng bộ, không chuyển `ready→submitting→success/error`. Enum `TradeHighRiskFlowStatus` có 10 trạng thái (`trade_read_model.dart:7–18`) nhưng grep toàn `lib` cho thấy `submitting/confirming/preview/success/error/offline` chỉ bị ĐỌC trong guard (vd `state.status == ...offline`, `...isBusy`) — không có điểm nào GHI các trạng thái đó ở production → các nhánh guard là dead branch. Idiom async thật chỉ tồn tại ở 4 file / 2 module: `home` (`home_controller_providers.dart`, `home_page_part_01.dart:157` dùng `homeAsync.when`) và `news`.
- **Cần làm:** Chuyển `TradeOrderController` (và tương tự futures/leverage) từ class `const` sang `AsyncNotifier`/`Notifier` giữ `TradeOrderViewState` mutable; `submit()`/`preview()` phải `state = state.copyWith(status: submitting)` → `await guard(repo call)` → `success`/`error`, tận dụng `loadDelay` sẵn có trong mock repo để render loading/error thật. Nối `VitHighRiskStatePanel` (đã có ở `trade_page_part_01.dart:144–152` qua `highRiskContractId`) vào `status` thực thay vì luôn `ready`. Làm pilot 2–3 flow trước (spot order, futures order, leverage) rồi mở rộng; đây là lý do Effort L (cần thiết kế state machine + đồng bộ 6 module trade family dùng chung enum).
- **Kiểm chứng:** `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart` (đang assert page chứa `VitHighRiskStatePanel`+`highRiskContractId`); thêm unit test controller khẳng định chuỗi transition và `errorMessage` khi repo ném lỗi; `flutter test test/quality/high_risk_text_entry_harness_test.dart`.

### S2.3. Gỡ "hai nguồn sự thật" — [Viết lại] · [P1] · [Effort L]
- **Hiện trạng:** Pattern lặp lại: seed bản sao cục bộ trong `initState` bằng `ref.read(...)`, mutate bằng `setState`, trong khi `build` lại `ref.watch(...)` cùng provider — hai nguồn song song, mất khi điều hướng, không write-back. Đã xác minh ≥18 trang qua grep `late List<...>` trong `presentation/pages`: `watchlist_page.dart:60,65–68` (`_entries`, mutate ở `:92–96` remove và `:145–157` edit note, còn `build:162` watch snapshot); `address_book_page.dart:58,67` (`_addresses`, mutate `:205–214` toggle favorite, `:245–250` delete, còn `build:78` watch `walletAddressBookProvider`); `p2p_fraud_prevention_page.dart:61` (`_checklist` — chính là "security checklist"); ngoài ra `p2p_2fa_settings_page.dart:53–54`, `p2p_device_management_page.dart:53`, `p2p_suspicious_activity_page.dart:39`, `dca_rebalance_config_page.dart:67`, `savings_notification_preferences_page.dart:55–56`, `launchpad_webhooks_page.dart:118`, `launchpad_gas_tracker_page.dart:76`, `launchpad_multisig_page.dart:67`, `launchpad_address_book_page.dart:63`, `price_alerts_page.dart:98`, `comparison_tool_page.dart:44`, `arena_blocked_users_page.dart:49`, `advanced_chart_page.dart:61`, `trade_history_export_page.dart:57`. (Loại trừ `otp_page.dart:63–64` — `late final List<TextEditingController>/<FocusNode>` là controller UI hợp lệ, không phải bản sao domain.)
- **Cần làm:** Nâng mỗi collection mutable lên `NotifierProvider` theo đúng mẫu đã có `NotificationsStateController` (`notifications_controller_providers.dart:59–106`: `build()` seed từ repo, `markRead/deleteNotification/copyWith` cập nhật `state`, `List.unmodifiable`). Trang chỉ `ref.watch(...)` + gọi method Notifier; bỏ `late List` và `setState`. Với mock hiện tại, thêm method write-back vào repository (hoặc giữ state ở Notifier tồn tại suốt phiên) để mutation không mất khi điều hướng. Effort L vì trải 8 module; nên làm theo lô module (markets → wallet → p2p → launchpad → earn/dca/arena).
- **Kiểm chứng:** Test điều hướng: mở trang → mutate (xoá/favorite) → `context.go` sang trang khác → quay lại → assert state giữ nguyên. Guardrail ở S2.4 chặn tái xuất hiện `late List<...>` seed từ `ref.read` trong `presentation/pages`.

### S2.4. Ép convention `autoDispose` + cấm sao chép provider bằng lint/guardrail — [Cải thiện] · [P1] · [Effort S]
- **Hiện trạng:** `analysis_options.yaml` rất mỏng — chỉ `include: package:flutter_lints/flutter.yaml` và `avoid_print: true` (dòng 1,10–12); không có `riverpod_lint`/`custom_lint`. Không có rào chắn nào ngăn `Provider.family` thiếu `autoDispose` hay pattern `late List`+`setState` sao chép provider (đã có sẵn hệ guardrail grep-based trong `test/quality/*`, ví dụ `architecture_baseline_guardrails_test.dart`, `high_risk_state_primitives_guardrail_test.dart`).
- **Cần làm:** (a) Thêm `riverpod_lint` + `custom_lint` vào dev_dependencies và bật analyzer plugin trong `analysis_options.yaml`, hoặc — theo đúng "văn hoá" repo — (b) viết guardrail test mới kiểu grep trong `test/quality/` (vd `state_management_guardrail_test.dart`) fail khi: `Provider.family(` xuất hiện không kèm `.autoDispose`/không key bằng scalar id; và khi file trong `presentation/pages` có `late List<` được seed bằng `ref.read(` (dấu hiệu dual-source). Ghim danh sách trang hiện vi phạm làm baseline rồi siết dần.
- **Kiểm chứng:** `flutter analyze` (nếu dùng lint plugin); `flutter test test/quality/architecture_baseline_guardrails_test.dart` và test guardrail mới; hoặc chạy khối chuẩn qua skill `vt-verify`.

### S2.5. Bỏ `AsyncValue.requireValue` tiềm ẩn StateError — [Cải thiện] · [P2] · [Effort S]
- **Hiện trạng:** `home_controller_providers.dart:12` gọi `ref.watch(homeSnapshotProvider).requireValue` bên trong `homeControllerProvider`. `requireValue` ném `StateError` khi `AsyncValue` đang `loading`/`error`. Hiện `home_page_part_01.dart:157` render qua `homeAsync.when(...)` nên tránh được, nhưng bất kỳ consumer nào đọc `homeControllerProvider` trong khung loading/error đều vỡ.
- **Cần làm:** Cho `homeControllerProvider` trả `AsyncValue<HomeController>` (map từ `homeSnapshotProvider` bằng `.whenData`/`.guard`) hoặc gộp `HomeController` vào một `AsyncNotifier` để mọi điểm tiêu thụ xử lý loading/error tường minh, không phụ thuộc thứ tự resolve.
- **Kiểm chứng:** `flutter test test/features/home/home_controller_test.dart`; thêm test đọc provider ở trạng thái loading không ném `StateError`.

### S2.6. Hợp nhất về 1 pattern controller — [Viết lại] · [P2] · [Effort M]
- **Hiện trạng:** Ba idiom cùng tồn tại: (1) `Provider<XController>` bọc controller `const` immutable mang sẵn `state` view-state (vd `tradeReadModelControllerProvider`, `tradeOrderControllerProvider`, `homeControllerProvider`, `notificationsControllerProvider`) — chỉ đọc, không transition; (2) `NotifierProvider<Controller, ViewState>` đúng chuẩn Riverpod 3, nhưng chỉ 4 nơi: `arena_controller_providers.dart:16`, `trade_bots_controller_providers.dart:54`, `notifications_controller_providers.dart:14`, `auth/.../password_reset_flow_controller.dart:4`; (3) `setState` trên bản sao trong `ConsumerState` (S2.3), bỏ qua provider hoàn toàn. Sự pha trộn này che khuất composition-root ở `app/providers/`.
- **Cần làm:** Chốt `NotifierProvider`/`AsyncNotifierProvider` là pattern chính thức cho mọi controller có mutation/async; hạ kiểu (1) xuống chỉ dùng cho read-model thuần tuý không đổi trạng thái; xoá kiểu (3). S2.2 và S2.3 là hai lô thực thi cụ thể của việc hợp nhất này. Ghi chuẩn vào `AGENTS.md`/`docs/02_FLUTTER_MIGRATION/` để review ép tuân thủ.
- **Kiểm chứng:** Grep xác nhận không còn class controller stateful tạo qua `Provider(` (chỉ `NotifierProvider`/`AsyncNotifierProvider`); review kiến trúc + guardrail S2.4.

**Thứ tự đề xuất trong chiều:** S2.4 (dựng rào chắn trước để chặn nợ mới) → S2.1 (vá rò, tác động người dùng trực tiếp) → S2.6 (chốt pattern đích) → S2.2 (pilot async state machine trên trade) → S2.3 (gỡ dual-source theo lô module) → S2.5 (dọn `requireValue`).


---

## 3. Xử lý lỗi & khả năng phục hồi — Hiện tại: B → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** App có error boundary toàn cục (bắt cả lỗi sync trong widget tree lẫn lỗi async ngoài zone) route về một seam quan sát được (reporting/logging, no-op ở giai đoạn mock) và một màn fallback mang brand thay cho màn xám của Flutter. 100% `features/*/data/providers/*_repository_provider.dart` đi qua `guardedRepository` và điều đó được một guardrail test ép cứng (build production không thể lọt mock data). Có một idiom lỗi async chuẩn (AsyncNotifier + `AsyncValue.guard`, hoặc Result type) áp cho mọi đường đọc/ghi có thể fail. Mọi nút submit tài chính (trade order, futures order, prediction order) có đủ vòng trạng thái submitting → success/receipt → error, không còn no-op.

**Khoảng cách chính hiện nay:** `main.dart` chỉ gọi `runApp` trần, không có bất kỳ handler lỗi nào (grep 0 kết quả cho `runZonedGuarded`/`FlutterError.onError`/`PlatformDispatcher.onError`/`ErrorWidget.builder` trong toàn `lib`). Ít nhất 9 module dữ liệu người dùng (markets, launchpad, home, rewards, referral, news, discovery, onboarding, support) cùng 4 provider của `cross_module` trả thẳng Mock repository, bỏ qua `guardedRepository` — build production sẽ hiển thị dữ liệu giả thay vì fail-closed. Toàn app có 0 `AsyncValue.guard` và chỉ 2 `FutureProvider`; đường submit lệnh tài chính gọi đồng bộ, không try/catch, không vòng trạng thái. Không có seam logging/crash reporting nào.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3.1 | Error boundary toàn cục + màn fallback brand | Cải thiện | P1 | M | `lib/main.dart:6-9`, `lib/app/vit_trade_app.dart:47` | Mọi exception uncaught làm crash trắng/xám màn, không có màn phục hồi | `flutter test`, chạy app với repo ném lỗi cố ý |
| 3.2 | Seam reporting/logging (no-op ở mock) | Cải thiện | P2 | S | mới: `lib/core/observability/`, gắn vào 3.1 | Không có điểm cắm crash reporting; lỗi biến mất im lặng | grep seam được 3.1 gọi; unit test no-op |
| 3.3 | Route 9+ provider bỏ sót qua `guardedRepository` | Cải thiện | P1 | M | `features/{markets,launchpad,home,rewards,referral,news,discovery,onboarding,support}/data/providers/*_repository_provider.dart` + `features/cross_module/data/providers/*` | Build production (mock tắt) hiển thị data giả thay vì fail-closed | `flutter test test/quality/architecture_baseline_guardrails_test.dart` |
| 3.4 | Guardrail test ép 100% guard coverage | Cải thiện | P1 | S | mới: `test/quality/repository_guard_coverage_guardrail_test.dart` | Provider mới lại lọt mock, không ai chặn | `flutter test test/quality/repository_guard_coverage_guardrail_test.dart` |
| 3.5 | Idiom lỗi async chuẩn + chuyển trade order submit làm tham chiếu | Viết lại | P1 | L | `features/trade/presentation/controllers/trade_order_controller_models.dart:61-63`, `features/trade/presentation/widgets/hub/trade_page_part_01.dart:19-30` | Submit đồng bộ không try/catch: repo ném → crash không phục hồi; không có submitting/error | `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart` + widget test flow lỗi |
| 3.6 | Wiring submit thật cho prediction order (submitting/success/receipt) | Viết lại | P2 | M | `features/predictions/presentation/widgets/event/prediction_event_detail_trade_panel.dart:154`, `features/predictions/presentation/controllers/predictions_controller.dart:15-16,89-124` | Nút Buy/Sell enabled nhưng no-op — người dùng bấm không có gì xảy ra | Widget test: bấm Buy → submitting → receipt |

**Chi tiết từng hạng mục**

### 3.1. Error boundary toàn cục + màn fallback brand — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** `lib/main.dart:6-9` chỉ có `void main() { _disableDebugVisualOverlays(); runApp(const VitTradeApp()); }` — không zone, không handler. `lib/app/vit_trade_app.dart:47` dựng `MaterialApp.router` không set `ErrorWidget.builder` và không có widget bọc lỗi. Grep toàn `lib` cho `runZonedGuarded|FlutterError.onError|PlatformDispatcher|ErrorWidget.builder` = 0 kết quả.
- **Cần làm:** Trong `main.dart` bọc `runApp` bằng `runZonedGuarded`, gán `FlutterError.onError` (lỗi trong framework/build) và `PlatformDispatcher.instance.onError` (lỗi async ngoài zone) — cả 3 cùng route về seam ở mục 3.2. Trong `vit_trade_app.dart` (hoặc builder của `MaterialApp.router`) set `ErrorWidget.builder` trả về một màn fallback dùng `AppColors`/`AppTextStyles` (brand tối, thông điệp tiếng Việt "Đã xảy ra lỗi, thử lại"), thay cho khối đỏ debug/màn xám mặc định. Ở giai đoạn mock, tất cả chỉ chuyển sang seam no-op — không đổi hành vi runtime, chỉ mở điểm cắm.
- **Kiểm chứng:** `flutter test` (không regression); chạy app tạm ép một provider ném exception và xác nhận màn fallback brand hiện thay vì crash trắng; grep xác nhận đủ 4 primitive tồn tại trong `main.dart`/`vit_trade_app.dart`.

### 3.2. Seam reporting/logging (no-op ở giai đoạn mock) — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** Không có hạ tầng logging/crash reporting trong `lib` (grep `developer.log|package:logging|Logger(|crashlytics|Sentry` = 0 kết quả thực; 2 hit chỉ là text trong fixtures `trade_bots`/`earn`). Lỗi hiện tại không có nơi để đi tới.
- **Cần làm:** Tạo một abstraction mỏng (vd `lib/core/observability/error_reporter.dart` với interface `ErrorReporter { void report(Object error, StackTrace stack, {String? context}); }` và một `NoopErrorReporter` mặc định cho mock phase). Cung cấp qua Riverpod provider (`errorReporterProvider`) để 3.1 gọi. Không bind SDK bên thứ ba nào ở giai đoạn mock — chỉ để đúng một điểm sau này thay bằng Crashlytics/Sentry mà không phải sờ vào `main.dart`.
- **Kiểm chứng:** Unit test: gọi `report` trên `NoopErrorReporter` không ném; grep xác nhận 3.1 (FlutterError/PlatformDispatcher/zone) đều gọi qua `errorReporterProvider` chứ không `debugPrint` trực tiếp.

### 3.3. Route 9+ provider bỏ sót qua `guardedRepository` — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** `guardedRepository` (`lib/core/data/repository_guard.dart:9-29`) trả mock khi `enableMockData`, ngược lại dùng `remote`/`failClosed`, nếu không có thì ném `StateError`. Mẫu đúng: `features/wallet/data/providers/wallet_repository_provider.dart:8-15` (có `failClosed: FailClosedWalletRepository`). Các provider bỏ qua guard, trả thẳng Mock: `market_repository_provider.dart:5-7`, `launchpad_repository_provider.dart:5-7`, `home_repository_provider.dart:6-8`, `rewards_repository_provider.dart:5-7`, `referral_repository_provider.dart:5-7`, `news_repository_provider.dart:5-7`, `discovery_repository_provider.dart:5-7`, `onboarding_repository_provider.dart:5-7`, `support_repository_provider.dart:5-7`, và 4 provider `cross_module` (`unified_portfolio_repository_provider.dart:5-9` + `cross_module_analytics/smart_alerts/tax_report`). Ghi chú: `dev/data/providers/dev_tools_repository_provider.dart` và `enterprise_states/...` là scaffolding dev/demo — có thể allowlist ở 3.4 thay vì bắt guard.
- **Cần làm:** Với từng provider trên, bọc thân provider bằng `guardedRepository(ref, featureName: '<Tên>', mock: () => const Mock...Repository(), failClosed: () => const FailClosed...Repository())` giống wallet. Cần thêm một `FailClosed<Feature>Repository` cho mỗi feature (trả state rỗng/lỗi an toàn, không dữ liệu giả). Giữ chữ ký `Provider<XRepository>` không đổi để không phá consumer.
- **Kiểm chứng:** `flutter test test/quality/architecture_baseline_guardrails_test.dart`; grep `guardedRepository` phải xuất hiện trong mọi file provider không nằm trong allowlist; toàn bộ `flutter test` xanh.

### 3.4. Guardrail test ép 100% guard coverage — [Cải thiện] · [P1] · [S]
- **Hiện trạng:** `test/quality/architecture_baseline_guardrails_test.dart` đã có sẵn cơ chế quét `lib/features` bằng `_sourceMatches`/regex (vd test "presentation controllers avoid mock and remote repositories" ở dòng 58-66), nhưng chưa có test nào ép guard coverage của repository provider.
- **Cần làm:** Thêm `test/quality/repository_guard_coverage_guardrail_test.dart` (hoặc một test mới trong file architecture baseline) duyệt mọi `lib/features/*/data/providers/*_repository_provider.dart`, assert nội dung chứa `guardedRepository`; giữ một `allowlist` khai báo tường minh (`{'dev', 'enterprise_states'}` nếu quyết định miễn) kèm comment lý do — mọi provider ngoài allowlist mà thiếu guard làm fail test. Đây là hàng rào chặn hồi quy sau khi 3.3 xong.
- **Kiểm chứng:** `flutter test test/quality/repository_guard_coverage_guardrail_test.dart` — đỏ trước khi làm 3.3, xanh sau; thử thêm một provider trần để xác nhận test bắt được.

### 3.5. Idiom lỗi async chuẩn + chuyển trade order submit làm tham chiếu — [Viết lại] · [P1] · [L]
- **Hiện trạng:** Toàn `lib` có 0 `AsyncValue.guard` và chỉ 2 `FutureProvider` (`app/providers/home_controller_providers.dart:7`, `app/providers/news_controller_providers.dart:7`); mọi đường đọc repo là `Provider` đồng bộ (vd `app/providers/trade_controller_providers.dart:27-61`). `TradeOrderController.submit()` (`features/trade/presentation/controllers/trade_order_controller_models.dart:61-63`) trả `TradeOrderReceipt` đồng bộ, gọi `_repository.submitOrder(...)` không try/catch. View gọi thẳng trong `trade_page_part_01.dart:19-30`: `submit()` → `context.go(receipt)` → show sheet success — không có nhánh lỗi, không dùng `TradeOrderViewState.status`/`errorMessage` (đã khai báo ở `trade_order_controller_models.dart:12-13,19-20` nhưng chết cho luồng submit).
- **Cần làm:** Định nghĩa idiom đích: chuyển đường ghi tài chính sang `AsyncNotifier`/`Notifier` giữ `AsyncValue`, dùng `AsyncValue.guard` để bắt lỗi, hoặc một `Result<T, Failure>` type ở domain. Chọn trade order submit làm tham chiếu: thay `TradeOrderController` const-state bằng một Notifier expose `submit()` async chuyển `status` qua ready → submitting → success/error và điền `errorMessage`; view render submitting (disable nút, spinner) và nhánh lỗi (banner/sheet) thay vì giả định luôn thành công. Viết ADR ngắn trong `docs/02_FLUTTER_MIGRATION/` chốt idiom để các submit khác theo.
- **Kiểm chứng:** `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart` (test đang ép `highRiskContractId`); thêm widget test cho luồng submit lỗi: repo ném → UI hiện error state, không crash, không điều hướng tới receipt.

### 3.6. Wiring submit thật cho prediction order — [Viết lại] · [P2] · [M]
- **Hiện trạng:** `features/predictions/presentation/widgets/event/prediction_event_detail_trade_panel.dart:154` render CTA Buy/Sell với `onPressed: preview.canSubmit ? () {} : null` — enabled nhưng callback rỗng. Controller `features/predictions/presentation/controllers/predictions_controller.dart` đã có enum `PredictionHighRiskFlowStatus.submitting/submitted` (dòng 15-16) và `canSubmitOrder`/`previewOrder` (dòng 89-124) nhưng KHÔNG có method submit; receipt chỉ lấy được qua `getOrderReceipt(receiptId)` (`predictions_repository.dart:33`) — tức vòng submitting/submitted khai báo mà chết.
- **Cần làm:** Áp idiom ở 3.5: thêm method submit vào controller/Notifier của predictions, chuyển `PredictionHighRiskFlowStatus` ready → submitting → submitted, sinh/nhận receipt rồi điều hướng `prediction_order_receipt_page.dart`. Thay `() {}` ở dòng 154 bằng handler thật (disable + spinner khi submitting, banner lỗi khi fail). Đồng thời rà các no-op tương tự trong cùng feature (vd `prediction_market_maker_returns.dart:47` `onPressed: enabled ? () {} : null`).
- **Kiểm chứng:** Widget test: bấm Buy khi `canSubmit` → state chuyển submitting → điều hướng receipt; grep `() {}` trong `features/predictions/presentation` phải về 0 cho các CTA tài chính.

**Thứ tự đề xuất trong chiều:** 3.1 → 3.2 (nền error boundary + seam) → 3.3 → 3.4 (đóng lỗ guard + hàng rào hồi quy) → 3.5 (chốt idiom async, làm tham chiếu trên trade) → 3.6 (nhân idiom sang prediction submit).


---

## 4. Bảo mật & an toàn sản phẩm tài chính — Hiện tại: A → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Mọi control an toàn tài chính bắt buộc (masking, tách biệt Arena/Prediction, không rò secret) đều có test tự động chặn hồi quy, và mọi input không tin cậy (route param) đều dẫn tới trạng thái lỗi rõ ràng thay vì âm thầm hiển thị dữ liệu demo. Cụ thể, đo được: (1) `core/utils/data_masking.dart` là nguồn duy nhất cho masking email/account/address và có unit test phủ biên; (2) không còn secret định dạng thật trong `lib/`, có secret-scan trong CI; (3) guardrail copy Arena bắt cả tiếng Việt lẫn tiếng Anh; (4) `ApiClient` có sẵn khung interceptor/TLS-pinning để nối backend thật mà không phải viết lại tầng mạng.

**Khoảng cách chính hiện nay:** Masking bị nhân bản >12 nơi và `data_masking.dart` chưa có `maskAddress` lẫn test nào (0 coverage cho một control bắt buộc theo AGENTS.md). Secret định dạng thật (`sk_live_`/`vt_live_`/`pk_live_` 32 ký tự) nằm rải rác trong `lib/` mà CI (`.github/workflows/flutter-ci.yml`) không có bước quét secret. Guardrail Arena chỉ khớp từ khóa tiếng Anh trong khi copy sản phẩm là tiếng Việt, nên thuật ngữ tài chính tiếng Việt có thể lọt. Route param sai/thiếu âm thầm rơi về entity demo (`?? 'sample'`, `?? 'p2p001'`…) kể cả trên luồng tài chính P2P, và `ApiClient` chưa có khung interceptor/pinning.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S4.1 | Trung hòa secret định dạng thật + thêm secret-scan CI/guardrail | Cải thiện | P2 | M | `lib/features/profile/data/repositories/mock_profile_repository_settings_fixtures.dart:229-256`, `.../pages/api_key_create_page.dart:243,247`, `earn/.../mock_earn_repository_part_13.dart:390,398`, `trade_bots/.../trade_bot_lifecycle_risk_repository_methods.dart:277`, `predictions/.../mock_predictions_repository_fixtures_part_03.dart:184`, `.github/workflows/flutter-ci.yml` | Trip secret-scanner của bên thứ ba / rò rỉ khi mẫu bị copy sang code thật; mất niềm tin bảo mật | grep 0 kết quả `sk_live_[A-Za-z0-9]{20,}`; test guardrail mới; bước gitleaks CI |
| S4.2 | Guardrail copy Arena song ngữ (asciiFold + stem tiếng Việt) | Cải thiện | P2 | S | `test/quality/product_copy_guardrails_test.dart:41-49,52-78,107-111`; util `test/quality/product_copy_guardrail_test_utils.dart:17` | Thuật ngữ tài chính tiếng Việt (ví, lợi nhuận, rút tiền, tiền mặt) lọt vào Arena mà guardrail không thấy | `flutter test test/quality/product_copy_guardrails_test.dart` |
| S4.3 | Gom masking địa chỉ về `data_masking.dart`, xóa bản sao | Tối ưu | P2 | M | Thêm `maskAddress` vào `lib/core/utils/data_masking.dart`; thay ~12+ site: `wallet/.../withdraw_common.dart:30`, `deposit_page_common.dart:129`, `pending_deposits_page_common.dart:191`, `transaction_history_page_common.dart:213`, `transaction_detail_page_common.dart:188`, `address_book_page.dart:32-34`, `wallet_controller.dart:334-336`, `p2p/.../p2p_orders_entities.dart:485-487`, `launchpad/.../launchpad_entities_part_03.dart:154`, v.v. | Drift quy tắc mask (số ký tự lộ khác nhau: 6/4, 8/6, 16/8, 20/10) → lộ nhiều hơn ý muốn ở vài màn | grep 0 bản sao pattern `substring(0, 6)...length - 4` ngoài `data_masking.dart`; `flutter analyze` |
| S4.4 | Unit test cho `data_masking.dart` (control bắt buộc) | Cải thiện | P2 | S | `lib/core/utils/data_masking.dart:11 (maskEmail)`, `:20 (maskAccountNumber)`, + `maskAddress` mới; hiện **0** test tham chiếu | Sửa masking vô tình lộ dữ liệu mà không có gì chặn; vi phạm AGENTS.md | `flutter test test/core/utils/data_masking_test.dart` (mới) |
| S4.5 | Route param sai → trạng thái lỗi, bỏ fallback demo im lặng | Viết lại | P3 (P2 cho route tài chính) | M | `lib/app/router/route_groups/p2p_routes.dart:75,83,91,112,120,290,298,358` (`?? 'sample'`), và các `?? 'p2p001'/'mc001'` cùng file; mở rộng: `arena_routes.dart`, `predictions_routes.dart`, `earn_routes.dart`, `dca_routes.dart` | Deep-link/param hỏng trên luồng tranh chấp/rút tiền âm thầm mở entity demo → người dùng thao tác nhầm đối tượng | `flutter test test/app/router`; test điều hướng param rỗng/sai → trang lỗi, không phải `sample` |
| S4.6 | Khung interceptor/TLS-pinning cho `ApiClient` | Cải thiện | P3 | M | `lib/core/network/api_client.dart:12-35` (chỉ có `BaseOptions`, `dio.interceptors` trống, không pinning) | Khi nối backend thật phải viết lại tầng mạng + thiếu chặn MITM; idiom lỗi async chưa có chỗ đặt | `flutter analyze`; `flutter test test/core/network/api_client_test.dart` (mới) |

**Chi tiết từng hạng mục**

### S4.1. Trung hòa secret định dạng thật + thêm secret-scan — [Cải thiện] · [P2] · [M]
- **Hiện trạng:** `mock_profile_repository_settings_fixtures.dart:229-230,242-243,255-256` chứa cặp key/secret định dạng thật 32 ký tự (`key: 'vt_live_4x7j9mKpQr2LwNvSbEuF8yTcZdHgXkAm'`, `secret: 'sk_live_J8mK3pRtYxWvCqBnZ5hGfD2sLuNaE9cT'`). `api_key_create_page.dart:243,247` hiển thị `'vt_live_demo_7h3k9m2p4x8q'` và `'sk_live_demo_only_once'`. Cùng họ còn ở `mock_earn_repository_part_13.dart:390,398`, `trade_bot_lifecycle_risk_repository_methods.dart:277`, `mock_predictions_repository_fixtures_part_03.dart:184`. `.github/workflows/flutter-ci.yml` (đã đọc toàn bộ 329 dòng) không có bước gitleaks/trufflehog; không có `.gitleaks.toml`/`.pre-commit-config.yaml` trong repo.
- **Cần làm:** Đổi các chuỗi 32-ký-tự "trông thật" sang dạng rõ ràng là mẫu (ví dụ tiền tố `vt_live_EXAMPLE_` / `sk_live_EXAMPLE_` hoặc chèn dấu chấm lửng như `keyPreview` đã dùng ở `mock_earn_repository_part_13.dart`), giữ nguyên UI. Thêm guardrail Dart `test/quality/secret_material_guardrail_test.dart` quét `lib/` chặn regex secret có đuôi entropy dài (đồng bộ với pattern guardrail hiện có dùng `readSource`/`listDartFiles` từ `product_copy_guardrail_test_utils.dart`). Thêm 1 step gitleaks vào job CI trước "Full test suite".
- **Kiểm chứng:** `grep -rE "(sk|vt|pk)_live_[A-Za-z0-9]{20,}" flutter_app/lib` trả 0; `flutter test test/quality/secret_material_guardrail_test.dart`; chạy `gitleaks detect --no-git` không có finding.

### S4.2. Guardrail copy Arena song ngữ — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** Trong `product_copy_guardrails_test.dart`, các regex cấm từ vựng tài chính chỉ có tiếng Anh: dòng 42 `r"...\b(USDT|USD|wallet|payout|profit|cash)\b"`, dòng 54-57 `\b(wallet|profit|payout|stake|USDT|USD|cash|PnL|P/L)\b`, dòng 107-108 tương tự. `asciiFold()` đã tồn tại (`product_copy_guardrail_test_utils.dart:17`) và được dùng ở dòng 92, 132 để chuẩn hóa dấu tiếng Việt, nhưng regex tài chính không có stem tiếng Việt nên copy như "ví", "lợi nhuận", "rút tiền", "tiền mặt", "đặt cược" không bị bắt.
- **Cần làm:** Bọc `asciiFold()` cho nguồn ở cả 3 test (dòng 35-50, 52-78, 91-129 nếu chưa) và mở rộng bộ regex cấm thêm stem tiếng Việt đã fold ASCII: `vi`, `loi nhuan`, `rut tien`, `tien mat`, `dat cuoc`, `thang/thua`… Giữ nguyên danh sách file mục tiêu Arena; không đổi copy sản phẩm.
- **Kiểm chứng:** `flutter test test/quality/product_copy_guardrails_test.dart`; chèn thử một dòng copy "rút tiền/lợi nhuận" vào một page Arena → test phải fail, rồi revert.

### S4.3. Gom masking địa chỉ về `data_masking.dart` — [Tối ưu] · [P2] · [M]
- **Hiện trạng:** `data_masking.dart` chỉ có `maskEmail` (dòng 11) và `maskAccountNumber` (dòng 20); **không** có `maskAddress`. Logic mask địa chỉ bị nhân bản hơn 12 nơi với các biến thể lộ khác nhau: 3 hàm `_maskAddress` cục bộ (`address_book_page.dart:32`, `wallet_controller.dart:334`, `p2p_orders_entities.dart:485`) cộng nhiều bản inline `'${x.substring(0, 6)}...${x.substring(x.length - 4)}'` (`withdraw_common.dart:30`, `deposit_page_common.dart:129`, `pending_deposits_page_common.dart:191`, `transaction_history_page_common.dart:213`, `transaction_detail_page_common.dart:188`, `launchpad_abi_diff_extensions.dart:82`, `launchpad_claim_receipt_misc_widgets.dart:227`, `launchpad_entities_part_03.dart:154`), và biến thể độ dài khác (16/8 ở `wallet_address_add_common.dart:232`, 20/10 ở `staking_proof_of_reserves_verify_sheet.dart:279`, 10/4 ở `launchpad_entities_part_03.dart:275`, 8/6 ở `p2p_orders_entities.dart:487`).
- **Cần làm:** Thêm `maskAddress(String value, {int head = 6, int tail = 4})` vào `data_masking.dart` (thuần Dart, không phụ thuộc Flutter như 2 hàm hiện có), có phòng thủ độ dài. Thay toàn bộ site trên bằng lời gọi `maskAddress(...)`, truyền `head/tail` cho các biến thể. Lưu ý part-file: `p2p_orders_entities.dart` và `launchpad_entities_part_03.dart` là domain entity — kiểm tra import/part trước khi sửa.
- **Kiểm chứng:** `grep -rE "substring\(0, 6\)\.\.\.\$\{.*length - 4" flutter_app/lib` chỉ còn ở `data_masking.dart`; `flutter analyze`; suite hồi quy `flutter test`.

### S4.4. Unit test cho `data_masking.dart` — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** Không có file test nào tham chiếu `data_masking`/`maskEmail`/`maskAccountNumber` (glob `test/**/*mask*` rỗng, grep trong `test/` rỗng). Đây là control an toàn tài chính bắt buộc theo AGENTS.md (nêu ngay trong doc comment `data_masking.dart:1-4`) nhưng 0 coverage.
- **Cần làm:** Tạo `test/core/utils/data_masking_test.dart` phủ biên: `maskEmail` với input không có `@` (fallback dòng 13), local-part 1 ký tự; `maskAccountNumber` với chuỗi rỗng, ≤4 ký tự (`'***'`), 5-6 ký tự (prefix 1) vs ≥7 (prefix 3); và `maskAddress` mới (địa chỉ ngắn hơn head+tail không được lộ toàn bộ). Nên thêm vào chuỗi step CI (một dòng `flutter test test/core/utils/...`).
- **Kiểm chứng:** `flutter test test/core/utils/data_masking_test.dart`.

### S4.5. Route param sai → trạng thái lỗi, bỏ fallback demo — [Viết lại] · [P3 · P2 cho route tài chính] · [M]
- **Hiện trạng:** Nhiều builder trong `route_groups` rơi âm thầm về entity demo khi thiếu/sai param: `p2p_routes.dart:75,83,91` (`disputeId ?? 'sample'`), `:112,120` (`adId ?? 'sample'`), `:290,298` (`methodId ?? 'sample'`), `:358` (`claimId ?? 'sample'`), cùng loạt `orderId ?? 'p2p001'`, `merchantId ?? 'mc001'`; tương tự ở `arena_routes.dart` (`ch003`, `mode001`), `predictions_routes.dart` (`pred-1`, `btcusdt`), `earn_routes.dart:235` (`prop001`), `dca_routes.dart:77` (`config001`). Param sai định dạng không phân biệt được với "không truyền".
- **Cần làm:** Thay pattern `?? '<demo>'` bằng: nếu param bắt buộc thiếu/không parse được thì điều hướng tới màn lỗi/NotFound (hoặc trả `errorBuilder` của router) thay vì id mẫu. Ưu tiên P2 cho nhóm luồng tài chính P2P (dispute/ad/method/claim, `p2p_routes.dart`), phần còn lại P3. Đây là đổi pattern (Viết lại) — thống nhất một helper `requireParam(state, key)` để dùng lại.
- **Kiểm chứng:** `flutter test test/app/router`; thêm test điều hướng tới route dispute với param rỗng/không hợp lệ và assert ra trang lỗi, không phải entity `sample`.

### S4.6. Khung interceptor/TLS-pinning cho `ApiClient` — [Cải thiện] · [P3] · [M]
- **Hiện trạng:** `api_client.dart:12-35` chỉ tạo `Dio` với `BaseOptions` (timeout, header, `validateStatus`); `dio.interceptors` để trống, không có auth/retry/error-mapping interceptor, không có certificate pinning trên `HttpClientAdapter`. Đang dormant vì giai đoạn MOCK-DATA (không repository nào dùng client này).
- **Cần làm:** Bổ sung khung (chưa cần bật): danh sách interceptor có chỗ cho auth-token, error-mapping (chuyển `DioException` → lỗi domain, làm nền cho idiom async error), và điểm cắm `badCertificateCallback`/pinning trên adapter, có cờ bật theo `AppConfig`/môi trường. Giữ constructor test-injectable `Dio? dio` hiện có để mock trong test.
- **Kiểm chứng:** `flutter analyze`; `flutter test test/core/network/api_client_test.dart` (mới) kiểm interceptor được nối đúng thứ tự và pinning kích hoạt khi cờ bật.

**Thứ tự đề xuất trong chiều:** S4.1 (chặn rò secret) → S4.3 (gom `maskAddress`) → S4.4 (test masking, phủ luôn hàm mới) → S4.2 (guardrail song ngữ) → S4.5 (route lỗi, ưu tiên route tài chính P2P) → S4.6 (khung `ApiClient`).


---

## 5. Hiệu năng — Hiện tại: B → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Có benchmark rebuild và scroll chạy trong CI (đo được, có ngưỡng gãy khi hồi quy), không màn nào cache provider element vô hạn theo keystroke. Danh sách dài render lazy/paginated (sliver/`ListView.builder`) thay vì `Column` eager. Rebuild fine-grained bằng `select`/`Notifier` thay vì `setState` toàn trang. Mọi `CustomPainter` nặng được bọc `RepaintBoundary` với `shouldRepaint` chính xác. `const` lint bật để enforce discipline tự động thay vì tự nguyện.

**Khoảng cách chính hiện nay:** Màn đặt lệnh Spot/Futures dùng `Provider.family` không `autoDispose` với key là draft object identity-equality → rò rỉ 1 provider element mỗi keystroke. Không có bất kỳ guardrail hiệu năng nào (35 file `test/quality/` không có file rebuild/scroll; golden chỉ có `home`); 0 `RepaintBoundary` trên 88 file `CustomPainter` dù skill nội bộ đã khuyến nghị. Hub và search render collection eager trong `Column`/`SingleChildScrollView`, `setState` toàn trang + query repo lặp mỗi build. `analysis_options.yaml` chỉ bật `avoid_print`.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| HN-1 | Rò rỉ provider element mỗi keystroke ở màn đặt lệnh Spot/Futures | Viết lại | P0 | M | `trade_controller_providers.dart:47-61,102-116`; `trade_page_part_01.dart:76-85,141`; `futures_page_part_01.dart:183-197,100`; `trade_core_spot_entities.dart:375-389` | Memory tăng tuyến tính theo số phím gõ; leak thật khi có backend + phiên dài | Harness pump form, gõ N ký tự, assert số element không tăng; `flutter test test/quality/` (guardrail autoDispose) |
| HN-2 | Không có bảo vệ hồi quy hiệu năng (rebuild + scroll + autoDispose) | Cải thiện | P1 | L | `test/quality/` (thiếu file perf); `test/features/home/golden/` (chỉ home); `architecture_baseline_guardrails_test.dart` | Mọi tối ưu HN-1/3/4/5 có thể âm thầm hồi quy, không ai phát hiện | Thêm harness đếm rebuild + benchmark scroll + guardrail grep; `flutter test test/quality/` |
| HN-3 | Hub/list render eager `Column` + `.take(n)`, chưa lazy/paginated | Viết lại | P2 | L | `market_list_page.dart:130-131,142-210`; `trade_page_part_01.dart:215`; `predictions_home_events.dart:15`, `predictions_home_highlights.dart:128` | Không scale khi repo thật trả list đầy đủ; jank/OOM khi bỏ `.take` | Thay bằng sliver/`ListView.builder`; guardrail cấm `Column`+`.map` trên list dài; scroll benchmark HN-2 |
| HN-4 | `setState` toàn trang mỗi keystroke + query repo lặp mỗi build | Viết lại | P2 | M | `market_list_page.dart:118,130,163-165`; `trade_page_part_01.dart:75-85,141` | Toàn cây rebuild + re-sort/re-filter mỗi phím; lãng phí CPU khi list lớn | Chuyển sang `Notifier` + `select`; harness đếm rebuild (HN-2) chứng minh giảm |
| HN-5 | Painter nặng chạy trong `paint()`, không `RepaintBoundary`, `shouldRepaint` identity | Tối ưu | P3 | M | `advanced_chart_painter.dart:15-65,135-169,213-248,251-255`; 88 file `CustomPainter`; `SKILL.md:52-54` | Repaint dư khi cha rebuild; chart phức tạp giật khi có price tick | Bọc `RepaintBoundary`, hoist `_expandedCandles`, `shouldRepaint` so sánh giá trị; benchmark HN-2 |
| HN-6 | Chưa bật `const` lint (discipline tự nguyện) | Cải thiện | P3 | S | `analysis_options.yaml:10-12` | Rebuild dư do widget không `const`; trôi dần theo thời gian | Bật rule; `cd flutter_app && flutter analyze` sạch |
| HN-7 | 64 chỗ `shrinkWrap:true` chưa được guardrail phân loại | Cải thiện | P2 | S | 64 occ / 60 file (vd `p2p_dashboard_page_part_03.dart`, `staking_analytics_earnings_tab.dart`) | Đa số OK (bounded), nhưng không có chốt chặn để bắt 1 nested-scroll thật lọt vào | Guardrail yêu cầu `shrinkWrap:true` đi kèm `NeverScrollableScrollPhysics`; `flutter test test/quality/scroll_physics_guardrail_test.dart` |

**Chi tiết từng hạng mục**

### HN-1. Rò rỉ provider element mỗi keystroke ở màn đặt lệnh — [Viết lại] · [P0] · [M]
- **Hiện trạng:** `tradeOrderControllerProvider` khai báo `Provider.family<TradeOrderController, TradeOrderControllerRequest>` (`trade_controller_providers.dart:47-61`) — **không** `autoDispose`. Key là record `({String pairId, TradeOrderDraft draft})` (`:19`). Trong `trade_page_part_01.dart:76-85`, mỗi `build` tạo một `TradeOrderDraft` mới rồi `ref.watch(tradeOrderControllerProvider((pairId, draft: draft)))`; `onChanged: () => setState(() {})` (`:141`) buộc rebuild mỗi keystroke. `TradeOrderDraft` (`trade_core_spot_entities.dart:375-389`) là `final class` thường, **không override `==`/`hashCode`** → identity-equality. Do đó mỗi keystroke sinh một draft mới → record key mới → Riverpod cache một `TradeOrderController` mới **và giữ mãi** vì family không autoDispose. Futures giống hệt: `tradeFuturesOrderControllerProvider` (`trade_controller_providers.dart:102-116`) + `_FuturesSimpleForm.build` (`futures_page_part_01.dart:183-197`), `onChanged` `:100`; `TradeFuturesOrderDraft` cũng plain class.
- **Cần làm:** (1) Đổi cả hai provider sang `Provider.autoDispose.family` để element rời scope được GC khi không còn watcher. (2) Bỏ dùng draft object làm key: hoặc cho `TradeOrderDraft`/`TradeFuturesOrderDraft` value-equality (thêm `==`/`hashCode` hoặc Equatable/freezed), hoặc đổi key thành record primitive `(pairId, side, type, price, amount)` để hai lần gõ cùng giá trị dùng lại element. Pattern đích ưu tiên: chuyển amount/side vào một `AutoDisposeNotifier` giữ draft state, view chỉ `watch(previewProvider.select(...))` — preview tính lại mà không sinh element mới theo từng key.
- **Kiểm chứng:** Widget test pump `TradePage`/`FuturesPage`, gõ ≥20 ký tự vào field số lượng, đọc số element trong `ProviderContainer` (hoặc dùng `ProviderObserver` đếm `didAddProvider`), assert không tăng theo số keystroke. Cộng guardrail static (xem HN-2). `cd flutter_app && flutter test test/quality/`.

### HN-2. Bộ bảo vệ hồi quy hiệu năng (rebuild + scroll + autoDispose) — [Cải thiện] · [P1] · [L]
- **Hiện trạng:** `test/quality/` có 35 guardrail (card-tile, page-rhythm, scroll-physics, top-header…) nhưng **không** file nào cho rebuild-count hay scroll. Golden chỉ tồn tại ở `test/features/home/golden/home_page_golden_test.dart` và `home_shared_widgets_golden_test.dart`. `.codex/skills/performance-optimization/SKILL.md` khuyến nghị `RepaintBoundary` cho `advanced_chart_painter.dart` (`:52-54`) và `select` (`:45`), nhưng grep cho thấy **0 `RepaintBoundary`** trong `lib` trên **88 file `CustomPainter`** → skill là nguyện vọng, chưa hiện thực và không có gì enforce.
- **Cần làm:** Ba tài sản, thêm vào `test/quality/`: (a) *Rebuild harness* cho form đặt lệnh — pump `TradePage`, gõ chuỗi ký tự, dùng counter (đếm `build` của `VitTradeSimpleOrderForm`/`_FuturesSimpleForm` hoặc `ProviderObserver`) và assert số rebuild/element ≤ ngưỡng; đặt cạnh `high_risk_text_entry_harness_test.dart` và `high_risk_state_primitives_guardrail_test.dart` (harness precedent sẵn có). (b) *Scroll benchmark* cho `MarketListPage` và hub `predictions` — fling qua danh sách, assert `WidgetController`/`tester.binding` frame budget hoặc số widget dựng (kiểu mở rộng `responsive_visual_qa_matrix_test.dart`). (c) *Guardrail static* "request-keyed family phải `autoDispose`" — grep `Provider.family`/`NotifierProvider.family` với key là record chứa object nghiệp vụ (draft/request) mà thiếu `autoDispose`, đặt trong `architecture_baseline_guardrails_test.dart`.
- **Kiểm chứng:** `cd flutter_app && flutter test test/quality/` (guardrail static + rebuild harness) và `flutter test test/quality/<scroll_benchmark>_test.dart` (mới). Đưa vào block vt-verify để chạy CI.

### HN-3. Hub/list eager `Column` + `.take(n)` → lazy/paginated — [Viết lại] · [P2] · [L]
- **Hiện trạng:** `MarketListPage` render toàn bộ trong `SingleChildScrollView` (`market_list_page.dart:142`) → `VitPageContent` (Column) với danh sách cắt bằng `filtered.take(8)` (`:130-131`). `trade_page_part_01.dart:215` cắt `positions.take(3)`; predictions hub cắt `.take(2)` (`predictions_home_events.dart:15`, `predictions_home_highlights.dart:128`). `.take(n)` chỉ mitigate — mọi phần tử vẫn dựng eager, không tái sử dụng viewport.
- **Cần làm:** Với các surface có list có thể dài khi backend thật trả đủ (market pairs, predictions events/movers, orders/positions), chuyển sang sliver composition (`CustomScrollView` + `SliverList`/`SliverList.builder`) hoặc `ListView.builder` với `itemExtent` cố định khi có thể, thêm phân trang/`cacheExtent` khi profiling cho thấy lợi ích (SKILL.md `:37-42`). Giữ `.take(n)` cho các preview cố ý ngắn (vd 3 vị thế ở hub), nhưng list chính (`MarketListPairList`) phải lazy. Không đụng các list bounded cố ý trong card.
- **Kiểm chứng:** Scroll benchmark HN-2 chứng minh số widget dựng độc lập với độ dài data; guardrail cảnh báo `Column`/spread `.map` trên nguồn list có thể tăng trưởng. `cd flutter_app && flutter test test/quality/`.

### HN-4. `setState` toàn trang + query repo lặp mỗi build ở search/filter — [Viết lại] · [P2] · [M]
- **Hiện trạng:** `market_list_page.dart:118` gọi `ref.watch(marketControllerProvider).getMarketList()` **mỗi build**; `:130` gọi `_filteredPairs(...)` re-filter + re-sort **mỗi build** (`:81-114`); `onChanged`/`onClear`/`onFilterTap` đều `setState(() {})` (`:163-165`) → rebuild toàn trang mỗi keystroke. Form đặt lệnh cùng anti-pattern (`trade_page_part_01.dart:75-85` dựng lại draft + preview mỗi `setState` `:141`).
- **Cần làm:** Chuyển state màn (query, category, sort, favoriteIds) vào một `AutoDisposeNotifier`; đưa danh sách đã filter/sort ra provider memoize (chỉ tính lại khi input đổi) thay vì tính trong `build`; leaf widget dùng `ref.watch(provider.select(...))` (SKILL.md `:45-49`) để chỉ subtree đổi mới rebuild. `getMarketList()` để một provider watch một lần, không gọi trong `build`. Đây là pattern "setState-trên-bản-sao → Notifier + select".
- **Kiểm chứng:** Rebuild harness HN-2 assert gõ 1 ký tự chỉ rebuild subtree search/list, không phải toàn `MarketListPage`. `cd flutter_app && flutter test test/quality/`.

### HN-5. Painter nặng trong `paint()`, thiếu `RepaintBoundary`, `shouldRepaint` identity — [Tối ưu] · [P3] · [M]
- **Hiện trạng:** `advanced_chart_painter.dart` chạy toàn bộ work trong `paint()` (`:15-65`): `_expandedCandles` nội suy 3x mỗi cặp nến (`:213-248`), `_drawMovingAverages` với `sublist`+`fold` O(n·period) mỗi frame (`:135-169`). `shouldRepaint` (`:251-255`) so sánh `candles`/`indicators` bằng `!=` trên `List` → identity, list mới cùng nội dung vẫn repaint. Không có `RepaintBoundary` bọc `CustomPaint` (0 trong toàn `lib`). Skill đã nêu đích danh file này (`SKILL.md:52-54`).
- **Cần làm:** Hoist `_expandedCandles` và MA ra khỏi `paint()` (tính một lần khi data đổi, truyền vào painter hoặc cache theo input); bọc `CustomPaint` chart bằng `RepaintBoundary` để cô lập repaint khi cha rebuild; làm `shouldRepaint` chính xác (so sánh độ dài + reference ổn định hoặc value-equality của candle list). Áp cùng nguyên tắc cho nhóm painter analytics nặng khác (vd `prediction_advanced_chart_*`, `bot_*_painters`).
- **Kiểm chứng:** Guardrail đếm `CustomPaint` không có `RepaintBoundary` tổ tiên (grep-based, thêm ngưỡng giảm dần); benchmark repaint HN-2 với data tĩnh + cha rebuild. `cd flutter_app && flutter test test/quality/`.

### HN-6. Bật `const` lint — [Cải thiện] · [P3] · [S]
- **Hiện trạng:** `analysis_options.yaml` chỉ include `flutter_lints` và bật thủ công `avoid_print: true` (`:10-12`). Không có `prefer_const_constructors`, `prefer_const_constructors_in_immutables`, `prefer_const_literals_to_create_immutables` → `const` discipline hoàn toàn tự nguyện.
- **Cần làm:** Thêm 3 rule trên vào block `linter.rules`. Vá các vi phạm phát sinh (nhiều chỗ đã dùng `const` sẵn nên diff hữu hạn). Cân nhắc `use_key_in_widget_constructors` nếu chưa qua `flutter_lints`.
- **Kiểm chứng:** `cd flutter_app && flutter analyze` sạch sau khi vá; CI fail nếu có `const` thiếu.

### HN-7. Guardrail phân loại 64 `shrinkWrap:true` — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** 64 occurrence trên 60 file (vd `p2p_dashboard_page_part_03.dart`, `staking_analytics_earnings_tab.dart`, `bot_portfolio_dashboard_page_sections.dart` có 2). Audit xác nhận **đa số** là idiom list bounded đi kèm `NeverScrollableScrollPhysics` — không phải nested-scroll jank — nên rủi ro thực thấp, nhưng không có chốt chặn để bắt một nested scrollable thật lọt vào tương lai.
- **Cần làm:** Thêm guardrail yêu cầu mọi `shrinkWrap: true` phải đi cùng `physics: NeverScrollableScrollPhysics()` (hoặc nằm trong danh sách allowlist có chú thích), fail nếu xuất hiện `shrinkWrap:true` trên một scrollable lồng cuộn được. Không refactor 64 chỗ hiện tại (chúng đúng) — chỉ khóa bất biến.
- **Kiểm chứng:** `cd flutter_app && flutter test test/quality/scroll_physics_guardrail_test.dart` (mở rộng file guardrail scroll-physics sẵn có).

**Thứ tự đề xuất trong chiều:** HN-1 (chặn leak, P0) → HN-2 (dựng lưới đo trước khi tối ưu) → HN-4 (rebuild fine-grained, tận dụng harness vừa dựng) → HN-3 (lazy list, cần scroll benchmark của HN-2) → HN-5 (RepaintBoundary/painter) → HN-6 → HN-7.


---

## 6. Đa ngôn ngữ (i18n) & Khả năng tiếp cận (a11y) — Hiện tại: D → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Có tầng l10n thật (gen-l10n/.arb + `localizationsDelegates` + `supportedLocales`) HOẶC một quyết định vi-VN-only được ghi thành văn bản trong `AGENTS.md` kèm ratchet cho code mới. Mọi touch target được ép hit-area ≥44dp bằng token dùng chung + guardrail; không còn ID nội bộ (`SC-xxx`) rò ra a11y tree; có policy text-scaling (clamp + test pump ở scale 1.3); format số/tiền đi qua một facade locale-aware (`VitFormat`); tương phản dark theme có tài liệu và test tự động. Mỗi tiêu chí phải có ít nhất một test dưới `flutter_app/test/quality/` giữ nhịp.

**Khoảng cách chính hiện nay:** App hoàn toàn không có i18n framework — `MaterialApp.router` tại `vit_trade_app.dart:47` không khai báo `localizationsDelegates`, `supportedLocales` hay `locale`; ~10.4k dòng copy tiếng Việt nằm inline trong 1.074/2.216 file, và các guardrail copy (`product_copy_guardrails_test.dart`) đang khoá chặt literal vào source. 382 file phát `semanticLabel: 'SC-xxx ...'` (ID nội bộ) ra screen reader qua `vit_page_layout.dart:42`. Không có chiến lược text-scaling (0 `textScaler`), trong khi `vit_cta_button.dart:169` dùng `FittedBox(scaleDown)` thu nhỏ nhãn CTA ngược ý người dùng. Touch target header/icon 36–40dp < 44dp. Format tiền hardcode en-US (`currency_formatters.dart`, `number_formatters.dart`).

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| I18N-1 | Quyết định sản phẩm + tầng l10n/policy | Viết lại | P1 | L | `AGENTS.md`; `flutter_app/l10n.yaml` (mới); `vit_trade_app.dart:47`; guardrail copy | Không thể quốc tế hoá; 10.4k copy hoá đá; guardrail khoá copy vào source | Quyết định có văn bản trong AGENTS.md HOẶC `flutter gen-l10n` chạy + guardrail ratchet mới |
| I18N-2 | Thêm `localizationsDelegates` + `supportedLocales` | Cải thiện | P2 | S | `vit_trade_app.dart:47` | Material surfaces (date picker, tooltip mặc định, cursor menu) hiện tiếng Anh | Widget test bơm `showDatePicker` kiểm nhãn tiếng Việt |
| A11Y-1 | `SC-xxx` chuyển từ `label` sang `identifier` | Viết lại | P1 | M | `vit_page_layout.dart:37-54`; 382 call site (`login_page.dart:112` ...); `accessibility_semantics_critical_flows_test.dart` | Screen reader đọc "SC-001 LoginPage" cho người khiếm thị | `flutter test test/quality/accessibility_semantics_critical_flows_test.dart` sau khi đổi finder |
| A11Y-2 | Ép hit-area ≥44dp (giữ visual 36/40dp) | Cải thiện | P1 | M | `vit_header_action_button.dart:118-120`; `vit_icon_button.dart:156`; `app_top_header_tokens.dart:23-24` | Nút nhỏ 36–40dp fail WCAG 2.5.5 / Material min tap size | Guardrail mới pump 2 primitive, assert `tester.getSize` vùng chạm ≥44 |
| A11Y-3 | Policy text-scaling: clamp + bỏ `FittedBox` trên CTA | Viết lại | P1 | M | `vit_trade_app.dart` (MediaQuery builder); `vit_cta_button.dart:168-178` | Chữ CTA co lại khi user phóng to; layout vỡ ở scale cao | Guardrail pump `textScaler: 1.3`, assert CTA không nhỏ hơn base |
| FMT-1 | Format số/tiền locale-aware qua `VitFormat` | Tối ưu | P2 | M | `currency_formatters.dart:4-16`; `number_formatters.dart:10-20`; `vit_format.dart` | Đã gây copy-drift tiền tệ (440dcb06); en-US ghim cứng | Test `VitFormat` với locale; `flutter test test/quality/*product_copy*` |
| A11Y-4 | Chuẩn hoá ngôn ngữ semantic label (Việt) | Cải thiện | P2 | M | `withdraw_form_sections.dart:169`; `arena_smart_rule_builder_page_part_02.dart`; vs `vit_segmented_choice.dart:92` | Screen reader trộn Anh/Việt trong cùng một luồng | Guardrail regex quét `semanticLabel:` cấm ký tự Latin-only ở trang user-facing |
| A11Y-5 | Tài liệu + test tương phản (dark-only) | Cải thiện | P2 | M | `vit_trade_app.dart:52-83`; `app_colors.dart`; `docs/02_FLUTTER_MIGRATION/` | Không có bằng chứng WCAG AA cho text3/border trên nền tối | Test tính tỉ lệ tương phản `text*` vs `bg`, assert ≥4.5:1 (hoặc 3:1 cho text lớn) |

**Chi tiết từng hạng mục**

### I18N-1. Quyết định sản phẩm + tầng l10n/policy — [Viết lại] · [P1] · [L]
- **Hiện trạng:** Không có `flutter_localizations`/`intl`/`.arb`, không có `l10n.yaml`. Copy tiếng Việt inline khắp nơi (vd `vit_header_action_button.dart:190-213` trả thẳng `'Quay lại'`, `'Tìm kiếm'`...). Các guardrail như `product_copy_guardrails_test.dart:16-31` dùng `readSource(path)` + `expect(source, contains(...))` để khoá literal — nghĩa là mọi nỗ lực rút copy ra `.arb` sẽ làm đỏ test, đây là điểm khoá cứng có chủ đích cần gỡ đồng bộ. `AGENTS.md` không có một dòng nào về locale/i18n (grep rỗng).
- **Cần làm:** Đây là **cổng quyết định** phải chốt trước mọi việc khác trong chiều. Hai nhánh:
  - Nhánh A (vi-VN-only): thêm mục "Chính sách ngôn ngữ: vi-VN-only" vào `AGENTS.md`, nêu rõ copy tiếng Việt inline là hợp lệ, kèm ratchet cấm hardcode chuỗi tiếng Anh user-facing mới. Effort tụt xuống S–M.
  - Nhánh B (gen-l10n): tạo `flutter_app/l10n.yaml` + `lib/l10n/app_vi.arb`, chạy `flutter gen-l10n`, chuyển primitive dùng chung (`vit_header_action_button.dart` tooltip, CTA) sang `AppLocalizations`, và viết lại guardrail copy để assert trên `.arb` thay vì source. Effort L.
- **Kiểm chứng:** Nhánh A: diff `AGENTS.md` + guardrail ratchet mới pass. Nhánh B: `cd flutter_app && flutter gen-l10n` không lỗi, `flutter test test/quality/` xanh sau khi cập nhật guardrail.

### I18N-2. Thêm `localizationsDelegates` + `supportedLocales` — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** `vit_trade_app.dart:47-84` — `MaterialApp.router` chỉ set `title`, `theme`, `scrollBehavior`, `routerConfig`; không có `localizationsDelegates`, `supportedLocales`, `locale`. Grep toàn `lib` cho hai symbol này ra rỗng.
- **Cần làm:** Thêm `flutter_localizations` vào `pubspec.yaml`, khai báo `localizationsDelegates: GlobalMaterialLocalizations.delegates` (+ Cupertino/Widgets) và `supportedLocales: const [Locale('vi')]`, `locale: const Locale('vi')` trong `_VitTradeMaterialApp.build`. Việc này độc lập với quyết định I18N-1 (kể cả vi-VN-only vẫn cần để Material widget nói tiếng Việt).
- **Kiểm chứng:** Widget test bơm `showDatePicker`/`showTimePicker` trong `VitTradeApp` và assert nhãn nút ("Huỷ"/"OK" theo locale) là tiếng Việt; `flutter analyze` sạch.

### A11Y-1. `SC-xxx` chuyển từ `label` sang `identifier` — [Viết lại] · [P1] · [M]
- **Hiện trạng:** `vit_page_layout.dart:42-44` bọc body trong `Semantics(container: true, label: semanticLabel, ...)`. 382 file truyền `semanticLabel: 'SC-001 LoginPage'` (vd `login_page.dart:112`, `register_page.dart:172`, `admin_home.dart:58`) — TalkBack/VoiceOver đọc thẳng ID nội bộ thành tiếng.
- **Cần làm:** Trong `VitPageLayout` tách hai thuộc tính: thêm param `semanticIdentifier` (map vào `Semantics(identifier: ...)`, không phát âm) cho mã `SC-xxx`, và giữ `semanticLabel` cho tiêu đề tiếng Việt thật (vd "Đăng nhập"). Đổi 382 call site: `SC-xxx` → `semanticIdentifier`, đặt label tiếng Việt mô tả trang. Cập nhật `accessibility_semantics_critical_flows_test.dart` — hiện finder `semanticsLabel` (dòng 26-37) match trên `.label`; đổi các test dựa vào `SC-xxx` sang match `identifier` (`widget.properties.identifier`).
- **Kiểm chứng:** `cd flutter_app && flutter test test/quality/accessibility_semantics_critical_flows_test.dart`; thêm guardrail assert không còn `Semantics.label` nào khớp `RegExp(r'^SC-\d')` khi bơm route.

### A11Y-2. Ép hit-area ≥44dp (giữ visual 36/40dp) — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** `vit_header_action_button.dart:118-120` set `SizedBox(width/height: metrics.size)` với `metrics.size = AppTopHeaderTokens.buttonSize (40)` hoặc `compactButtonSize (36)` (`app_top_header_tokens.dart:23-24`). `vit_icon_button.dart:41-68` các size `sm/md` cho `height` nhỏ hơn 44 và `SizedBox(height: metrics.height)` (dòng 156) không có min tap. Không có guardrail min-tap-size nào trong `test/quality/` (4 file khớp "44/48" chỉ là `physicalSize`).
- **Cần làm:** Giữ nguyên khối visual (36/40dp) nhưng bọc vùng chạm ≥44dp: thêm token `AppTopHeaderTokens.minTapTarget = 44` và bọc `InkWell`/`Semantics` trong hai primitive dùng chung bằng `ConstrainedBox(minWidth:44, minHeight:44)` hoặc `MergeSemantics` + `GestureDetector` mở rộng — sửa ở HAI file shared để phủ hàng trăm call site. Thêm guardrail pump cả hai primitive, assert `tester.getSize(find.byType(InkWell))` (vùng chạm) ≥ Size(44,44).
- **Kiểm chứng:** Guardrail mới `test/quality/tap_target_min_size_guardrail_test.dart` pump `VitHeaderActionButton`/`VitIconButton` ở mọi size, assert ≥44dp; `flutter test test/quality/`.

### A11Y-3. Policy text-scaling: clamp + bỏ `FittedBox` trên CTA — [Viết lại] · [P1] · [M]
- **Hiện trạng:** Grep `textScaler`/`textScaleFactor`/`MediaQuery.withNoTextScaling` toàn `lib` ra rỗng — không có chiến lược. `vit_cta_button.dart:168-178` bọc nhãn trong `Flexible > FittedBox(fit: BoxFit.scaleDown)`, nên khi người dùng phóng chữ, FittedBox thu nhỏ nhãn CTA trở lại — đi ngược ý định trợ năng.
- **Cần làm:** Chọn một chiến lược app-wide tại `vit_trade_app.dart`: dùng `MaterialApp.router(builder: (ctx, child) => MediaQuery.withClampedTextScaling(minScaleFactor: 1.0, maxScaleFactor: 1.3, child: child!))`. Đồng thời bỏ hoặc thay `FittedBox(scaleDown)` ở `vit_cta_button.dart` bằng cho phép wrap/xuống dòng (hoặc chỉ scaleDown khi thực sự tràn), để chữ CTA không co ngược khi scale ≤1.3.
- **Kiểm chứng:** Guardrail pump một trang CTA ở `MediaQuery(textScaler: TextScaler.linear(1.3))`, assert kích thước chữ CTA ≥ base (không co) và không overflow; `flutter test test/quality/`.

### FMT-1. Format số/tiền locale-aware qua `VitFormat` — [Tối ưu] · [P2] · [M]
- **Hiện trạng:** `currency_formatters.dart:4-16` (`formatUsd`) ghim cứng dấu `,` nhóm nghìn và `.` thập phân; `number_formatters.dart:10-20` (`insertThousandsSeparator`) ghim `,`. `VitFormat` (`vit_format.dart`) chỉ là facade mỏng gọi thẳng hai hàm này. MEMORY ghi nhận dedup formatter ở 440dcb06 đã âm thầm đổi copy tiền — rủi ro drift đã hiện thực hoá.
- **Cần làm:** Quyết định rõ: hoặc (a) tài liệu hoá "USD luôn hiển thị theo quy ước en-US, số đếm/VND theo vi-VN" ngay trong docstring `VitFormat` và ép mọi call site đi qua facade (cấm gọi thẳng `formatUsd`/`insertThousandsSeparator` ngoài `vit_format.dart` bằng guardrail import); hoặc (b) nội bộ hoá `intl` `NumberFormat` theo locale. Ưu tiên (a) trong giai đoạn mock để chặn drift trước.
- **Kiểm chứng:** Test đơn vị `VitFormat.usd/count/compactSuffix` với các mốc số; guardrail cấm import trực tiếp `currency_formatters`/`number_formatters` ngoài facade; `flutter test test/quality/*product_copy*`.

### A11Y-4. Chuẩn hoá ngôn ngữ semantic label (Việt) — [Cải thiện] · [P2] · [M]
- **Hiện trạng:** Semantic label trộn Anh/Việt trong cùng luồng: `withdraw_form_sections.dart:169` `'Withdrawal destination address'`, `arena_smart_rule_builder_page_part_02.dart:140/234/351` (`'Arena custom win condition'`...) là tiếng Anh, trong khi `vit_segmented_choice.dart:92/100` là `'Chọn mua'/'Chọn bán'`. Chính `accessibility_semantics_critical_flows_test.dart` (dòng 45-107) cũng phản ánh sự trộn này.
- **Cần làm:** Với app UI tiếng Việt, chuyển toàn bộ `semanticLabel` user-facing sang tiếng Việt (vd `'Địa chỉ nhận rút'`, `'Số tiền rút'`), cập nhật đồng thời các assert tương ứng trong test a11y. Nếu chọn nhánh gen-l10n (I18N-1 nhánh B) thì semantic label lấy từ `AppLocalizations`.
- **Kiểm chứng:** Guardrail regex quét các literal truyền vào `semanticLabel:` ở trang user-facing, gắn cờ chuỗi Latin-only (loại trừ mã kỹ thuật như tên mạng/địa chỉ ví); `flutter test test/quality/accessibility_semantics_critical_flows_test.dart` sau cập nhật assert.

### A11Y-5. Tài liệu + test tương phản (dark-only) — [Cải thiện] · [P2] · [M]
- **Hiện trạng:** `vit_trade_app.dart:52-83` chỉ định nghĩa `ThemeData(brightness: Brightness.dark)` với `ColorScheme.dark(...)`; không có light theme, không có bất kỳ tài liệu/test nào về tỉ lệ tương phản của `AppColors.text2/text3/border/divider` trên nền `AppColors.bg`.
- **Cần làm:** Viết một trang tài liệu tương phản dưới `docs/02_FLUTTER_MIGRATION/` liệt kê từng cặp foreground/background chính và tỉ lệ WCAG, và thêm test tính tương phản (dùng luminance của `Color`) assert `text1/text2` ≥4.5:1, text phụ/lớn ≥3:1 so với `bg`/`surface`. Đây là điều kiện A+ ("contrast có tài liệu/test"), chưa cần dựng light theme trong giai đoạn mock.
- **Kiểm chứng:** `test/quality/color_contrast_guardrail_test.dart` mới tính tỉ lệ từ `app_colors.dart`, assert ngưỡng; `flutter test test/quality/`.

**Thứ tự đề xuất trong chiều:** I18N-1 (cổng quyết định, chốt trước) → A11Y-1 (ID rò screen reader, P1 dễ đo) → A11Y-2 (touch target, sửa 2 file shared) → A11Y-3 (text-scaling + CTA) → I18N-2 (delegates) → FMT-1 (chặn drift tiền tệ) → A11Y-4 (ngôn ngữ semantic) → A11Y-5 (contrast).


---

## 7. Dependencies, tooling & CI/CD — Hiện tại: B → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Analyzer bật strict-casts/strict-inference/strict-raw-types + bộ lint async-safety, `flutter analyze` vẫn 0 issue. CI là graph nhiều job song song có cache đầy đủ (SDK + pub + gradle), không chạy trùng suite, đo coverage với sàn + ratchet chặn tụt. Chuỗi cung ứng được khóa: dependabot bật cho pub và github-actions, mọi action pin theo commit SHA, secret-scan chạy trên mỗi PR. CODEOWNERS trỏ owner thật + branch protection ép review. Có release engineering thực: flavor dev/staging/prod, workflow build appbundle/ipa release qua signing guard, và job iOS.

**Khoảng cách chính hiện nay:** `analysis_options.yaml` chỉ có `flutter_lints` + `avoid_print` (không có khối `analyzer: language:` strict nào) — bỏ phí việc code đã sạch. CI là MỘT job tuần tự (`flutter-ci.yml` job `flutter`) gọi `flutter test` 27 lần trong đó bước cuối `Full test suite` chạy lại toàn bộ, cộng 19 lần `dart run tool ... --check`, chỉ cache SDK, không coverage. Không có `.github/dependabot.yml`; action pin bằng tag mutable. CODEOWNERS toàn `@replace-with-real-owner` (fail-open). Version tĩnh `1.0.0+1`, `build.gradle.kts` không có `productFlavors`, không workflow release, không job iOS — dù tầng `AppConfig`/dart-define đã sẵn.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| D1 | Bật strict analyzer + lint async-safety | Cải thiện | P1 | S | `flutter_app/analysis_options.yaml` | Regression về dynamic/raw-type/future bị nuốt lọt CI | `flutter analyze` phải 0 issue sau khi bật |
| D2 | Tách CI thành job song song, bỏ chạy trùng, thêm cache | Tối ưu | P1 | M | `.github/workflows/flutter-ci.yml` | CI 60–150+ phút, lãng phí runner, feedback chậm | So wall-clock Actions; xác nhận đủ 27 test + 19 audit vẫn gate |
| D3 | Coverage + sàn threshold + ratchet | Cải thiện | P1 | M | `flutter-ci.yml` (job full-suite) + `pubspec`/tool mới | 508 test file nhưng không biết vùng nào trống; coverage tụt âm thầm | `flutter test --coverage`; kiểm `coverage/lcov.info`; script enforce floor |
| D4 | Dependabot + SHA-pin action + secret scan | Cải thiện | P1 | S–M | `.github/dependabot.yml` (thiếu), `flutter-ci.yml` L27/30/36/71 | Dep/action lỗ hổng không được vá; token bị action bên thứ 3 lạm dụng | Dependabot chạy thử; `gitleaks detect` sạch |
| D5 | CODEOWNERS owner thật + branch protection | Cải thiện | P1→P2 | S | `.github/CODEOWNERS` L18–29 | Review bottleneck file fail-open, merge blast-radius cao không kiểm soát | GitHub báo owner resolve hợp lệ; branch protection ép CODEOWNERS |
| D6 | Release engineering: flavors + workflow release + iOS + CHANGELOG | Cải thiện | P1→P2 | L | `android/app/build.gradle.kts`, `pubspec.yaml` L4, `.github/workflows/`, `lib/core/config/app_environment.dart` | Không tách được env build, không phát hành reproducible, không CI iOS | `flutter build appbundle --flavor prod --dart-define=...` chạm signing guard `build.gradle.kts:83-95` |

**Chi tiết từng hạng mục**

### D1. Bật strict analyzer + lint async-safety — [Cải thiện] · [P1] · [S]
- **Hiện trạng:** `flutter_app/analysis_options.yaml` chỉ có `include: package:flutter_lints/flutter.yaml` (L1), khối `analyzer:` chỉ chứa `exclude` (L3–8), `linter.rules` chỉ có `avoid_print: true` (L10–12). Không có `analyzer.language` strict, không có lint nào cho future/subscription.
- **Cần làm:** Thêm vào `analyzer:` khối `language: { strict-casts: true, strict-inference: true, strict-raw-types: true }` và `errors:` để nâng các vi phạm này lên `error`. Thêm vào `linter.rules`: `unawaited_futures`, `discarded_futures`, `cancel_subscriptions`, `close_sinks`, `prefer_final_locals`, `always_use_package_imports`. Vì audit xác nhận code đã sạch (0 dynamic thật, 0 downcast trên 2216 file) nên chi phí gần bằng 0; nếu còn vài chỗ vi phạm mới thì fix tại chỗ, không nới rule.
- **Kiểm chứng:** `cd flutter_app && flutter analyze` phải trả về "No issues found"; nếu có, sửa code chứ không hạ severity. Chạy kèm `dart format --output=none --set-exit-if-changed .` để không lệch bước format trong CI (`flutter-ci.yml` L45–46).

### D2. Tách CI thành job song song, bỏ chạy trùng, thêm cache — [Tối ưu] · [P1] · [M]
- **Hiện trạng:** `.github/workflows/flutter-ci.yml` chỉ có 1 job `flutter` (L18) chạy tuần tự mọi bước trên `flutter_app`. Có 27 lệnh `flutter test` (từ L58 tới L325) trong đó bước cuối `Full test suite` (L324–325) `flutter test --reporter=compact` **chạy lại toàn bộ** các guardrail test đã chạy riêng ở trên. 19 lệnh `dart run tool ... --check` (route L49, nav-edge L52, design-token L67, spacing L83, page-content-width L99, home-ref L115, page-rhythm L134/137/140, card-tile L160/163, segment-pill L190/193, top-header L210/224/240/256, back-nav L272, home-entry L288). Chỉ `subosito/flutter-action` cache SDK (`cache: true`, L40); không cache `~/.pub-cache`, không cache Gradle → `flutter build apk --debug` (L327–328) build nguội.
- **Cần làm:** Tách thành các job chạy song song với `needs` tối thiểu: (a) `static` = `flutter analyze` + `dart format` + 19 audit `--check`; (b) `guardrails` = các test `test/quality/**` + router + golden; (c) `full-suite` = `flutter test --coverage` chia shard qua `--total-shards/--shard-index` (matrix) — và BỎ các bước guardrail lặp lại ở (b) khỏi full-suite, hoặc ngược lại giữ các bước named cho fail đọc được rồi loại `Full test suite` L324–325 vốn trùng; (d) `build-android` = `flutter build apk --debug`. Thêm cache `actions/cache` cho `~/.pub-cache` (key theo `pubspec.lock`) và Gradle (`~/.gradle/caches`, key theo `**/*.gradle*`). Giữ `permissions: contents: read` (L10–11) và `concurrency` (L13–15) — đã tốt.
- **Kiểm chứng:** So tổng wall-clock trong tab Actions trước/sau (mục tiêu <20 phút); đối chiếu danh sách bước để xác nhận đủ 27 nội dung test + 19 audit `--check` vẫn được gate ở đâu đó (không rơi bước nào). Chạy `dart run tool/route_coverage_audit.dart --check` cục bộ để chắc job static còn xanh.

### D3. Coverage + sàn threshold + ratchet — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** Không bước nào trong `flutter-ci.yml` truyền `--coverage`; `Full test suite` (L324–325) không đo coverage dù repo có 508 test file dưới `flutter_app/test`. Không có `coverage/`, không publish lcov, không ngưỡng.
- **Cần làm:** Ở job full-suite (D2), chạy `flutter test --coverage` (trên 1 shard gộp hoặc merge lcov các shard), upload `coverage/lcov.info` qua `actions/upload-artifact` (theo mẫu upload đã có ở L69–77). Thêm một tool kiểm sàn — có thể một script Dart nhỏ trong `flutter_app/tool/` đọc `lcov.info` và fail nếu tổng < ngưỡng khởi điểm ~40% (chọn thấp hơn số đo thực để không đỏ ngay), rồi ratchet: mỗi lần tăng, chỉ cho lên. Loại `lib/**/*.g.dart`, fixture mock (`features/*/data/fixtures/**`) khỏi mẫu số cho khỏi loãng.
- **Kiểm chứng:** `cd flutter_app && flutter test --coverage` sinh `coverage/lcov.info`; chạy script sàn cục bộ để xác nhận nó fail khi hạ ngưỡng giả định. Đưa vào `vt-verify` như một bước cuối.

### D4. Dependabot + SHA-pin action + secret scan — [Cải thiện] · [P1] · [S–M]
- **Hiện trạng:** Không tồn tại `.github/dependabot.yml` (glob `.github/dependabot.yml` = no files). Action pin bằng tag mutable: `actions/checkout@v4` (L27), `actions/setup-java@v4` (L29–30), `subosito/flutter-action@v2` (L36), `actions/upload-artifact@v4` (nhiều chỗ, vd L71). `subosito/flutter-action` nhận repo token khi chạy. Không có gitleaks/secret-scan job.
- **Cần làm:** Tạo `.github/dependabot.yml` với 2 ecosystem: `pub` (thư mục `/flutter_app`, theo `pubspec.yaml`) và `github-actions` (thư mục `/`). Pin mọi action theo commit SHA đầy đủ + comment tag để dependabot vẫn bump được. Bật secret scanning + push protection ở repo settings, và/hoặc thêm job `gitleaks` chạy trên PR. Xem lại quyền: giữ `permissions: contents: read` cấp workflow, chỉ nâng cục bộ ở job nào cần.
- **Kiểm chứng:** Mở PR thử để dependabot đề xuất bump; chạy `gitleaks detect --source .` (nếu thêm) trả 0 leak; xác nhận `flutter pub get` (L43) vẫn pass sau khi lock được dependabot đụng.

### D5. CODEOWNERS owner thật + branch protection — [Cải thiện] · [P1→P2] · [S]
- **Hiện trạng:** `.github/CODEOWNERS` liệt kê đúng các bottleneck file (router `app_router.dart`/`app_route_names.dart`/`app_route_paths.dart` L18–20, trade kernel `trade_module_layout.dart`/`trade_repository.dart` L23–24, fixture `earn/data/` L28, `p2p/data/` L29) nhưng mọi owner là `@replace-with-real-owner` (ghi rõ ở comment L10–15). GitHub bỏ qua entry không resolve → fail-open, không ai bị buộc review.
- **Cần làm:** Thay `@replace-with-real-owner` bằng GitHub team/username thật (vd `@org/platform-team` cho router, `@org/trade-team` cho trade kernel). Bật branch protection cho `main`/`master`: require PR review + "Require review from Code Owners" + require status checks (các job ở D2). Nếu tổ chức chưa có team thật thì XÓA file để khỏi giả tạo cảm giác được bảo vệ.
- **Kiểm chứng:** GitHub UI hiển thị owner resolve hợp lệ (không cảnh báo); tạo PR đụng `app_router.dart` để xác nhận nó tự request review từ owner; kiểm ruleset branch protection ép Code Owners.

### D6. Release engineering: flavors + workflow release + iOS + CHANGELOG — [Cải thiện] · [P1→P2] · [L]
- **Hiện trạng:** `pubspec.yaml` version tĩnh `1.0.0+1` (L4). `android/app/build.gradle.kts` chỉ có 1 `applicationId = "com.vittrade.vit_trade_flutter"` (L52), KHÔNG có `flavorDimensions`/`productFlavors`; đã có signing guard `gradle.taskGraph.whenReady` chặn build Release khi thiếu keystore (L83–95) và signing config đọc `key.properties`/env (L10–35). Tầng Dart env đã sẵn: `lib/core/config/app_environment.dart` có `AppConfig.fromDartDefines()` đọc `APP_ENV`/`API_BASE_URL`/`ENABLE_MOCK_DATA` (L23–43), nối vào `ApiClient` qua `appConfigProvider` (`api_client.dart` L6–10). CI chỉ build `flutter build apk --debug` (L327–328); không workflow release, không job iOS.
- **Cần làm:** (1) Thêm `productFlavors` dev/staging/prod trong `build.gradle.kts` với `applicationIdSuffix` (`.dev`/`.staging`) và `flavorDimensions("env")`, giữ nguyên khối signing guard. (2) Chuẩn hóa lệnh build truyền `--dart-define` khớp flavor (vd `--flavor prod --dart-define=APP_ENV=production --dart-define=API_BASE_URL=...`) — tận dụng `AppConfig.fromDartDefines` đã có, KHÔNG viết lại tầng config. (3) Thêm workflow release build `flutter build appbundle --flavor prod ...` (đi qua signing guard) và job iOS (`flutter build ipa`/`ios --no-codesign` tối thiểu) trên `macos-latest`, tách khỏi CI PR, trigger theo tag. (4) Thêm `CHANGELOG.md` và quy ước bump `version:` (L4) thay vì để tĩnh.
- **Kiểm chứng:** `cd flutter_app && flutter build appbundle --flavor prod --dart-define=APP_ENV=production` phải chạm đúng `GradleException` signing guard (`build.gradle.kts:87-94`) khi chưa cấu hình keystore — chứng minh guard còn hiệu lực với flavor mới; `flutter build apk --flavor dev --debug` ra artifact `applicationId` có suffix `.dev`; job iOS xanh trên runner macOS.

**Thứ tự đề xuất trong chiều:** D1 (chặn regression, gần miễn phí) → D2 (rút ngắn CI để mở đường cho các job mới) → D3 (gắn coverage vào job full-suite vừa tách) → D4 (khóa chuỗi cung ứng) → D5 (ép review owner thật) → D6 (release engineering, cần thiết kế + runner macOS).


---

## 8. Nợ code — file khổng lồ, trùng lặp, code chết — Hiện tại: B → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Chỉ tồn tại DUY NHẤT một đường format hiển thị (`VitFormat` + các file `*_formatters.dart` cấp module delegate về nó); không còn hàm `_format*` cục bộ tự cài logic tiền/phần trăm, và có guardrail cơ học chặn hàm mới. Mọi method public của `VitFormat` (12/12) có test, và có guardrail money-copy cấp module để một màn hình không thể render `$1234.50` khi màn khác render `$1,234.50`. Widget trùng đã có bản shared (`VitSectionHeader`, …) bị ép dùng bản shared; god-family lớp mock được để nguyên nhưng ghi tài liệu + đóng băng bằng baseline để không phình thêm.

**Khoảng cách chính hiện nay:** Có 312 khai báo `String _format*` trên 160 file nhưng chỉ 41 call site `VitFormat.*` trên 32 file — tức phần lớn logic tiền tệ vẫn tự cài rời rạc. Drift đã thành thật: `auto_compound_settings_shared.dart` render USD không nhóm nghìn (`$1234.50`) trong khi surface auto-compound khác của cùng feature earn và `VitFormat.usd` đều nhóm nghìn (`$1,234.50`). `VitFormat` chỉ có test cho 5/12 method, không có guardrail money-copy, không có guardrail chặn `_format*` mới, và còn 7 bản `_SectionLabel` dù đã có `VitSectionHeader`.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 8.1 | Vá drift tiền thật ở earn auto-compound | Cải thiện | P1 | S | `auto_compound_settings_shared.dart:212` | Cùng feature earn hiển thị USD hai kiểu (`$1234.50` vs `$1,234.50`) — sai chuẩn tiền tệ, mất niềm tin | `flutter test test/shared/utils/vit_format_test.dart` + đọc lại render |
| 8.2 | Migrate ~224 hàm `_format*` có logic riêng về VitFormat/formatter cấp module | Tối ưu | P2 | L | 160 file `String _format*`; đích: `*_formatters.dart` từng module | Drift tiếp diễn khi sửa 1 công thức phải nhớ 160 chỗ | grep `String _format` giảm dần; guardrail 8.3 xanh |
| 8.3 | Guardrail chặn `String _format*` mới không delegate | Cải thiện | P1 | S | `test/quality/architecture_baseline_guardrails_test.dart` (thêm rule) | Mọi công sức migrate bị hồi quy ngay tuần sau | `flutter test test/quality/architecture_baseline_guardrails_test.dart` |
| 8.4 | Phủ test 12/12 method VitFormat + guardrail money-copy cấp module | Cải thiện | P1 | M | `test/shared/utils/vit_format_test.dart`; tool + test money-copy mới | Đổi format âm thầm phá copy (đã xảy ra ở commit 440dcb06) | `flutter test test/shared/utils/vit_format_test.dart` + test money-copy mới |
| 8.5 | Dedup 7 `_SectionLabel` → `VitSectionHeader` | Tối ưu | P2 | S | 7 file (vd `staking_risk_disclosure_assessment_common.dart:122`) | Section header lệch nhau khi tinh chỉnh design token | grep `class _SectionLabel` = 0; visual QA |
| 8.6 | Audit + dedup lớp private trùng tên có bản shared | Tối ưu | P2 | M | 203 tên private ≥3 lần (965 định nghĩa) | Sửa 1 hành vi phải lặp lại N nơi; phình widget | `dart run tool/<audit mới>.dart --check` |
| 8.7 | Ghi tài liệu + đóng băng god-family mock | Cải thiện | P2 | S | `lib/features/earn/data/fixtures/` (27 file, ~11.2k dòng) | Đội hiểu nhầm là code chết cần xoá; hoặc phình thêm | Baseline file-count/line-count + review |
| 8.8 | Decompose `_AdvancedSettings.build` (~225 dòng) | Tối ưu | P3 | S | `dca_rebalance_config_page_part_02.dart:192` | Build method khó đọc/khó test từng phần | `flutter analyze`; review độ dài method |
| 8.9 | Chia nhỏ `TradeSpacingTokens` theo nhóm | Tối ưu | P3 | M | `trade_spacing_tokens.dart` (2.261 dòng/1.023 const) | File lớn nhất repo, khó điều hướng, dễ trùng token | `dart run tool/spacing_token_duplication_audit.dart --check` |

**Chi tiết từng hạng mục**

### 8.1. Vá drift tiền thật ở earn auto-compound — [Cải thiện] · [P1] · [S]
- **Hiện trạng:** `flutter_app/lib/features/earn/presentation/widgets/hub/auto_compound_settings_shared.dart:212-214`:
  ```dart
  String _formatUsd(double value) {
    return '\$${value.toStringAsFixed(2)}';   // → $1234.50, KHÔNG nhóm nghìn
  }
  ```
  Trong khi cùng feature earn, `flutter_app/lib/features/earn/presentation/widgets/staking/staking_auto_compound_shared.dart:107-119` (`_formatCurrency`) tự cài vòng lặp chèn dấu phẩy → `$1,234.50`, và `VitFormat.usd` (`flutter_app/lib/shared/utils/vit_format.dart:9`, delegate `formatUsd`) cũng nhóm nghìn. Ba đường format tiền cho cùng loại giá trị, hai kết quả khác nhau.
- **Cần làm:** Thay thân `_formatUsd` ở `auto_compound_settings_shared.dart` bằng delegate `VitFormat.usd(value)` (thêm import `shared/utils/vit_format.dart`), hoặc xoá hẳn hàm và gọi thẳng `VitFormat.usd`. Đồng thời gỡ `_formatCurrency` tự cài ở `staking_auto_compound_shared.dart:107` cho về `VitFormat.usd` / `VitFormat.compactInt` (bản compact) để khử luôn bản sao thứ hai. Đây là mẫu nhỏ nhất của hạng mục 8.2, làm trước để đóng bug user-visible.
- **Kiểm chứng:** `flutter test test/shared/utils/vit_format_test.dart`; grep `toStringAsFixed(2)` trong hai file trên = 0; chạy màn auto-compound và đối chiếu giá trị >= 1000 phải có dấu phẩy.

### 8.2. Migrate ~224 hàm `_format*` có logic riêng về VitFormat/formatter cấp module — [Tối ưu] · [P2] · [L]
- **Hiện trạng:** 312 khai báo `String _format*` trên 160 file (grep `String _format` trong `flutter_app/lib`), so với 41 call site `VitFormat.*` trên 32 file. Một phần đã là delegate 1 dòng về `VitFormat`, phần lớn còn lại tự cài công thức tiền/phần trăm/compact riêng — đây là gốc rễ của drift 8.1. Repo đã có sẵn các file formatter cấp module để làm đích: `trade_core/presentation/widgets/trade_formatters.dart` (đã dùng `VitFormat` 6 lần), `earn/presentation/widgets/hub/earn_formatters.dart`, `markets/.../market_formatters.dart`, `profile/.../profile_sub_account_formatters.dart`, `launchpad/.../launchpad_limit_orders_formatters.dart`.
- **Cần làm:** Migrate theo TỪNG module (không đại trà một PR), thứ tự ưu tiên module tiền-nhạy: earn → wallet → p2p → trade family → predictions. Với mỗi module: gom các `_format*` tiền/phần trăm về file `*_formatters.dart` của module, và file đó chỉ delegate về `VitFormat`. Lưu ý part-file (earn/p2p/trade dùng `part`): formatter dùng chung trong module phải đặt ở file được `part`/`import` chung, không nhân bản trong từng part. KHÔNG xoá các `_format*` mang copy sản phẩm đặc thù (không phải giá trị generic) — theo doc comment ở `vit_format.dart:5-7` chỉ generic mới ép về VitFormat.
- **Kiểm chứng:** Số khai báo `String _format` (grep) giảm theo từng đợt; guardrail 8.3 giữ xanh sau mỗi module; `flutter test` module tương ứng + các `test/quality/*_product_copy_guardrails_test.dart`.

### 8.3. Guardrail chặn `String _format*` mới không delegate — [Cải thiện] · [P1] · [S]
- **Hiện trạng:** `flutter_app/test/quality/architecture_baseline_guardrails_test.dart` đã có cơ chế quét `lib/features` bằng regex (`_sourceMatches`) cho các luật kiến trúc (vd cấm presentation import data facade, dòng 40-56), nhưng chưa có luật nào về formatter. grep `_format|VitFormat` trong file test này = 0.
- **Cần làm:** Thêm một `test(...)` trong nhóm `architecture baseline guardrails`: quét `lib/features`, bắt các khai báo khớp `RegExp(r'String\s+_format\w*\s*\(')` mà thân KHÔNG phải một dòng delegate về `VitFormat.`/`*Formatters.`; so với một allowlist đóng băng (danh sách hàm hợp lệ hiện tại có copy đặc thù). Bất kỳ hàm `_format*` MỚI nào không delegate → fail test, buộc tác giả hoặc thêm vào allowlist có review hoặc delegate. Dùng lại tiện ích `readSource`/`listDartFiles` ở `test/quality/product_copy_guardrail_test_utils.dart`.
- **Kiểm chứng:** `flutter test test/quality/architecture_baseline_guardrails_test.dart` — thêm một hàm `_formatUsd` giả không delegate phải làm test đỏ.

### 8.4. Phủ test 12/12 method VitFormat + guardrail money-copy cấp module — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** `VitFormat` có 12 method public (`vit_format.dart`: `usd`, `usdSigned`, `usdWhole`, `usdWholeSigned`, `count`, `thousands`, `email`, `account`, `percent`, `signedPercent`, `compactInt`, `compactSuffix`). `flutter_app/test/shared/utils/vit_format_test.dart` (35 dòng) chỉ chạm `usdSigned`, `usdWhole`, `usdWholeSigned`, `compactSuffix` + `formatUsd` — 7 method (`count`, `thousands`, `email`, `account`, `percent`, `signedPercent`, `compactInt`) chưa có test nào; không guardrail nào chặn drift money-copy ở tầng module.
- **Cần làm:** (a) Bổ sung case cho 7 method còn thiếu vào `vit_format_test.dart`, gồm biên: âm, 0, nhóm nghìn, `stripTrailingZero`, `fractionDigits`. (b) Tạo guardrail money-copy: một `tool/money_copy_audit.dart --check` + `test/quality/money_copy_guardrail_test.dart` (theo đúng khuôn `spacing_token_duplication_audit.dart` + `spacing_token_duplication_guardrail_test.dart`) quét presentation từng module bắt pattern nội suy USD tự cài kiểu `'\$' + ...toStringAsFixed(...)` không đi qua `VitFormat`/formatter module — chính là mẫu đã tạo drift 8.1.
- **Kiểm chứng:** `flutter test test/shared/utils/vit_format_test.dart` (12/12 method có assertion) và `flutter test test/quality/money_copy_guardrail_test.dart`.

### 8.5. Dedup 7 `_SectionLabel` → `VitSectionHeader` — [Tối ưu] · [P2] · [S]
- **Hiện trạng:** 7 khai báo `class _SectionLabel` trong: `trade_copy/.../performance_attribution_common.dart`, `p2p/.../p2p_payment_method_add_page_sections.dart`, `p2p/.../p2p_settings_hours_common.dart`, `p2p/.../p2p_create_ad_page_sections.dart`, `earn/.../staking_risk_disclosure_assessment_common.dart`, `arena/.../arena_flow_map_qa.dart`, `arena/.../arena_leaderboard_body.dart`. Bản ở `staking_risk_disclosure_assessment_common.dart:122-151` là Row [marker bar + Text caption bold] — trùng chức năng `VitSectionHeader` (variant `accentBar`) ở `flutter_app/lib/shared/widgets/vit_section_header.dart`.
- **Cần làm:** Với mỗi bản, thay bằng `VitSectionHeader(title: ..., variant: VitSectionHeaderVariant.accentBar, density: VitDensity.compact)` rồi xoá lớp `_SectionLabel` cục bộ. Đối chiếu marker size/line-height: nếu bản cục bộ dùng token riêng (vd `_stakingRiskSectionMarkerWidth`) khác `VitSectionHeader`, xác nhận sai lệch pixel chấp nhận được hoặc mở tham số density phù hợp trước khi thay.
- **Kiểm chứng:** grep `class _SectionLabel` = 0; `flutter analyze`; đối chiếu ảnh trước/sau ở màn đại diện.

### 8.6. Audit + dedup lớp private trùng tên có bản shared — [Tối ưu] · [P2] · [M]
- **Hiện trạng:** 203 tên private class được định nghĩa ≥3 lần (tổng ~965 định nghĩa). Nhiều bản là hợp lệ (part-file cục bộ, hoặc cố ý per-module) — KHÔNG kết luận trùng tên là code chết. Nhưng một tập con (như `_SectionLabel` ở 8.5) đã có bản shared tương đương.
- **Cần làm:** Viết `tool/duplicate_private_widget_audit.dart --check` liệt kê các tên private trùng ≥3 lần, đối chiếu với danh mục widget shared (`lib/shared/widgets/`) và whitelist các tên hợp lệ (part-local, `_State`, painter). Chỉ đưa vào diện dedup những lớp có bản shared tương đương về mặt render; xuất manifest CSV như các audit khác trong `tool/`. Dedup theo đợt nhỏ, mỗi đợt một họ widget, sau khi đã có bản shared thật.
- **Kiểm chứng:** `dart run tool/duplicate_private_widget_audit.dart --check` (baseline đóng băng, chỉ giảm được, không tăng); `flutter analyze`.

### 8.7. Ghi tài liệu + đóng băng god-family mock — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** `flutter_app/lib/features/earn/data/fixtures/` gồm 26 file `mock_earn_repository_part_*.dart` (~11.202 dòng) + `mock_earn_repository.dart` (30 dòng) = 27 file ~11,2k dòng, là aggregation của 68 `class Mock*` nhỏ. Đây là lớp mock của giai đoạn MOCK-DATA, sẽ bị thay khi có backend — không phải code chết, nhưng hiện không có ghi chú nào nói rõ điều đó, dễ bị hiểu nhầm hoặc bị nhân bản thêm.
- **Cần làm:** (a) Thêm doc comment đầu `mock_earn_repository.dart` (và các họ mock lớn tương tự) nêu rõ: "lớp fixture mock, sẽ được thay bằng repository backend; không refactor cấu trúc, không thêm logic hiển thị vào đây". (b) Ghi mục "god-family mock chấp nhận được" vào `docs/02_FLUTTER_MIGRATION/`. (c) Đóng băng bằng một baseline đếm file/dòng (mở rộng audit hiện có hoặc test nhẹ) để mock KHÔNG phình thêm ngoài dự kiến.
- **Kiểm chứng:** Review doc; baseline count file trong `fixtures/` không tăng bất thường giữa các PR.

### 8.8. Decompose `_AdvancedSettings.build` (~225 dòng) — [Tối ưu] · [P3] · [S]
- **Hiện trạng:** `flutter_app/lib/features/dca/presentation/pages/portfolio/dca_rebalance_config_page_part_02.dart` — `class _AdvancedSettings` khai báo dòng 174, `build` bắt đầu dòng 192, và `build` của lớp kế tiếp ở dòng 417 → thân build khoảng 225 dòng liền mạch không tách widget con.
- **Cần làm:** Tách các cụm UI lớn trong `build` thành các private widget/helper method (vd nhóm slider ngưỡng, nhóm toggle, nhóm nút hành động) để mỗi phần <60 dòng, dễ đọc và test snippet. Không đổi hành vi/layout, chỉ trích xuất.
- **Kiểm chứng:** `flutter analyze`; đối chiếu ảnh trang DCA rebalance config trước/sau; độ dài `build` sau tách <100 dòng.

### 8.9. Chia nhỏ `TradeSpacingTokens` theo nhóm — [Tối ưu] · [P3] · [M]
- **Hiện trạng:** `flutter_app/lib/app/theme/spacing/trade_spacing_tokens.dart` là file lớn nhất repo: 2.261 dòng, 1.023 `static const`. Một class chứa toàn bộ token spacing của trade family, khó điều hướng và dễ khai báo trùng.
- **Cần làm:** Tách `TradeSpacingTokens` thành các nhóm theo màn/khu vực (vd part-file `trade_spacing_tokens_hub.part.dart`, `..._futures.part.dart`, …) giữ nguyên tên class qua `part`, hoặc gom theo namespace con — không đổi tên hằng để tránh vỡ call site. Đây là bước dọn cuối cùng, làm sau khi guardrail `spacing_token_duplication_audit` đã ổn định để tách không tạo trùng mới.
- **Kiểm chứng:** `dart run tool/spacing_token_duplication_audit.dart --check`; `flutter analyze` (không call site nào gãy).

**Thứ tự đề xuất trong chiều:** 8.3 (đóng băng chống drift mới, rẻ) → 8.1 (vá bug tiền đang hiển thị) → 8.4 (test + guardrail money-copy) → 8.2 (migrate theo module, dài) → 8.5 → 8.6 → 8.7 → 8.8 → 8.9.


---

All findings verified against real files. Here is the section.

## 9. Tài liệu & quản trị kỹ thuật — Hiện tại: B → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Mọi tuyên bố trong tài liệu quản trị đều đúng với đĩa và git — không có "removal log" nói đã xoá nhưng file còn tracked, không có doc required-reading nằm ngoài git, không có cặp doc trùng đường dẫn diverge. Có một quy ước path canonical duy nhất cho từng loại artifact (standards/ · checklists/ · audits/ · redesign/) được guardrail chặn. Có hệ ADR để tra cứu vì-sao-quyết-định, đủ bộ CONTRIBUTING/LICENSE/SECURITY và CODEOWNERS thật. Public API của tầng `domain/` (contract tài chính) và `shared/` (widget dùng chung) được lint ép có dartdoc.

**Khoảng cách chính hiện nay:** INDEX ghi "Removed docs (2026-07-10)" nhưng 4/… nhóm file nêu tên vẫn còn tracked trong git; 1 doc required-reading (`Two-Phase-Codex-Workflow.md`) chưa vào git; hơn 50 cặp doc top-level vs subdir đang song song và phần lớn đã diverge (tool sinh vào `audits/` còn bản top-level bị bỏ lại stale). Chưa có ADR, chưa có CONTRIBUTING/LICENSE/SECURITY, CODEOWNERS toàn placeholder, `analysis_options.yaml` chỉ bật `avoid_print` nên public API không bị ép doc.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| D1 | INDEX "Removed docs" trung thực + guardrail | Cải thiện | P1 | M | `docs/INDEX.md:150-158`; guardrail mới trong `flutter_app/test/quality/ops_metadata_guardrails_test.dart` | Tài liệu quản trị nói dối → mất niềm tin, dev đọc log tưởng file đã xoá | `flutter test test/quality/ops_metadata_guardrails_test.dart` |
| D2 | Commit doc required-reading vào git | Cải thiện | P1 | S | `docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` (untracked); tham chiếu `docs/INDEX.md:14` | Doc bắt buộc đọc chỉ có trên máy 1 người, mất khi clone mới | `git ls-files --error-unmatch docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` |
| D3 | Xoá bản top-level leftover diverge + chốt path canonical | Tối ưu | P1 | M | `docs/02_FLUTTER_MIGRATION/*.md/*.csv` (bản top-level) vs `standards//checklists//audits//redesign/` | 2 bản mâu thuẫn, dev đọc nhầm bản stale; tool ghi đè 1 bản, bản kia phân kỳ tiếp | Script diff top-level vs subdir + `dart run tool/card_tile_audit.dart --check` |
| D4 | Dựng hệ ADR / decision record | Cải thiện | P2 | M | `docs/05_ARCHITECTURE/` (mới: `decisions/NNNN-*.md` + `README.md`) | Quyết định lớn (tách Trade family, mock-first) không lưu lý do, tái tranh luận | Review thủ công: mỗi quyết định P0/P1 có 1 ADR |
| D5 | Freshness metadata + guardrail cho contract | Cải thiện | P2 | S | `AGENTS.md:7` (`Last Updated: 2026-05-26`), `docs/INDEX.md` | Dev không biết doc còn hiệu lực; contract cũ 7 tuần | Guardrail assert `Last Updated` ≥ ngưỡng trong `ops_metadata_guardrails_test.dart` |
| D6 | Bổ sung CONTRIBUTING/LICENSE/SECURITY + fill CODEOWNERS | Cải thiện | P2 | M | root `CONTRIBUTING.md`/`LICENSE`/`SECURITY.md` (thiếu); `.github/CODEOWNERS:11-30` (placeholder) | Không quy trình đóng góp/khai báo lỗ hổng; CODEOWNERS không enforce | `ls CONTRIBUTING.md LICENSE SECURITY.md`; kiểm CODEOWNERS không còn `@replace-with-real-owner` |
| D7 | Lint ép dartdoc public API cho `shared/` + `domain/` | Cải thiện | P2 | L | `flutter_app/analysis_options.yaml:10-12`; vùng `lib/**/domain/`, `lib/shared/` | Contract tài chính + widget an toàn không doc, backend/đội mới hiểu sai | `flutter analyze` sau khi bật `public_member_api_docs` |

**Chi tiết từng hạng mục**

### D1. INDEX "Removed docs" trung thực + guardrail — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** `docs/INDEX.md:150-158` khai "Removed docs (2026-07-10)": "Card Tile execution-plan/checklist … the VitTrade UI Redesign v2.5 pending-batch trackers … 4 stale/abandoned CSV dumps … and `03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`". Thực tế các file vẫn tracked: `git ls-files` xác nhận `docs/02_FLUTTER_MIGRATION/Card-Tile-Migration-Checklist.md`, `Card-Tile-Migration-Execution-Plan.md`, `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`, `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Redesign-Checklist.csv` đều còn TRACKED và tồn tại trên đĩa.
- **Cần làm:** Chọn một trong hai và đồng bộ triệt để: (a) thật sự `git rm` các file mà log tuyên bố đã xoá (sau khi xác nhận zero-reference bằng grep toàn repo), hoặc (b) sửa log 2026-07-10 cho khớp thực tế. Sau đó thêm một guardrail: trong `flutter_app/test/quality/ops_metadata_guardrails_test.dart` (test đã đọc file repo như `README.md`/`web/manifest.json`), parse mọi mục "Removed docs …" của `docs/INDEX.md`, trích tên file nêu trong đoạn và `expect` chúng KHÔNG tồn tại trên đĩa. Gộp chung nhóm assert freshness của D5.
- **Kiểm chứng:** `flutter test test/quality/ops_metadata_guardrails_test.dart` (đỏ khi log nhắc một path còn tồn tại); phụ trợ `git ls-files docs/02_FLUTTER_MIGRATION/Card-Tile-Migration-Execution-Plan.md`.

### D2. Commit doc required-reading vào git — [Cải thiện] · [P1] · [S]
- **Hiện trạng:** `docs/INDEX.md:14` liệt kê `Two-Phase-Codex-Workflow.md` ở nhóm "Always-on (short)" ("Plan chat → Execute chats … copy-paste prompts"), nhưng `git status --porcelain` cho `?? docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` — file 4.8K tồn tại trên đĩa nhưng chưa vào git (`git ls-files` trả rỗng).
- **Cần làm:** Review nội dung rồi `git add docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` và commit cùng đợt dọn tài liệu. Kiểm nhanh các doc always-on/required khác trong INDEX (AGENTS.md, AI_EXECUTION_CONTRACT.md, DOCUMENT_PRECEDENCE.md) đều đã tracked (đã xác nhận chỉ file này untracked trong `docs/`).
- **Kiểm chứng:** `git ls-files --error-unmatch docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` (exit 0). Có thể gia cố bằng guardrail đọc bảng "Always-on" trong INDEX và assert từng path là tracked.

### D3. Xoá bản top-level leftover diverge + chốt path canonical — [Tối ưu] · [P1] · [M]
- **Hiện trạng:** `docs/02_FLUTTER_MIGRATION/` chứa song song bản top-level và bản subdir cho hơn 50 tài liệu, phần lớn đã diverge. Ví dụ đã xác minh: `Card-Tile-Compliance-Report.md` (top-level) DIVERGED với `audits/Card-Tile-Compliance-Report.md`; loạt `*-Standard.md` diverge với `standards/…`; loạt `VitTrade-*-Audit.csv` diverge với `audits/…`. Bằng chứng canonical là các tool: `flutter_app/tool/card_tile_audit.dart:11-16`, `design_token_consistency_audit.dart:156-159`, `back_navigation_behavior_audit.dart:38-41` đều ghi vào `${docsDir.path}/audits/…`, còn `docs/INDEX.md` (vd dòng 30-54, 45) trỏ tới `standards/`·`audits/`·`checklists/` — nên bản top-level là leftover stale, tool regen subdir làm hai bản ngày càng lệch. (Lưu ý: một số cặp vẫn SAME như `ke-hoach-redesign-batches.csv`, `redesign/…` — không phải mọi cặp đều diverge, cần dedup chứ không kết luận "code chết".)
- **Cần làm:** Chốt quy ước path canonical: standards → `standards/`, checklist → `checklists/`, audit CSV/report do tool sinh → `audits/`, redesign → `redesign/`, prompt-redesign → `prompt-redesign/`. `git rm` các bản top-level trùng tên với bản subdir sau khi (1) grep xác nhận không link/tool nào trỏ vào bản top-level, (2) nếu bản top-level mới hơn thì merge nội dung về bản canonical trước khi xoá. Ghi quy ước vào `docs/INDEX.md` mục "Audit tools" (gần dòng 119-130, chỗ đã ghi "Generated CSV artifacts live under `docs/02_FLUTTER_MIGRATION/`" — sửa thành `…/audits/`).
- **Kiểm chứng:** Script so khớp: mọi `*.md/*.csv` ở `docs/02_FLUTTER_MIGRATION/` top-level không được trùng tên với file ở subdir (fail nếu còn cặp). Sau dedup chạy `dart run tool/card_tile_audit.dart --check` và `dart run tool/design_token_consistency_audit.dart --check` để chắc tool vẫn ghi đúng `audits/`.

### D4. Dựng hệ ADR / decision record — [Cải thiện] · [P2] · [M]
- **Hiện trạng:** Không có thư mục/decision record nào (`find` cho `*adr*`/`*decision*` không tìm thấy ADR). `docs/05_ARCHITECTURE/` chỉ có `VitTrade-Enterprise-Architecture-Report.md`. Các quyết định lớn (tách Trade thành 6 module sibling — commit `6da5cfc3`; mock-first repository; dedup VitFormat) không có bản ghi lý do.
- **Cần làm:** Tạo `docs/05_ARCHITECTURE/decisions/` với `README.md` mô tả format (MADR tối giản: Context · Decision · Consequences · Status) và template `0000-template.md`. Backfill vài ADR cho quyết định P0/P1 đã có: tách Trade family, chuẩn hoá design system VitTrade (commit `0e92fe00`), quy ước path canonical (D3). Thêm mục "Architecture" trong `docs/INDEX.md:100-104` trỏ tới `decisions/`.
- **Kiểm chứng:** Review thủ công trong buổi họp: mỗi quyết định kiến trúc P0/P1 trong 6 tháng gần nhất có đúng 1 ADR; kiểm ADR mới theo template (assert có đủ các heading trong guardrail nếu muốn).

### D5. Freshness metadata + guardrail cho contract — [Cải thiện] · [P2] · [S]
- **Hiện trạng:** `AGENTS.md:7` ghi `**Last Updated:** 2026-05-26` — cũ ~7 tuần so với ngày hiện tại (2026-07-15), trong khi repo có nhiều commit chuẩn hoá lớn sau đó (`0e92fe00`, `6da5cfc3`, `440dcb06`). Không có cơ chế chặn metadata cũ; `docs/INDEX.md` không có trường Last Updated cho toàn bộ index.
- **Cần làm:** Cập nhật `AGENTS.md:7` khi nội dung đổi, thêm trường Last Updated vào `docs/INDEX.md` (đầu file). Thêm guardrail trong `ops_metadata_guardrails_test.dart` parse dòng `Last Updated:` của các contract top-level (AGENTS.md, INDEX.md, AI_EXECUTION_CONTRACT.md) và fail nếu quá ngưỡng (vd > 90 ngày) — cảnh báo staleness, không khoá cứng theo ngày build.
- **Kiểm chứng:** `flutter test test/quality/ops_metadata_guardrails_test.dart` (đỏ khi `Last Updated` vượt ngưỡng); kiểm `AGENTS.md:7` phản ánh commit gần nhất.

### D6. CONTRIBUTING/LICENSE/SECURITY + fill CODEOWNERS — [Cải thiện] · [P2] · [M]
- **Hiện trạng:** Root không có `CONTRIBUTING.md`, `LICENSE`, `SECURITY.md` (đã `ls` xác nhận thiếu); `docs/99_LEGAL/` chỉ có `ATTRIBUTIONS.md` (244B). `.github/CODEOWNERS:11-15` tự ghi owner là placeholder và mọi entry (`:18-30`) là `@replace-with-real-owner` nên GitHub bỏ qua, không enforce reviewer cho router/Trade-kernel/earn·p2p data.
- **Cần làm:** Thêm `CONTRIBUTING.md` (tham chiếu quy trình verify của repo: `flutter test test/quality/…`, các `dart run tool/*_audit.dart --check`), `SECURITY.md` (kênh báo lỗ hổng — lưu ý app đang mock-data, chưa backend thật), và `LICENSE` (chọn license, hoặc ghi rõ proprietary). Thay `@replace-with-real-owner` trong CODEOWNERS bằng team/username GitHub thật cho 3 nhóm bottleneck (router composition, `trade_core` kernel, `earn/data`+`p2p/data`).
- **Kiểm chứng:** `ls CONTRIBUTING.md LICENSE SECURITY.md`; `grep -c "@replace-with-real-owner" .github/CODEOWNERS` = 0; guardrail đơn giản assert 3 file tồn tại và CODEOWNERS không còn placeholder.

### D7. Lint ép dartdoc public API cho `shared/` + `domain/` — [Cải thiện] · [P2] · [L]
- **Hiện trạng:** `flutter_app/analysis_options.yaml:1-12` chỉ `include: package:flutter_lints/flutter.yaml` và bật đúng một rule `avoid_print: true`; không có `public_member_api_docs`/`package_api_docs`. Public API tầng `domain/` (repository/entity contract tài chính) và widget `Vit*` trong `lib/shared/` phần lớn không có dartdoc, không gì ép.
- **Cần làm:** Vì bật `public_member_api_docs` toàn repo sẽ nổ hàng nghìn warning, làm theo scope: backfill dartdoc trước cho `lib/**/domain/repositories/`, `domain/entities/` và `lib/shared/` (widget dùng chung); sau đó bật `public_member_api_docs` có giới hạn phạm vi bằng `analysis_options.yaml` riêng đặt trong các thư mục đó (analyzer hỗ trợ per-directory options file), hoặc thêm rule ở root rồi dùng `// ignore_for_file` cho vùng chưa backfill. Đặt cứng ở mức error cho `shared/` và `domain/` để CI chặn.
- **Kiểm chứng:** `flutter analyze` (không còn `public_member_api_docs` warning trong `shared/`+`domain/`); có thể thêm bước analyze này vào khối `vt-verify`.

**Thứ tự đề xuất trong chiều:** D2 (S, khôi phục toàn vẹn required-reading) → D1 (honesty guardrail, chốt sự thật INDEX) → D3 (dedup + path canonical, gỡ nguồn diverge lớn nhất) → D5 (freshness, tái dùng cùng guardrail file) → D6 (governance stubs + CODEOWNERS thật) → D4 (ADR) → D7 (dartdoc lint, cần backfill nên làm cuối).


---

## 10. Độ sâu kiểm thử — Hiện tại: B- → Mục tiêu: A+

**A+ cho chiều này nghĩa là gì:** Mọi high-risk contract (9 họ) vừa có guardrail tĩnh (allowlist đầy đủ) vừa có ít nhất một test lifecycle được `pumpWidget` chạy thật end-to-end. Mọi feature tài chính có unit test cho tầng data (repository) và domain (entity/getter suy diễn), không chỉ test page/widget. CI bật `--coverage` với ngưỡng sàn (floor) không cho tụt. Feature chính có golden test, và mọi test co-located đúng module sở hữu symbol.

**Khoảng cách chính hiện nay:** 3/9 high-risk contract nằm ngoài allowlist guardrail; earn — module lớn nhất (344 file lib) — có 0 test tầng data/domain; cả 9 contract chỉ được kiểm ở mức hình-dạng-dữ-liệu, không flow nào được pump chạy thật; 21/28 feature không có test repository/entity; không có coverage tooling/floor trong CI; golden chỉ phủ 1/28 feature; và 2 file test đặt sai module.

**Bảng hành động**

| # | Hạng mục | Loại | Ưu tiên | Effort | File / Vùng cụ thể | Rủi ro nếu bỏ qua | Cách kiểm chứng |
| --- | --- | --- | --- | --- | --- | --- | --- |
| HR-1 | Wire + đưa 3 high-risk flow vào allowlist guardrail | Cải thiện | P0 | M | `test/quality/high_risk_state_primitives_guardrail_test.dart:7-21`; pages trong `trade_terminal`/`trade_bots`/`trade_copy` | Panel high-risk có thể bị gỡ khỏi margin/bots/copy mà không test nào bắt được | `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart` |
| HR-2 | Unit test tầng data/domain cho earn | Cải thiện | P0 | M | `lib/features/earn/data/repositories/mock_earn_repository.dart` (+26 part); `earn_entities_part_06.dart:354-358`, `part_05.dart:394-400` | Module tài chính lớn nhất, sở hữu `earn_savings_staking`, chỉ có test giao diện; logic suy diễn (%, uptime, cooling-off) không được canh | `flutter test test/features/earn` |
| HR-3 | Test lifecycle end-to-end (pump) cho 9 high-risk contract | Cải thiện | P1 | L | `test/core/product_flow/high_risk_flow_contract_test.dart`, `high_risk_flow_binding_test.dart`; `test/quality/accessibility_semantics_critical_flows_test.dart` | Chỉ kiểm metadata; không chứng minh flow entry→confirm→support chạy thật; 6/9 họ chưa từng được pump | `flutter test test/core/product_flow test/quality/accessibility_semantics_critical_flows_test.dart` |
| HR-4 | Test repository/entity cho các feature tài chính còn thiếu | Cải thiện | P1 | L | `test/features/{launchpad,trade_bots,trade_copy,trade_terminal,rewards,...}` (21/28 thiếu thư mục `data/`) | 21/28 feature không canh contract tầng data; drift copy/số tiền (như VitFormat 440dcb06) không bị bắt | `flutter test test/features` + đối chiếu thư mục `test/features/*/data` |
| HR-5 | Bật coverage tooling + ngưỡng sàn trong CI | Cải thiện | P1 | M | `.github/workflows/flutter-ci.yml:324-325` (`flutter test` không có `--coverage`) | Không đo được độ phủ; không thể phát hiện vùng 0-test; A+ bar không đạt được | `flutter test --coverage` sinh `coverage/lcov.info` + bước check floor mới |
| HR-6 | Golden/visual-regression cho feature chính | Cải thiện | P2 | L | Chỉ có `test/features/home/golden/` (2 file); trade/wallet/p2p/earn không có | Regressions thị giác ở các flow tiền thật không bị bắt tự động | `flutter test test/features/*/golden` |
| HR-7 | Di dời 2 test lạc chỗ về đúng module | Tối ưu | P2 | S | `test/features/trade_core/trade_copy_controller_test.dart`, `trade_risk_order_controller_test.dart` | Test co-located sai module; phụ thuộc barrel-export vòng của `trade_core` che giấu ranh giới sở hữu | `flutter test test/features/trade_copy test/features/trade_terminal` sau khi chuyển |
| HR-8 | Tách các file test >400 dòng | Tối ưu | P3 | S | `test/shared/widgets/vit_shared_widgets_test.dart` (1653 dòng) + 6 file khác | Khó bảo trì, khó khoanh vùng lỗi, review chậm | `flutter test test/shared/widgets` sau khi tách |

**Chi tiết từng hạng mục**

### HR-1. Wire + đưa 3 high-risk flow vào allowlist guardrail — [Cải thiện] · [P0] · [M]
- **Hiện trạng:** `test/quality/high_risk_state_primitives_guardrail_test.dart:7-21` chỉ liệt kê 13 file, không có đại diện nào của `trade_margin_futures`, `trade_bots`, `trade_copy`. Đây là gap thực chứ không chỉ thiếu tên trong allowlist: quét source cho thấy **không file nào** trong `trade_terminal`/`trade_bots`/`trade_copy` chứa đồng thời `VitHighRiskStatePanel` và `highRiskContractId`. `trade_copy` dùng `VitHighRiskStatePanel` ở 22 file nhưng truyền `contractId` là chuỗi ad-hoc (vd `lib/features/trade_copy/presentation/pages/analytics/copy_performance_page.dart:77` → `contractId: 'copy-performance-${widget.copyId}'`), KHÔNG lấy từ `snapshot.highRiskContractId` đã được audit. Trong khi đó snapshot của cả 3 họ vẫn mang `highRiskContractId` (chứng minh ở `high_risk_flow_binding_test.dart:130-137`: `getFutures()/getTradingBots()/getCopyTrading()`).
- **Cần làm:** Hai bước, không chỉ "thêm 1 dòng test". (1) Trên một trang đại diện của mỗi flow, wire `snapshot.highRiskContractId` vào `VitHighRiskStatePanel.contractId` theo đúng khuôn mẫu `lib/features/earn/presentation/pages/staking/staking_earn_page.dart:103-109` (`if (snapshot.highRiskContractId != null) VitHighRiskStatePanel(contractId: snapshot.highRiskContractId)`). (2) Thêm 3 file trang đó vào `const targets` ở `high_risk_state_primitives_guardrail_test.dart:7`. Nếu lãnh đạo chấp nhận contractId ad-hoc, phương án thay thế là nới guardrail để đối chiếu qua fixture binding thay vì literal `highRiskContractId` — nhưng phương án wire mới là chuẩn enterprise.
- **Kiểm chứng:** `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart` (phải fail trước khi wire, pass sau khi wire + cập nhật allowlist).

### HR-2. Unit test tầng data/domain cho earn — [Cải thiện] · [P0] · [M]
- **Hiện trạng:** `test/features/earn/` có 69 test nhưng chỉ 1 file không phải page/widget (`earn_controller_test.dart`); **không có** thư mục `test/features/earn/data/`. Trong khi đó tầng data là `lib/features/earn/data/repositories/mock_earn_repository.dart` (barrel 31 dòng gom 26 part fixture) và tầng domain có getter suy diễn thật sự cần canh: `earn_entities_part_06.dart:354-358` (`yesPercent => totalVotes == 0 ? 0 : yesVotes / totalVotes * 100`, `noPercent => 100 - yesPercent` — có nhánh chia-cho-0), `earn_entities_part_05.dart:394-400` (`healthyCount`/`warningCount`/`averageUptime`), `earn_entities_part_08.dart:478` (`resolvedFindings`).
- **Cần làm:** Tạo `test/features/earn/data/mock_earn_repository_*_test.dart` (theo khuôn `test/features/wallet/data/mock_wallet_repository_test.dart`) canh bất biến của snapshot: `getStakingEarn(route: StakingEarnRoute.staking).highRiskContractId == HighRiskFlowContractIds.earnSavingsStaking`, cooling-off hours, trường không rỗng. Thêm `test/features/earn/domain/earn_entities_test.dart` canh các getter suy diễn ở trên (đặc biệt nhánh `totalVotes == 0`). Lưu ý app đang MOCK-DATA nên trọng tâm là bất biến snapshot + getter, không phải engine tính APY thời gian thực (không tồn tại).
- **Kiểm chứng:** `flutter test test/features/earn` (bổ sung nhánh data/domain vào bộ đếm 69→).

### HR-3. Test lifecycle end-to-end (pump) cho 9 high-risk contract — [Cải thiện] · [P1] · [L]
- **Hiện trạng:** `test/core/product_flow/high_risk_flow_contract_test.dart` và `high_risk_flow_binding_test.dart` chỉ kiểm hình-dạng-dữ-liệu — thứ tự stage, route bắt đầu bằng `/`, `highRiskContractId` khớp (vd `high_risk_flow_binding_test.dart:112-198`) — **không hề `pumpWidget`** flow nào. Test pump thật duy nhất chạm high-risk là `test/quality/accessibility_semantics_critical_flows_test.dart`, nhưng chỉ chạm ~3–4 họ: withdraw (`wallet_money_movement`, dòng 39-74), p2p payment add (`p2p_escrow_order`, dòng 99-114), prediction risk calc (`prediction_market_event`, dòng 136-143), cộng address-add/token-approval của wallet. 6/9 họ (trade_spot, trade_margin_futures, trade_bots, trade_copy, earn_savings_staking, launchpad_token_access) chưa bao giờ được pump.
- **Cần làm:** Với mỗi contract, thêm một `testWidgets` pump route entry qua `createAppRouter(initialLocation: contract.entryRoute)` (khuôn `accessibility_semantics_critical_flows_test.dart:10-24`) rồi assert panel high-risk + control preview/confirm hiển thị, tối thiểu qua bước entry→preview→support. Ưu tiên 6 họ chưa được pump. Dùng `HighRiskFlowBindings.findByRoute(...)` (đã có ở `high_risk_flow_binding_test.dart:57-110`) để lấy route chuẩn.
- **Kiểm chứng:** `flutter test test/core/product_flow test/quality/accessibility_semantics_critical_flows_test.dart`.

### HR-4. Test repository/entity cho các feature tài chính còn thiếu — [Cải thiện] · [P1] · [L]
- **Hiện trạng:** Chỉ 7/28 feature có thư mục `test/features/*/data/`: markets, news, p2p, predictions, referral, trade_core, wallet (xác nhận qua `find test/features -type d -name data`). 21 feature còn lại — gồm các họ tiền thật launchpad, trade_bots, trade_copy, trade_terminal, rewards — không có test tầng data/entity nào.
- **Cần làm:** Với mỗi feature tài chính, tạo `test/features/<feature>/data/mock_<feature>_repository_test.dart` canh getter repository trả đúng snapshot, bất biến số/chuỗi, và propagation `highRiskContractId` nếu có. Lấy `test/features/p2p/data/mock_p2p_repository_orders_test.dart` và `test/features/markets/data/mock_market_repository_logic_test.dart` làm khuôn. Ưu tiên các feature có contract high-risk trước.
- **Kiểm chứng:** `flutter test test/features` + kiểm mỗi feature tài chính đã có `test/features/*/data/`.

### HR-5. Bật coverage tooling + ngưỡng sàn trong CI — [Cải thiện] · [P1] · [M]
- **Hiện trạng:** `.github/workflows/flutter-ci.yml:324-325` bước "Full test suite" chạy `flutter test --reporter=compact` **không có `--coverage`**; không có bước sinh `lcov.info`, không upload codecov, không ngưỡng sàn. Không grep được tham chiếu coverage nào trong `pubspec.yaml`/`tool/`. Không đo được độ phủ nên các gap HR-2/HR-4 vô hình với CI.
- **Cần làm:** Đổi bước 324-325 thành `flutter test --coverage --reporter=compact` (sinh `coverage/lcov.info`), thêm bước enforce floor (script Dart trong `tool/` đọc lcov và fail nếu < ngưỡng, hoặc dùng action lcov). Đặt floor khởi điểm bằng mức hiện tại rồi nâng dần. Bước này nên làm sớm để đo lường HR-2/HR-3/HR-4.
- **Kiểm chứng:** `flutter test --coverage` sinh `coverage/lcov.info`; bước CI mới fail khi tụt dưới floor.

### HR-6. Golden/visual-regression cho feature chính — [Cải thiện] · [P2] · [L]
- **Hiện trạng:** Golden chỉ tồn tại ở `test/features/home/golden/` (`home_page_golden_test.dart`, `home_shared_widgets_golden_test.dart`) và được CI chạy riêng ở `flutter-ci.yml:130-131`. Trade/wallet/p2p/earn — các flow tiền thật — không có golden nào.
- **Cần làm:** Thêm `test/features/<feature>/golden/` cho ít nhất trade, wallet, p2p, earn theo khuôn `test/features/home/golden/home_page_golden_test.dart` (pump trang chính, `matchesGoldenFile`). Bổ sung bước CI tương ứng cạnh dòng 130-131, hoặc mở rộng bước đó thành `flutter test test/features/*/golden/`. Chốt kích thước thiết bị nhất quán để golden ổn định.
- **Kiểm chứng:** `flutter test test/features/wallet/golden test/features/trade/golden ...` (golden khởi tạo bằng `--update-goldens` lần đầu).

### HR-7. Di dời 2 test lạc chỗ về đúng module — [Tối ưu] · [P2] · [S]
- **Hiện trạng:** `test/features/trade_core/trade_copy_controller_test.dart` thực chất test `TradeCopyConfirmationController`/`TradeActiveCopiesController`/... định nghĩa ở `lib/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart`; `test/features/trade_core/trade_risk_order_controller_test.dart` test `TradeRiskManagementController`/`TradeAdvancedToolsController` định nghĩa ở `lib/features/trade_terminal/presentation/controllers/trade_risk_management_controller_models.dart` và `trade_order_controller_models.dart`. Cả hai tiếp cận symbol qua barrel-export vòng của `trade_core`: `lib/features/trade_core/presentation/controllers/trade_controller.dart:1-6` re-export entities/controllers từ trade_terminal/bots/compliance/copy.
- **Cần làm:** Chuyển 2 file test sang `test/features/trade_copy/` và `test/features/trade_terminal/`, đổi import trỏ trực tiếp package của module sở hữu thay vì barrel `trade_core/.../trade_controller.dart` (giảm phụ thuộc vòng). Không đổi nội dung assert.
- **Kiểm chứng:** `flutter test test/features/trade_copy test/features/trade_terminal` (pass sau khi chuyển + sửa import).

### HR-8. Tách các file test >400 dòng — [Tối ưu] · [P3] · [S]
- **Hiện trạng:** 7 file >400 dòng: `test/shared/widgets/vit_shared_widgets_test.dart` (1653), `test/quality/page_rhythm_guardrail_test.dart` (609), `test/quality/architecture_baseline_guardrails_test.dart` (419), `test/quality/home_reference_consistency_guardrail_test.dart` (418), `test/quality/page_rhythm_phone_visual_qa_test.dart` (409); ngoài ra 2 file lớn là fixture chứ không phải test (`test/fixtures/navigation_intent_contract.dart` 971, `test/fixtures/high_risk_flow_binding.dart` 832 — chỉ cần biết, không cần tách như test).
- **Cần làm:** Tách `vit_shared_widgets_test.dart` theo nhóm widget (mỗi nhóm một file `test/shared/widgets/vit_<widget>_test.dart`). Với các guardrail test lớn, cân nhắc tách theo domain đã audit. Không đổi assert, chỉ tổ chức lại.
- **Kiểm chứng:** `flutter test test/shared/widgets test/quality` (số test không đổi trước/sau khi tách).

**Thứ tự đề xuất trong chiều:** HR-1 (P0, chặn regression high-risk) → HR-7 (S, dọn ranh giới module nhanh) → HR-2 (P0, earn) → HR-5 (bật coverage để đo mọi việc còn lại) → HR-3 (pump end-to-end high-risk) → HR-4 (phủ repo/entity 21 feature) → HR-6 (golden feature chính) → HR-8 (tách file test lớn).


---


# PHẦN TỔNG HỢP — Lộ trình lên A+, phân công & họp đội

## 11. Lộ trình 4 giai đoạn (gộp toàn bộ hành động của 10 chiều)

Nguyên tắc xếp thứ tự: **(1)** đóng P0 và các mục "gần như miễn phí hôm nay, đắt sau này" trước; **(2)** mọi việc "chuẩn bị backend" phải xong *trước* khi backend thật về; **(3)** việc "Viết lại" nặng nằm sau khi đã có guardrail chặn hồi quy.

### Giai đoạn 0 — Quick wins (1 sprint ngắn, chủ yếu Effort S, rủi ro thấp)
Mục tiêu: đóng 2 P0 rẻ nhất + bật các chốt chặn gần-miễn-phí. Làm được ngay, không cần thiết kế.

| Việc | Chiều | Loại | File chính |
| --- | --- | --- | --- |
| Thêm 3 contract high-risk (`trade_margin_futures`, `trade_bots`, `trade_copy`) vào allowlist guardrail | 10 | Cải thiện | `test/quality/high_risk_state_primitives_guardrail_test.dart` |
| Bật strict analyzer + async lints (`strict-casts/inference/raw-types`, `unawaited_futures`, `discarded_futures`) | 7 | Cải thiện | `analysis_options.yaml` |
| Sửa INDEX.md khớp đĩa + `git add` doc required-reading + xoá bản doc trùng diverge | 9 | Cải thiện | `docs/INDEX.md`, `docs/01_AI_RULES/…` |
| Điền owner thật cho CODEOWNERS (hoặc xoá) + bật branch protection | 7 | Cải thiện | `.github/CODEOWNERS` |
| Dời `core/back_navigation.dart` khỏi phụ thuộc `flutter/widgets` | 1 | Tối ưu | `core/navigation/back_navigation.dart` |
| Cập nhật exception guardrail `trade` lỗi thời + re-baseline | 1 | Cải thiện | `architecture_baseline_guardrails_test.dart` |

**Kết quả GĐ0:** giảm 1 P0 (high-risk allowlist), khoá độ nghiêm analyzer, dọn tài liệu — nền cho các giai đoạn sau.

### Giai đoạn 1 — An toàn & enforcement (làm TRƯỚC khi tích hợp backend; P0/P1)
Mục tiêu: đóng nốt P0 còn lại và dựng các guardrail "mặc định bị gác".

| Việc | Chiều | Loại | Effort |
| --- | --- | --- | --- |
| Error boundary toàn cục (`runZonedGuarded` + `FlutterError.onError` + `PlatformDispatcher.onError` + `ErrorWidget.builder`) + seam observability no-op | 3 | Cải thiện | M |
| Đưa 9 feature bypass về `guardedRepository` + guardrail ép mọi `*_repository_provider.dart` gọi guard | 3 | Cải thiện | M |
| Unit test data/domain cho `earn` (APY/staking/cooling-off) — đóng P0 còn lại | 10 | Cải thiện | L |
| `autoDispose` cho family scoped + sửa leak màn đặt lệnh (key theo `pairId`, draft trong Notifier) + guardrail "request-keyed family phải autoDispose" | 2, 5 | Tối ưu | M |
| Guardrail import-graph phát hiện cycle (allowlist 2 cycle đã biết, ratchet giảm) | 1 | Cải thiện | M |
| Hợp nhất ~224 formatter `_format*` về VitFormat + guardrail cấm `_format*` mới không delegate | 8 | Tối ưu | L |
| Masking tập trung vào `core/utils/data_masking.dart` + unit test | 4 | Cải thiện | S |
| 4 vá a11y: touch target ≥44dp (2 file shared), `SC-ID` → `Semantics(identifier:)`, policy text-scaling + test @1.3, label song ngữ | 6 | Cải thiện | M |

### Giai đoạn 2 — Chuẩn hoá & chuẩn bị backend (Viết lại nặng; P1)
Mục tiêu: sửa các pattern sai hướng *trước* khi mock đổi thành API thật.

| Việc | Chiều | Loại | Effort |
| --- | --- | --- | --- |
| Định idiom lỗi async (AsyncNotifier + `AsyncValue.guard` hoặc Result type) + chuyển 1 flow tài chính (trade order submit) làm tham chiếu + lifecycle test high-risk đầu tiên | 2, 3, 10 | Viết lại | L |
| Gỡ 2 vòng phụ thuộc trade family (bỏ export sibling-entity khỏi `trade_core`; hợp nhất `trade_product_navigation`) | 1 | Viết lại | L |
| Chuyển collection mutable (watchlist, address book, alerts, checklist) từ `setState`-bản-sao sang Notifier | 2 | Viết lại | L |
| Flavors `dev/staging/prod` + `applicationIdSuffix` + env qua `--dart-define` vào `ApiClient` + release workflow chạy qua signing guard | 7 | Cải thiện | L |
| CI song song (static+audit \| guardrail \| full-suite shards \| APK) + gradle/actions cache + coverage + floor ~40% ratchet + dependabot + pin action SHA + secret-scan | 7 | Tối ưu | L |
| **Quyết định i18n** rồi thực thi: vi-VN-only (ghi AGENTS.md) HOẶC gen-l10n + delegates + ratchet cho code mới | 6 | Viết lại | L |
| Format số/tiền locale-aware qua VitFormat (`intl NumberFormat`) — sau khi có quyết định i18n | 6, 8 | Tối ưu | M |

### Giai đoạn 3 — Hoàn thiện & bền vững (P2/P3)
| Việc | Chiều | Loại |
| --- | --- | --- |
| Golden/visual-regression cho trade, wallet, p2p, earn | 10 | Cải thiện |
| Hệ ADR + CONTRIBUTING/LICENSE/SECURITY + lint dartdoc public API (`shared/`, `domain/`) | 9 | Cải thiện |
| Pagination/lazy list thay Column-in-Scroll ở các hub + RepaintBoundary painter + bật const lint + benchmark rebuild/scroll trong CI | 5 | Tối ưu |
| Dedup widget còn lại (7 `_SectionLabel`…) + shard hằng số route + chuẩn hoá 1 quy ước part-file | 1, 8 | Tối ưu |
| Guardrail Arena song ngữ + route param sai → error state + interceptor/TLS-pinning scaffolding | 4 | Cải thiện |
| Dời 2 file test lạc chỗ dưới `test/features/trade_core/` về đúng module | 10 | Tối ưu |

---

## 12. Phân loại theo yêu cầu "Cải thiện / Tối ưu / Viết lại"

- **Cần VIẾT LẠI (pattern sai hướng cho enterprise thật):** idiom lỗi async cho toàn data plane; 2 vòng phụ thuộc trade family; mutation `setState`-trên-bản-sao → Notifier; đường đi i18n (nếu chọn gen-l10n). → Đây là phần *nặng nhất*, nằm ở Giai đoạn 2, phải làm trước backend.
- **Cần TỐI ƯU (đúng nhưng chưa hiệu quả/gọn):** `autoDispose` + leak màn đặt lệnh; hợp nhất 310 formatter; CI song song + cache; pagination/RepaintBoundary/const; shard route constants; dedup widget.
- **Cần CẢI THIỆN (bổ sung cái đang thiếu):** guardrail high-risk (3 contract) & import-graph & money-copy & autoDispose; error boundary; guard coverage 9 feature; test earn + lifecycle high-risk + golden; strict analyzer; dependabot/secret-scan/CODEOWNERS; masking test; 4 vá a11y; ADR/CONTRIBUTING; dọn tài liệu.

**Đọc nhanh:** phần lớn khối lượng là **Cải thiện** (thêm chốt chặn) và **Tối ưu** (làm gọn) — chỉ 4 nhóm thật sự **Viết lại**, và cả 4 đều xoay quanh một sự thật: *code hiện tại được thiết kế cho mock đồng bộ, cần tái cấu trúc cho async thật*.

---

## 13. Quyết định cần chốt trong buổi họp

1. **i18n — quyết định sản phẩm, không phải kỹ thuật (ảnh hưởng lớn nhất tới điểm A+):** cam kết **vi-VN-only** (ghi vào AGENTS.md, chấp nhận điểm chiều 6 trần ở mức "có chủ đích") hay **đầu tư gen-l10n** (nâng được lên A nhưng là dự án L). Mọi việc format locale-aware phụ thuộc quyết định này.
2. **Thời điểm backend:** các mục "Viết lại" ở Giai đoạn 2 (idiom async, gỡ cycle, Notifier mutation) nên **xong trước** khi API thật về. Cần chốt mốc backend để khoá lịch Giai đoạn 2.
3. **Ngưỡng coverage khởi điểm:** đề xuất floor 40% + ratchet tăng dần (repo chưa có tooling coverage nào).
4. **iOS có trong scope release không:** hiện CI chỉ build debug APK Android, không có job iOS — ảnh hưởng phạm vi Giai đoạn 2.
5. **Chủ sở hữu thật cho CODEOWNERS:** ai gác `app_router.dart`, `trade_core`, `earn/data`, `p2p/data` (các file blast-radius cao).

---

## 14. Phân công gợi ý (RACI-lite theo vùng blast-radius)

| Vùng | Việc trọng tâm | Kỹ năng cần |
| --- | --- | --- |
| **Platform/Core** | Error boundary, guard coverage, idiom async, CI/flavors, analyzer | Riverpod nâng cao, CI/CD, Gradle |
| **Trade family** | Gỡ 2 cycle, lifecycle test high-risk trade, leak màn đặt lệnh | Hiểu sâu trade module + go_router |
| **Earn/P2P/Wallet** | Test data/domain earn, hợp nhất formatter, masking | Domain tài chính, test |
| **Design System/Shared** | 4 vá a11y, dedup widget, golden, guardrail money-copy | Flutter UI, `Vit*` primitives |
| **Docs/QA** | ADR, INDEX, CONTRIBUTING, dartdoc lint, coverage ratchet | Kỹ thuật viết + governance |

---

## 15. Cách kiểm chứng (bộ gate chính thức của repo — chạy từ `flutter_app/`)

Mỗi giai đoạn phải qua trọn bộ gate trước khi merge:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart \
  test/quality/trade_product_copy_guardrails_test.dart \
  test/quality/prediction_product_copy_guardrails_test.dart \
  test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact
flutter test --reporter=compact
```

Mỗi guardrail **mới** (import-graph cycle, autoDispose, money-copy, high-risk mở rộng) phải được thêm vào CI (`.github/workflows/flutter-ci.yml`) để "mặc định bị gác" — đây là cơ chế giữ cho dự án không tụt hạng sau khi lên A+.

> **Trạng thái gate lúc lập báo cáo:** bộ gate không chạy fresh trong phiên (đang ở chế độ plan, chặn thực thi). Bằng chứng gần nhất — phiên remediation sáng cùng ngày: `flutter analyze` sạch, architecture guardrails 10/10, full suite **2817/2817 pass**. Working tree hiện có 104 file chưa commit đúng vùng nhạy cảm → **chạy lại trọn bộ gate trước commit kế tiếp.**

---

## 16. Giới hạn của báo cáo

- Đây là audit **tĩnh (structural)**: "có test/guardrail" ≠ "đủ sâu"; repo không có tooling đo coverage dòng/nhánh nên không nêu con số %.
- Chiều Hiệu năng đánh giá theo **pattern** (app đang mock, không có tải thật) — chưa profile runtime.
- Branch protection & secret-scanning phía GitHub không kiểm chứng được từ local.
- Ước lượng effort (S/M/L) là tương đối để lập kế hoạch, cần đội tinh chỉnh theo năng lực thực tế.
- Mọi khuyến nghị đã đọc lại code thật tới cấp file, nhưng working tree thay đổi nhanh — verify file/pattern còn tồn tại trước khi thực thi.
