import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_errors.dart';
import 'package:vit_trade_flutter/features/auth/domain/repositories/auth_repository.dart';

export 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
export 'package:vit_trade_flutter/features/auth/domain/entities/auth_errors.dart';
export 'package:vit_trade_flutter/features/auth/domain/repositories/auth_repository.dart';

String authOperationErrorMessage(Object error) {
  if (error is AuthBackendContractMissingException) return error.userMessage;
  return 'Dịch vụ xác thực tạm thời không khả dụng. Vui lòng thử lại.';
}

final class AuthController {
  const AuthController({required this._repository});

  final AuthRepository _repository;

  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo = false,
  }) {
    return _repository.login(
      identifier: identifier.trim(),
      password: password,
      demo: demo,
    );
  }

  Future<AuthRegistrationDraft> register({
    required String name,
    required String contact,
    required AuthContactType contactType,
    required String password,
    String? referralCode,
  }) {
    return _repository.register(
      name: name.trim(),
      contact: contact.trim(),
      contactType: contactType,
      password: password,
      referralCode: referralCode?.trim(),
    );
  }

  Future<AuthOtpVerificationDraft> verifyFactor({
    required String contact,
    required String code,
    required AuthOtpPurpose purpose,
  }) {
    return _repository.verifyFactor(
      contact: contact.trim(),
      code: code.trim(),
      purpose: purpose,
    );
  }

  Future<AuthTwoFaSetupDraft> setupTwoFactor({
    required String secretKey,
    required String code,
    required bool backupCodesSaved,
  }) {
    return _repository.setupTwoFactor(
      secretKey: secretKey.trim(),
      code: code.trim(),
      backupCodesSaved: backupCodesSaved,
    );
  }

  Future<AuthPasswordResetDraft> requestPasswordReset({required String email}) {
    return _repository.requestPasswordReset(email: email.trim());
  }

  Future<AuthPasswordResetDraft> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return _repository.resetPassword(
      email: email.trim(),
      otp: otp.trim(),
      newPassword: newPassword,
    );
  }

  Future<AuthTokenPair> refreshSession({required String refreshToken}) {
    return _repository.refreshSession(refreshToken: refreshToken.trim());
  }
}
