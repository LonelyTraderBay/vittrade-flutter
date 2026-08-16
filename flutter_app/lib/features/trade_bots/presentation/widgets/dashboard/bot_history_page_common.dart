part of '../../phone/pages/dashboard/bot_history_page.dart';

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeBotHistoryTrade trade;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.side == TradeBotHistorySide.buy;
    final sideColor = isBuy ? _historyGreen : _historyRed;
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isBuy
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: sideColor,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(
                          width: TradeSpacingTokens.tradeBotTinyGap,
                        ),
                        VitAccentPill(
                          label: isBuy ? 'MUA' : 'BÁN',
                          accentColor: sideColor,
                        ),
                        const SizedBox(
                          width: TradeSpacingTokens.tradeBotInlineIconGap,
                        ),
                        Text(
                          trade.pair,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      '${trade.botName} · ${trade.strategy}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (trade.pnl != 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatSignedMoney(trade.pnl),
                      style: AppTextStyles.caption.copyWith(
                        color: trade.pnl >= 0 ? _historyGreen : _historyRed,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                    Text(
                      'Lãi/lỗ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _DetailBox(
                  label: 'Số lượng',
                  value: _formatQty(trade.qty),
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotMetricGap),
              Expanded(
                child: _DetailBox(
                  label: 'Giá',
                  value: '\$${_formatNumber(trade.price)}',
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotMetricGap),
              Expanded(
                child: _DetailBox(
                  label: 'Phí',
                  value: '\$${trade.fee.toStringAsFixed(3)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            color: AppColors.borderSolid,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  trade.timestamp,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              VitStatusPill(
                label: _statusLabel(trade.status),
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportNote extends StatelessWidget {
  const _ExportNote({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tùy chọn xuất dữ liệu',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Tải xuống toàn bộ lịch sử giao dịch của bạn để phục vụ báo cáo thuế, kế toán hoặc phân tích. Định dạng khả dụng: CSV, PDF, Excel.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: BotHistoryPage.exportAllKey,
            density: VitDensity.tool,
            height: TradeSpacingTokens.tradeBotSheetActionHeight,
            onPressed: onTap,
            leading: const Icon(Icons.download_rounded),
            child: const Text('Xuất tất cả giao dịch'),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      title: 'Không tìm thấy giao dịch nào',
      icon: Icons.history_rounded,
    );
  }
}

String _statusLabel(String status) {
  return switch (status.toLowerCase()) {
    'filled' => 'Đã khớp',
    'partial' || 'partially_filled' => 'Khớp một phần',
    'cancelled' || 'canceled' => 'Đã hủy',
    'open' => 'Đang mở',
    _ => status,
  };
}

String _formatNumber(double value) {
  final hasFraction = (value - value.truncateToDouble()).abs() > 0.0001;
  final raw = hasFraction
      ? value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')
      : value.toStringAsFixed(0);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return buffer.toString();
}

String _formatQty(double value) {
  final text = value.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
