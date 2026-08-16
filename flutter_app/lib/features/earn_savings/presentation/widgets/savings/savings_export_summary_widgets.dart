part of '../../phone/pages/savings/savings_export_page.dart';

class _ExportSummary extends StatelessWidget {
  const _ExportSummary({
    required this.snapshot,
    required this.selectedReport,
    required this.selectedFormat,
  });

  final SavingsExportSnapshot snapshot;
  final SavingsExportReportType selectedReport;
  final SavingsExportFormat selectedFormat;

  @override
  Widget build(BuildContext context) {
    final report = snapshot.reportTypes.firstWhere(
      (item) => item.id == selectedReport,
      orElse: () => snapshot.reportTypes.first,
    );

    return VitCard(
      key: SavingsExportPage.summaryRowsKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.visibility_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tóm tắt',
                style: _captionBold.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Số dòng',
                  value: report.rowsLabel.split(' ').first,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Kích thước',
                  value: snapshot.summaryFileSize,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Định dạng',
                  value: _formatLabel(selectedFormat),
                  accent: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.accent = false,
  });

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(
              color: accent ? AppModuleAccents.earn : AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewReadyBanner extends StatelessWidget {
  const _PreviewReadyBanner({required this.format});

  final SavingsExportFormat format;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsExportPage.previewBannerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppModuleAccents.earn.withValues(alpha: 0.2),
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppModuleAccents.earn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Bản xem trước ${_formatLabel(format)} đã sẵn sàng để tải xuống.',
              style: _captionBold.copyWith(color: AppColors.text1),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.history});

  final List<SavingsExportHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsExportPage.historyListKey,
      children: [
        for (final item in history) ...[
          _HistoryCard(item: item),
          if (item != history.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final SavingsExportHistoryDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(item.status);

    return VitCard(
      key: SavingsExportPage.historyKey(item.id),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _RoundIcon(icon: Icons.description_outlined, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_reportTypeLabel(item.reportType)} · ${_formatLabel(item.format)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitAccentPill(
                label: _statusLabel(item.status),
                accentColor: color,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetaText(label: 'Kỳ', value: item.period),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetaText(label: 'Dung lượng', value: item.fileSize),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Tạo ${item.createdAt} · Hết hạn ${item.expiresAt}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _microBold.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: EarnSpacingTokens.earnExportSelectionDot,
      height: EarnSpacingTokens.earnExportSelectionDot,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(color: selected ? color : AppColors.borderSolid),
          ),
        ),
        child: selected
            ? Center(
                child: SizedBox(
                  width: EarnSpacingTokens.earnExportSelectionDotInner,
                  height: EarnSpacingTokens.earnExportSelectionDotInner,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: color,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'download' => Icons.file_download_outlined,
    'upload' => Icons.file_upload_outlined,
    'shield' => Icons.shield_outlined,
    'portfolio' => Icons.account_balance_wallet_outlined,
    'trend' => Icons.trending_up_rounded,
    'filter' => Icons.filter_alt_outlined,
    'bolt' => Icons.bolt_outlined,
    'info' => Icons.info_outline_rounded,
    'chart' => Icons.show_chart_rounded,
    'settings' => Icons.tune_rounded,
    'mail' => Icons.mail_outline_rounded,
    _ => Icons.description_outlined,
  };
}

String _formatLabel(SavingsExportFormat format) {
  return switch (format) {
    SavingsExportFormat.csv => 'CSV',
    SavingsExportFormat.pdf => 'PDF',
    SavingsExportFormat.xlsx => 'Excel',
  };
}

String _reportTypeLabel(SavingsExportReportType type) {
  return switch (type) {
    SavingsExportReportType.transaction => 'Lịch sử giao dịch',
    SavingsExportReportType.tax => 'Báo cáo thuế',
    SavingsExportReportType.portfolio => 'Ảnh chụp danh mục',
    SavingsExportReportType.performance => 'Hiệu suất đầu tư',
  };
}

String _statusLabel(SavingsExportStatus status) {
  return switch (status) {
    SavingsExportStatus.ready => 'Sẵn sàng',
    SavingsExportStatus.generating => 'Đang tạo',
    SavingsExportStatus.completed => 'Hoàn tất',
    SavingsExportStatus.failed => 'Lỗi',
  };
}

Color _statusColor(SavingsExportStatus status) {
  return switch (status) {
    SavingsExportStatus.ready => AppModuleAccents.earn,
    SavingsExportStatus.generating => AppColors.warn,
    SavingsExportStatus.completed => AppModuleAccents.earn,
    SavingsExportStatus.failed => AppColors.sell,
  };
}
