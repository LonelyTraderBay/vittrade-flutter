# Chuẩn tổ chức UI theo thiết bị

Phạm vi áp dụng: các feature đã có giao diện tablet riêng.

## Boundary chuẩn

Trong `features/<feature>/presentation/`:

```text
pages/
├── phone/       # page gốc cho màn hình phone và part-file nội bộ của nó
├── tablet/      # page composition dành riêng cho tablet
└── responsive/  # dispatcher theo breakpoint, không chứa UI chi tiết

widgets/
└── tablet/      # toàn bộ widget composition riêng của tablet
```

Tablet root surface không import page, part-file hoặc widget composition của
Phone. Tablet được phép dùng domain/data/controller của feature, design token,
layout primitive trong `shared/` và các contract riêng trong
`widgets/tablet/`. Nếu UI cần một biến thể riêng, tạo bản tablet-owned trong
`widgets/tablet/` thay vì kéo ngược widget Phone vào Tablet.

## Quy tắc import

- Code mới phải import page từ boundary chuẩn `phone/`, `tablet/` hoặc
  `responsive/`.
- Route root chỉ import `pages/responsive/`.
- Tablet page chỉ dùng contract/domain, data/controller và primitive dùng chung
  ở `shared/`; không import page phone, page hub, part-file hoặc widget UI
  legacy của cùng feature.
- Các file path cũ ở ngay dưới `pages/` hoặc `pages/hub/` chỉ là compatibility
  export trong giai đoạn chuyển tiếp; không thêm logic vào đó.
- Các page chi tiết chưa có tablet composition riêng vẫn ở thư mục module
  hiện tại và tiếp tục chạy qua tablet shell. Chỉ chuyển chúng khi có thiết
  kế tablet và test breakpoint tương ứng.

## Feature hiện đã áp dụng

Home, Markets, Wallet, Trade và Profile đều có đủ ba page boundary. Toàn bộ
composition UI của năm màn Tablet đã được tách vào `pages/tablet/` và
`widgets/tablet/`, kèm contract key riêng cho từng feature. Các facade ở path
cũ chỉ còn export để giữ tương thích với test/route legacy; Tablet không import
các facade này.
