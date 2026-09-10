# Changelog — VitTrade Flutter

Định dạng theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/); phiên
bản theo [SemVer](https://semver.org/lang/vi/) + build number Flutter
(`x.y.z+build` trong `flutter_app/pubspec.yaml`).

## Quy ước phát hành (CI-D6, Android-only theo DEC-ios)

1. Bump `version:` trong `flutter_app/pubspec.yaml`:
   - `+build` tăng MỖI lần phát hành (Google Play yêu cầu versionCode tăng đơn điệu);
   - `patch` cho sửa lỗi, `minor` cho tính năng, `major` cho thay đổi phá vỡ.
2. Chuyển mục từ `[Chưa phát hành]` xuống heading phiên bản mới kèm ngày.
3. Merge vào `main` qua PR (required check "Enterprise Flutter Gates" xanh).
4. Tag `v<x.y.z>` và push tag — workflow `Release Android` build AAB flavor
   `prod` đã ký (cần 4 secret `VITTRADE_KEYSTORE_*`, xem release.yml).

Lệnh build theo môi trường:

| Môi trường | Lệnh |
| --- | --- |
| dev | `flutter build apk --flavor dev --debug` (applicationId `.dev`) |
| staging | `flutter build apk --flavor staging --dart-define=APP_ENV=staging` (applicationId `.staging`) |
| prod | `flutter build appbundle --release --flavor prod --dart-define=APP_ENV=production` |

## [Chưa phát hành]

### Thêm mới
- Pilot remote repository đầu tiên: `RemoteAuthRepository` (login/refresh qua
  `ApiClient` + DTO theo ADR-010) + 9 test hợp đồng + playbook 5 bước
  `docs/05_ARCHITECTURE/remote-repository-playbook.md`; cố ý chưa nối `remote:`
  vào provider P0 chờ backend thật (ratchet guardrail).
- ADR-014 chốt chính sách theme dark-only (không ThemeMode/light, không
  brightness-branch); bổ sung dòng ADR-012 thiếu trong danh mục ADR.
- Đồng bộ toàn bộ tài liệu sống theo hiện trạng production-enterprise:
  AGENTS.md (34 provider/35 feature, tablet composition hoàn tất toàn bộ
  route), dashboard tổng thể, kế hoạch sẵn sàng production, INDEX,
  START_HERE, README, Module-Identity-Standard, Color-Contrast-Audit.
- Nền tảng CI/CD enterprise (GĐ2 A-Plus): pipeline CI song song 6 job với gate
  tổng hợp, sàn coverage ratchet, quét secret (gitleaks + guardrail), dependabot,
  action pin theo SHA, product flavors Android (dev/staging/prod) và quy trình
  release theo tag.
- Máy trạng thái async cho toàn bộ write-path tài chính (spot, futures,
  leverage, predictions) theo ADR-001; gỡ dual-source state 17 trang; gỡ 2
  cycle kiến trúc họ trade; hiệu năng markets (memoize + rebuild harness).
- Nhãn semantics tiếng Việt + semanticIdentifier cho ~420 màn hình (A11Y-1).

### Thay đổi
- Toolchain align: 9 chỗ pin CI (flutter-ci ×6, release, flutter-release,
  ios-demo-build) lên Flutter 3.47.2; `flutter_riverpod` 3.3.2 → 3.4.3 (xoá
  DEP-LOCK pubspec + ignore dependabot, `environment: sdk ^3.12.0`); fix 10 chỗ
  `prefer_initializing_formals` theo hành vi linter mới của language 3.12
  (named initializing formal `this._x`, call site không đổi).

### Sửa lỗi
- 3 test stale sót sau UI-sync Đợt 2-3: SC-322 cập nhật kỳ vọng tên module
  tiếng Việt; SC-211 gắn lại key `sc211_tablet_content` bị rơi khi refactor
  `VitTwoColumnTabletDashboard`.

## [1.0.0] — bản mock UI đầu tiên

- Toàn bộ UI VitTrade dịch từ Figma sang Flutter chạy trên mock repositories
  (chưa có backend); design system Vit* + bộ audit/guardrail chất lượng.
