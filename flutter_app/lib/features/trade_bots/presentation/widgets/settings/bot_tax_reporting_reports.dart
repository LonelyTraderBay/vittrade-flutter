part of '../../phone/pages/settings/bot_tax_reporting_page.dart';

class _ReportTypeCard extends StatelessWidget {
  const _ReportTypeCard({
    required this.report,
    required this.selected,
    required this.onTap,
  });

  final TradeBotTaxReportType report;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotTaxReportingPage.reportKey(report.id),
      onTap: onTap,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: selected ? _taxPrimary : _taxOptionBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckBox(selected: selected),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        report.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? _taxPrimary : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
                    _Pill(
                      text: report.format,
                      color: AppColors.text3,
                      background: _taxPanel2,
                    ),
                    if (report.recommended) ...[
                      const SizedBox(
                        width: TradeSpacingTokens.tradeBotSmallGap,
                      ),
                      const _Pill(
                        text: 'Đề xuất',
                        color: _taxGreen,
                        background: AppColors.buy12,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  report.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.summary, required this.breakdown});

  final TradeBotTaxSummary summary;
  final TradeBotTaxBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          _BreakdownRow(
            title: breakdown.shortTermLabel,
            description: breakdown.shortTermDescription,
            value: '+${_formatUsd(summary.shortTermGains)}',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _BreakdownRow(
            title: breakdown.longTermLabel,
            description: breakdown.longTermDescription,
            value: '+${_formatUsd(summary.longTermGains)}',
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.title,
    required this.description,
    required this.value,
  });

  final String title;
  final String description;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _taxGreen,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TaxNotesCard extends StatelessWidget {
  const _TaxNotesCard({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lưu ý thuế quan trọng',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final note in notes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.circle,
                  color: AppColors.text3,
                  size: AppSpacing.x1,
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
                Expanded(
                  child: Text(
                    note,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
            if (note != notes.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _GenerateFooter extends StatelessWidget {
  const _GenerateFooter({
    required this.bottomInset,
    required this.disabled,
    required this.generating,
    required this.selectedCount,
    required this.selectedYear,
    required this.onPressed,
  });

  final double bottomInset;
  final bool disabled;
  final bool generating;
  final int selectedCount;
  final String selectedYear;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final child = VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        AppSpacing.x2,
      ),
      borderColor: AppColors.borderSolid,
      child: VitCtaButton(
        key: BotTaxReportingPage.generateKey,
        onPressed: disabled ? null : onPressed,
        loading: generating,
        density: VitDensity.tool,
        leading: generating ? null : const Icon(Icons.download_rounded),
        child: Text(
          generating
              ? 'Đang tạo báo cáo...'
              : 'Tạo $selectedCount báo cáo cho năm $selectedYear',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: bottomInset),
      child: child,
    );
  }
}
