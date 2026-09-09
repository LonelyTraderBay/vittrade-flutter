import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

/// PROVISIONAL wire shape for the `POST /auth/login` request body
/// (`docs/02_FLUTTER_MIGRATION/Auth-Backend-Contract-Skeleton.md`, ADR-010
/// `docs/05_ARCHITECTURE/decisions/ADR-010-dto-provisional.md`).
///
/// Mirrors the parameters already accepted by `AuthController.login` /
/// `AuthRepository.login` (`identifier`, `password`, `demo`) — the only
/// shape confidently inferable from existing, tested code ahead of a signed
/// contract. Wired to the network transport by `RemoteAuthRepository` (remote
/// pilot — chưa nối vào provider P0 chờ backend, xem
/// `docs/05_ARCHITECTURE/remote-repository-playbook.md`); when the contract
/// is signed only `data/dto/` + the remote repository should need to change.
///
/// `checked: true` makes generated `fromJson` throw a controlled
/// [CheckedFromJsonException] (rather than a raw cast failure) when a field
/// is missing or has the wrong type.
@JsonSerializable(checked: true)
final class LoginRequestDto {
  /// Creates a DTO directly from wire-shape fields.
  const LoginRequestDto({
    required this.identifier,
    required this.password,
    this.demo = false,
  });

  /// Decodes a DTO from a JSON map. Throws [CheckedFromJsonException] if a
  /// required field is missing or has the wrong runtime type.
  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  /// Login/contact identifier (email or phone) — PROVISIONAL.
  final String identifier;

  /// Plaintext password submitted for authentication — PROVISIONAL. Never
  /// logged or persisted; only serialized for the outbound login request.
  final String password;

  /// Whether the login is requesting a demo-mode session — PROVISIONAL.
  final bool demo;

  /// Encodes this DTO to a JSON map.
  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
