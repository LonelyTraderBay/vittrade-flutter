# Surface Architecture Standard

**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Phạm vi:** UI Phone, Tablet và Web của VitTrade Flutter.

**Trạng thái:** Chuẩn đích trong migration ADR-013. Trong giai đoạn chuyển
tiếp, module chưa migrate có thể còn compatibility route, nhưng không được
thêm caller mới vào boundary legacy.

## Boundary chuẩn

```text
lib/
├── app/
│   ├── bootstrap/       # chọn surface/router một lần ở composition root
│   ├── providers/       # Riverpod composition root
│   ├── router/
│   │   ├── contracts/   # path/name/screen ID/deep-link contract
│   │   ├── phone/
│   │   ├── tablet/
│   │   └── web/
│   └── shell/
│       ├── phone/
│       ├── tablet/
│       └── web/
├── core/                # cross-cutting non-UI boundaries
├── shared/              # design tokens + primitives, không chứa page feature
└── features/<feature>/
    ├── domain/
    ├── data/
    ├── application/
    ├── routes/          # route contribution của feature theo surface
    └── presentation/
        ├── phone/
        ├── tablet/
        └── web/
```

## Được phép dùng chung

- Domain entities và repository contracts.
- Data repository/service và provider composition.
- Application use-case, command, query và financial policy.
- Auth/session/security/observability.
- Route contract, screen ID và analytics contract.
- Design token, typography, accessibility primitive và low-level shared widget.

## Bị cấm dùng chung

- Phone page/widget/controller → Tablet hoặc Web.
- Tablet page/widget/controller → Phone hoặc Web.
- Web page/widget/controller → Phone hoặc Tablet.
- Page composition đặt trong `shared/` để né boundary feature.
- Domain/data import presentation.
- Core import page/widget.
- Logic tài chính viết lại ở từng surface.

## Router

Router factory của mỗi surface phải:

1. Có route tree độc lập.
2. Dùng cùng route contract.
3. Giữ cùng auth/maintenance/force-update policy.
4. Giữ deep-link, dynamic parameter và back navigation.
5. Không chọn Phone/Tablet ở từng page bằng `ResponsiveEntry` sau P8.

`SurfaceRouterHost` chỉ chọn một router ở bootstrap. Không tạo lại router trong
mỗi `build()` và không làm mất location/stack khi cửa sổ thay đổi kích thước.

## Feature route ownership

Route group của feature đặt gần feature:

```text
features/markets/routes/phone_markets_routes.dart
features/markets/routes/tablet_markets_routes.dart
features/markets/routes/web_markets_routes.dart
```

`app/router/<surface>/<surface>_app_router.dart` chỉ làm composition root.

## Test bắt buộc

- Import boundary test.
- Route parity test.
- Deep-link test.
- Back navigation test.
- Auth/maintenance redirect test.
- Widget test riêng cho Phone/Tablet/Web.
- Golden/visual test theo surface khi UI thay đổi.
- Financial preview/confirm/risk test cho flow nhạy cảm.

## Migration rule

- Batch 5–10 file, một feature/bounded context.
- Analyze + focused test sau mỗi batch.
- Không xóa legacy khi còn caller.
