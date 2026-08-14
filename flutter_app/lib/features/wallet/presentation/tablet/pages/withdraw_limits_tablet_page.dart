import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for withdrawal limits SC-153.
class WithdrawLimitsTabletPage extends ConsumerWidget {
  const WithdrawLimitsTabletPage({super.key});

  static const contentKey = Key('sc153_withdraw_limits_tablet_content');
  static const currentTierKey = Key('sc153_withdraw_limits_current_tier_tablet');
  static const dailyUsageKey = Key('sc153_withdraw_limits_daily_usage_tablet');
  static const monthlyUsageKey = Key(
    'sc153_withdraw_limits_monthly_usage_tablet',
  );
  static const upgradeKycKey = Key('sc153_withdraw_limits_upgrade_kyc_tablet');
  static Key tierKey(int level) =>
      Key('sc153_withdraw_limits_tier_tablet_$level');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(walletWithdrawLimitsProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
        onBack: () => context.go(AppRoutePaths.wallet),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được hạn mức rút',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletWithdrawLimitsProvider),
        ),
        secondary: const SizedBox.shrink(),
        onBack: () => context.go(AppRoutePaths.wallet),
      ),
      data: (snapshot) => _frame(
        primary: _buildPrimary(context, snapshot),
        secondary: _buildSecondary(context, snapshot),
        onBack: () => context.go(AppRoutePaths.wallet),
      ),
    );
  }

  Widget _frame({
    required Widget primary,
    required Widget secondary,
    required VoidCallback onBack,
  }) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Hạn mức rút tiền theo cấp KYC trên tablet',
      semanticIdentifier: 'SC-153-TABLET',
      title: 'Hạn mức rút tiền',
      subtitle: 'Theo cấp KYC · hạn mức ngày và tháng',
      onBack: onBack,
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(
    BuildContext context,
    WalletWithdrawLimitsSnapshot snapshot,
  ) {
    final tier = snapshot.currentTier;
    return Column(
      key: WithdrawLimitsTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: WithdrawLimitsTabletPage.currentTierKey,
          variant: VitCardVariant.hero,
          child: Row(
            children: [
              Icon(Icons.verified_user_outlined, color: Color(tier.colorHex)),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cấp KYC ${tier.level}', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tier.name,
                      style: AppTextStyles.caption.copyWith(color: AppColors.buy),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Đã xác minh',
                icon: Icons.check_circle_outline_rounded,
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'Mức sử dụng hiện tại',
          headerIcon: Icons.speed_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            _usageCard(
              key: WithdrawLimitsTabletPage.dailyUsageKey,
              label: 'Hạn mức rút/ngày',
              used: snapshot.usedToday,
              limit: tier.dailyLimit,
              remaining: snapshot.dailyRemaining,
              percent: snapshot.dailyPercent,
            ),
            _usageCard(
              key: WithdrawLimitsTabletPage.monthlyUsageKey,
              label: 'Hạn mức rút/tháng',
              used: snapshot.usedMonth,
              limit: tier.monthlyLimit,
              remaining: snapshot.monthlyRemaining,
              percent: snapshot.monthlyPercent,
            ),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.caution.withValues(alpha: .34),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.caution),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Rút số tiền lớn có thể cần xem xét thủ công hoặc xác minh bổ sung. Kiểm tra bước tiếp theo trước khi tạo lệnh.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.caution),
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'So sánh hạn mức theo cấp KYC',
          headerIcon: Icons.layers_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            for (final item in snapshot.tiers)
              _tierCard(context, item, snapshot.currentLevel),
          ],
        ),
      ],
    );
  }

  Widget _usageCard({
    Key? key,
    required String label,
    required double used,
    required double limit,
    required double remaining,
    required double percent,
  }) {
    return VitCard(
      key: key,
      variant: VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(
                '${VitFormat.usd(used)} / ${VitFormat.usd(limit)}',
                style: AppTextStyles.caption.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x1,
              value: (percent / 100).clamp(0, 1).toDouble(),
              color: AppColors.buy,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Còn lại: ${VitFormat.usd(remaining)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
              ),
              VitStatusPill(
                label: '${percent.toStringAsFixed(1)}% đã dùng',
                icon: Icons.speed_rounded,
                status: percent >= 80
                    ? VitStatusPillStatus.warning
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tierCard(
    BuildContext context,
    WalletKycTier tier,
    int currentLevel,
  ) {
    final isCurrent = tier.level == currentLevel;
    final isLocked = tier.level > currentLevel;
    final stateLabel = isLocked
        ? 'Cần xác minh'
        : isCurrent
        ? 'Hiện tại'
        : 'Đã mở';
    return Semantics(
      button: isLocked,
      label: '$stateLabel cấp KYC ${tier.level}, ${tier.name}',
      child: VitCard(
        key: WithdrawLimitsTabletPage.tierKey(tier.level),
        onTap: isLocked ? () => context.go(AppRoutePaths.profileKyc) : null,
        variant: isCurrent ? VitCardVariant.hero : VitCardVariant.inner,
        child: Row(
          children: [
            Icon(
              isLocked
                  ? Icons.lock_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Color(tier.colorHex),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cấp ${tier.level} · ${tier.name}'),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    tier.dailyLimit > 0
                        ? '${VitFormat.usd(tier.dailyLimit)}/ngày'
                        : 'Không có hạn mức',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
            ),
            VitStatusPill(
              key: isLocked ? WithdrawLimitsTabletPage.upgradeKycKey : null,
              label: isLocked
                  ? 'Xác minh KYC'
                  : isCurrent
                  ? 'Hiện tại'
                  : 'Đã mở',
              icon: isLocked
                  ? Icons.open_in_new_rounded
                  : Icons.check_circle_outline_rounded,
              status: isLocked
                  ? VitStatusPillStatus.warning
                  : VitStatusPillStatus.success,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondary(
    BuildContext context,
    WalletWithdrawLimitsSnapshot snapshot,
  ) {
    final tier = snapshot.currentTier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Kiểm tra hạn mức trước khi rút',
          message:
              'Hạn mức hiển thị là dữ liệu tham khảo vận hành. Xác nhận phí, giới hạn đơn và bước kiểm tra bổ sung trước khi tạo lệnh.',
          contractId: snapshot.highRiskContractId ?? 'SC-153',
          density: VitDensity.compact,
        ),
        VitPageSection(
          label: 'Tóm tắt hạn mức',
          headerIcon: Icons.account_balance_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  VitInfoRow(
                    label: 'Rút/ngày tối đa',
                    value: VitFormat.usd(tier.dailyLimit),
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Giao dịch đơn',
                    value: VitFormat.usd(tier.singleTxLimit),
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Rút/tháng',
                    value: VitFormat.usd(tier.monthlyLimit),
                    density: VitDensity.compact,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Câu hỏi thường gặp',
          headerIcon: Icons.help_outline_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < snapshot.faqs.length; i++) ...[
                    Text(
                      snapshot.faqs[i].question,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.faqs[i].answer,
                      style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                    ),
                    if (i != snapshot.faqs.length - 1) ...[
                      const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
