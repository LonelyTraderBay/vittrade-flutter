import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/onboarding_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _mgFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
  String backFallback = AppRoutePaths.home,
}) {
  final showBack = context.canPop();
  return VitPageLayout(
    variant: VitPageVariant.flush,
    semanticLabel: semanticLabel,
    semanticIdentifier: semanticIdentifier,
    child: Column(
      children: [
        VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          onBack: showBack
              ? () => goBackOrFallback(
                  context,
                  fallbackPath: backFallback,
                  mode: BackNavigationMode.historyThenFallback,
                )
              : null,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SingleChildScrollView(
                key: contentKey,
                padding: const EdgeInsets.fromLTRB(
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x4,
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x6,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _mgSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _mgBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _mgBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// Onboarding tablet — lộ trình làm quen nền tảng.
class OnboardingTabletPage extends ConsumerWidget {
  const OnboardingTabletPage({super.key});

  static const contentKey = Key('onboarding_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(onboardingSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _mgFrame(
        context: context,
        semanticIdentifier: 'SC-000',
        semanticLabel: 'Làm quen nền tảng',
        title: 'Bắt đầu',
        subtitle: 'Lộ trình làm quen',
        contentKey: OnboardingTabletPage.contentKey,
        child: _mgSection(
          title: 'Không tải được',
          rows: [_mgBody('Vui lòng thử lại.')],
        ),
      ),
      data: (snapshot) => _mgFrame(
        context: context,
        semanticIdentifier: 'SC-000',
        semanticLabel: 'Làm quen nền tảng',
        title: 'Bắt đầu',
        subtitle: snapshot.contractNotes,
        contentKey: OnboardingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _mgSection(
              title: 'Các bước',
              rows: _mgBullets([for (final step in snapshot.steps) step.name]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _mgSection(
              title: 'Cam kết',
              rows: _mgBullets(snapshot.commitments),
            ),
          ],
        ),
      ),
    );
  }
}

/// P2P escrow — xem trước số dư ký quỹ theo lệnh.
class P2PEscrowTabletPage extends ConsumerWidget {
  const P2PEscrowTabletPage({super.key, required this.orderId});

  static const contentKey = Key('p2p_escrow_tablet_content');

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _mgFrame(
      context: context,
      semanticIdentifier: 'SC-265',
      semanticLabel: 'Ký quỹ P2P',
      title: 'Ký quỹ',
      subtitle: 'Lệnh $orderId',
      contentKey: P2PEscrowTabletPage.contentKey,
      backFallback: AppRoutePaths.p2p,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _mgSection(
            title: 'Cơ chế ký quỹ',
            rows: _mgBullets([
              'Tài sản được khóa trong quỹ trung gian đến khi lệnh hoàn tất',
              'Mọi giải phóng ký quỹ cần xác nhận của hai bên hoặc phân xử',
              'Trạng thái ký quỹ hiển thị theo thời gian thực trong chi tiết lệnh',
            ]),
          ),
        ],
      ),
    );
  }
}

/// Chi tiết bạn được giới thiệu.
class ReferralFriendDetailTabletPage extends ConsumerWidget {
  const ReferralFriendDetailTabletPage({super.key});

  static const contentKey = Key('ref_friend_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _mgFrame(
      context: context,
      semanticIdentifier: 'SC-333',
      semanticLabel: 'Chi tiết bạn giới thiệu',
      title: 'Chi tiết bạn bè',
      subtitle: 'Tiến độ · Thưởng',
      contentKey: ReferralFriendDetailTabletPage.contentKey,
      backFallback: AppRoutePaths.referral,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _mgSection(
            title: 'Theo dõi',
            rows: _mgBullets([
              'Trạng thái xác minh và mốc khối lượng của người được mời',
              'Phần thưởng tương ứng hiển thị khi điều kiện đủ',
            ]),
          ),
        ],
      ),
    );
  }
}
