# Kế hoạch vệ sinh vùng xám tablet (nhóm C) — chốt 2026-09-16

Trạng thái: **ĐÃ DUYỆT** — chạy theo thứ tự ưu tiên GĐ1 → GĐ4 đến hoàn thiện 100%.
Phạm vi: tablet-only. Mọi nợ phone chỉ ghi vào bảng bàn giao, không sửa.

## Đầu vào đo được (2026-09-16)

- **C1**: 55 widget trung tính bị tablet import = 29 dual-surface (hợp lệ, giữ) + **26 tablet-only cần dời** về `presentation/widgets/tablet/` (profile 8, trade 3 + 6 panel terminal, wallet 4, markets 3, home 2). 0/55 widget đọc `AppSpacing` trực tiếp ⇒ không migrate token.
- **C2**: 2 pattern module song song (P2P: phone-UI thuần + domain dồn p2p_core ↔ 27 module full-stack). Chưa chuẩn chốt pattern feature mới.
- **C3**: 2 part tablet của `trade_tablet_order_receipt_page.dart` đặt ở `widgets/tablet/` qua `part '../../…'`. Phone pair cùng tên cũng lệch chuẩn (bàn giao, không sửa).
- **C4**: 5 part file đuôi "2" (staking ×4, predictions ×1). Test không tham chiếu tên file nào trong 5 file.

## Gate chung mọi batch

1. Trace importer full-path (tránh basename false-positive chéo feature) trước khi move/rename.
2. Sau batch: `flutter analyze` + focused test module + `dart run tool/tablet_composition_tier_audit.dart --check`.
3. Giữa chừng `dart run tool/preflight_check.dart --fast`; nghiệm thu giai đoạn chạy đủ.
4. Regem artifact/baseline đúng thứ tự khi preflight báo stale.
5. Commit riêng từng batch, message tiếng Việt, không tự push.

## GĐ1 — Quick wins

- **Batch 1 (C3)**: `git mv` 2 file `order_receipt_page_{common,sections}.dart` từ `trade/presentation/widgets/tablet/` → `trade/presentation/tablet/pages/trade_tablet_order_receipt_page_{common,sections}.dart`; sửa 2 dòng part trong lib cha thành đường dẫn cùng thư mục. Phone pair: chỉ ghi bàn giao.
- **Batch 2 (C4)**: đổi tên theo vai trò (ARCH-A4):
  - `staking_tablet_pages_core2` → `staking_tablet_pages_core`
  - `staking_tablet_pages_operators2` → `staking_tablet_pages_institutional`
  - `staking_tablet_pages_reports2` → `staking_tablet_pages_custody`
  - `staking_tablet_pages_community2` → `staking_tablet_pages_governance`
  - `predictions_tablet_pages_explore2` → `predictions_tablet_pages_social`
  - Sửa part directive trong 2 thư viện cha. Re-verify tên mới chưa tồn tại trước khi mv.

## GĐ2 — Dời 26 widget tablet-only về `presentation/widgets/tablet/`

Chỉ dời + sửa import, không sửa nội dung widget. Đích là quy ước đa số `widgets/tablet/` (wallet dùng `presentation/tablet/widgets/` — ghi nhận lệch, ngoài scope).

| Batch | Feature | File (26) | Lưu ý |
| --- | --- | --- | --- |
| 3 | profile | account_hero, discovery_panel, pane_navigation, **pane_scaffold**, product_hub_panel, security_summary, status_content, tablet_keys | pane_scaffold là scaffold registry T1/T2 — chạy tier audit sau move |
| 4 | trade | trade_status_content, trade_tablet_detail_surface, trade_tablet_keys (13 importer) + trade_terminal_{book,bottom,chart,meta,panel,tape}_panel | trace đầy đủ importer |
| 5 | wallet | wallet_address_add_{common,form,preview}, wallet_tablet_keys | — |
| 6 | markets | markets_pulse_strip, markets_status_content, markets_tablet_keys | chạy golden suite markets |
| 7 | home | home_more_products_sheet_tablet, home_tablet_reference_home | rà chuẩn Home-Tablet-Reference-Contract trước khi move (có thể reference path) |

Chấp nhận GĐ2: `presentation/widgets/` (ngoài `/tablet/`) không còn file nào chỉ tablet dùng; 29 file dual-surface còn lại = "trung tính thật".

## GĐ3 — Chuẩn module pattern (doc-only)

- Chốt phương án A: **full-stack module mặc định** (domain+data+presentation+tablet pages trong feature dir; composition-module chị chỉ cho product family chia dir hoặc màn ghép đa module thật). P2P = ngoại lệ được ghi nhận, KHÔNG refactor ngược.
- Thêm section "Module Composition Pattern" vào `Flutter-Module-Identity-Standard.md` + sync: Enforcement của chính chuẩn, cross-ref Surface-Architecture-Standard/Device-UI-Organization-Standard nếu liên quan, AGENTS nếu cần.
- Cập nhật bảng bàn giao phone: thêm pair `order_receipt_page_{common,sections}.dart` ở `widgets/phone/`.

## GĐ4 — Khóa C1 bằng audit tool

- `tool/tablet_neutral_widget_audit.dart` theo khuôn `tablet_sheet_audit.dart`: quét widget trung tính có tablet-importer mà không có phone-importer ⇒ baseline = 0; thêm CI step trong `.github/workflows/flutter-ci.yml` (preflight tự đọc CI nên tự đồng bộ).

## Nghiệm thu cuối

- `dart run tool/preflight_check.dart` đủ (P1–P3 xanh; P4 golden font Windows là fail có sẵn).
- Cập nhật memory census + scope policy bàn giao.
