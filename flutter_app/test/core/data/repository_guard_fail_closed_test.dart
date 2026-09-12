// Coverage dòng 2 p3k + giá trị thật: nhánh fail-closed của guardedRepository
// chưa từng chạy qua hàm thật (test P0 cũ chỉ khẳng định class); test này
// xác minh adminRepositoryProvider resolve FailClosedAdminRepository khi tắt
// mock — hợp đồng production của chính hàm guard lõi.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';

void main() {
  test('guardedRepository: không remote -> failClosed khi tắt mock', () {
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

    final repository = container.read(adminRepositoryProvider);

    expect(repository, isA<FailClosedAdminRepository>());
    expect(repository, isNot(isA<MockAdminRepository>()));
  });
}
