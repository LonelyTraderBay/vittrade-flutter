# Surface Architecture Migration Plan

Tài liệu theo dõi thực thi [ADR-013](../../05_ARCHITECTURE/decisions/ADR-013-surface-ui-architecture.md).

## Source of truth

- Route truth table: `Flutter-Route-Coverage-Truth-Table.md`.
- Route audit: `flutter_app/tool/route_coverage_audit.dart`.
- Current public router facade: `flutter_app/lib/app/router/app_router.dart`.
- Current router implementation: `flutter_app/lib/app/router/route_groups/root_routes.dart`.
- Current surface standard: `../standards/Surface-Architecture-Standard.md`.

## Baseline tại thời điểm bắt đầu

| Hạng mục | Giá trị |
| --- | ---: |
| Route thật (`real_page`) | 412 |
| Redirect alias | 6 |
| Tổng route declaration | 418 |
| Tablet page class riêng | 6 |
| Web presentation tree | 0 |
| Responsive entry hiện tại | 5 |

## Trạng thái phase

| Phase | Mục tiêu | Trạng thái |
| --- | --- | --- |
| P0 | Baseline, ADR, route register | Hoàn tất |
| P1 | Foundation và import boundary | Chưa bắt đầu |
| P2 | Route contract/parity | Chưa bắt đầu |
| P3 | Shell/router độc lập | Chưa bắt đầu |
| P4 | Auth + 5 root tabs + receipt | Chưa bắt đầu |
| P5 | Trade/Wallet/P2P/Security high-risk | Chưa bắt đầu |
| P6 | Các feature route còn lại | Chưa bắt đầu |
| P7 | Web completion | Chưa bắt đầu |
| P8 | Xóa legacy | Chưa bắt đầu |
| P9 | Release gate và bàn giao | Chưa bắt đầu |

## Evidence P0

- `flutter analyze`: PASS.
- `dart run tool/route_coverage_audit.dart --check`: PASS.
- `dart run tool/navigation_edge_audit.dart --check`: PASS.
- `flutter test test/quality --reporter=compact --concurrency=4`: PASS (233 bài).
- `flutter test test/app/router test/shared --reporter=compact --concurrency=4`: PASS (165 bài).
- `surface_architecture_boundary_guardrail_test.dart`: PASS.
- Full `flutter test` đã được thử lại với concurrency mặc định và `--concurrency=1`; runner vượt giới hạn 5 phút và đóng pipe nhưng không ghi nhận test failure. Full-suite gate vẫn mở cho P9.

## Điều kiện không bỏ sót route

Mỗi route trong route truth table phải có các cột sau trước khi đóng migration:

```text
route_name
route_path
screen_id
module
phone_builder
tablet_builder
web_builder
focused_test
deep_link_test
financial_safety_review
status
```

Route chỉ được đánh dấu `completed` khi builder, test và audit của surface đó
đã xanh. Redirect alias được kiểm tra riêng và không tính thành page mới.

## Gate kết thúc

```text
412/412 real routes có builder hợp lệ trên ba surface
6/6 redirect alias giữ đúng target
0 import chéo Phone ↔ Tablet ↔ Web
0 caller tới ResponsiveEntry legacy
0 Tablet fallback sang Phone UI
0 Web fallback sang Phone/Tablet UI
analyze + focused tests + full tests + build đều PASS
```
