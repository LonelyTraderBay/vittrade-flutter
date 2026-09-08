import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
part 'p2p_kyc_tablet_pages_extra.dart';

/// Khuôn chung các trang KYC P2P tablet: header + nội dung 1080dp + contract
/// notes. Cung cấp sẵn builder cho loading/error của từng provider.
Widget p2pKycPageFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
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
                  fallbackPath: AppRoutePaths.p2p,
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

Widget _section({required String title, required List<Widget> rows}) {
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

List<Widget> _noteList(List<String> notes, IconData icon, Color color) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Icon(icon, size: TabletSpacingTokens.iconSm, color: color),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-247: Yêu cầu KYC theo hạng.
class P2PKycRequirementsTabletPage extends ConsumerWidget {
  const P2PKycRequirementsTabletPage({super.key});

  static const contentKey = Key('sc247_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pKycRequirementsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pKycPageFrame(
        context: context,
        semanticIdentifier: 'SC-247',
        semanticLabel: 'Yêu cầu KYC P2P',
        title: 'Yêu cầu KYC',
        subtitle: 'Hạng · Hạn mức',
        contentKey: P2PKycRequirementsTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được yêu cầu KYC',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pKycRequirementsProvider),
        ),
      ),
      data: (snapshot) => p2pKycPageFrame(
        context: context,
        semanticIdentifier: 'SC-247',
        semanticLabel: 'Yêu cầu KYC P2P',
        title: 'Yêu cầu KYC',
        subtitle: 'Hạng · Hạn mức · Quyền lợi',
        contentKey: P2PKycRequirementsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    snapshot.heroBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final tier in snapshot.tiers)
              Padding(
                padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
                child: _KycTierSummaryCard(tier: tier),
              ),
            _section(
              title: snapshot.noticeTitle,
              rows: [
                Text(
                  snapshot.noticeBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _section(
              title: snapshot.supportTitle,
              rows: [
                Text(
                  snapshot.supportBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitCtaButton(
                  fullWidth: false,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () => context.go(snapshot.supportRoute),
                  child: const Text('Liên hệ hỗ trợ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KycTierSummaryCard extends StatelessWidget {
  const _KycTierSummaryCard({required this.tier});

  final P2PKycTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${tier.name} · ${tier.badge}',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: switch (tier.status) {
                  P2PKycTierStatus.current => 'Đang dùng',
                  P2PKycTierStatus.available => 'Khả dụng',
                  P2PKycTierStatus.pending => 'Đang chờ',
                  P2PKycTierStatus.locked => 'Chưa mở',
                },
                status: tier.status == P2PKycTierStatus.current
                    ? VitStatusPillStatus.success
                    : tier.status == P2PKycTierStatus.available ||
                          tier.status == P2PKycTierStatus.pending
                    ? VitStatusPillStatus.info
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x4,
            runSpacing: TabletSpacingTokens.x1,
            children: [
              Text(
                'Mua/ngày ${_formatVnd(tier.limits.dailyBuy)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'Bán/ngày ${_formatVnd(tier.limits.dailySell)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'Tháng ${_formatVnd(tier.limits.monthlyVolume)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          ..._noteList(
            tier.requirements.map((r) => r.label).toList(),
            Icons.check_circle_outline_rounded,
            AppColors.buy,
          ),
        ],
      ),
    );
  }
}

String _formatVnd(int value) => '${VitFormat.compactSuffix(value)} VND';

/// SC-248: Trạng thái KYC.
class P2PKycStatusTabletPage extends ConsumerWidget {
  const P2PKycStatusTabletPage({super.key});

  static const contentKey = Key('sc248_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pKycStatusProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pKycPageFrame(
        context: context,
        semanticIdentifier: 'SC-248',
        semanticLabel: 'Trạng thái KYC P2P',
        title: 'Trạng thái KYC',
        subtitle: 'Hạng · Tiến độ',
        contentKey: P2PKycStatusTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được trạng thái KYC',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pKycStatusProvider),
        ),
      ),
      data: (snapshot) => p2pKycPageFrame(
        context: context,
        semanticIdentifier: 'SC-248',
        semanticLabel: 'Trạng thái KYC P2P',
        title: 'Trạng thái KYC',
        subtitle: 'Hạng ${snapshot.tier} · ${snapshot.tierName}',
        contentKey: P2PKycStatusTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final step in snapshot.steps) _StatusStepCard(step: step),
            const SizedBox(height: TabletSpacingTokens.x3),
            _section(
              title: 'Thông tin',
              rows: [
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                Text(
                  snapshot.supportBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStepCard extends StatelessWidget {
  const _StatusStepCard({required this.step});

  final P2PKycStatusStepDraft step;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (step.status) {
      P2PKycStepStatus.completed => AppColors.buy,
      P2PKycStepStatus.rejected => AppColors.sell,
      P2PKycStepStatus.processing ||
      P2PKycStepStatus.waiting => AppColors.caution,
      P2PKycStepStatus.pending => AppColors.text3,
    };
    final statusLabel = switch (step.status) {
      P2PKycStepStatus.completed => 'Đã duyệt',
      P2PKycStepStatus.rejected => 'Bị từ chối',
      P2PKycStepStatus.processing => 'Đang xử lý',
      P2PKycStepStatus.waiting => 'Đang chờ',
      P2PKycStepStatus.pending => 'Chưa bắt đầu',
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
      child: VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    step.label,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                VitStatusPill(
                  label: statusLabel,
                  status: step.status == P2PKycStepStatus.completed
                      ? VitStatusPillStatus.success
                      : step.status == P2PKycStepStatus.rejected
                      ? VitStatusPillStatus.error
                      : step.status == P2PKycStepStatus.pending
                      ? VitStatusPillStatus.neutral
                      : VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x1),
            Text(
              step.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.3,
              ),
            ),
            if (step.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: TabletSpacingTokens.x1),
                child: Text(
                  'Duyệt lúc ${step.completedAt}',
                  style: AppTextStyles.micro.copyWith(
                    color: statusColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            if (step.rejectedReason != null)
              Padding(
                padding: const EdgeInsets.only(top: TabletSpacingTokens.x1),
                child: Text(
                  'Lý do: ${step.rejectedReason}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.sell),
                ),
              ),
            if (step.actionLabel != null && step.actionRoute != null)
              Padding(
                padding: const EdgeInsets.only(top: TabletSpacingTokens.x2),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: VitCtaButton(
                    fullWidth: false,
                    variant: VitCtaButtonVariant.secondary,
                    onPressed: () => context.go(step.actionRoute!),
                    child: Text(step.actionLabel!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
