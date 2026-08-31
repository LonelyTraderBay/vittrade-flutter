part of 'wallet_page_sections.dart';

const double _walletHeroPrimaryActionHeight =
    AppSpacing.searchBarCompactHeight - AppSpacing.x1;
const double _walletBreakdownDividerHeight = AppSpacing.x6;

class WalletBalanceHero extends StatelessWidget {
  const WalletBalanceHero({
    super.key,
    required this.snapshot,
    required this.change24hPct,
    required this.hidden,
    required this.onToggle,
    required this.onNavigate,
    this.onShowMore,
  });

  final WalletSnapshot snapshot;
  final double change24hPct;
  final bool hidden;
  final VoidCallback onToggle;
  final ValueChanged<String> onNavigate;
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context) {
    final actionsById = {
      for (final action in snapshot.actions) action.id: action,
    };
    final deposit = actionsById['deposit'];
    final withdraw = actionsById['withdraw'];
    final hasOverflow = onShowMore != null;

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: VitDensity.compact.cardPadding,
      borderColor: _walletPrimary.withValues(alpha: .12),
      background: const VitHeroGlow(center: Alignment(0, -0.96)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tài sản ước tính',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      'Quy USD · theo giá thị trường',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              VitInlineIconAction(
                key: const Key('sc135_wallet_balance_toggle'),
                tooltip: hidden ? 'Hiện số dư' : 'Ẩn số dư',
                onPressed: onToggle,
                icon: hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.portfolioTextDim,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            hidden ? '••••••' : _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.onAccent,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            hidden
                ? '••••• BTC'
                : '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC',
            style: AppTextStyles.numericMicro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          if (!hidden) ...[
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Biến động 24h',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.portfolioTextMuted,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                VitMetricDeltaPill(
                  label: _formatPct(change24hPct),
                  tone: change24hPct >= 0
                      ? VitMetricDeltaTone.positive
                      : VitMetricDeltaTone.negative,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          _BreakdownRow(snapshot: snapshot, hidden: hidden),
          if (deposit != null || withdraw != null || hasOverflow) ...[
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                if (deposit != null)
                  Expanded(
                    child: _WalletTabletHeroActionButton(
                      action: deposit,
                      primary: true,
                      onTap: () => onNavigate(deposit.route),
                    ),
                  ),
                if (deposit != null && withdraw != null)
                  const SizedBox(width: AppSpacing.x4),
                if (withdraw != null)
                  Expanded(
                    child: _WalletTabletHeroActionButton(
                      action: withdraw,
                      primary: false,
                      onTap: () => onNavigate(withdraw.route),
                    ),
                  ),
                if (hasOverflow) ...[
                  const SizedBox(width: AppSpacing.x4),
                  VitInlineIconAction(
                    key: const Key('sc135_wallet_more_actions'),
                    tooltip: 'Thêm thao tác',
                    onPressed: onShowMore!,
                    icon: Icons.more_horiz_rounded,
                    color: AppColors.portfolioTextDim,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class WalletPortfolioHint extends StatelessWidget {
  const WalletPortfolioHint({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitNextActionCard(
      icon: Icons.health_and_safety_outlined,
      title: 'Điểm sức khỏe ví',
      subtitle: 'Bảo mật và đa dạng hóa danh mục',
      statusLabel: 'Gợi ý',
      ctaLabel: 'Xem',
      accentColor: _walletPrimary,
      onTap: () => onNavigate('/wallet/health-score'),
    );
  }
}

class WalletPendingDepositStatusCard extends StatelessWidget {
  const WalletPendingDepositStatusCard({
    super.key,
    required this.pendingDeposits,
    required this.onNavigate,
  });

  final WalletPendingDepositsSnapshot pendingDeposits;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final count = pendingDeposits.pendingCount;
    return VitNextActionCard(
      icon: Icons.access_time_rounded,
      title: '$count giao d\u1ECBch n\u1EA1p \u0111ang ch\u1EDD',
      subtitle:
          'Theo d\u00F5i x\u00E1c nh\u1EADn blockchain v\u00E0 b\u01B0\u1EDBc ti\u1EBFp theo',
      statusLabel: '\u0110ang x\u1EED l\u00FD',
      ctaLabel: 'Xem',
      accentColor: _walletAmber,
      onTap: () => onNavigate('/wallet/pending-deposits'),
    );
  }
}

class _WalletTabletHeroActionButton extends StatelessWidget {
  const _WalletTabletHeroActionButton({
    required this.action,
    required this.primary,
    required this.onTap,
  });

  final WalletAction action;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: Key('sc135_wallet_action_${action.id}'),
      height: _walletHeroPrimaryActionHeight,
      density: VitDensity.compact,
      variant: primary
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      onPressed: onTap,
      leading: Icon(_actionIcon(action.iconKey)),
      child: Text(action.label),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.snapshot, required this.hidden});

  final WalletSnapshot snapshot;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Khả dụng',
        snapshot.availableUsd,
        _walletGreen,
        Icons.visibility_outlined,
      ),
      ('Trong lệnh', snapshot.inOrderUsd, _walletAmber, Icons.flag_rounded),
      ('Đóng băng', snapshot.frozenUsd, _walletRed, Icons.lock_outline_rounded),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: VitStatusPill(
                    label: items[i].$1,
                    status: _breakdownStatus(items[i].$3),
                    icon: items[i].$4,
                    size: VitStatusPillSize.sm,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  hidden ? '••••' : _formatUsd(items[i].$2),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          if (i != items.length - 1)
            SizedBox(
              width: 1,
              height: _walletBreakdownDividerHeight,
              child: ColoredBox(
                color: AppColors.onAccent.withValues(alpha: .08),
              ),
            ),
        ],
      ],
    );
  }
}

VitStatusPillStatus _breakdownStatus(Color color) {
  if (color == _walletGreen) return VitStatusPillStatus.success;
  if (color == _walletAmber) return VitStatusPillStatus.warning;
  if (color == _walletRed) return VitStatusPillStatus.error;
  return VitStatusPillStatus.neutral;
}
