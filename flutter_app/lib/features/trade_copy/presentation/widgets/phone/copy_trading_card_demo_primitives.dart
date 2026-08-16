import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

class CopyTradingTrendPill extends StatelessWidget {
  const CopyTradingTrendPill({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label:
          '${value >= 0 ? '+' : '-'}${value.abs().toStringAsFixed(1)}% vs last month',
      accentColor: value >= 0 ? AppColors.buy : AppColors.sell,
      size: VitStatusPillSize.sm,
    );
  }
}

class CopyTradingTrendSmall extends StatelessWidget {
  const CopyTradingTrendSmall({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${value >= 0 ? '+' : '-'}${value.abs().toStringAsFixed(1)}%',
      style: AppTextStyles.micro.copyWith(
        color: value >= 0 ? AppColors.buy : AppColors.sell,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class CopyTradingSmallButton extends StatelessWidget {
  const CopyTradingSmallButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: TradeSpacingTokens.tradeBotCopyDemoInlinePadding,
      borderColor: AppColors.primary20,
      background: const ColoredBox(color: AppColors.primary15),
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.primary,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class CopyTradingBadge extends StatelessWidget {
  const CopyTradingBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: AppColors.buy,
      size: VitStatusPillSize.sm,
    );
  }
}

class CopyTradingIconLine extends StatelessWidget {
  const CopyTradingIconLine({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TradeSpacingTokens.tradeBotCopyDemoLinePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.buy,
            size:
                TradeSpacingTokens.tradeBotSmallIcon +
                AppSpacing.hairlineStroke,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

String formatCopyTradingUsd(int value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(2)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$$value';
}

String formatCopyTradingCompact(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
