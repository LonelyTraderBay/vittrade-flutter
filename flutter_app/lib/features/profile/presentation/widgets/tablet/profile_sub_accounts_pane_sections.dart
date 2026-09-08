part of 'profile_sub_accounts_pane.dart';

List<Widget> _subsPaneChildren({
  required ProfileSubAccountsSnapshot snapshot,
  required bool isBalanceHidden,
  required bool showCreate,
  required String? expandedId,
  required VoidCallback onToggleBalance,
  required VoidCallback onToggleCreateForm,
  required ValueChanged<String> onToggleExpanded,
}) {
  return [
    _SubsSummaryCard(
      snapshot: snapshot,
      isBalanceHidden: isBalanceHidden,
      onToggleBalance: onToggleBalance,
    ),
    VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'Rà soát quyền tài khoản phụ',
      message:
          'Kiểm tra quyền chuyển, rút, API key và giới hạn trước khi tạo '
          'hoặc mở rộng tài khoản phụ.',
      contractId: 'Sub accounts: ${snapshot.accounts.length}',
      density: VitDensity.compact,
    ),
    _SubsCreateButton(isOpen: showCreate, onTap: onToggleCreateForm),
    if (showCreate) const _SubsCreateForm(),
    VitSectionHeader(
      title: 'TÀI KHOẢN (${snapshot.accounts.length})',
      bottomGap: TabletSpacingTokens.x4,
      density: VitDensity.compact,
    ),
    if (snapshot.accounts.isEmpty)
      const VitEmptyState(
        title: 'Chưa có tài khoản phụ',
        message: 'Tạo tài khoản phụ để tách quyền, API và ví giao dịch.',
        icon: Icons.groups_outlined,
      )
    else
      for (final account in snapshot.accounts)
        _SubsAccountCard(
          account: account,
          isExpanded: expandedId == account.id,
          isBalanceHidden: isBalanceHidden,
          onTap: () => onToggleExpanded(account.id),
        ),
    const _SubsInfoNote(),
  ];
}

class _SubsSummaryCard extends StatelessWidget {
  const _SubsSummaryCard({
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
      key: ProfileTabletKeys.subAccountsSummary,
      density: VitDensity.compact,
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
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: Text(
                  'Tổng tài sản tất cả tài khoản',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              VitIconButton(
                key: ProfileTabletKeys.subAccountsBalanceToggle,
                icon: isBalanceHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                tooltip: isBalanceHidden ? 'Hiện số dư' : 'Ẩn số dư',
                onPressed: onToggleBalance,
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            isBalanceHidden ? '••••••' : VitFormat.usd(snapshot.totalBalance),
            style: AppTextStyles.heroNumber.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            isBalanceHidden
                ? 'PnL 30d: ••••'
                : 'PnL 30d: ${VitFormat.usdSigned(snapshot.totalPnl30d)}',
            style: AppTextStyles.caption.copyWith(
              color: pnlColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Row(
            children: [
              Expanded(
                child: _SubsMetric(
                  label: 'Tổng TK',
                  value: '${snapshot.accounts.length}',
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: _SubsMetric(
                  label: 'Hoạt động',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: _SubsMetric(
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

class _SubsMetric extends StatelessWidget {
  const _SubsMetric({
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
        horizontal: TabletSpacingTokens.x3,
        vertical: TabletSpacingTokens.x2,
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
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _SubsCreateButton extends StatelessWidget {
  const _SubsCreateButton({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ProfileTabletKeys.subAccountsCreateButton,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      density: VitDensity.compact,
      leading: Icon(isOpen ? Icons.close_rounded : Icons.add_rounded),
      child: Text(isOpen ? 'Đóng biểu mẫu' : 'Tạo tài khoản phụ mới'),
    );
  }
}

class _SubsCreateForm extends StatefulWidget {
  const _SubsCreateForm();

  @override
  State<_SubsCreateForm> createState() => _SubsCreateFormState();
}

class _SubsCreateFormState extends State<_SubsCreateForm> {
  String _accountType = 'Spot';

  static const _accountTypes = ['Spot', 'Margin', 'Futures', 'Tất cả'];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.subAccountsCreateForm,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tạo tài khoản phụ',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          const _SubsFieldPreview(
            label: 'Tên tài khoản',
            value: 'VD: Grid Bot #2',
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loại tài khoản',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitPresetChipRow<String>(
                gap: ProfileSpacingTokens.profileSubAccountFormPillGap,
                selectedValue: _accountType,
                onTap: (value) => setState(() => _accountType = value),
                items: [
                  for (final type in _accountTypes)
                    VitPresetChipItem<String>(value: type, label: type),
                ],
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          const _SubsPermissionPreview(),
          const SizedBox(height: TabletSpacingTokens.x4),
          VitCtaButton(
            onPressed: _submitCreate,
            density: VitDensity.compact,
            child: const Text('Tạo tài khoản'),
          ),
        ],
      ),
    );
  }

  void _submitCreate() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Tạo tài khoản phụ sẽ sớm ra mắt',
      ),
    );
  }
}

class _SubsPermissionPreview extends StatelessWidget {
  const _SubsPermissionPreview();

  static const _permissions = [
    'Spot',
    'Margin',
    'Futures',
    'Chuyển',
    'Rút',
    'Xem',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quyền hạn',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Wrap(
          spacing: ProfileSpacingTokens.profileSubAccountFormPillGap,
          runSpacing: ProfileSpacingTokens.profileSubAccountFormPillGap,
          children: [
            for (final permission in _permissions)
              VitAccentPill(label: permission, accentColor: AppColors.primary),
          ],
        ),
      ],
    );
  }
}

class _SubsFieldPreview extends StatelessWidget {
  const _SubsFieldPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        // Field-preview placeholder (mock-UI stage) — disabled bare input
        // keeps the same input chrome as the phone's preview box.
        VitInput(
          controller: TextEditingController(text: value),
          semanticLabel: label,
          enabled: false,
        ),
      ],
    );
  }
}
