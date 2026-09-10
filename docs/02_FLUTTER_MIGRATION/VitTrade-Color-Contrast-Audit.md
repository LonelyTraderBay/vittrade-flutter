# VitTrade — Kiểm tương phản màu (WCAG 2.1)

**Last Updated:** 2026-07-18 (A11Y-5)

Bảng tỉ lệ tương phản của các cặp foreground/background chính, tính theo công
thức WCAG 2.1 (relative luminance) từ token trong
`flutter_app/lib/app/theme/app_colors.dart`. Enforce bởi
`flutter_app/test/quality/color_contrast_guardrail_test.dart`.

App là một-theme (dark) — chỉ kiểm nền tối hiện có. Ngưỡng: **4.5:1** body
text thường; **3:1** text lớn/đậm + thành phần UI (icon/viền).

## Text trên nền tối

| Foreground | bg `#07090D` | surface `#10141B` | surface2 `#171C24` | surface3 `#222936` |
|---|---|---|---|---|
| text1 `#F5F7FA` | 18.57 | 17.20 | 15.93 | 13.60 |
| text2 `#A7AFBF` | 9.04 | 8.37 | 7.76 | 6.62 |
| text3 `#667085` | 4.01 | 3.71 | 3.44 | **2.93** ⚠️ |
| textDisabled `#566175` | 3.19 | 2.95 | 2.74 | 2.34 (miễn trừ) |

- **text1, text2**: đạt AA (≥ 4.5:1) trên MỌI nền — dùng thoải mái cho body.
- **text3**: màu chú thích/hint, ngưỡng 3:1 cho label nhỏ phụ trợ. Đạt trên
  bg/surface/surface2; **hụt sát trên surface3 (2.93)** — ngoại lệ có ghi chép:
  text3 không đặt trực tiếp trên surface3 (surface3 là nền chip/badge dùng
  text1/text2). Có trong allowlist của guardrail.
- **textDisabled**: WCAG 1.4.3 **miễn trừ** thành phần disabled/inactive — không
  kiểm.

## Màu ngữ nghĩa trên nền chính (bg)

| Màu | Tỉ lệ trên bg | Ghi chú |
|---|---|---|
| primary `#E58A00` | 7.56 | CTA/nhấn — đạt |
| primarySoft/warn `#F5A524` | 9.76 | cảnh báo — đạt |
| buy `#10B981` | 7.86 | tăng giá — đạt |
| sell `#EF4444` | 5.29 | giảm giá — đạt |
| accent `#8B5CF6` | 4.71 | nhấn phụ — đạt (≥ 3:1 UI) |

## Nguyên tắc

- Đây là **cảnh báo hồi quy**, không phải giấy phép đổi màu. Đổi token màu là
  việc design riêng; nếu một cặp mới tụt dưới ngưỡng, hoặc sửa màu, hoặc thêm
  vào allowlist của guardrail kèm lý do + cập nhật bảng này.
- Không có light theme — đã chốt dark-only tại ADR-014; bảng này chỉ cần
  cột nền tối trừ khi một ADR mới thay thế quyết định đó.
