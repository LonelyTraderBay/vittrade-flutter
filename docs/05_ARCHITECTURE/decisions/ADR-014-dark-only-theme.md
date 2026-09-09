# ADR-014 — Chính sách theme dark-only: không dựng nhánh light

- **Trạng thái:** Đã chốt (DEC-theme · toolchain align + foundation freeze, 2026-09-10)
- **Phạm vi:** Toàn bộ token màu/`ThemeData` ở `app/theme/` và mọi màn hình
  Phone/Tablet/Web của app.
- **Implementation tham chiếu:** `lib/app/theme/app_colors.dart`,
  `lib/app/theme/app_theme.dart` (không tồn tại `ThemeMode`/`ThemeData.light`
  nào trong `lib/` — hiện trạng chính là trạng thái mong muốn).

## Bối cảnh

Sản phẩm VitTrade là app giao dịch crypto doanh nghiệp, identity "VitTrade
Dark Enterprise" (DESIGN.md): nền ink sâu, primary amber ấm, buy/sell
xanh/đỏ chuẩn tài chính, surface phân tầng cho card/terminal. Toàn bộ hệ
token màu (21 file ở `app/theme/`) được đặc định cho nền dark, và các
guardrail contrast/WCAG floor (`contrast_floor_guardrail_test`,
`color_contrast_guardrail_test`, `tap_target_min_size_guardrail_test`…)
đều chốt ngưỡng trên nền dark.

Lúc nền tảng được đóng băng trước khi UI phình to (2026-09-10), câu hỏi
"có cần light theme không" phải có câu trả lời dứt khoát, vì chi phí của
hai vế chênh nhau bậc:

- Chốt **dark-only**: không phát sinh việc gì thêm; mọi màn hình tương lai
  chỉ verify 1 mode.
- Dựng **light**: phải tái cấu trúc `app_colors.dart` thành cặp màu theo
  role, thêm `ThemeMode` + chỗ bật/tắt, rà guardrail contrast chạy 2 mode,
  và mọi màn hình thêm sau đó tốn gấp đôi lần verify/QA.

Tham chiếu ngành: các trading app lớn (Binance, Bybit, OKX) mặc định dark;
light mode ở các sản phẩm này là tính năng phụ, không phải baseline.

## Quyết định

1. App **chỉ có đúng một theme dark**. Không dựng `ThemeMode`, không dựng
   nhánh `ThemeData.light`, không dựng cơ chế bật/tắt theme trong UI
   (settings/profile không có mục đổi theme).
2. Token màu tiếp tục là hằng số đặc định dark ở `app/theme/` — không
   chuyển sang scheme song song "phòng khi cần".
3. Guardrail contrast/WCAG hiện hành tiếp tục là hợp đồng duy nhất, đo
   trên nền dark; không mở baseline thứ hai cho light.
4. Việc thêm màn hình mới KHÔNG được tạo dependency vào giả thiết có
   thể đổi brightness (vd không đọc `Theme.of(context).brightness` để
   nhánh màu — dùng token `AppColors`/`AppModuleAccents` như mọi trang
   hiện có).

## Hệ quả / nợ còn lại

- Chấp nhận: nếu một ngày sản phẩm yêu cầu light mode, đó là một dự án
  token-refactor riêng (ước 3–5 batch chạm `app_colors` + guardrail +
  QA 2 mode), KHÔNG phải một cờ bật. Điều kiện tái kích hoạt: yêu cầu
  sản phẩm thật (nghiên cứu người dùng/đối tác) ghi nhận trong ADR mới
  thay thế ADR-014 — theo quy ước ADR chỉ thêm, không sửa.
- Không cần guardrail mới: hiện trạng "không tồn tại `ThemeMode`" là
  mặc định an toàn; guardrail chỉ có giá trị khi tồn tại áp lực ngược
  (hiện không có). Quyết định này được enforce bằng chính sách review +
  dẫn chiếu từ DESIGN.md.
- DESIGN.md giữ câu "dark theme only for new work" và trỏ về ADR này
  làm nguồn quyền quyết định.
