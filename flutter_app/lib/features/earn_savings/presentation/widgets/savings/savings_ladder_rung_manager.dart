import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class RungList extends StatelessWidget {
  const RungList({
    super.key,
    required this.rungs,
    required this.onToggleRenew,
    required this.onRemove,
  });

  final List<SavingsLadderRungDraft> rungs;
  final ValueChanged<String> onToggleRenew;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return VitCard(
        key: SavingsLadderPage.rungsKey,
        radius: VitCardRadius.large,
        density: VitDensity.compact,
        child: Column(
          children: [
            const Icon(
              Icons.layers_clear_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              'Chưa có bậc ladder',
              style: savingsLadderCaptionBoldStyle.copyWith(
                color: AppColors.text2,
              ),
            ),
          ],
        ),
      );
    }

    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      key: SavingsLadderPage.rungsKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        for (var i = 0; i < rungs.length; i++) ...[
          _RungTile(
            index: i + 1,
            rung: rungs[i],
            onToggleRenew: () => onToggleRenew(rungs[i].id),
            onRemove: () => onRemove(rungs[i].id),
          ),
        ],
      ],
    );
  }
}

class _RungTile extends StatelessWidget {
  const _RungTile({
    required this.index,
    required this.rung,
    required this.onToggleRenew,
    required this.onRemove,
  });

  final int index;
  final SavingsLadderRungDraft rung;
  final VoidCallback onToggleRenew;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = savingsLadderColorFor(rung.colorKey);
    return VitCard(
      key: SavingsLadderPage.rungKey(rung.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox.square(
            dimension: EarnSpacingTokens.savingsLadderRungIndexBox,
            child: Material(
              color: color.withValues(alpha: .14),
              shape: const CircleBorder(),
              child: Center(
                child: Text(
                  '$index',
                  style: savingsLadderMicroBoldStyle.copyWith(color: color),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        rung.product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: savingsLadderCaptionBoldStyle.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    SmallPill(
                      label: '${rung.lockDays}D',
                      color: AppColors.warn,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    SmallPill(
                      label: rung.autoRenew ? 'Tự gia hạn' : 'Dừng',
                      color: rung.autoRenew ? AppColors.buy : AppColors.text3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      savingsLadderMoney(rung.amountUsd),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      '${rung.apyPct.toStringAsFixed(1)}%',
                      style: savingsLadderCaptionBoldStyle.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                    Text(
                      '→ ${rung.maturityDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VitIconButton(
            tooltip: rung.autoRenew ? 'Tắt tự gia hạn' : 'Bật tự gia hạn',
            icon: rung.autoRenew
                ? Icons.autorenew_rounded
                : Icons.block_flipped,
            onPressed: onToggleRenew,
            variant: rung.autoRenew
                ? VitIconButtonVariant.success
                : VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          VitIconButton(
            tooltip: 'Xóa bậc',
            icon: Icons.delete_outline_rounded,
            onPressed: onRemove,
            variant: VitIconButtonVariant.danger,
            size: VitIconButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

class AddRungButton extends StatelessWidget {
  const AddRungButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsLadderPage.addRungKey,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary30,
      density: VitDensity.compact,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Thêm bậc ladder',
            style: savingsLadderCaptionBoldStyle.copyWith(
              color: AppColors.text2,
            ),
          ),
        ],
      ),
    );
  }
}

class AllocationStatus extends StatelessWidget {
  const AllocationStatus({
    super.key,
    required this.amountUsd,
    required this.totalAllocated,
    required this.unallocated,
  });

  final int amountUsd;
  final double totalAllocated;
  final double unallocated;

  @override
  Widget build(BuildContext context) {
    final complete = unallocated.abs() < 1;
    final progress = amountUsd <= 0
        ? 0.0
        : (totalAllocated / amountUsd).clamp(0.0, 1.0);
    final color = complete ? AppColors.buy : AppColors.warn;
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: Text(
              complete
                  ? 'Đã phân bổ hết'
                  : 'Chưa phân bổ: ${savingsLadderMoney(unallocated)}',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          SizedBox(
            width: EarnSpacingTokens.savingsLadderAllocationProgressWidth,
            child: ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x1,
                value: progress,
                color: color,
                backgroundColor: AppColors.surface3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
