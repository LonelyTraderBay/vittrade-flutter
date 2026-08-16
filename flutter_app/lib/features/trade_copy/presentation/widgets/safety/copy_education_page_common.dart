part of '../../phone/pages/safety/copy_education_page.dart';

class _ConceptRow extends StatelessWidget {
  const _ConceptRow({required this.concept});

  final TradeCopyConceptGuide concept;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          _iconFor(concept.iconName),
          color: _copyPrimary,
          size: WalletSpacingTokens.walletAddressSectionIcon,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                concept.term,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(
                height: WalletSpacingTokens.walletAddressCompactGap,
              ),
              Text(
                concept.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SupplementalTabContent extends StatelessWidget {
  const _SupplementalTabContent({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    final title = switch (activeTab) {
      'scenarios' => 'Kịch bản Copy Trading',
      'fees' => 'Phí & Chi phí',
      'mistakes' => 'Sai lầm phổ biến',
      'regulatory' => 'Quy định & bảo vệ nhà đầu tư',
      _ => 'Hướng dẫn Copy Trading',
    };
    final description = switch (activeTab) {
      'scenarios' =>
        'Mô phỏng lợi nhuận, lỗ và slippage trước khi bạn copy provider.',
      'fees' =>
        'Tính platform fee, performance fee, trading fee và chi phí ẩn do slippage.',
      'mistakes' =>
        'Nhắc lại các sai lầm thường gặp: chỉ nhìn ROI, không kiểm Max Drawdown, copy toàn bộ vốn.',
      'regulatory' =>
        'Tóm tắt các nghĩa vụ disclosure, cooling-off, appropriateness assessment và quyền dừng copy.',
      _ =>
        'Nội dung giáo dục giúp bạn hiểu rõ cơ chế, rủi ro và chi phí trước khi copy.',
    };

    return _CardShell(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.walletAddressActionGap),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ProviderCta extends StatelessWidget {
  const _ProviderCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: CopyEducationPage.providerCtaKey,
      onPressed: onTap,
      density: VitDensity.tool,
      leading: const Icon(Icons.visibility_outlined),
      height: AppSpacing.buttonCompact,
      child: const Text('Xem danh sách providers'),
    );
  }
}

class _SmallGuideLine extends StatelessWidget {
  const _SmallGuideLine({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: AppSpacing.statusPillIconSizeSm),
        const SizedBox(width: WalletSpacingTokens.walletAddressCompactGap),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

String _tabLabel(TradeCopyEducationTab tab) {
  if (tab.id == 'fees') return 'Phí & Chi\nphí';
  return tab.label;
}

IconData _iconFor(String name) {
  return switch (name) {
    'users' => Icons.group_outlined,
    'target' => Icons.adjust_rounded,
    'zap' => Icons.bolt_outlined,
    'activity' => Icons.show_chart_rounded,
    'down' => Icons.trending_down_rounded,
    'up' => Icons.trending_up_rounded,
    'clock' => Icons.access_time_rounded,
    _ => Icons.info_outline_rounded,
  };
}
