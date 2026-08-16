part of '../phone/pages/vip_page.dart';

List<Widget> _vipPageChildren({
  required BuildContext context,
  required ProfileVipSnapshot snapshot,
  required _VipTab selectedTab,
  required ValueChanged<_VipTab> onTabChanged,
  required VoidCallback onTrade,
}) {
  return switch (snapshot.screenState) {
    ProfileScreenState.loading => [
      const VitSkeletonList(key: VIPPage.loadingKey, rows: 4),
    ],
    ProfileScreenState.error => [
      VitErrorState(
        key: VIPPage.errorKey,
        title:
            'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c ch\u01B0\u01A1ng tr\u00ECnh VIP',
        message: 'Ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
        actionLabel: 'Th\u1EED l\u1EA1i',
        onAction: () => context.go(AppRoutePaths.profileVip),
      ),
    ],
    ProfileScreenState.empty => [
      const VitEmptyState(
        key: VIPPage.emptyKey,
        title: 'Ch\u01B0a c\u00F3 d\u1EEF li\u1EC7u VIP',
        message:
            'Th\u00F4ng tin h\u1EA1ng VIP s\u1EBD hi\u1EC3n th\u1ECB sau khi \u0111\u1ED3ng b\u1ED9.',
        icon: Icons.workspace_premium_outlined,
      ),
    ],
    ProfileScreenState.offline => [
      const VitOfflineBanner(
        key: VIPPage.offlineKey,
        message: '\u0110ang ngo\u1EA1i tuy\u1EBFn',
        detail:
            'Hi\u1EC3n th\u1ECB d\u1EEF li\u1EC7u VIP \u0111\u00E3 l\u01B0u g\u1EA7n nh\u1EA5t.',
      ),
      ..._vipReadySections(
        snapshot: snapshot,
        selectedTab: selectedTab,
        onTabChanged: onTabChanged,
        onTrade: onTrade,
      ),
    ],
    _ => _vipReadySections(
      snapshot: snapshot,
      selectedTab: selectedTab,
      onTabChanged: onTabChanged,
      onTrade: onTrade,
    ),
  };
}

List<Widget> _vipReadySections({
  required ProfileVipSnapshot snapshot,
  required _VipTab selectedTab,
  required ValueChanged<_VipTab> onTabChanged,
  required VoidCallback onTrade,
}) {
  return [
    _VipHero(snapshot: snapshot),
    _VipTabs(active: selectedTab, onChanged: onTabChanged),
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: _vipTabContent(
        selectedTab: selectedTab,
        snapshot: snapshot,
        onTrade: onTrade,
      ),
    ),
  ];
}

Widget _vipTabContent({
  required _VipTab selectedTab,
  required ProfileVipSnapshot snapshot,
  required VoidCallback onTrade,
}) {
  return switch (selectedTab) {
    _VipTab.overview => _OverviewTab(
      key: const ValueKey('overview'),
      snapshot: snapshot,
    ),
    _VipTab.benefits => _BenefitsTab(
      key: const ValueKey('benefits'),
      snapshot: snapshot,
      onTrade: onTrade,
    ),
    _VipTab.history => VipHistoryTab(
      key: const ValueKey('history'),
      snapshot: snapshot,
    ),
  };
}

class _VipHero extends StatelessWidget {
  const _VipHero({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final currentTier = snapshot.currentTier;
    return VitModuleHeroCard(
      accentColor: _vipGold,
      density: VitDensity.compact,
      child: ClipRRect(
        borderRadius: AppRadii.cardLargeRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: VitHeroGlow(
                center: const Alignment(.75, -.75),
                radius: 1.2,
                colors: [
                  _vipGold.withValues(alpha: .18),
                  AppColors.primary08,
                  AppColors.transparent,
                ],
                stops: const [0, .38, 1],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _TierIcon(tier: currentTier, large: true),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                color: _vipGold,
                                size: ProfileSpacingTokens
                                    .profileVipHeroBadgeIcon,
                              ),
                              const SizedBox(
                                width:
                                    ProfileSpacingTokens.profileVipHeroTitleGap,
                              ),
                              Flexible(
                                child: Text(
                                  currentTier.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    color: _vipGold,
                                    fontWeight: AppTextStyles.heavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: VitDensity.compact.verticalSpace),
                          Text(
                            'Th\u00E0nh vi\u00EAn t\u1EEB ${snapshot.memberSince}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.portfolioTextDim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: ProfileSpacingTokens.profileVipHeroStatusGap,
                    ),
                    VitStatusPill(
                      label: currentTier.badge,
                      status: VitStatusPillStatus.orange,
                      outline: true,
                    ),
                  ],
                ),
                SizedBox(height: VitDensity.compact.verticalSpace),
                Row(
                  children: [
                    Expanded(
                      child: _HeroFeeBox(
                        label: 'Maker fee',
                        value: _formatFee(currentTier.makerFee),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(
                      child: _HeroFeeBox(
                        label: 'Taker fee',
                        value: _formatFee(currentTier.takerFee),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroFeeBox extends StatelessWidget {
  const _HeroFeeBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: VitDensity.compact.controlHeight),
      child: Material(
        color: AppColors.onAccent.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.onAccent.withValues(alpha: .08)),
        ),
        child: Padding(
          padding: ProfileSpacingTokens.profileHeroInfoPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: VitDensity.compact.verticalSpace),
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: _vipSuccess,
                  fontWeight: AppTextStyles.heavy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VipTabs extends StatelessWidget {
  const _VipTabs({required this.active, required this.onChanged});

  final _VipTab active;
  final ValueChanged<_VipTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_VipTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: 'overview',
          label: 'T\u1ED5ng quan',
          widgetKey: VIPPage.tabKey('overview'),
        ),
        VitTabItem(
          key: 'benefits',
          label: '\u0110\u1EB7c quy\u1EC1n',
          widgetKey: VIPPage.tabKey('benefits'),
        ),
        VitTabItem(
          key: 'history',
          label: 'L\u1ECBch s\u1EED',
          widgetKey: VIPPage.tabKey('history'),
        ),
      ],
    );
  }
}
