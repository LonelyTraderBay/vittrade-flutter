part of 'tax_report_center_page.dart';

class _ReportStatusBadge extends StatelessWidget {
  const _ReportStatusBadge({required this.status});

  final TaxReportStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TaxReportStatus.ready => AppColors.buy,
      TaxReportStatus.generating => AppColors.warn,
      TaxReportStatus.error => AppColors.sell,
    };
    final background = switch (status) {
      TaxReportStatus.ready => AppColors.buy10,
      TaxReportStatus.generating => AppColors.warn10,
      TaxReportStatus.error => AppColors.sell10,
    };

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: CrossModuleSpacingTokens.crossModulePillPadding,
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.chartLabelTiny.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _TaxSettingsTab extends StatelessWidget {
  const _TaxSettingsTab({
    required this.includeArena,
    required this.onToggleArena,
  });

  final bool includeArena;
  final VoidCallback onToggleArena;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Report Settings',
          children: [
            VitCard(
              padding: CrossModuleSpacingTokens.crossModuleCardPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Include Arena Points',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Show Arena activity in reports (typically non-taxable)',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ToggleSwitch(
                    key: TaxReportCenterPage.includeArenaKey,
                    enabled: includeArena,
                    onTap: onToggleArena,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          padding: CrossModuleSpacingTokens.crossModuleCardPadding,
          radius: VitCardRadius.large,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tax Resources',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              for (final resource in const [
                'IRS Publication 544 - Sales and Other Dispositions',
                'Form 8949 - Sales and Dispositions of Capital Assets',
                'Schedule D - Capital Gains and Losses',
                'Crypto Tax Guide by IRS',
              ])
                Padding(
                  padding:
                      CrossModuleSpacingTokens.crossModuleTrailingRowPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          resource,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _ImportantNoticeCard(),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const CrossModuleInfoPanel(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          border: AppColors.primary20,
          text:
              'Tax reports aggregate data from all modules. Each transaction includes timestamp, type, amount, and gain/loss calculation.',
        ),
      ],
    );
  }
}

class _ImportantNoticeCard extends StatelessWidget {
  const _ImportantNoticeCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.sell10,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.sell20),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: CrossModuleSpacingTokens.crossModuleCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.sell,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important Notice',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Text(
                        'This platform does not provide tax advice. Tax reports are generated for your convenience only. Please consult a qualified tax professional or accountant for accurate tax filing guidance specific to your jurisdiction.',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            for (final note in const [
              'Reports may not include all taxable events',
              'Tax laws vary by jurisdiction',
              'Accuracy depends on transaction data quality',
              'Arena Points are typically non-taxable but check local laws',
              'We are not tax advisors or accountants',
            ])
              Padding(
                padding: CrossModuleSpacingTokens.crossModuleTrailingRowPadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: AppColors.text3,
                      size: AppSpacing.x2,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        note,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      width: AppSpacing.inputHeight,
      height: AppSpacing.x6,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: enabled ? AppColors.primary : AppColors.toggleTrackOff,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
        ),
        child: Padding(
          padding: CrossModuleSpacingTokens.crossModuleTogglePadding,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 160),
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: const SizedBox.square(
              dimension: AppSpacing.x5,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.navCenterIcon,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _ActivityVisual {
  const _ActivityVisual({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;
}

_ActivityVisual _activityVisual(TaxActivityModuleId module) {
  return switch (module) {
    TaxActivityModuleId.trading => const _ActivityVisual(
      icon: Icons.bar_chart_rounded,
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    TaxActivityModuleId.p2p => const _ActivityVisual(
      icon: Icons.shopping_cart_outlined,
      color: AppModuleAccents.p2p,
      background: AppColors.warn10,
    ),
    TaxActivityModuleId.predictions => const _ActivityVisual(
      icon: Icons.track_changes_rounded,
      color: AppModuleAccents.predictions,
      background: AppColors.accent10,
    ),
    TaxActivityModuleId.dca => const _ActivityVisual(
      icon: Icons.show_chart_rounded,
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    TaxActivityModuleId.wallet => const _ActivityVisual(
      icon: Icons.account_balance_wallet_outlined,
      color: AppModuleAccents.wallet,
      background: AppColors.primary12,
    ),
    TaxActivityModuleId.arena => const _ActivityVisual(
      icon: Icons.bolt_rounded,
      color: AppModuleAccents.arena,
      background: AppColors.warn10,
    ),
  };
}

String _formatLabel(TaxExportFormat format) {
  return switch (format) {
    TaxExportFormat.pdf => 'PDF',
    TaxExportFormat.csv => 'CSV',
    TaxExportFormat.excel => 'Excel',
  };
}

String _formatInteger(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
}

String _formatMoney(int value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatInteger(value.abs())}';
}
