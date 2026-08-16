part of '../../phone/pages/provider/provider_application_page.dart';

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TradeSpacingTokens.providerApplicationStepTitlePadding,
      child: Text(title, style: AppTextStyles.sectionTitle),
    );
  }
}

class _TogglePanel extends StatelessWidget {
  const _TogglePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.active,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool active;
  final String activeLabel;
  final String inactiveLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: icon, title: title),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(description, style: _panelDescriptionStyle),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          VitCtaButton(
            height: AppSpacing.buttonCompact,
            density: VitDensity.tool,
            variant: active
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.primary,
            onPressed: onTap,
            child: Text(active ? activeLabel : inactiveLabel),
          ),
        ],
      ),
    );
  }
}

class _NumberPanel extends StatelessWidget {
  const _NumberPanel({
    required this.title,
    required this.description,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String title;
  final String description;
  final String label;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: Icons.schedule_rounded, title: title),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(description, style: _panelDescriptionStyle),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            fieldKey: ProviderApplicationPage.monthsFieldKey,
            controller: controller,
            hintText: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: icon, title: title),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(description, style: _panelDescriptionStyle),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerApplicationPanelPadding,
      onTap: onTap,
      child: child,
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _providerPrimary, size: 18),
        const SizedBox(width: AppSpacing.x3),
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
      ],
    );
  }
}

TextStyle get _panelDescriptionStyle => AppTextStyles.caption.copyWith(
  color: AppColors.text3,
  height: TradeSpacingTokens.providerApplicationPanelDescriptionLineHeight,
);

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.caption.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: _providerField,
    contentPadding: TradeSpacingTokens.providerApplicationInputContentPadding,
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: AppRadii.inputRadius,
    ),
  );
}

IconData _benefitIcon(String iconName) {
  return switch (iconName) {
    'dollar' => Icons.attach_money_rounded,
    'users' => Icons.groups_2_outlined,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.check_rounded,
  };
}
