# Kế hoạch vệ sinh vùng xám tablet (nhóm C) — chốt 2026-09-16

Trạng thái: **HOÀN THÀNH 100%** (2026-09-16). Kết quả từng giai đoạn:

| Giai đoạn | Kết quả | Commit |
| --- | --- | --- |
| GĐ1 Batch 1 (C3) | 2 part order receipt tablet dời về cùng thư mục lib cha + tiền tố tên lib; regen 7 artifact + baseline icon | `560e3346` |
| GĐ1 Batch 2 (C4) | 5 part file đuôi "2" đổi tên vai trò (core/institutional/custody/governance/social); baseline C3 dot-name + nav edges | `eddfadac` |
| GĐ2 (C1) | Đo lại import-graph: 0 widget cần dời (33 đã ở widgets/tablet, 22 trung tính đều dual-surface) — không thi công | `0de5484a` |
| GĐ3 (C2) | Section Module Composition Pattern trong Surface-Architecture-Standard + AGENTS + bàn giao phone (pair order_receipt phone) | `d414e3f7` |
| GĐ4 | `tool/tablet_neutral_widget_audit.dart` (N-tablet-only/N-tablet-part, giải import transitive) + CI step + baseline 0 | `c1beffac` |

Phạm vi: tablet-only. Mọi nợ phone chỉ ghi vào bảng bàn giao, không sửa.

## Đầu vào đo được (2026-09-16)

- **C1**: 55 đường widget bị tablet page import = **33 file đã nằm đúng `presentation/widgets/tablet/`** + 22 file trung tính, trong đó **toàn bộ 22 đều dual-surface** (19 phone import trực tiếp + 3 chuỗi wallet `widgets/address/` phone dùng transitively qua `wallet_address_add_sections.dart` ← `address_add_page.dart:13`). **Tập cần dời = 0 file.** (Số "26 cần dời" ban đầu là lỗi đo: regex bắt cả path `/tablet/` + đếm basename không thấy usage transitive; bẫy grep-wrapper pattern bắt đầu `/` cũng che mất bước lọc.) 0/55 widget đọc `AppSpacing` trực tiếp ⇒ không migrate token.
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

## GĐ2 — Dời widget tablet-only: KHÔNG CẦN THI CÔNG (đo lại = 0 vi phạm)

Đo lại bằng import-graph trước khi di chuyển cho ra: mọi widget tablet-only đã ở
đúng `presentation/widgets/tablet/`; đường trung tính `presentation/widgets/**`
chứa đúng widget dual-surface (trực tiếp hoặc transitively). Không batch 3–7.
Quy ước thực tế này được ghi thành chuẩn ở GĐ3 và khóa bằng audit ở GĐ4
(audit phải giải import transitive — bài học từ chuỗi wallet address).

## GĐ3 — Chuẩn module pattern (doc-only)

- Chốt phương án A: **full-stack module mặc định** (domain+data+presentation+tablet pages trong feature dir; composition-module chị chỉ cho product family chia dir hoặc màn ghép đa module thật). P2P = ngoại lệ được ghi nhận, KHÔNG refactor ngược.
- Thêm section "Module Composition Pattern" vào `Flutter-Module-Identity-Standard.md` + sync: Enforcement của chính chuẩn, cross-ref Surface-Architecture-Standard/Device-UI-Organization-Standard nếu liên quan, AGENTS nếu cần.
- Cập nhật bảng bàn giao phone: thêm pair `order_receipt_page_{common,sections}.dart` ở `widgets/phone/`.

## GĐ4 — Khóa C1 bằng audit tool

- `tool/tablet_neutral_widget_audit.dart` theo khuôn `tablet_sheet_audit.dart`: quét widget trung tính có tablet-importer mà không có phone-importer ⇒ baseline = 0; thêm CI step trong `.github/workflows/flutter-ci.yml` (preflight tự đọc CI nên tự đồng bộ).

## Nghiệm thu cuối

- `dart run tool/preflight_check.dart` đủ (P1–P3 xanh; P4 golden font Windows là fail có sẵn).
- Cập nhật memory census + scope policy bàn giao.
