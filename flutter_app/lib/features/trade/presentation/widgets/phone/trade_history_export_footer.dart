part of '../../phone/pages/hub/trade_history_export_page.dart';

class _TaxNote extends StatelessWidget {
  const _TaxNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: _tradePrimary.withValues(alpha: .18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: _tradePrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'File xuất phục vụ mục đích lưu trữ và khai thuế. Không phải tài liệu '
              'chính thức về thuế. Tham khảo ý kiến chuyên gia thuế cho trường hợp cụ thể.',
              style: AppTextStyles.navLabel.copyWith(color: _tradePrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportFooter extends StatelessWidget {
  const _ExportFooter({
    required this.format,
    required this.period,
    required this.isExporting,
    required this.result,
    required this.onExport,
    required this.onNewExport,
  });

  final String format;
  final String period;
  final bool isExporting;
  final TradeExportResult? result;
  final VoidCallback onExport;
  final VoidCallback onNewExport;

  @override
  Widget build(BuildContext context) {
    final exported = result != null;

    return Material(
      color: AppColors.surface2,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        child: exported
            ? Row(
                children: [
                  Expanded(
                    child: VitCtaButton(
                      key: TradeHistoryExportPage.newExportKey,
                      variant: VitCtaButtonVariant.secondary,
                      density: VitDensity.tool,
                      onPressed: onNewExport,
                      child: const Text('Tạo mới'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    flex: TradeSpacingTokens.tradeToolFooterButtonFlex,
                    child: VitCtaButton(
                      key: TradeHistoryExportPage.downloadKey,
                      variant: VitCtaButtonVariant.success,
                      density: VitDensity.tool,
                      onPressed: () => _showComingSoon(context),
                      leading: const Icon(Icons.file_download_outlined),
                      child: Text('Tải ${format.toUpperCase()}'),
                    ),
                  ),
                ],
              )
            : VitCtaButton(
                key: TradeHistoryExportPage.exportKey,
                variant: VitCtaButtonVariant.primary,
                density: VitDensity.tool,
                loading: isExporting,
                onPressed: isExporting ? null : onExport,
                leading: Icon(
                  isExporting
                      ? Icons.schedule_outlined
                      : Icons.file_download_outlined,
                ),
                child: Text(
                  isExporting
                      ? 'Đang tạo file...'
                      : 'Xuất ${format.toUpperCase()} ($period)',
                ),
              ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Tải file xuất',
        message: 'Tải file xuất sẽ sớm ra mắt',
      ),
    );
  }
}

String _formatInteger(int value) => formatTradeInt(value);

String _formatCompact(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return _formatMoney(value);
}

String _formatMoney(double value) => formatTradeUsd(value);
