# Tablet-Composition-Tier Standard (mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md) · `AGENTS.md` UI Rules
**Scope:** tablet surface — every Dart library under
`lib/features/**/presentation/tablet/pages/` (main file + its `part` files,
tính như MỘT library).
**Enforcement:** `tool/tablet_composition_tier_audit.dart` — step `Tablet composition tier artifact is current` trong `.github/workflows/flutter-ci.yml`; preflight tự nhận step này vì đọc trực tiếp CI.

Chốt 2026-09-13 (Đợt 0 — kế hoạch nâng cấp UI tablet enterprise,
`ke-hoach-nang-cap-ui-tablet-enterprise.md`). Bài học nền: đợt port 100%
route 2026-09-06 đóng route nhưng composition tier chỉ được dọn một phần
(Đợt 0-1 dọn khuôn `_xxFrame`) — guardrail literal cũ đều xanh trong khi
role scaffold chưa ai khóa. Chuẩn này khóa **role của khung trang tablet**.

## T1 — Registry scaffold (ratchet)

Mỗi page library tablet phải dựng khung từ **registry scaffold chuẩn** dưới
đây (match bằng substring lệnh dựng `XxxScaffold(`/`XxxSurface(`… ở bất kỳ
đâu trong library, kể cả part file):

| Scaffold / surface | Dùng cho |
| --- | --- |
| `VitTwoColumnTabletDashboard` | Monitor dashboard (Home/Wallet/Profile + hubs 2 cột) |
| `VitTabletSectionFrame` / `VitTabletSectionBody` | Trang section chuẩn của tablet (khung section + header) |
| `VitPageLayout` | Trang tablet một cột chuẩn (full-page scaffold wrapper) |
| `VitPageContent` | Trang content rhythm chuẩn (tab root trong master shell) |
| `VitTradeDetailScaffold` | Chi tiết cụm trade |
| `WalletTabletDetailSurface` | Money-movement detail (deposit/withdraw/transfer…) |
| `TradeTabletDetailSurface` | Detail dòng trade (futures/leverage/convert/export…) |
| `AuthTabletSurface` | Cụm auth tablet |
| `*TabletMasterShell` | Shell master–detail cấp feature (Profile/Markets…, match substring `TabletMasterShell(`) |
| `*PaneScaffold` | Pane trong shell master–detail (match substring `PaneScaffold(`) |

- Nợ hiện có pin trong `test/quality/tablet_composition_tier_baseline.txt`
  (2 file `*_tablet_utility_page.dart` dead-code, chờ xóa Đợt 9).
- Baseline là **ratchet đẳng thức**: file được sửa hết nợ thì phải xóa dòng
  baseline; file mới thiếu scaffold fail ngay. Chỉ regen baseline bằng
  `dart run tool/tablet_composition_tier_audit.dart --regen-baseline` khi
  trả nợ hoặc khi một scaffold mới được thêm vào registry.
- Thêm scaffold mới vào registry = sửa `_registryScaffolds` trong tool +
  bảng này + [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md).

## T2 — Banned pattern (tuyệt đối, không baseline)

Trong mọi file `presentation/tablet/pages/`:

1. **`VitAutoHidePageScaffold(`** — anti-pattern R9 (Tablet-Adaptive): header
   hai cột không có scroll offset duy nhất để auto-hide.
2. **`class …Frame extends`** — khuôn trang tự chế (nợ tablet-gd56 đã dọn hết
   2026-09-10, khóa về 0 vĩnh viễn). Khuôn hợp lệ chỉ tồn tại ở tầng shared
   (`lib/shared/layout/`).

Lưu ý ranh giới với guardrail C1 (`tablet_composition_guardrail_test.dart`):
C1 cấm literal `maxWidth: 1xxx` (reading width); cap bề rộng **cấp widget**
(ví dụ bong bóng chat `VitCard(constraints: BoxConstraints(maxWidth: 640))`)
là hợp lệ — cap bề rộng cấp khung/cột thì đi qua `TabletDashboardWidths`.

## Verify

```bash
cd flutter_app
dart run tool/tablet_composition_tier_audit.dart --check
```
