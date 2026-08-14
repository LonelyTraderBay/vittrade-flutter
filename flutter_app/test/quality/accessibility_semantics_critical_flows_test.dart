// Origin: 3b8c3e79 (2026-05-31) - refactor: tách nhỏ kiến trúc Flutter enterprise
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/security_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/transfer/transfer_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/withdraw_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/tools/wallet_token_approval_page.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String initialLocation) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder semanticsLabel(Pattern pattern) {
    return find.byWidgetPredicate((widget) {
      if (widget is! Semantics) return false;
      final label = widget.properties.label;
      if (label == null) return false;
      return switch (pattern) {
        String() => label == pattern,
        RegExp() => pattern.hasMatch(label),
        _ => false,
      };
    });
  }

  testWidgets('SC-139 Withdraw exposes critical control semantics', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletWithdraw);

    expect(semanticsLabel(RegExp(r'Địa chỉ nhận rút')), findsOneWidget);
    expect(semanticsLabel(RegExp(r'Số tiền rút')), findsOneWidget);
    expect(semanticsLabel('Dùng toàn bộ số dư có thể rút'), findsOneWidget);
    expect(semanticsLabel('Xem trước lệnh rút'), findsOneWidget);
    expect(
      semanticsLabel(RegExp(r'Chọn mạng rút .+, phí .+, tối thiểu .+')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(WithdrawPage.addressFieldKey),
      'TXYZ1234567890abcdef',
    );
    await tester.ensureVisible(find.byKey(WithdrawPage.amountFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(WithdrawPage.amountFieldKey), '100');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(WithdrawPage.nextKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WithdrawPage.nextKey));
    await tester.pumpAndSettle();

    expect(semanticsLabel('Hủy xem trước lệnh rút'), findsOneWidget);
    expect(semanticsLabel('Xác nhận rút'), findsOneWidget);
  });

  testWidgets(
    'SC-143 Address Add exposes form, selector, and agreement semantics',
    (tester) async {
      await pumpRoute(tester, AppRoutePaths.walletAddressBookAdd);

      expect(semanticsLabel(RegExp(r'Tên địa chỉ')), findsOneWidget);
      expect(semanticsLabel(RegExp(r'Địa chỉ ví')), findsOneWidget);
      expect(semanticsLabel('Mạng địa chỉ TRC20'), findsOneWidget);
      expect(semanticsLabel('Tài sản địa chỉ USDT'), findsOneWidget);
      expect(semanticsLabel('Dán địa chỉ ví'), findsOneWidget);
      expect(semanticsLabel('Quét mã QR địa chỉ ví'), findsOneWidget);
      expect(
        semanticsLabel('Thêm địa chỉ vào danh sách trắng rút tiền'),
        findsOneWidget,
      );
      expect(
        semanticsLabel('Xác nhận địa chỉ ví và mạng là chính xác'),
        findsOneWidget,
      );
      expect(semanticsLabel('Lưu địa chỉ ví'), findsOneWidget);
    },
  );

  testWidgets(
    'SC-232 P2P Payment Add exposes type, option, form, and save semantics',
    (tester) async {
      await pumpRoute(tester, AppRoutePaths.p2pPaymentMethodAdd);

      expect(semanticsLabel('Chọn ngân hàng'), findsOneWidget);
      expect(semanticsLabel('Chọn ví điện tử'), findsOneWidget);
      expect(
        semanticsLabel('Vietcombank phương thức thanh toán'),
        findsOneWidget,
      );
      expect(semanticsLabel('Số tài khoản thanh toán P2P'), findsOneWidget);
      expect(
        semanticsLabel('Tên chủ tài khoản thanh toán P2P'),
        findsOneWidget,
      );
      expect(
        semanticsLabel('Xem trước và thêm phương thức thanh toán P2P'),
        findsOneWidget,
      );
    },
  );

  testWidgets('SC-150 Token approval exposes revoke semantics', (tester) async {
    await pumpRoute(tester, AppRoutePaths.walletTokenApproval);

    expect(semanticsLabel('Tab ủy quyền Đang hoạt động'), findsOneWidget);
    expect(semanticsLabel(RegExp(r'Thu hồi ủy quyền .+ cho .+')), findsWidgets);
    expect(
      semanticsLabel('Thu hồi tất cả ủy quyền token rủi ro cao'),
      findsOneWidget,
    );

    await tester.tap(WalletTokenApprovalPage.revokeKey('a3').finder);
    await tester.pumpAndSettle();

    expect(semanticsLabel('Hủy xem trước thu hồi token'), findsOneWidget);
    expect(semanticsLabel('Xác nhận'), findsOneWidget);
  });

  testWidgets('SC-146 Transfer confirm exposes money CTA semantics', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletTransfer);

    expect(semanticsLabel(RegExp(r'Số tiền chuyển nội bộ')), findsOneWidget);
    expect(
      semanticsLabel(RegExp(r'Chuyển khoản nội bộ đã tắt')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(TransferPage.maxKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TransferPage.maxKey));
    await tester.pumpAndSettle();

    expect(semanticsLabel('Xem trước chuyển khoản nội bộ'), findsOneWidget);

    await tester.ensureVisible(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();

    expect(
      semanticsLabel(RegExp(r'Số tiền chuyển [\d,]+\.\d+')),
      findsOneWidget,
    );
    expect(semanticsLabel('Hủy xác nhận chuyển nội bộ'), findsOneWidget);
    expect(semanticsLabel('Xác nhận chuyển nội bộ'), findsOneWidget);
  });

  testWidgets('SC-048 Trade exposes buy/sell and confirm CTA semantics', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.trade);

    expect(semanticsLabel('Chọn mua'), findsOneWidget);
    expect(semanticsLabel('Chọn bán'), findsOneWidget);
    expect(semanticsLabel(RegExp(r'Số lượng mua .+')), findsOneWidget);
    expect(
      semanticsLabel('Nhập số lượng để tiếp tục đặt lệnh'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.byKey(TradePage.pctKey(25)),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(TradePage.pctKey(25)));
    await tester.pumpAndSettle();

    expect(semanticsLabel('Xác nhận mua lệnh Spot'), findsOneWidget);

    await tester.tap(find.byKey(TradePage.submitKey));
    await tester.pumpAndSettle();

    expect(semanticsLabel('Huỷ xem trước lệnh giao dịch'), findsOneWidget);
    expect(semanticsLabel('Xác nhận gửi lệnh giao dịch'), findsOneWidget);
  });

  testWidgets('SC-158 Security save exposes anti-phishing CTA semantics', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileSecurity);

    expect(semanticsLabel('Mã chống lừa đảo'), findsOneWidget);
    expect(semanticsLabel('Lưu mã chống lừa đảo'), findsOneWidget);
    expect(find.byKey(SecurityPage.antiPhishingSaveKey), findsOneWidget);
  });

  testWidgets('SC-036 Prediction risk calculator exposes tabs and scenarios', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.marketsPredictionsRiskCalculator);

    expect(semanticsLabel(RegExp(r'.+ máy tính rủi ro.*')), findsWidgets);
    expect(semanticsLabel(RegExp(r'Kịch bản rủi ro .+')), findsWidgets);
  });

  testWidgets('Admin dashboards expose KPI and chart summaries', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.adminAnalytics);

    expect(
      semanticsLabel(RegExp(r'Chỉ số phân tích quản trị .+')),
      findsWidgets,
    );
    expect(
      semanticsLabel(RegExp(r'Biểu đồ khối lượng sự kiện .+')),
      findsOneWidget,
    );

    await pumpRoute(tester, AppRoutePaths.adminFunnels);
    expect(semanticsLabel(RegExp(r'Chỉ số funnel quản trị .+')), findsWidgets);
    expect(semanticsLabel(RegExp(r'Biểu đồ rời bỏ .+')), findsOneWidget);

    await pumpRoute(tester, AppRoutePaths.adminAbtests);
    expect(
      semanticsLabel(RegExp(r'Chỉ số A/B test quản trị .+')),
      findsWidgets,
    );
    expect(
      semanticsLabel(RegExp(r'Tỷ lệ chuyển đổi biến thể .+')),
      findsWidgets,
    );
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
