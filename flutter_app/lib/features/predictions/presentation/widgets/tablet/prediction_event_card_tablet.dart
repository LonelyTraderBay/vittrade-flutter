import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_outcome_widgets.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_time_remaining.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Thẻ sự kiện dự đoán dùng chung cho các trang tablet (hub SC-208, tìm kiếm
/// SC-209, biến động SC-210) — tái composition thẻ phone SC-027 với token
/// tablet, kết quả nhị phân hiển thị thanh xác suất 2 màu.
class PredictionEventCardTablet extends StatelessWidget {
  const PredictionEventCardTablet({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    final isMulti = event.outcomes.length > 2;
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionSmallBadge(
                label: event.category,
                color: AppColors.primary,
                background: AppColors.primary.withValues(alpha: .12),
              ),
              const Spacer(),
              Text(
                predictionsTimeRemaining(event.endDate),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          if (isMulti)
            PredictionMultiOutcomeRow(event: event)
          else
            _TabletBinaryOutcomeBar(outcomes: outcomes),
        ],
      ),
    );
  }
}

class _TabletBinaryOutcomeBar extends StatelessWidget {
  const _TabletBinaryOutcomeBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    final yesColor = yes.tone.resolve();
    final noColor = no.tone.resolve();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${yes.label} ${yes.chance}%',
              style: AppTextStyles.badge.copyWith(
                color: yesColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            Text(
              '${no.label} ${no.chance}%',
              style: AppTextStyles.badge.copyWith(
                color: noColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        ClipRRect(
          borderRadius: AppRadii.badgeRadius,
          child: SizedBox(
            height: TabletSpacingTokens.x3,
            child: Row(
              children: [
                Expanded(
                  flex: yes.chance,
                  child: ColoredBox(color: yesColor),
                ),
                Expanded(
                  flex: no.chance,
                  child: ColoredBox(color: noColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
