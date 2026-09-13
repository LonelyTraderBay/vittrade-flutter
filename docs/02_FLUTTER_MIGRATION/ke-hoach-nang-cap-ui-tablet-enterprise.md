# Kế hoạch nâng cấp UI Tablet — Production-Ready Enterprise Composition

Updated: 2026-09-13 (Đợt 0 hoàn tất — khóa nền bằng guardrail tier)

Phạm vi: nâng **chất lượng composition** của toàn bộ UI tablet lên đúng
7 archetype chuẩn đã chốt trong
[Tablet-Adaptive-Standard.md](./standards/Tablet-Adaptive-Standard.md) —
tablet là UI hoàn toàn khác phone (không phải phone thu nhỏ), mỗi màn chọn
grammar theo *nghề* của màn. Route KHÔNG đụng: 361 route tablet đã render
page thật, 0 utility (gate GĐ7 2026-09-06).

Quyết định đã chốt với user 2026-09-13:

1. Màn linear detail (receipt/otp/transaction_detail…) **giữ một cột** theo
   đúng chuẩn "skip dedicated layout" — không bốc 2 cột cho bằng hết.
2. Thứ tự ưu tiên cluster: **Wallet → Trade → P2P → Earn → còn lại**.
3. Redesign từng nhóm archetype chốt bằng **mockup ASCII trước/sau** trước
   khi code (gate redesign).

## Hiện trạng đo được 2026-09-13

| Hạng mục | Giá trị |
| --- | --- |
| Route tablet thật | 361 (9 alias redirect), 0 utility placeholder |
| Page library / part file / class widget | 94 / 46 / 580 |
| File phone vs tablet | 485 vs 140 — tablet mỏng ~29%, gap chính |
| Khuôn `_xxFrame` / `VitAutoHidePageScaffold` | 0 / 0 (Đợt 0-1 đã dọn, giờ khóa T2) |
| Library thiếu registry scaffold | 2 (2 file `*_tablet_utility_page.dart` dead-code, baseline T1) |
| Test riêng cho tablet page | 21/94 library — gap production-readiness lớn nhất |
| Flagship tablet thuần | 5 root tabs (Trade terminal, Markets analysis, Home/Wallet/Profile dashboard) + Arena redesign |

## Ba vấn đề cốt lõi

1. **Composition mỏng, chưa phân vai**: 68/94 library 1–3 class, một cột
   mang token tablet — màn dạng bảng dữ liệu (orders/positions/operators)
   và hub nhiều nhóm (staking/compliance/p2p) đáng lẽ master-detail hoặc
   dashboard. Nguyên nhân: đợt port 100% route ưu tiên đóng route trước.
2. **Test parity thiếu**: New-Screen-DoD §4 + bước 7 Tablet-Adaptive đòi
   widget test pump ≥ ngưỡng hai cột + overflow guard + 1 nhánh tương tác
   cho từng page — mới 21/94.
3. **Chưa khóa composition tier**: bài học tablet-gd56 — guardrail literal
   không khóa role. Đã khóa 2026-09-13 bằng
   [Tablet-Composition-Tier-Standard.md](./standards/Tablet-Composition-Tier-Standard.md)
   + `tool/tablet_composition_tier_audit.dart` (T1 ratchet + T2 tuyệt đối).

## Bản đồ chuyển đổi 94 library → archetype đích

| Archetype đích | Library chuyển | SL |
| --- | --- | --- |
| Monitor dashboard (`VitTwoColumnTabletDashboard`) | wallet hub, p2p_home, p2p_dashboard, dca overview, news hub, rewards | ~6 |
| Trading terminal / terminal-adjacent | trade_tablet (giữ), futures, margin_hub, margin_trading, advanced_chart, advanced_analytics, market_data_analytics, live_market_data_analytics, execution_quality | ~9 |
| Settings master-detail | compliance×3, trade_settings, p2p_settings, p2p_account, p2p_security, p2p_compliance, admin console, dev console, trade_bots | ~12 |
| Analysis master-detail (bảng dữ liệu `Data-Table-Standard`) | staking hub, savings hub, orders_history, position_dashboard, risk_management, predictions explore, launchpad, p2p_my_orders, p2p_order_book, p2p_merchant, p2p_my_ads, p2p_ad_analytics, copy×5, address_book, transaction_history, pending_deposits | ~22 |
| Money-movement detail (`WalletTabletDetailSurface`) | deposit, withdraw, withdraw_limits, transfer, buy_crypto, dust_converter, token_approval, gas_optimizer, health_score, multi_manager, address_add, asset_detail | ~12 |
| Wizard/form (sticky footer CTA) | p2p_create_ad, two_fa_setup, dca plan create, p2p kyc | ~4 |
| Linear detail — giữ một cột, chỉ polish | receipt, transaction_detail, otp, reset/forgot, news detail, misc_gate, màn read-only đơn | ~29 |

Re-compose sâu ~65 library; polish nhẹ ~29; giữ nguyên flagship 5 root tabs
+ Arena. Nhóm màn của 16 feature không có thư mục tablet pages nằm ở
`cross_module` (admin/dev/notifications/discovery/referral/onboarding…) và
`p2p_core` (6 feature con p2p_*) — chuyển theo cluster tương ứng.

