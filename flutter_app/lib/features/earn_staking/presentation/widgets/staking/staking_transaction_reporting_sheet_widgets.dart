part of '../../phone/pages/staking/staking_transaction_reporting_page.dart';

class _MethodSheet extends StatelessWidget {
  const _MethodSheet({
    required this.methods,
    required this.selected,
    required this.onChanged,
  });

  final List<StakingCostBasisMethodDraft> methods;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingTransactionReportingPage.methodSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'Select Cost Basis Method'),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (final method in methods) ...[
            _MethodOption(
              method: method,
              selected: method.value == selected,
              onTap: () => onChanged(method.value),
            ),
            if (method != methods.last)
              const SizedBox(height: AppSpacing.rowGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: _transactionReportingCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Once you choose a method for a tax year, use it consistently. Consult a tax professional for guidance.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: _transactionReportingNoticeLineHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final StakingCostBasisMethodDraft method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.methodKey(method.value),
      onTap: onTap,
      borderColor: selected ? AppColors.primary : null,
      padding: _transactionReportingCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.primary : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method.label, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  method.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _transactionReportingMethodLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportSheet extends StatelessWidget {
  const _ExportSheet({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingTransactionReportingPage.exportSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'Export Options'),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ExportGroup(title: 'Tax Forms (PDF)', options: snapshot.taxForms),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ExportGroup(
            title: 'Third-Party Integrations',
            options: snapshot.integrations,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ExportGroup(title: 'Raw Data', options: snapshot.rawDataFormats),
        ],
      ),
    );
  }
}

class _ExportGroup extends StatelessWidget {
  const _ExportGroup({required this.title, required this.options});

  final String title;
  final List<StakingTaxExportOptionDraft> options;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: AppColors.primarySoft,
      density: VitDensity.compact,
      children: [
        for (final option in options)
          VitCard(
            key: StakingTransactionReportingPage.exportOptionKey(option.name),
            onTap: () => Navigator.of(context).pop(),
            padding: _transactionReportingCardPadding,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.name, style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        option.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.contentPad,
          top: AppSpacing.contentPad,
          right: AppSpacing.contentPad,
          bottom: AppSpacing.contentPad,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.cardLargeRadius,
            padding: _transactionReportingCardPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        VitIconButton(
          icon: Icons.close_rounded,
          tooltip: 'Close',
          onPressed: () => Navigator.of(context).pop(),
          variant: VitIconButtonVariant.transparent,
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.footerKey,
      variant: VitCardVariant.inner,
      padding: _transactionReportingCardPadding,
      child: VitRiskDisclaimerNote(
        message: note,
        height: _transactionReportingBodyLineHeight,
      ),
    );
  }
}

String _tabLabel(_ReportingTab tab) {
  return switch (tab) {
    _ReportingTab.summary => 'Summary',
    _ReportingTab.transactions => 'Transactions',
    _ReportingTab.export => 'Export',
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'stake' => 'Staked',
    'unstake' => 'Unstaked',
    'reward' => 'Reward',
    _ => type,
  };
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
}
