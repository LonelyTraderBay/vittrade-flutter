part of '../phone/pages/enterprise_states_page.dart';

class _ReferenceBanner extends StatelessWidget {
  const _ReferenceBanner({required this.banner});

  final EnterpriseBannerDraft banner;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: _bannerVariant(banner.kind),
      icon: _bannerIcon(banner.kind),
      message: banner.title,
      detail: banner.detail,
    );
  }
}

class _AppliedSection extends StatelessWidget {
  const _AppliedSection({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '6 màn dữ liệu × 4–5 states. Chọn page và state để preview.',
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ReferenceTile(
          icon: Icons.bar_chart_rounded,
          title: 'MarketListPage',
          subtitle: 'Loading · Empty · Error · Offline',
          actionLabel: 'Mở Markets',
          onTap: () => context.go(snapshot.marketRoute),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _ReferenceTile(
          icon: Icons.history_rounded,
          title: 'OrdersHistoryPage',
          subtitle: 'Gate state requires 2FA before risky actions',
          actionLabel: 'Preview only',
        ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '4 security overlay chuẩn enterprise. Các CTA đi tới route đã migrate hoặc auth shell.',
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ReferenceTile(
          icon: Icons.login_rounded,
          title: 'Session Expired Modal',
          subtitle: 'Phiên đăng nhập đã hết hạn',
          actionLabel: 'Đăng nhập lại',
          actionKey: EnterpriseStatesPage.loginCtaKey,
          onTap: () => context.go(snapshot.loginRoute),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ReferenceTile(
          icon: Icons.verified_user_outlined,
          title: 'KYC Gate Panel',
          subtitle: 'Cần KYC để tiếp tục',
          actionLabel: 'Đi tới KYC',
          onTap: () => context.go(snapshot.kycRoute),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ReferenceTile(
          icon: Icons.key_rounded,
          title: '2FA Gate Panel',
          subtitle: 'Bật 2FA để tiếp tục',
          actionLabel: 'Thiết lập 2FA',
          onTap: () => context.go(snapshot.securityRoute),
        ),
      ],
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    this.actionKey,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Key? actionKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitNextActionCard(
      key: actionKey,
      icon: icon,
      title: title,
      subtitle: subtitle,
      ctaLabel: actionLabel,
      accentColor: AppModuleAccents.enterpriseStates,
      onTap: onTap,
    );
  }
}

String _previewLabel(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return 'Loading';
    case EnterprisePreviewState.empty:
      return 'Empty';
    case EnterprisePreviewState.error:
      return 'Error';
    case EnterprisePreviewState.offline:
      return 'Offline';
    case EnterprisePreviewState.gate:
      return 'Gate';
  }
}

EnterpriseStateSection _sectionFromKey(String key) {
  return EnterpriseStateSection.values.firstWhere(
    (section) => section.name == key,
    orElse: () => EnterpriseStateSection.stateKit,
  );
}

VitBannerVariant _bannerVariant(EnterpriseBannerKind kind) {
  switch (kind) {
    case EnterpriseBannerKind.info:
      return VitBannerVariant.info;
    case EnterpriseBannerKind.warning:
      return VitBannerVariant.warning;
    case EnterpriseBannerKind.error:
      return VitBannerVariant.error;
  }
}

IconData _bannerIcon(EnterpriseBannerKind kind) {
  switch (kind) {
    case EnterpriseBannerKind.info:
      return Icons.bar_chart_rounded;
    case EnterpriseBannerKind.warning:
      return Icons.warning_amber_rounded;
    case EnterpriseBannerKind.error:
      return Icons.report_problem_outlined;
  }
}
