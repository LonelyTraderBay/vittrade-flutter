# Checklist: Thêm màn hình mới (UI Definition of Done)

Bản chốt 2026-09-12 sau khi gate "Enterprise Flutter Gates" XANH lần đầu
(run 34723194564, coverage sàn 92.0% ratchet chỉ-tăng). Mục tiêu: màn hình
mới đi theo checklist này thì **không phải quay lại sửa gì** — guardrail tự
chạy là người gác.

## 1. Route (cả 3 surface cùng batch)

- [ ] Thêm path vào `app_route_paths.dart` + name vào `app_route_names.dart`
  + route id theo group; KHÔNG sửa các group gốc `app/router/route_groups/`
  (legacy web-only, đã stub — xem Surface-Architecture-Standard).
- [ ] Đăng ký ở phone group + tablet route (nếu path tham số: cả manifest
  tablet) + web tự sinh utility. Chạy `dart run tool/route_coverage_audit.dart
  --check` — thiếu route là đỏ ngay.
- [ ] Tablet composition BẮT BUỘC cùng batch phone (gate GĐ7: 0 utility
  placeholder). Scaffold chuẩn: `VitTabletSectionFrame` /
  `VitTwoColumnTabletDashboard` / `WalletTabletDetailSurface`... không tự
  lắp `Center + maxWidth`.

## 2. Dữ liệu (nếu có snapshot mới)

- [ ] Entity ở `domain/`, mock ở `data/fixtures/`, provider qua
  `guardedRepository` (mock + failClosed; KHÔNG `remote:` cho tới khi
  backend thật tồn tại — guardrail cấm).
- [ ] Method repo `Future<T>` (ADR-001); id mock phải khớp id mà provider
  thực sự đọc (bẫy 'btc-fixed-90' vs 'sav001' — grep fixture mà provider đọc).

## 3. UI theo token đóng

- [ ] Spacing: Phone `AppSpacing` / Tablet `TabletSpacingTokens` — Base-8
  role scale, không 4dp tùy ý; radius chỉ `app_radii.dart`; motion chỉ
  `app_motion.dart`; màu chỉ `app_colors.dart` + module accents (dark-only
  ADR-014 — không ThemeMode, không brightness branch).
- [ ] Widget tái dùng từ 67 `Vit*` trước khi tự viết; `VitTabBar` không bọc
  trong card; semanticLabel tiếng Việt có dấu.
- [ ] File >600 dòng phải tách part `_sections`/`_widgets` (cùng thư mục,
  KHÔNG `_part_NN`).

## 4. Test tối thiểu (ratchet coverage chỉ-tăng)

- [ ] Widget test pump trang: assert tiêu đề + section chính.
- [ ] Test tương tác ít nhất 1 nhánh (tap/picker/sheet) — pump route mặc
  định chỉ phủ build gốc; nhánh error dùng khuôn
  `VitTradeApp(overrides: [providerFamily(KEY).overrideWith((ref) async =>
  throw ...)])` — KEY phải khớp giá trị default của page, và mỗi test một
  cây riêng (ProviderScope container không đổi override giữa 2 pumpWidget).
- [ ] Mock delay 250ms không phải frame — pump `Duration(milliseconds: 400)`
  trước `pumpAndSettle` khi cần data branch.
- [ ] Không để coverage tụt dưới 92.0%: chạy
  `flutter test --coverage` + `dart run tool/coverage_floor.dart
  coverage/lcov.info` (thuật toán SUM + loại fixtures — đừng tự tính khác).

## 5. Artifact regen (SAU MỖI đợt sửa route/UI)

- [ ] `route_coverage_audit` + `navigation_edge_audit` + artifact có
  `--check` trong preflight đều phải tươi; báo "stale" thì chạy lại lệnh
  (không `--check`) rồi commit artifact kèm code.
- [ ] `dart run tool/preflight_check.dart` PASS trước commit (một lệnh mô
  phỏng toàn bộ CI).

## 6. Trước khi gọi là xong

- [ ] `flutter analyze` 0 issue; `dart format` sạch.
- [ ] Emulator smoke màn hình mới (phone + tablet).
- [ ] Không thêm dependency mới; diff nhỏ nhất (Ponytail-lite).
