part of '../../phone/pages/safety/copy_safety_center_page.dart';

class _EnforcementTab extends StatelessWidget {
  const _EnforcementTab({required this.actions});

  final List<TradeCopyEnforcementAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent enforcement actions taken to protect users:',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: _safetySpace),
        for (final action in actions) ...[
          _EnforcementCard(action: action),
          if (action != actions.last) const SizedBox(height: _safetySpace),
        ],
        const SizedBox(height: _safetySpace),
        const _SimpleCard(
          title: 'Transparent enforcement',
          body:
              'All actions are logged. If you believe an action was unfair, contact support.',
          color: _safetyPrimary,
        ),
      ],
    );
  }
}

class _EnforcementCard extends StatelessWidget {
  const _EnforcementCard({required this.action});

  final TradeCopyEnforcementAction action;

  @override
  Widget build(BuildContext context) {
    final color = switch (action.action) {
      'suspended' => AppColors.sell,
      'warned' => AppColors.warn,
      _ => AppColors.buy,
    };
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.copySafetyActionCardPadding,
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: color,
            size: TradeSpacingTokens.tradeBotActionIcon,
          ),
          const SizedBox(width: AppSpacing.cardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.action.toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _safetySpace),
                Text(
                  action.providerName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${action.date} - ${action.reason}',
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

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.title,
    required this.color,
    required this.child,
  });

  final String title;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _safetySpace),
        child,
      ],
    );
  }
}

class _IconTextRow extends StatelessWidget {
  const _IconTextRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.copySafetyIconTextPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: TradeSpacingTokens.copySafetyIconTextIcon,
          ),
          const SizedBox(width: _safetySpace),
          Expanded(
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

class _SimpleCard extends StatelessWidget {
  const _SimpleCard({required this.title, required this.body, this.color});

  final String title;
  final String body;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.text1;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      width: double.infinity,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            body,
            style: AppTextStyles.micro.copyWith(
              color: color ?? AppColors.text3,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyPanel extends StatelessWidget {
  const _EmergencyPanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.modalScrim,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: AppRadii.sheetTopLargeRadius,
            child: ColoredBox(
              color: AppColors.bg,
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitSheetHandle(),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    const Text(
                      'Emergency stop activated',
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: _safetySpace),
                    Text(
                      'All copies would be stopped and positions queued for close in the backend flow.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      onPressed: onClose,
                      density: VitDensity.tool,
                      height: AppSpacing.searchBarCompactHeight,
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
