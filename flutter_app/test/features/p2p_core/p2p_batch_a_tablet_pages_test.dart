import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_ad_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_ad_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_create_ad_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_dashboard_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_my_ads_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_chat_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_kyc_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_dispute_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_compliance_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_payment_method_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_account_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_security_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_settings_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_insurance_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_merchant_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_my_orders_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_wallet_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_order_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_express_confirm_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_express_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_order_book_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

/// Khóa Batch A (GĐ2) P2P tablet: order-book/dashboard/express/confirm
/// render trang thật, KHÔNG rơi vào placeholder.
void main() {
  Future<void> pumpTablet(
    WidgetTester tester, {
    required String initialLocation,
    Size size = const Size(1280, 800),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: initialLocation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-273 renders the real order book tablet page', (tester) async {
    await pumpTablet(tester, initialLocation: '/p2p/order-book');

    expect(find.byType(P2POrderBookTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Bid tốt nhất'), findsOneWidget);
    expect(find.text('Lệnh mua (Bid)'), findsOneWidget);
  });

  testWidgets('SC-274 renders the real dashboard tablet page', (tester) async {
    await pumpTablet(tester, initialLocation: '/p2p/dashboard');

    expect(find.byType(P2PDashboardTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Tổng đơn'), findsOneWidget);
    expect(find.text('Đơn hàng theo tháng'), findsOneWidget);
  });

  testWidgets('SC-211 renders the express form with wired amount flow', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/express');

    expect(find.byType(P2PExpressTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Số tiền (VND)'), findsOneWidget);
    expect(find.byKey(P2PExpressTabletPage.contentKey), findsOneWidget);

    // Nhập số lượng → nhãn CTA dẫn xác nhận wired (không crash).
    await tester.enterText(
      find.byKey(P2PExpressTabletPage.contentKey).first,
      '',
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-210 renders the confirm preview page', (tester) async {
    await pumpTablet(
      tester,
      initialLocation:
          '/p2p/express/confirm?type=buy&asset=USDT&fiat=5000000&crypto=0.0500',
    );

    expect(find.byType(P2PExpressConfirmTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Xem trước khi gửi'), findsOneWidget);
    expect(
      find.byKey(P2PExpressConfirmTabletPage.confirmCtaKey),
      findsOneWidget,
    );
  });

  testWidgets('P2P home route still renders the real dashboard', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p');
    expect(find.byType(P2PHomeTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
  });

  testWidgets('SC-226/225/224/223 render real ads batch pages', (tester) async {
    await pumpTablet(tester, initialLocation: '/p2p/create');
    expect(find.byType(P2PCreateAdTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/my-ads');
    expect(find.byType(P2PMyAdsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/ad/ad-usdt-01');
    expect(find.byType(P2PAdDetailTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/ad-analytics/ad-usdt-01');
    expect(find.byType(P2PAdAnalyticsTabletPage), findsOneWidget);
    expect(find.text('Lượt hiển thị'), findsOneWidget);
  });

  testWidgets('SC-281/216/212/213/214/215 render real order flow pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/my-orders');
    expect(find.byType(P2PMyOrdersTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/order/order-001');
    expect(find.byType(P2POrderTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/order/timeline/order-001');
    expect(find.byType(P2POrderTimelineTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/order/rate/order-001');
    expect(find.byType(P2POrderRateTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/order/cancel/order-001');
    expect(find.byType(P2POrderCancelTabletPage), findsOneWidget);
    expect(find.text('Xác nhận hủy lệnh'), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/order/proof/order-001');
    expect(find.byType(P2POrderProofTabletPage), findsOneWidget);
  });

  testWidgets('SC-217/264/261/262/263 render real chat wallet pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/chat/order-001');
    expect(find.byType(P2PChatTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/wallet');
    expect(find.byType(P2PWalletTabletPage), findsOneWidget);
    expect(find.text('Chuyển nội bộ'), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/wallet/transfer');
    expect(find.byType(P2PWalletTransferTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/wallet/fund-lock-history');
    expect(find.byType(P2PFundLockHistoryTabletPage), findsOneWidget);
    expect(find.text('Lịch sử fund lock'), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/wallet/history');
    expect(find.text('Lịch sử giao dịch ví'), findsOneWidget);
  });

  testWidgets('SC-227/228/229 render real merchant pages', (tester) async {
    await pumpTablet(tester, initialLocation: '/p2p/merchant-apply');
    expect(find.byType(P2PMerchantApplyTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/merchant/merch-01');
    expect(find.byType(P2PMerchantProfileTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/report/merch-01');
    expect(find.byType(P2PReportMerchantTabletPage), findsOneWidget);
    expect(find.text('Gửi báo cáo'), findsOneWidget);
  });

  testWidgets('SC-247/248/249/402/250/251/403/252 render real kyc pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/kyc/requirements');
    expect(find.byType(P2PKycRequirementsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/status');
    expect(find.byType(P2PKycStatusTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/identity');
    expect(find.byType(P2PIdentityVerificationTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/verify');
    expect(find.byType(P2PIdentityVerificationTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/address');
    expect(find.byType(P2PAddressProofTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/selfie');
    expect(find.byType(P2PSelfieVerificationTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/face-match');
    expect(find.byType(P2PSelfieVerificationTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/kyc/video');
    expect(find.byType(P2PVideoVerificationTabletPage), findsOneWidget);
  });

  testWidgets('SC-237/232/233/234/235/236 render real payment pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/payment-methods');
    expect(find.byType(P2PPaymentMethodsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/payment-method/add');
    expect(find.byType(P2PPaymentMethodAddTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/payment-method/verification/pm-01',
    );
    expect(find.byType(P2PPaymentMethodVerificationTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/payment-method/ownership/pm-01',
    );
    expect(find.byType(P2PPaymentMethodOwnershipTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/payment-method/cooling-period',
    );
    expect(
      find.byType(P2PPaymentMethodCoolingPeriodTabletPage),
      findsOneWidget,
    );

    await pumpTablet(tester, initialLocation: '/p2p/payment-method/history');
    expect(find.byType(P2PPaymentMethodHistoryTabletPage), findsOneWidget);
  });

  testWidgets('SC-222/218/219/220/221 render real dispute pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/disputes');
    expect(find.byType(P2PDisputesTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/dispute/detail/disp-01');
    expect(find.byType(P2PDisputeDetailTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/dispute/evidence/disp-01');
    expect(find.byType(P2PDisputeEvidenceTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/dispute/resolution/disp-01',
    );
    expect(find.byType(P2PDisputeResolutionTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/dispute/order-001');
    expect(find.byType(P2PDisputeOpenTabletPage), findsOneWidget);
  });

  testWidgets('SC-238/239/240/241/243 render real insurance pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/insurance');
    expect(find.byType(P2PInsuranceFundTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/insurance/certificate');
    expect(find.byType(P2PInsuranceCertificateTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/insurance/score');
    expect(find.byType(P2PInsuranceScoreTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/insurance/policy');
    expect(find.byType(P2PInsurancePolicyTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/insurance/claim/claim-01');
    expect(find.byType(P2PClaimDetailTabletPage), findsOneWidget);
  });

  testWidgets('SC-253/254/255/256/257/258/404 render real security pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/security/center');
    expect(find.byType(P2PSecurityCenterTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/security/2fa');
    expect(find.byType(P2PTwoFactorSettingsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/security/devices');
    expect(find.byType(P2PDeviceManagementTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/security/anti-phishing');
    expect(find.byType(P2PAntiPhishingCodeTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/security/login-history');
    expect(find.byType(P2PLoginHistoryTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/security/suspicious-activity',
    );
    expect(find.byType(P2PSuspiciousActivityTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/security/whitelist');
    expect(find.byType(P2PWhitelistModeTabletPage), findsOneWidget);
  });

  testWidgets('SC-231/242/277/276/259/260/275 render real account pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/reviews');
    expect(find.byType(P2PReviewsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/insurance/contribution-history',
    );
    expect(find.byType(P2PContributionHistoryTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/blacklist');
    expect(find.byType(P2PBlacklistTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/blacklist/add');
    expect(find.byType(P2PBlacklistAddTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/e2e-info');
    expect(find.byType(P2PE2EInfoTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/fraud-prevention');
    expect(find.byType(P2PFraudPreventionTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/achievements');
    expect(find.byType(P2PAchievementsTabletPage), findsOneWidget);
  });

  testWidgets('SC-266/265/267/268/269/270/271 render real compliance pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/limits');
    expect(find.byType(P2PTransactionLimitsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/limits/tracker');
    expect(find.byType(P2PLimitTrackerTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/compliance/overview');
    expect(find.byType(P2PComplianceOverviewTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/compliance/aml-screening');
    expect(find.byType(P2PAmlScreeningTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/compliance/source-of-funds',
    );
    expect(find.byType(P2PSourceOfFundsTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/p2p/compliance/large-transaction',
    );
    expect(
      find.byType(P2PLargeTransactionJustificationTabletPage),
      findsOneWidget,
    );

    await pumpTablet(
      tester,
      initialLocation: '/p2p/compliance/risk-assessment',
    );
    expect(find.byType(P2PRiskAssessmentTabletPage), findsOneWidget);
  });

  testWidgets('SC-230/279/278/280/272 render real settings pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/p2p/trading-level');
    expect(find.byType(P2PTradingLevelTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/p2p/guide');
    expect(find.byType(P2PGuideTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/settings');
    expect(find.byType(P2PSettingsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/settings/notifications');
    expect(find.byType(P2PNotificationsSettingsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/tax-reporting');
    expect(find.byType(P2PTaxReportingTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/p2p/tax-report/detailed/2025');
    expect(find.byType(P2PTaxReportingTabletPage), findsOneWidget);
  });

  testWidgets('Batch A pages stay overflow-safe at portrait QA width', (
    tester,
  ) async {
    const locations = [
      '/p2p/order-book',
      '/p2p/dashboard',
      '/p2p/express',
      '/p2p/express/confirm?type=buy&asset=USDT&fiat=5000000&crypto=0.0500',
    ];
    for (final location in locations) {
      await pumpTablet(
        tester,
        initialLocation: location,
        size: const Size(800, 1024),
      );
      expect(tester.takeException(), isNull, reason: 'overflow tại $location');
    }
  });
}
