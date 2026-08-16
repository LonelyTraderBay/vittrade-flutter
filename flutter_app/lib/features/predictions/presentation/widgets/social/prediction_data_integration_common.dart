part of '../../phone/pages/social/prediction_data_integration_page.dart';

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: PredictionsSpacingTokens.predictionDataCompactLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(
                width: PredictionsSpacingTokens.predictionDataMetricIconGap,
              ),
              Icon(
                trailingIcon,
                color: color,
                size: PredictionsSpacingTokens.predictionDataMetricIcon,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MiniStatusPill extends StatelessWidget {
  const _MiniStatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDataStatusPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: PredictionsSpacingTokens.predictionDataCompactLineHeight,
          ),
        ),
      ),
    );
  }
}

class _NeutralChip extends StatelessWidget {
  const _NeutralChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDataNeutralChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

class _InlineIconButton extends StatelessWidget {
  const _InlineIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text3,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: PredictionsSpacingTokens.predictionDataInlineButtonSize,
      height: PredictionsSpacingTokens.predictionDataInlineButtonSize,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: AppSpacing.zeroInsets,
      child: Icon(
        icon,
        color: color,
        size: PredictionsSpacingTokens.predictionDataInlineIcon,
      ),
    );
  }
}

class _PrimaryBlueButton extends StatelessWidget {
  const _PrimaryBlueButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      density: VitDensity.compact,
      leading: Icon(icon),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(icon: icon, color: _predictionPrimary, message: message);
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(
      icon: Icons.error_outline_rounded,
      color: AppColors.sell,
      message: message,
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitInfoCallout(
      message: message,
      icon: icon,
      accentColor: color,
      iconSize: PredictionsSpacingTokens.predictionDataNoticeIcon,
      padding: VitDensity.compact.cardPadding,
      messageStyle: AppTextStyles.micro.copyWith(
        height: PredictionsSpacingTokens.predictionDataMetricLineHeight,
      ),
    );
  }
}

Color _sourceStatusColor(PredictionDataSourceStatus status) {
  return switch (status) {
    PredictionDataSourceStatus.active => AppColors.buy,
    PredictionDataSourceStatus.inactive => AppColors.text3,
    PredictionDataSourceStatus.error => AppColors.sell,
  };
}

String _sourceStatusLabel(PredictionDataSourceStatus status) {
  return switch (status) {
    PredictionDataSourceStatus.active => 'ACTIVE',
    PredictionDataSourceStatus.inactive => 'INACTIVE',
    PredictionDataSourceStatus.error => 'ERROR',
  };
}

Color _apiKeyStatusColor(PredictionApiKeyStatus status) {
  return switch (status) {
    PredictionApiKeyStatus.active => AppColors.buy,
    PredictionApiKeyStatus.revoked => AppColors.sell,
  };
}

String _apiKeyStatusLabel(PredictionApiKeyStatus status) {
  return switch (status) {
    PredictionApiKeyStatus.active => 'ACTIVE',
    PredictionApiKeyStatus.revoked => 'REVOKED',
  };
}

Color _webhookStatusColor(PredictionWebhookStatus status) {
  return switch (status) {
    PredictionWebhookStatus.active => AppColors.buy,
    PredictionWebhookStatus.inactive => AppColors.text3,
  };
}

String _webhookStatusLabel(PredictionWebhookStatus status) {
  return switch (status) {
    PredictionWebhookStatus.active => 'ACTIVE',
    PredictionWebhookStatus.inactive => 'INACTIVE',
  };
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) {
    return '${value.toStringAsFixed(0)}%';
  }
  return '${value.toStringAsFixed(1)}%';
}

String _maskKey(String key) {
  final parts = key.split('_');
  if (parts.length >= 3) {
    return '${parts[0]}_${parts[1]}_${List.filled(parts[2].length, '*').join()}';
  }
  return List.filled(key.length, '*').join();
}