## Các đợt triển khai

| Đợt | Phạm vi | Trạng thái |
| --- | --- | --- |
| 0 — Blueprint & khóa nền | Tier standard + audit tool + CI step; xác định maxWidth p2p_chat là cap bong bóng chat hợp lệ (C1 chỉ khóa 1xxx) | ✅ 2026-09-13 (789cf7d1) |
| 1 — Shared bổ khuyết archetype | `WalletTabletDetailSurface` thêm slot `footer` ghim CTA flow (idiom `MarketsPaneScaffold.footer`) + test riêng surface | ✅ 2026-09-14 (e95b9fff) |
| 2 — Wallet cluster | Đ2a: ghim footer CTA rút/chuyển/dust/address_add (mua crypto giữ inline — CTA nằm trong `BuyInputContent` dùng chung phone, R2; deposit/asset_detail/withdraw_limits không có CTA flow; token_approval + 3 trang tools giữ CTA inline vì là hành động rà soát theo tab). Đ2b: Lịch sử giao dịch SC-136/141 lên shell master-detail route-based (`WalletTabletHistoryShell` + `StatefulShellRoute` 1 branch, selection route-derived, hub pane = empty state rule 6). Đ2c: portfolio_analytics + network_status đã dày sẵn, hub là dashboard reference — giữ nguyên | ✅ 2026-09-14 (e95b9fff → ba0e67c2) |
| 3 — Trade cluster | **Audit delta 2026-09-14: cluster đã ở tầng đích sẵn** — 12/21 library dùng `VitTwoColumnTabletDashboard` (analytics ×4, orders_history có bảng `_OrdersTable` tabular figures, position_dashboard, risk_management, margin_hub, trade_settings, tools, demos), advanced_chart SC-055 là terminal thuần full-height (OHLCV strip + MUA/BÁN ghim), receipt dùng `VitTradeDetailScaffold`. Delta thật: `TradeTabletDetailSurface` thêm slot `footer` (mirror wallet) + ghim CTA hoàn tất 4 luồng convert/futures/leverage/export; live_market_data_analytics dùng SectionBody chuẩn — giữ nguyên; utility dead-code chờ Đợt 9 | ✅ 2026-09-14 |
| 4 — P2P cluster | **Audit delta 2026-09-14: cluster đã ở tầng đích sẵn** — 8 dashboard 2 cột (home hub có banner stats + express 550 dòng + merchant/insurance/wallet/security/ad_analytics/create_ad), 7 SectionFrame family (account/compliance/dispute/kyc/payment/settings/order), 6 SectionBody một cột (my_orders/my_ads/order_book/ad_detail/express_confirm/chat — list chức năng có navigation + empty state); CTA express đặt cạnh offer live trong cột phụ (chủ đích, không ghim); kyc wizard CTA theo bước. Delta thật: ghim CTA "Xem trước & đăng" create_ad bằng bọc Column + dải ghim (idiom advanced_chart). Chat giữ cap bong bóng 640 (hợp lệ). Không xây shell master-detail mới cho cặp my_ads→ad_detail (cần mockup gate riêng nếu muốn) | ✅ 2026-09-14 |
| 5 — Earn cluster | staking (8 part), savings, dca, launchpad | ⬜ |
| 6 — Bots + Copy + Compliance | 13 library | ⬜ |
| 7 — Predictions + Arena hub còn lại | phần "nhiều màn gộp" cuối | ⬜ |
| 8 — Admin/Dev console + Auth/News/Rewards/Profile-pane | cross_module 29 class + cụm nhỏ | ⬜ |
| 9 — Chốt & khóa | Xóa 3 file `*_tablet_utility_page.dart` dead-code; strict tier; smoke matrix 6 size + rotation; preflight full; đồng bộ AGENTS/DoD/UI-Rule-Layer-Map | ⬜ |

## Quy trình bắt buộc trong mỗi batch

Bám [New-Screen-Definition-of-Done.md](./standards/New-Screen-Definition-of-Done.md)
§1–§6: mockup ASCII chốt trước khi code → re-compose → widget test pump ≥
900px + overflow guard + 1 nhánh tương tác + nhánh error khuôn override →
6 tablet lock audit + page_rhythm `--strict-full` + card_tile +
content_width + i18n baseline + composition tier `--check` → regen artifact
audit đúng thứ tự → `dart run tool/preflight_check.dart` PASS → commit
(tiếng Việt, user push).

## Tiêu chí Done cho từng màn

- [ ] Archetype đúng job, scaffold từ registry (T1), 0 pattern T2
- [ ] Threshold hai cột đo thực; QA matrix 768/800/834×1024/1112 + rotation xanh
- [ ] Skeleton mirror dashboard, pull-to-refresh mọi cột, `VitEmptyState`/`VitErrorState`
- [ ] Mask dữ liệu nhạy cảm; copy vi-VN có dấu; financial safety cho dòng tiền
- [ ] Test riêng page + coverage không tụt dưới 92% (ratchet chỉ-tăng)
- [ ] Emulator smoke theo vision-verification workflow
