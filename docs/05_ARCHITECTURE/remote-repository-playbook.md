# Playbook: thêm RemoteRepository cho một feature

Công thức cơ học đưa một feature từ mock sang remote — chuẩn hoá theo pilot
`RemoteAuthRepository` (2026-09-10). Khi backend ký contract, mỗi feature chỉ
làm theo 5 bước này; không thiết kế lại gì.

Tham chiếu kiến trúc: ADR-010 (DTO provisional), ADR-001 (idiom lỗi async),
ADR-008 (tầng vận hành runtime). Mẫu triển khai: 
`lib/features/auth/data/repositories/remote_auth_repository.dart`; mẫu test:
`test/features/auth/data/remote_auth_repository_test.dart`.

## Bối cảnh: vì sao pilot chưa nối vào provider

Guardrail `test/quality/repository_guard_coverage_guardrail_test.dart` cấm
truyền `remote:` vào 6 provider P0 **cho tới khi backend thật tồn tại** — nối
remote khi chưa có backend sẽ khiến build production fail với thông báo "mất
kết nối" gây hiểu lầm, thay vì thông điệp fail-closed trung thực
(`Dịch vụ xác thực chưa sẵn sàng vì backend production chưa được cấu hình`).
Pilot auth vì vậy dừng ở bước 3: repo + test hợp đồng hoàn chỉnh, wiring là
bước 4 chờ ngày ký contract.

## 5 bước

### 1. DTO + mapper (`features/<x>/data/dto/`)

Với mỗi endpoint đã ký: tạo `<name>_dto.dart` (`@JsonSerializable(checked:
true)`), `<name>_dto.g.dart` sinh bằng build_runner, mapper mở rộng
`<x>_dto_mappers.dart` theo hướng `toEntity()` / `toDto()`. DTO mirror
field-for-field với entity — khi contract đổi, chỉ `data/dto/` + remote repo
đổi (ADR-010).

```bash
dart run build_runner build --delete-conflicting-outputs
```

CI job static kiểm git-diff sạch sau build_runner — đừng commit tay file `.g.dart`.

### 2. Remote repository (`features/<x>/data/repositories/remote_<x>_repository.dart`)

Khuôn (copy từ `RemoteAuthRepository`):

- Constructor `const RemoteXRepository({required this._client})`, field
  `final ApiClient _client` — mọi request qua `_client.dio`.
- Request: `_client.dio.post('/<endpoint>', data: Dto(...).toJson())`.
- Response: `Dto.fromJson(map).toEntity()`.
- Lỗi: bọc mọi call trong helper `_send` — bắt `DioException`, unwrap
  `error.error` (đã là `ApiFailure`/`OfflineFailure` nhờ
  `errorMappingInterceptor`) và `Error.throwWithStackTrace` tiếp cho
  controller (ADR-001: controller hiển thị `userMessage`, không thấy HTTP).
- Body lệch DTO (`CheckedFromJsonException`, thiếu trường) → `ApiFailure`
  statusCode 200 + "Hệ thống đang gián đoạn".
- Endpoint CHƯA ký contract: ném
  `<X>BackendContractMissingException` — không bịa wire shape.

### 3. Test hợp đồng (`test/features/<x>/data/remote_<x>_repository_test.dart`)

Theo khuôn `_FakeAuthAdapter` (implements `HttpClientAdapter`, bắt
`RequestOptions` để assert wire shape, trả response đặt trước hoặc ném lỗi
mạng) — KHÔNG thêm dependency mock-server mới. Tối thiểu 4 nhóm:

1. Thành công: request đúng method/path/body; unwrap entity đúng field.
2. Lỗi HTTP (vd 401) → `ApiFailure` tiếng Việt đúng status.
3. Mất kết nối → `OfflineFailure`.
4. Endpoint chưa ký → contract-missing, không chạm mạng.

### 4. Nối nhánh remote vào provider — CHỈ KHI backend ký contract

Trong `features/<x>/data/providers/<x>_repository_provider.dart`, thêm đúng
một tham số:

```dart
remote: (client) => RemoteXRepository(client: client),
```

`guardedRepository` tự đổi: `enableMockData=true` vẫn mock, `false` thì remote
thay vì failClosed. Nếu `<x>` thuộc 6 provider P0 (auth, wallet, trade,
p2p_core, markets, profile): XOÁ path tương ứng khỏi rule cấm `remote:` trong
`repository_guard_coverage_guardrail_test.dart` cùng commit, và cập nhật kỳ
vọng runtime trong `p0_repository_fail_closed_runtime_test.dart`
(FailClosedXxx → RemoteXxx).

### 5. Verify

```bash
dart run tool/preflight_check.dart
```

Full: format, analyze, 21 audit `--check`, toàn bộ test. Xanh thì commit theo
mốc "feature <x>: remote repository + wiring".

## Checklist nhanh

- [ ] DTO `checked: true` + `.g.dart` sinh từ build_runner
- [ ] Mapper hai hướng, entity không dính annotation
- [ ] Remote repo: mọi request qua `_client.dio`, lỗi unwrap qua `_send`
- [ ] Endpoint chưa ký ném contract-missing (không bịa shape)
- [ ] 4 nhóm test hợp đồng xanh
- [ ] Wiring + guardrail P0 cập nhật (nếu áp dụng, chỉ khi backend ký)
- [ ] Preflight PASS
