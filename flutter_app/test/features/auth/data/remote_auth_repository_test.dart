// Hợp đồng của RemoteAuthRepository (pilot remote đầu tiên, ADR-010): chứng
// minh trọn đường ống ApiClient → DTO → mapper → entity + unwrap lỗi domain
// qua errorMappingInterceptor thật, không đụng provider thật (guardrail
// repository_guard_coverage cấm nối `remote:` vào provider P0 cho tới khi
// backend tồn tại — xem remote-repository-playbook.md cho bước nối).
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/core/network/api_error_mapper.dart';
import 'package:vit_trade_flutter/features/auth/data/repositories/fail_closed_auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/data/repositories/remote_auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_errors.dart';
import 'package:vit_trade_flutter/features/auth/domain/repositories/auth_repository.dart';

void main() {
  late _FakeAuthAdapter adapter;
  late RemoteAuthRepository repository;

  setUp(() {
    adapter = _FakeAuthAdapter();
    repository = _buildRepository(adapter);
  });

  group('login', () {
    test('gửi đúng wire shape LoginRequestDto và unwrap AuthSession', () async {
      final issuedAt = DateTime.now();
      adapter.respondWith(
        status: 200,
        body: {
          'identifier': 'user@vittrade.vn',
          'demo': false,
          'issuedAt': issuedAt.toIso8601String(),
        },
      );

      final session = await repository.login(
        identifier: 'user@vittrade.vn',
        password: 'secret',
        demo: true,
      );

      expect(session.identifier, 'user@vittrade.vn');
      expect(session.demo, isFalse);
      expect(session.issuedAt, issuedAt);

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/auth/login');
      expect(request.data, {
        'identifier': 'user@vittrade.vn',
        'password': 'secret',
        'demo': true,
      });
    });

    test('401 từ BE → ApiFailure tiếng Việt (qua interceptor thật)', () async {
      adapter.respondWith(status: 401, body: <String, Object>{});

      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'sai'),
        throwsA(
          isA<ApiFailure>()
              .having((f) => f.statusCode, 'statusCode', 401)
              .having((f) => f.userMessage, 'userMessage', contains('Phiên')),
        ),
      );
    });

    test('mất kết nối → OfflineFailure', () async {
      adapter.failWith(DioExceptionType.connectionError);

      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'secret'),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('body lệch DTO (thiếu trường) → ApiFailure gián đoạn', () async {
      adapter.respondWith(
        status: 200,
        body: {'identifier': 'user@vittrade.vn'},
      );

      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'secret'),
        throwsA(
          isA<ApiFailure>().having(
            (f) => f.userMessage,
            'userMessage',
            contains('gián đoạn'),
          ),
        ),
      );
    });
  });

  group('refreshSession', () {
    test('đổi cặp token và gửi đúng body', () async {
      adapter.respondWith(
        status: 200,
        body: {'accessToken': 'access.new', 'refreshToken': 'refresh.rotated'},
      );

      final pair = await repository.refreshSession(refreshToken: 'refresh.old');

      expect(pair.accessToken, 'access.new');
      expect(pair.refreshToken, 'refresh.rotated');

      final request = adapter.requests.single;
      expect(request.path, '/auth/refresh');
      expect(request.data, {'refreshToken': 'refresh.old'});
    });

    test('thiếu accessToken trong response → ApiFailure', () async {
      adapter.respondWith(status: 200, body: {'refreshToken': 'refresh.x'});

      await expectLater(
        repository.refreshSession(refreshToken: 'refresh.old'),
        throwsA(isA<ApiFailure>()),
      );
    });

    test('refreshToken không xoay → giữ null, không ném', () async {
      adapter.respondWith(status: 200, body: {'accessToken': 'access.new'});

      final pair = await repository.refreshSession(refreshToken: 'refresh.old');

      expect(pair.accessToken, 'access.new');
      expect(pair.refreshToken, isNull);
    });
  });

  group('endpoint chưa ký contract — fail-closed trong remote', () {
    test(
      'register/verifyFactor/setupTwoFactor/reset ném contract-missing',
      () async {
        await expectLater(
          repository.register(
            name: 'VitTrade User',
            contact: 'user@vittrade.vn',
            contactType: AuthContactType.email,
            password: 'secret',
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
        await expectLater(
          repository.verifyFactor(
            contact: 'user@vittrade.vn',
            code: '123456',
            purpose: AuthOtpPurpose.passwordReset,
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
        await expectLater(
          repository.setupTwoFactor(
            secretKey: 'SECRET',
            code: '123456',
            backupCodesSaved: true,
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
        await expectLater(
          repository.requestPasswordReset(email: 'user@vittrade.vn'),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
        await expectLater(
          repository.resetPassword(
            email: 'user@vittrade.vn',
            otp: '123456',
            newPassword: 'mat-khau-moi',
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );

        // Fail-closed không chạm mạng.
        expect(adapter.requests, isEmpty);
      },
    );
  });

  group('công thức guardedRepository (bước wiring của playbook)', () {
    test(
      'enableMockData=false + remote: → nhánh remote thắng failClosed',
      () async {
        final container = ProviderContainer(
          overrides: [
            appConfigProvider.overrideWithValue(
              AppConfig(
                environment: AppEnvironment.staging,
                apiBaseUrl: Uri.parse('https://api.staging.vittrade.example'),
                enableMockData: false,
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final repository = container.read(_remotePickedProvider);

        expect(repository, isA<RemoteAuthRepository>());
        expect(repository, isNot(isA<MockAuthRepository>()));
        expect(repository, isNot(isA<FailClosedAuthRepository>()));
      },
    );
  });
}

/// Bản sao provider thật + nhánh `remote:` — chứng minh đúng 3 dòng wiring
/// trong playbook là đủ để nhánh remote thắng khi tắt mock. Đặt ở test,
/// không đụng provider P0 thật (guardrail repository_guard_coverage cấm
/// `remote:` trong lib cho tới khi backend tồn tại).
final _remotePickedProvider = Provider<AuthRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Auth',
    mock: () => const MockAuthRepository(),
    remote: (client) => RemoteAuthRepository(client: client),
    failClosed: () => const FailClosedAuthRepository(),
  );
});

RemoteAuthRepository _buildRepository(_FakeAuthAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.staging.vittrade.example'))
    ..interceptors.add(errorMappingInterceptor())
    ..httpClientAdapter = adapter;
  return RemoteAuthRepository(
    client: ApiClient(
      config: AppConfig(
        environment: AppEnvironment.staging,
        apiBaseUrl: Uri.parse('https://api.staging.vittrade.example'),
      ),
      dio: dio,
    ),
  );
}

/// Adapter giả theo khuôn `_ThrowingAdapter` của
/// `test/core/network/api_client_error_mapping_test.dart` — bắt lại request
/// để assert wire shape, trả response đặt trước hoặc ném lỗi mạng.
final class _FakeAuthAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  ResponseBody Function(RequestOptions options)? _respond;
  DioExceptionType? _failType;

  void respondWith({required int status, required Map<String, Object?> body}) {
    _respond = (options) => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  void failWith(DioExceptionType type) => _failType = type;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (_failType != null) {
      throw DioException(requestOptions: options, type: _failType!);
    }
    return _respond!(options);
  }

  @override
  void close({bool force = false}) {}
}
