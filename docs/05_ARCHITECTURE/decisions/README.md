# Architecture Decision Records (ADR)

Nhật ký quyết định kiến trúc của VitTrade Flutter — mỗi ADR ghi lại **một**
quyết định có tác động dài hạn, theo định dạng [MADR](https://adr.github.io/madr/)
tối giản (Trạng thái · Bối cảnh · Quyết định · Hệ quả). Viết bằng tiếng Việt
theo chính sách ngôn ngữ vi-VN-only (xem ADR-005).

## Khi nào viết ADR

Viết một ADR mới khi quyết định thỏa TẤT CẢ:

- Ảnh hưởng cấu trúc/ranh giới/idiom toàn app (không phải một màn hình lẻ).
- Khó đảo ngược, hoặc đảo ngược tốn kém (đổi thư viện, đổi tầng, đổi quy ước
  áp lên hàng trăm call site).
- Người sau cần biết **lý do** để không vô tình phá.

Không viết ADR cho: tinh chỉnh UI một trang, đổi copy, sửa lỗi cục bộ.

## Quy ước

- Đánh số tuần tự bốn chữ số: `ADR-000N-mo-ta-ngan.md` (kebab-case).
- Copy `0000-template.md` để bắt đầu.
- ADR chỉ **thêm mới** hoặc đổi `Trạng thái` (Đề xuất → Đã chốt → Thay thế bởi
  ADR-XXX). KHÔNG sửa lại nội dung một ADR đã chốt — quyết định mới = ADR mới
  trỏ ngược ADR cũ.
- Quyết định gắn với gate/decision (DEC-*) của lộ trình A-Plus ghi rõ mã DEC
  trong phần Bối cảnh.

## Danh mục

| ADR | Quyết định | Trạng thái |
|---|---|---|
| [ADR-001](ADR-001-async-error-idiom.md) | Idiom lỗi async cho đường ghi tài chính | Đã chốt |
| [ADR-002](ADR-002-trade-family-split.md) | Tách module Trade thành 5 feature sibling | Đã chốt |
| [ADR-003](ADR-003-design-system-vit.md) | Design system VitTrade + audit/guardrail | Đã chốt |
| [ADR-004](ADR-004-canonical-paths.md) | Đường dẫn canonical (Flutter-only) | Đã chốt |
| [ADR-005](ADR-005-i18n-vi-vn-only.md) | Chính sách ngôn ngữ vi-VN-only | Đã chốt |
| [ADR-006](ADR-006-composition-root-coupling.md) | Composition root tập trung — chấp nhận coupling app↔features | Đã chốt |
| [ADR-007](ADR-007-chien-luoc-hieu-nang.md) | Chiến lược hiệu năng: bounded-build + repaint isolation | Đã chốt |
| [ADR-008](ADR-008-tang-van-hanh-runtime.md) | Tầng vận hành runtime: seam-trước-vendor-sau + persistence hai tầng | Đã chốt |
| [ADR-009](ADR-009-chien-luoc-realtime.md) | Realtime: Stream 3 surface lõi, mock-phát-trước, WS-sau | Đã chốt |
| [ADR-010](ADR-010-dto-provisional.md) | Serialization: DTO tách entity, pilot auth, provisional chờ contract ký | Đã chốt |
| [ADR-011](ADR-011-earn-family-split.md) | Tách module Earn thành earn_core + earn_staking + earn_savings (parity ADR-002) | Đã chốt |
| [ADR-013](ADR-013-surface-ui-architecture.md) | Tách UI/router theo surface Phone, Tablet, Web; giữ chung domain/data/contract | Đã chốt — migration P0–P9 |
