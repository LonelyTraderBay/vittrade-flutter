part of '../../phone/pages/futures/leverage_page.dart';

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.margin, required this.preview});

  final double margin;
  final TradeFuturesLeveragePreview preview;

  @override
  Widget build(BuildContext context) {
    final rows = [
      (
        'Giá trị hợp đồng',
        '\$${_formatWholeNumber(preview.positionSize)}',
        AppColors.text1,
      ),
      (
        'Thanh lý cách giá vào',
        '~${preview.liquidationDistancePct.toStringAsFixed(1)}%',
        AppColors.sell,
      ),
      (
        'Phí mở vị thế (0.02%)',
        '\$${preview.openFee.toStringAsFixed(4)}',
        AppColors.warn,
      ),
      (
        'Lợi nhuận nếu +1%',
        '+\$${preview.profitAtOnePct.toStringAsFixed(2)}',
        AppColors.buy,
      ),
      (
        'Lỗ nếu -1%',
        '-\$${preview.lossAtOnePct.toStringAsFixed(2)}',
        AppColors.sell,
      ),
    ];

    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _leverageCardSpace,
        top: _leverageCardSpace,
        right: _leverageCardSpace,
        bottom: _leverageCardSpace,
      ),
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: _tradePrimary,
                size: TradeSpacingTokens.tradeTpslIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Ước tính tác động',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _leverageSpace),
          Text(
            'Với ký quỹ \$${_formatWholeNumber(margin)} USDT',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _leverageSpace),
          for (final row in rows)
            _ImpactRow(label: row.$1, value: row.$2, valueColor: row.$3),
        ],
      ),
    );
  }
}

class _ImpactRow extends StatelessWidget {
  const _ImpactRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.zeroInsets.copyWith(
            top: WalletSpacingTokens.transferCardGap,
            bottom: WalletSpacingTokens.transferCardGap,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _leverageImpactRowLineHeight,
                  ),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.numericCode.copyWith(
                  color: valueColor,
                  fontWeight: AppTextStyles.bold,
                  height: _leverageImpactRowLineHeight,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({
    required this.preview,
    required this.status,
    this.errorMessage,
  });

  final TradeFuturesLeveragePreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: status.uiState,
      title: switch (status.uiState) {
        VitHighRiskUiState.submitting => 'Đang điều chỉnh đòn bẩy',
        VitHighRiskUiState.success => 'Đã điều chỉnh đòn bẩy',
        VitHighRiskUiState.error => 'Điều chỉnh đòn bẩy thất bại',
        VitHighRiskUiState.offline => 'Mất kết nối',
        _ => 'Leverage risk review',
      },
      message: switch (status.uiState) {
        VitHighRiskUiState.submitting =>
          'Đang gửi yêu cầu điều chỉnh. Vui lòng chờ trong giây lát.',
        VitHighRiskUiState.error || VitHighRiskUiState.offline =>
          errorMessage ?? 'Không điều chỉnh được đòn bẩy. Vui lòng thử lại.',
        _ => preview.warningText,
      },
      contractId: 'SC-058 ${preview.leverage}x',
      density: VitDensity.tool,
    );
  }
}

class _RiskTipsCard extends StatelessWidget {
  const _RiskTipsCard();

  static const _tips = [
    'Luôn đặt Stop Loss để giới hạn lỗ',
    'Không sử dụng quá 5% tổng vốn cho 1 lệnh',
    'Theo dõi vị thế thường xuyên',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.sell.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.sell,
                size: TradeSpacingTokens.tradeTpslIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Lưu ý quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _leverageSpace),
          for (final tip in _tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.zeroInsets.copyWith(top: AppSpacing.x1),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.sell,
                    size: AppSpacing.iconSm,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != _tips.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.leverage,
    required this.submitting,
    required this.onPressed,
  });

  final int leverage;
  final bool submitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: LeveragePage.confirmKey,
      onPressed: submitting ? null : onPressed,
      loading: submitting,
      density: VitDensity.tool,
      height: AppSpacing.searchBarCompactHeight,
      variant: leverage > 20
          ? VitCtaButtonVariant.danger
          : VitCtaButtonVariant.primary,
      child: Text(
        submitting ? 'Đang điều chỉnh…' : 'Xác nhận đòn bẩy ${leverage}x',
        style: AppTextStyles.baseMedium.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _formatWholeNumber(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}
