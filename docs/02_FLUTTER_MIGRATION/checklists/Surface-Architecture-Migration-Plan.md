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
| P1 | Foundation và import boundary | Hoàn tất |
| P2 | Route contract/parity | Hoàn tất |
| P3 | Shell/router độc lập | Hoàn tất |
| P4 | Auth + 5 root tabs + receipt | Hoàn tất |
| P5 | Trade/Wallet/P2P/Security high-risk | Hoàn tất |
| P6 | Các feature route còn lại | Hoàn tất |
| P7 | Web completion | Hoàn tất |
| P8 | Xóa legacy | Hoàn tất |
| P9 | Release gate và bàn giao | Hoàn tất |

## Evidence thực thi đến P8

- 412 route thật và 6 redirect alias vẫn giữ parity; route coverage `--check`: PASS.
- Router/shell Phone, Tablet, Web được chọn ở bootstrap; ba surface router explicit không dùng chung UI, còn `createAppRouter()` chỉ giữ compatibility responsive cho caller cũ và QA.
- Compatibility responsive dispatcher nằm tại composition root `app/bootstrap/responsive_surface_page.dart`; không được dùng bởi Phone/Tablet/Web router explicit.
- Web có composition riêng cho Home/Auth và route-family Web cho Wallet/Trade/Profile/P2P cùng các bounded context còn lại.
- Đã xóa 10 file `ResponsiveEntry` legacy sau khi xác minh caller về 0.
- Page rhythm: 1537/1537 file pass; screen rollup 412/412 L1 và L2 pass, unknown 0, inner gap debt 0; 6 documented exceptions.
- Header visual strict issues: 0; header action violations: 0; back-navigation strict issues: 0.
- `flutter analyze --no-pub`: PASS.
- `flutter test test/quality --reporter=compact --concurrency=1`: PASS; build Web là gate cuối của P9.
- `flutter test --reporter=compact`: PASS (3715 tests).
- `flutter build web`: PASS; Wasm dry-run PASS.

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
0 Web fallback sang Phone/Tablet UI ở route surface đã migrate
analyze + focused tests + full tests + build đều PASS
```
