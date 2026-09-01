# ADR-013 — Kiến trúc UI độc lập theo Surface Phone / Tablet / Web

- **Trạng thái:** Đã chốt — migration P0–P9 (2026-08-15)
- **Phạm vi:** `flutter_app/lib/app`, `flutter_app/lib/core`, `flutter_app/lib/shared` và toàn bộ `flutter_app/lib/features/**/presentation`
- **Liên quan:** [ADR-003](ADR-003-design-system-vit.md), [ADR-006](ADR-006-composition-root-coupling.md), [ADR-012](ADR-012-p2p-family-split.md)
- **Chuẩn thực thi:** [Surface-Architecture-Standard.md](../../02_FLUTTER_MIGRATION/standards/Surface-Architecture-Standard.md)
- **Kế hoạch migration:** [Surface-Architecture-Migration-Plan.md](../../02_FLUTTER_MIGRATION/checklists/Surface-Architecture-Migration-Plan.md)

## Bối cảnh

VitTrade từng có một `createAppRouter()` và một `VitAppShell` dùng chung để
chọn UI Phone hoặc Tablet. Route implementation hiện đã được tách thành các
composition root riêng; compatibility facade chỉ còn phục vụ caller cũ và
nhánh Web chưa migrate hoàn toàn. Route coverage hiện tại có 409
`real_page`, 6 `redirect_alias`, tổng cộng 415 khai báo route.

> **Cập nhật kiểm chứng 2026-09-01:** số liệu hiện hành là 409
> `real_page`, 6 `redirect_alias`, tổng cộng 415 khai báo. Tablet đã có cây
> route độc lập tại `app/router/tablet/tablet_route_tree.dart`; manifest route
> được sinh từ route truth table để giữ path/name/redirect parity. Các module
> đã có composition Tablet dùng page/pane thật; module chưa port dùng utility
> Tablet, không dùng Phone/Web page.
>
> Kiểm tra boundary cùng ngày: 0 import chéo giữa các presentation surface;
> mọi feature chỉ lấy path/name từ route contract trung lập. `app_router.dart`
> còn tồn tại như compatibility facade ở composition root. `createAppRouter()`
> mặc định dùng Phone tree, nhánh `surface: tablet` dùng trực tiếp Tablet
> tree; chỉ nhánh Web compatibility còn dùng route groups hỗn hợp. Đây là
> ngoại lệ migration có chủ đích, không phải dependency của Phone hoặc Tablet
> production tree.

Mô hình responsive dispatcher phù hợp cho giai đoạn đầu nhưng không đủ tách
ownership khi Phone, Tablet và Web cần phát triển theo các information
architecture, input model và nhịp phát hành khác nhau. Thay đổi router là
refactor mức CRITICAL vì có hàng trăm caller trực tiếp và gián tiếp.

## Quyết định

1. **Tách presentation theo surface.** Mỗi feature có boundary `phone/`,
   `tablet/` và `web/` dưới `presentation/`. Page, widget composition, UI
   controller và shell không được import chéo giữa các surface.
2. **Tách route implementation.** Tạo `createPhoneAppRouter()`,
   `createTabletAppRouter()` và `createWebAppRouter()`. Phone và Tablet router
   lắp ráp trực tiếp route builder của surface tương ứng; Web compatibility
   route groups được giữ ở composition root cho tới khi Web tree đạt parity
   đầy đủ. `ResponsiveEntry` đã bị loại bỏ khỏi các router explicit.
3. **Giữ route contract dùng chung.** Path, name, screen ID, dynamic parameter,
   deep-link và analytics ID nằm trong `app/router/contracts/`. Đây là hợp đồng
   ổn định, không phải UI dùng chung.
4. **Giữ nghiệp vụ dùng chung.** `domain`, `data`, repository, service, auth,
   financial-safety policy, security rule và application use-case không được
   nhân bản theo surface.
5. **Feature sở hữu route contribution.** App router là composition root;
   route group cụ thể của feature nằm gần feature để tránh một router monolith.
6. **Design system dùng chung ở tầng primitive.** Token, typography, color,
   accessibility primitive và primitive widget được dùng chung; page layout,
   dashboard composition và interaction pattern có thể surface-owned.
7. **Migration additive và có parity.** Không xóa router/shell/compatibility
   facade cũ trước khi route manifest đạt parity, caller về 0 và test/build của
   ba surface đều xanh.
8. **Chưa tách thành nhiều package Dart ở phase đầu.** Giữ một Flutter app với
   boundary import được kiểm soát; chỉ extract package khi ownership/team/build
   time tạo ra nhu cầu thực tế.

## Dependency direction

```text
surface presentation → application → domain
data implementation ─────────────────→ domain contract
app composition root ────────────────→ mọi layer cần lắp ráp
core ─────────────────────────────────→ không import page/widget
```

`domain` không import Flutter. `data` không import `presentation`. Phone,
Tablet và Web không import page/widget/controller của nhau.

## Hệ quả

### Tích cực

- Mỗi surface có ownership và nhịp phát triển độc lập.
- Web không bị xem là Tablet phóng to.
- Tablet không còn bị ràng buộc vào Phone page.
- Route path và nghiệp vụ tài chính vẫn ổn định giữa các surface.
- Có thể kiểm thử visual và interaction theo từng surface.

### Chi phí chấp nhận

- Một route có thể có ba builder và ba bộ widget composition.
- Số lượng test UI tăng.
- Router và shell cần parity contract riêng.
- Migration phải chạy theo batch, không thể di chuyển cơ học toàn repo một lần.

## Quy tắc an toàn tài chính

Phone, Tablet và Web có thể khác UI nhưng phải dùng cùng policy cho phí, hạn
mức, risk, preview, confirm, masking và next step. Không cho phép một surface
tự bỏ qua preview/confirm hoặc tự tính lại số tiền tài chính.

Prediction Markets và Open Arena giữ nguyên boundary sản phẩm; việc tách
surface không cho phép dùng chung wallet/PnL/positions với Arena Points.

## Điều kiện thay thế ADR

Nếu sau này tách thành các package/app triển khai riêng, tạo ADR mới thay thế
ADR-013; không sửa lịch sử quyết định này.
