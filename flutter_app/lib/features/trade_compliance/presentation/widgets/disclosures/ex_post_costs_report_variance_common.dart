part of '../../phone/pages/disclosures/ex_post_costs_report_page.dart';

class _VarianceNote {
  const _VarianceNote({required this.amount, required this.kind});

  factory _VarianceNote.lower(double amount) {
    return _VarianceNote(amount: amount, kind: _VarianceNoteKind.lower);
  }

  factory _VarianceNote.higher(double amount) {
    return _VarianceNote(amount: amount, kind: _VarianceNoteKind.higher);
  }

  final double amount;
  final _VarianceNoteKind kind;
}

enum _VarianceNoteKind { lower, higher }

class _VarianceNoteView extends StatelessWidget {
  const _VarianceNoteView({required this.note});

  final _VarianceNote note;

  @override
  Widget build(BuildContext context) {
    final isHigher = note.kind == _VarianceNoteKind.higher;
    final color = isHigher ? _reportAmber : AppColors.text1;
    final bg = isHigher
        ? _reportAmber.withValues(alpha: .12)
        : AppColors.transparent;
    final text = isHigher
        ? '${_formatEur(note.amount)} higher (better performance)'
        : '${_formatEur(note.amount)} lower than estimated';

    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: isHigher ? AppSpacing.x2 : AppSpacing.x1,
      ),
      borderColor: isHigher ? _reportAmber.withValues(alpha: .26) : null,
      background: ColoredBox(color: bg),
      child: Row(
        children: [
          Icon(
            isHigher ? Icons.warning_amber_rounded : Icons.check_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VarianceCard extends StatelessWidget {
  const _VarianceCard({required this.report});

  final TradeExPostCostReport report;

  @override
  Widget build(BuildContext context) {
    final variance = report.variance;
    final higher = variance > 0;
    final text = higher
        ? 'Actual costs were ${_formatEur(variance.abs())} higher than '
              'estimated, mainly due to higher performance fees.'
        : variance < 0
        ? 'Actual costs were ${_formatEur(variance.abs())} lower than '
              'estimated, mainly due to lower transaction costs.'
        : 'Actual costs matched estimates exactly.';

    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: _reportBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Variance',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${higher
                    ? '+'
                    : variance < 0
                    ? '-'
                    : ''}'
                '${_formatEur(variance.abs())}',
                style: AppTextStyles.amountSm.copyWith(
                  color: higher ? _reportRed : _reportGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatEur(double value) => formatTradeEur(value);
