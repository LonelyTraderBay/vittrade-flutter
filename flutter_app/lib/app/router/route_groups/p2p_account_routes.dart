import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
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
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> p2pAccountRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.p2pMerchantApply,
      name: AppRouteNames.sc227P2PMerchantApply,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-227',
          title: 'Đăng ký thương nhân',
          subtitle: 'Hồ sơ · điều kiện · xác minh',
          description:
              'Chuẩn bị hồ sơ thương nhân trong bố cục Tablet để rà soát điều kiện trước khi gửi.',
          facts: const [
            P2PTabletFact(label: 'Trạng thái hồ sơ', value: 'Chưa gửi'),
            P2PTabletFact(label: 'Cấp xác minh', value: 'Cần bổ sung'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Kiểm tra hồ sơ'),
          ],
          actionLabel: 'Gửi hồ sơ thương nhân',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi hồ sơ thương nhân',
          icon: Icons.storefront_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PMerchantApplyPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '/p2p/merchant/:merchantId',
      name: AppRouteNames.sc228P2PMerchantProfile,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-228',
          title: 'Hồ sơ thương nhân',
          subtitle: 'Uy tín · giao dịch · phương thức',
          description:
              'Xem tổng quan thương nhân và điều kiện giao dịch trong bố cục Tablet dễ đối chiếu.',
          facts: const [
            P2PTabletFact(label: 'Mã thương nhân', value: 'Đã chọn'),
            P2PTabletFact(label: 'Đánh giá', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Xem điều kiện giao dịch',
          icon: Icons.verified_user_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PMerchantProfilePage(
          merchantId: requireRouteParam(state, 'merchantId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycRequirements,
      name: AppRouteNames.sc247P2PKycRequirements,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-247',
          title: 'Điều kiện xác minh P2P',
          subtitle: 'KYC · giấy tờ · giới hạn',
          description:
              'Rà soát các điều kiện xác minh và tài liệu cần chuẩn bị trước khi bắt đầu.',
          facts: const [
            P2PTabletFact(label: 'Tài liệu bắt buộc', value: '3 mục'),
            P2PTabletFact(label: 'Thời gian dự kiến', value: '5–10 phút'),
            P2PTabletFact(label: 'Trạng thái', value: 'Sẵn sàng'),
          ],
          actionLabel: 'Bắt đầu chuẩn bị',
          icon: Icons.fact_check_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PKycRequirementsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycStatus,
      name: AppRouteNames.sc248P2PKycStatus,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-248',
          title: 'Trạng thái xác minh P2P',
          subtitle: 'KYC · hồ sơ · hạn mức',
          description:
              'Theo dõi trạng thái xác minh, phạm vi giao dịch và bước tiếp theo trên Tablet.',
          facts: const [
            P2PTabletFact(label: 'Cấp hiện tại', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Hạn mức', value: 'Theo kết quả xác minh'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Chờ rà soát'),
          ],
          actionLabel: 'Mở chi tiết xác minh',
          icon: Icons.assignment_turned_in_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PKycStatusPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycIdentity,
      name: AppRouteNames.sc249P2PIdentityVerification,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-249',
          title: 'Xác minh danh tính P2P',
          subtitle: 'KYC · danh tính · an toàn',
          description:
              'Kiểm tra thông tin định danh và bước xác nhận trước khi gửi hồ sơ KYC.',
          facts: const [
            P2PTabletFact(label: 'Loại xác minh', value: 'Danh tính'),
            P2PTabletFact(label: 'Tài liệu', value: 'Cần đối chiếu'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa hoàn tất'),
          ],
          actionLabel: 'Xác nhận danh tính',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận bắt đầu xác minh danh tính',
          icon: Icons.badge_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PIdentityVerificationPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycAddress,
      name: AppRouteNames.sc250P2PAddressProof,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-250',
          title: 'Xác minh địa chỉ P2P',
          subtitle: 'KYC · địa chỉ · bằng chứng',
          description:
              'Rà soát bằng chứng địa chỉ và phạm vi sử dụng trước khi xác nhận hồ sơ.',
          facts: const [
            P2PTabletFact(label: 'Bằng chứng', value: 'Cần tải lên'),
            P2PTabletFact(label: 'Định dạng', value: 'PDF hoặc ảnh'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa hoàn tất'),
          ],
          actionLabel: 'Gửi bằng chứng địa chỉ',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi bằng chứng địa chỉ',
          icon: Icons.home_work_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PAddressProofPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycVerify,
      name: AppRouteNames.sc402P2PKycVerify,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-402',
          title: 'Kiểm tra KYC P2P',
          subtitle: 'KYC · danh tính · kiểm tra',
          description:
              'Xem lại dữ liệu KYC và xác nhận bước kiểm tra danh tính trên Tablet.',
          facts: const [
            P2PTabletFact(label: 'Hồ sơ', value: 'Đã nhận'),
            P2PTabletFact(label: 'Kiểm tra', value: 'Đang chờ xác nhận'),
            P2PTabletFact(label: 'Kết quả', value: 'Chưa có'),
          ],
          actionLabel: 'Xem trước kiểm tra KYC',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận kiểm tra KYC',
          icon: Icons.verified_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PIdentityVerificationPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycFaceMatch,
      name: AppRouteNames.sc403P2PKycFaceMatch,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-403',
          title: 'Đối chiếu khuôn mặt P2P',
          subtitle: 'KYC · khuôn mặt · bảo mật',
          description:
              'Kiểm tra bước đối chiếu khuôn mặt và điều kiện an toàn trước khi xác nhận.',
          facts: const [
            P2PTabletFact(label: 'Phương thức', value: 'Đối chiếu khuôn mặt'),
            P2PTabletFact(label: 'Thiết bị', value: 'Đã sẵn sàng'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa thực hiện'),
          ],
          actionLabel: 'Bắt đầu đối chiếu',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận đối chiếu khuôn mặt',
          icon: Icons.face_retouching_natural_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PSelfieVerificationPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycSelfie,
      name: AppRouteNames.sc251P2PSelfieVerification,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-251',
          title: 'Xác minh selfie P2P',
          subtitle: 'KYC · selfie · bảo mật',
          description:
              'Rà soát hướng dẫn selfie và xác nhận bước tiếp theo trước khi mở camera.',
          facts: const [
            P2PTabletFact(label: 'Hướng dẫn', value: 'Đã sẵn sàng'),
            P2PTabletFact(label: 'Thiết bị', value: 'Cần cấp quyền camera'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa thực hiện'),
          ],
          actionLabel: 'Bắt đầu selfie',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận bắt đầu selfie',
          icon: Icons.camera_front_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PSelfieVerificationPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycVideo,
      name: AppRouteNames.sc252P2PVideoVerification,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-252',
          title: 'Xác minh video P2P',
          subtitle: 'KYC · video · kiểm tra',
          description:
              'Kiểm tra yêu cầu xác minh video và xác nhận phạm vi sử dụng trước khi tiếp tục.',
          facts: const [
            P2PTabletFact(label: 'Thời lượng', value: 'Theo hướng dẫn'),
            P2PTabletFact(label: 'Thiết bị', value: 'Cần cấp quyền camera'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa thực hiện'),
          ],
          actionLabel: 'Bắt đầu video',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận bắt đầu xác minh video',
          icon: Icons.videocam_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PVideoVerificationPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodAdd,
      name: AppRouteNames.sc232P2PPaymentMethodAdd,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-232',
          title: 'Thêm phương thức thanh toán',
          subtitle: 'Thanh toán · quyền sở hữu · bảo mật',
          description:
              'Kiểm tra loại phương thức và thông tin sở hữu trước khi thêm vào tài khoản P2P.',
          facts: const [
            P2PTabletFact(label: 'Loại phương thức', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Xác minh sở hữu', value: 'Bắt buộc'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa lưu'),
          ],
          actionLabel: 'Xem trước phương thức',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thêm phương thức thanh toán',
          icon: Icons.account_balance_wallet_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PPaymentMethodAddPage(
          initialType: state.uri.queryParameters['type'] == 'ewallet'
              ? P2PPaymentAddType.ewallet
              : P2PPaymentAddType.bank,
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/payment-method/verification/:methodId',
      name: AppRouteNames.sc233P2PPaymentMethodVerification,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-233',
          title: 'Xác minh phương thức thanh toán',
          subtitle: 'Thanh toán · mã xác nhận · an toàn',
          description:
              'Rà soát phương thức thanh toán và bước xác minh trước khi kích hoạt.',
          facts: const [
            P2PTabletFact(label: 'Phương thức', value: 'Đang chọn'),
            P2PTabletFact(label: 'Mã xác minh', value: 'Chưa nhập'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chờ xác minh'),
          ],
          actionLabel: 'Xác nhận phương thức',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận phương thức thanh toán',
          icon: Icons.lock_outline,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PPaymentMethodVerificationPage(
          methodId: requireRouteParam(state, 'methodId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/payment-method/ownership/:methodId',
      name: AppRouteNames.sc234P2PPaymentMethodOwnership,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-234',
          title: 'Xác minh quyền sở hữu',
          subtitle: 'Thanh toán · sở hữu · kiểm tra',
          description:
              'Kiểm tra bằng chứng sở hữu phương thức thanh toán trước khi hoàn tất xác minh.',
          facts: const [
            P2PTabletFact(label: 'Phương thức', value: 'Đang chọn'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Cần đối chiếu'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa hoàn tất'),
          ],
          actionLabel: 'Xác nhận quyền sở hữu',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận quyền sở hữu phương thức',
          icon: Icons.verified_user_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PPaymentMethodOwnershipPage(
          methodId: requireRouteParam(state, 'methodId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodCoolingPeriod,
      name: AppRouteNames.sc235P2PPaymentMethodCoolingPeriod,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-235',
          title: 'Thời gian chờ phương thức',
          subtitle: 'Thanh toán · an toàn · giới hạn',
          description:
              'Theo dõi thời gian chờ và phạm vi giao dịch của phương thức mới thêm.',
          facts: const [
            P2PTabletFact(label: 'Thời gian còn lại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Giao dịch bị giới hạn', value: 'Có'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang chờ'),
          ],
          actionLabel: 'Xem chính sách',
          icon: Icons.schedule_outlined,
        ),
        AppSurface.phone || AppSurface.web || null =>
          P2PPaymentMethodCoolingPeriodPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodHistory,
      name: AppRouteNames.sc236P2PPaymentMethodHistory,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-236',
          title: 'Lịch sử phương thức thanh toán',
          subtitle: 'Thanh toán · hoạt động · kiểm tra',
          description:
              'Đối chiếu các lần thêm, xác minh và thay đổi phương thức thanh toán P2P.',
          facts: const [
            P2PTabletFact(label: 'Hoạt động gần đây', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Xác minh thành công', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Lọc lịch sử',
          icon: Icons.history_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PPaymentMethodHistoryPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethods,
      name: AppRouteNames.sc237P2PPaymentMethods,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-237',
          title: 'Phương thức thanh toán P2P',
          subtitle: 'Thanh toán · danh sách · quyền',
          description:
              'Quản lý danh sách phương thức thanh toán với vùng rà soát rộng trên Tablet.',
          facts: const [
            P2PTabletFact(
              label: 'Phương thức đang bật',
              value: 'Đang cập nhật',
            ),
            P2PTabletFact(label: 'Phương thức chờ', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Bảo vệ rút tiền', value: 'Đang bật'),
          ],
          actionLabel: 'Mở quản lý phương thức',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận quản lý phương thức thanh toán',
          icon: Icons.payments_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PPaymentMethodsPage(shellRenderMode: shellRenderMode),
      },
    ),
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Tài khoản P2P',
      subtitle: 'Thương nhân · KYC · phương thức thanh toán',
      description:
          'Không gian Web riêng cho hồ sơ thương nhân, xác minh danh tính và phương thức thanh toán P2P. Điều kiện an toàn và bằng chứng cần được rà soát trước khi ghi nhận.',
      backPath: AppRoutePaths.p2p,
      icon: Icons.handshake_outlined,
    );
  }
  return routes;
}
