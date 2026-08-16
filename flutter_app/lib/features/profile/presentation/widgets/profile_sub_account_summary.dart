part of '../phone/pages/sub_account_page.dart';

List<Widget> _subAccountPageChildren({
  required BuildContext context,
  required ProfileSubAccountsSnapshot snapshot,
  required bool isBalanceHidden,
  required bool showCreate,
  required String? expandedId,
  required VoidCallback onToggleBalance,
  required VoidCallback onToggleCreateForm,
  required ValueChanged<String> onToggleExpanded,
}) {
  return switch (snapshot.screenState) {
    ProfileScreenState.loading => [
      const VitSkeletonList(key: SubAccountPage.loadingKey, rows: 4),
    ],
    ProfileScreenState.error => [
      VitErrorState(
        key: SubAccountPage.errorKey,
        title:
            'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c t\u00E0i kho\u1EA3n ph\u1EE5',
        message: 'Ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
        actionLabel: 'Th\u1EED l\u1EA1i',
        onAction: () => context.go(AppRoutePaths.profileSubAccounts),
      ),
    ],
    ProfileScreenState.empty => [
      const VitEmptyState(
        key: SubAccountPage.emptyKey,
        title: 'Ch\u01B0a c\u00F3 t\u00E0i kho\u1EA3n ph\u1EE5',
        message:
            'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5 \u0111\u1EC3 t\u00E1ch quy\u1EC1n, API v\u00E0 v\u00ED giao d\u1ECBch.',
        icon: Icons.groups_outlined,
      ),
    ],
    ProfileScreenState.offline => [
      const VitOfflineBanner(
        key: SubAccountPage.offlineKey,
        message: '\u0110ang ngo\u1EA1i tuy\u1EBFn',
        detail:
            'Hi\u1EC3n th\u1ECB danh s\u00E1ch t\u00E0i kho\u1EA3n ph\u1EE5 \u0111\u00E3 l\u01B0u.',
      ),
      ..._subAccountReadySections(
        snapshot: snapshot,
        isBalanceHidden: isBalanceHidden,
        showCreate: showCreate,
        expandedId: expandedId,
        onToggleBalance: onToggleBalance,
        onToggleCreateForm: onToggleCreateForm,
        onToggleExpanded: onToggleExpanded,
      ),
    ],
    _ => _subAccountReadySections(
      snapshot: snapshot,
      isBalanceHidden: isBalanceHidden,
      showCreate: showCreate,
      expandedId: expandedId,
      onToggleBalance: onToggleBalance,
      onToggleCreateForm: onToggleCreateForm,
      onToggleExpanded: onToggleExpanded,
    ),
  };
}

List<Widget> _subAccountReadySections({
  required ProfileSubAccountsSnapshot snapshot,
  required bool isBalanceHidden,
  required bool showCreate,
  required String? expandedId,
  required VoidCallback onToggleBalance,
  required VoidCallback onToggleCreateForm,
  required ValueChanged<String> onToggleExpanded,
}) {
  return [
    _SubAccountSummaryCard(
      snapshot: snapshot,
      isBalanceHidden: isBalanceHidden,
      onToggleBalance: onToggleBalance,
    ),
    VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'R\u00E0 so\u00E1t quy\u1EC1n t\u00E0i kho\u1EA3n ph\u1EE5',
      message:
          'Ki\u1EC3m tra quy\u1EC1n chuy\u1EC3n, r\u00FAt, API key v\u00E0 gi\u1EDBi h\u1EA1n tr\u01B0\u1EDBc khi t\u1EA1o ho\u1EB7c m\u1EDF r\u1ED9ng t\u00E0i kho\u1EA3n ph\u1EE5.',
      contractId: 'Sub accounts: ${snapshot.accounts.length}',
      density: VitDensity.compact,
    ),
    _CreateSubAccountButton(isOpen: showCreate, onTap: onToggleCreateForm),
    if (showCreate) const _CreateSubAccountForm(),
    VitSectionHeader(
      title: 'T\u00C0I KHO\u1EA2N (${snapshot.accounts.length})',
      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
      density: VitDensity.compact,
    ),
    if (snapshot.accounts.isEmpty)
      const VitEmptyState(
        title: 'Ch\u01B0a c\u00F3 t\u00E0i kho\u1EA3n ph\u1EE5',
        message:
            'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5 \u0111\u1EC3 t\u00E1ch quy\u1EC1n, API v\u00E0 v\u00ED giao d\u1ECBch.',
        icon: Icons.groups_outlined,
      )
    else ...[
      for (final account in snapshot.accounts)
        _SubAccountCard(
          account: account,
          isExpanded: expandedId == account.id,
          isBalanceHidden: isBalanceHidden,
          onTap: () => onToggleExpanded(account.id),
        ),
    ],
    const _SubAccountInfoNote(),
  ];
}

class _SubAccountSummaryCard extends StatelessWidget {
  const _SubAccountSummaryCard({
    required this.snapshot,
    required this.isBalanceHidden,
    required this.onToggleBalance,
  });

  final ProfileSubAccountsSnapshot snapshot;
  final bool isBalanceHidden;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl30d >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: SubAccountPage.summaryKey,
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      variant: VitCardVariant.hero,
      borderColor: AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.group_outlined,
                color: AppColors.primary,
                size: ProfileSpacingTokens.profileSubAccountSummaryIcon,
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileSubAccountSummaryIconGap,
              ),
              Expanded(
                child: Text(
                  'T\u1ED5ng t\u00E0i s\u1EA3n t\u1EA5t c\u1EA3 t\u00E0i kho\u1EA3n',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              VitIconButton(
                key: SubAccountPage.balanceToggleKey,
                icon: isBalanceHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                tooltip: isBalanceHidden
                    ? 'Hi\u1EC3n s\u1ED1 d\u01B0'
                    : '\u1EA8n s\u1ED1 d\u01B0',
                onPressed: onToggleBalance,
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            isBalanceHidden
                ? '\u2022\u2022\u2022\u2022\u2022\u2022'
                : _formatUsd(snapshot.totalBalance),
            style: AppTextStyles.heroNumber.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            isBalanceHidden
                ? 'PnL 30d: \u2022\u2022\u2022\u2022'
                : 'PnL 30d: ${_formatSignedUsd(snapshot.totalPnl30d)}',
            style: AppTextStyles.caption.copyWith(
              color: pnlColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'T\u1ED5ng TK',
                  value: '${snapshot.accounts.length}',
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileSubAccountSummaryMetricGap,
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Ho\u1EA1t \u0111\u1ED9ng',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileSubAccountSummaryMetricGap,
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'API Keys',
                  value: '${snapshot.apiKeyCount}',
                  valueColor: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
