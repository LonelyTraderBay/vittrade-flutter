import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

const _timelineBarHeight = 20.0;
const _maturityBadgeHeight = 44.0;
const _disclaimerLineHeight = 1.22;

class TimelineTab extends StatelessWidget {
  const TimelineTab({
    super.key,
    required this.snapshot,
    required this.rungs,
    required this.onEmptyCta,
  });

  final SavingsLadderSnapshot snapshot;
  final List<SavingsLadderRungDraft> rungs;
  final VoidCallback onEmptyCta;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return EmptyTab(
        icon: Icons.layers_clear_outlined,
        title: 'Chưa có bậc nào',
        cta: 'Bắt đầu xây',
        onCta: onEmptyCta,
      );
    }

    final sorted = [...rungs]..sort((a, b) => a.lockDays.compareTo(b.lockDays));
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      key: SavingsLadderPage.timelineKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        const SectionTitle(label: 'Lịch đáo hạn'),
        _TimelineChart(rungs: sorted),
        const SectionTitle(label: 'Lịch trình đáo hạn'),
        for (final rung in sorted) _MaturityTile(rung: rung),
        const SectionTitle(label: 'Dự kiến dòng tiền'),
        _CashFlowCard(rungs: sorted),
        EarnDisclaimerBanner(
          text: snapshot.disclaimer,
          lineHeight: _disclaimerLineHeight,
        ),
      ],
    );
  }
}

class _TimelineChart extends StatelessWidget {
  const _TimelineChart({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final maxDays = rungs.map((rung) => rung.lockDays).reduce(math.max);
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Hôm nay',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Expanded(child: SizedBox.shrink()),
              Text(
                '${maxDays}D',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final rung in rungs) ...[
            _TimelineBar(rung: rung, maxDays: maxDays),
            if (rung != rungs.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final rung in rungs)
                SmallPill(
                  label: rung.maturityDate,
                  color: savingsLadderColorFor(rung.colorKey),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  const _TimelineBar({required this.rung, required this.maxDays});

  final SavingsLadderRungDraft rung;
  final int maxDays;

  @override
  Widget build(BuildContext context) {
    final color = savingsLadderColorFor(rung.colorKey);
    final widthFactor = math.max(.18, rung.lockDays / maxDays);
    return Row(
      children: [
        SizedBox(
          width: EarnSpacingTokens.savingsLadderTimelineLabelWidth,
          child: Text(
            '${rung.asset} ${rung.lockDays}D',
            textAlign: TextAlign.right,
            style: savingsLadderMicroBoldStyle.copyWith(color: color),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Stack(
            children: [
              const SizedBox(
                height: _timelineBarHeight,
                child: Material(
                  color: AppColors.surface3,
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: SizedBox(
                  height: _timelineBarHeight,
                  child: Material(
                    color: color.withValues(alpha: .18),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(color: color.withValues(alpha: .3)),
                    ),
                    child: Padding(
                      padding: EarnSpacingTokens.earnHorizontalPaddingX2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${savingsLadderMoney(rung.amountUsd)} · ${rung.apyPct.toStringAsFixed(1)}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MaturityTile extends StatelessWidget {
  const _MaturityTile({required this.rung});

  final SavingsLadderRungDraft rung;

  @override
  Widget build(BuildContext context) {
    final color = savingsLadderColorFor(rung.colorKey);
    final parts = rung.maturityDate.split('/');
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox(
            width: EarnSpacingTokens.savingsLadderMaturityBadgeWidth,
            height: _maturityBadgeHeight,
            child: Material(
              color: color.withValues(alpha: .12),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.mdRadius,
                side: BorderSide(color: color.withValues(alpha: .25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    parts.first,
                    style: savingsLadderCaptionBoldStyle.copyWith(color: color),
                  ),
                  Text(
                    'T${parts[1]}',
                    style: AppTextStyles.micro.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rung.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: savingsLadderCaptionBoldStyle.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${savingsLadderMoney(rung.amountUsd)} · ${rung.apyPct.toStringAsFixed(1)}% APY',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${savingsLadderMoney(savingsLadderInterestForTerm(rung))}',
                style: savingsLadderCaptionBoldStyle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                rung.autoRenew ? 'Tự gia hạn' : 'Dừng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashFlowCard extends StatelessWidget {
  const _CashFlowCard({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (final rung in rungs) ...[
            DetailRow(
              label: rung.maturityDate,
              value:
                  'Vốn ${savingsLadderMoney(rung.amountUsd)}  +${savingsLadderMoney(savingsLadderInterestForTerm(rung))}',
              color: AppColors.buy,
            ),
            if (rung != rungs.last) const Divider(color: AppColors.divider),
          ],
          const Divider(color: AppColors.divider),
          DetailRow(
            label: 'Tổng',
            value:
                '${savingsLadderMoney(savingsLadderTotalAllocated(rungs))}  +${savingsLadderMoney(rungs.fold<double>(0, (total, rung) => total + savingsLadderInterestForTerm(rung)))}',
            color: AppColors.buy,
          ),
        ],
      ),
    );
  }
}
