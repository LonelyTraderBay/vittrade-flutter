// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_address_proof_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_identity_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_requirements_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_merchant_apply_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_merchant_profile_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_selfie_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_video_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_cooling_period_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_ownership_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_methods_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

List<RouteBase> p2pAccountRoutes(ShellRenderMode shellRenderMode) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.p2pMerchantApply,
      name: AppRouteNames.sc227P2PMerchantApply,
      builder: (_, _) => P2PMerchantApplyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/p2p/merchant/:merchantId',
      name: AppRouteNames.sc228P2PMerchantProfile,
      builder: (_, state) => P2PMerchantProfilePage(
        merchantId: requireRouteParam(state, 'merchantId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycRequirements,
      name: AppRouteNames.sc247P2PKycRequirements,
      builder: (_, _) =>
          P2PKycRequirementsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycStatus,
      name: AppRouteNames.sc248P2PKycStatus,
      builder: (_, _) => P2PKycStatusPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycIdentity,
      name: AppRouteNames.sc249P2PIdentityVerification,
      builder: (_, _) =>
          P2PIdentityVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycAddress,
      name: AppRouteNames.sc250P2PAddressProof,
      builder: (_, _) => P2PAddressProofPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycVerify,
      name: AppRouteNames.sc402P2PKycVerify,
      builder: (_, _) =>
          P2PIdentityVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycFaceMatch,
      name: AppRouteNames.sc403P2PKycFaceMatch,
      builder: (_, _) =>
          P2PSelfieVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycSelfie,
      name: AppRouteNames.sc251P2PSelfieVerification,
      builder: (_, _) =>
          P2PSelfieVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycVideo,
      name: AppRouteNames.sc252P2PVideoVerification,
      builder: (_, _) =>
          P2PVideoVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodAdd,
      name: AppRouteNames.sc232P2PPaymentMethodAdd,
      builder: (_, state) => P2PPaymentMethodAddPage(
        initialType: state.uri.queryParameters['type'] == 'ewallet'
            ? P2PPaymentAddType.ewallet
            : P2PPaymentAddType.bank,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/payment-method/verification/:methodId',
      name: AppRouteNames.sc233P2PPaymentMethodVerification,
      builder: (_, state) => P2PPaymentMethodVerificationPage(
        methodId: requireRouteParam(state, 'methodId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/payment-method/ownership/:methodId',
      name: AppRouteNames.sc234P2PPaymentMethodOwnership,
      builder: (_, state) => P2PPaymentMethodOwnershipPage(
        methodId: requireRouteParam(state, 'methodId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodCoolingPeriod,
      name: AppRouteNames.sc235P2PPaymentMethodCoolingPeriod,
      builder: (_, _) =>
          P2PPaymentMethodCoolingPeriodPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodHistory,
      name: AppRouteNames.sc236P2PPaymentMethodHistory,
      builder: (_, _) =>
          P2PPaymentMethodHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethods,
      name: AppRouteNames.sc237P2PPaymentMethods,
      builder: (_, _) =>
          P2PPaymentMethodsPage(shellRenderMode: shellRenderMode),
    ),
  ];

  return routes;
}
