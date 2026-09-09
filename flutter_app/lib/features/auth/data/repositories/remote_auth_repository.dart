import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/core/network/api_error_mapper.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/auth_dto_mappers.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/auth_session_dto.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/login_request_dto.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_errors.dart';
import 'package:vit_trade_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Remote repository pilot đầu tiên của repo (ADR-010): chứng minh công thức
/// `guardedRepository` nhánh `remote:` — ApiClient → DTO → mapper → entity,
/// unwrap lỗi domain từ `errorMappingInterceptor`, phần endpoint chưa ký
/// contract ném `AuthBackendContractMissingException` thay vì bịa wire shape.
///
/// Endpoint + wire shape theo
/// `docs/02_FLUTTER_MIGRATION/Auth-Backend-Contract-Skeleton.md` (PROVISIONAL):
/// khi contract ký, chỉ `data/dto/` + file này đổi — domain entity và UI giữ
/// nguyên. Xem playbook
/// `docs/05_ARCHITECTURE/remote-repository-playbook.md` cho feature kế tiếp.
final class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository({required this._client});

  final ApiClient _client;

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo = false,
  }) async {
    final response = await _send(
      () => _client.dio.post(
        '/auth/login',
        data: LoginRequestDto(
          identifier: identifier,
          password: password,
          demo: demo,
        ).toJson(),
      ),
    );
    return _parseSession(response.data);
  }

  @override
  Future<AuthTokenPair> refreshSession({required String refreshToken}) async {
    final response = await _send(
      () => _client.dio.post(
        '/auth/refresh',
        data: <String, Object?>{'refreshToken': refreshToken},
      ),
    );

    final map = _asStringKeyedMap(response.data);
    final accessToken = map?['accessToken'];
    if (accessToken is! String || accessToken.isEmpty) {
      throw const ApiFailure(
        statusCode: 200,
        userMessage: 'Hệ thống đang gián đoạn. Vui lòng thử lại sau.',
      );
    }
    final rotated = map?['refreshToken'];
    return AuthTokenPair(
      accessToken: accessToken,
      refreshToken: rotated is String && rotated.isNotEmpty ? rotated : null,
    );
  }

  // Endpoint dưới đây chưa được ký contract (Auth-Backend-Contract-Skeleton
  // còn "to confirm") — giữ fail-closed thay vì bịa wire shape; chỉ bổ DTO +
  // impl khi hàng tương ứng trong skeleton được ký.

  @override
  Future<AuthRegistrationDraft> register({
    required String name,
    required String contact,
    required AuthContactType contactType,
    required String password,
    String? referralCode,
  }) => _contractMissing();

  @override
  Future<AuthOtpVerificationDraft> verifyFactor({
    required String contact,
    required String code,
    required AuthOtpPurpose purpose,
  }) => _contractMissing();

  @override
  Future<AuthTwoFaSetupDraft> setupTwoFactor({
    required String secretKey,
    required String code,
    required bool backupCodesSaved,
  }) => _contractMissing();

  @override
  Future<AuthPasswordResetDraft> requestPasswordReset({
    required String email,
  }) => _contractMissing();

  @override
  Future<AuthPasswordResetDraft> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) => _contractMissing();

  /// Chạy request qua [ApiClient]; `DioException` tới tay đã được
  /// `errorMappingInterceptor` map thành `ApiFailure`/`OfflineFailure` trong
  /// `DioException.error` — unwrap và ném tiếp cho controller (ADR-001).
  /// Nhánh `domain` không khớp chỉ xảy ra khi Dio được inject không có chuỗi
  /// interceptor (test) — về message mặc định an toàn.
  Future<Response<dynamic>> _send(
    Future<Response<dynamic>> Function() run,
  ) async {
    try {
      return await run();
    } on DioException catch (error, stackTrace) {
      final domain = error.error;
      if (domain is ApiFailure || domain is OfflineFailure) {
        Error.throwWithStackTrace(domain as Object, stackTrace);
      }
      throw const ApiFailure(
        statusCode: null,
        userMessage: 'Không thể hoàn tất yêu cầu. Vui lòng thử lại.',
      );
    }
  }

  AuthSession _parseSession(Object? data) {
    final map = _asStringKeyedMap(data);
    if (map == null) {
      throw const ApiFailure(
        statusCode: 200,
        userMessage: 'Hệ thống đang gián đoạn. Vui lòng thử lại sau.',
      );
    }
    try {
      return AuthSessionDto.fromJson(map).toEntity();
    } on CheckedFromJsonException {
      throw const ApiFailure(
        statusCode: 200,
        userMessage: 'Hệ thống đang gián đoạn. Vui lòng thử lại sau.',
      );
    }
  }

  static Map<String, dynamic>? _asStringKeyedMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return <String, dynamic>{
        for (final entry in value.entries)
          if (entry.key is String) entry.key as String: entry.value,
      };
    }
    return null;
  }

  Future<T> _contractMissing<T>() {
    return Future<T>.error(const AuthBackendContractMissingException());
  }
}
