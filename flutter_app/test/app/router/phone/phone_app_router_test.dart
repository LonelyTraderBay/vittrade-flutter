import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_app_router.dart';

void main() {
  test('Phone route tree khởi tạo được với route mặc định', () {
    final router = createPhoneAppRouter(initialLocation: AppRoutePaths.home);

    expect(router.routeInformationProvider.value.uri.path, AppRoutePaths.home);
  });
}
