import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_formatters.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const double _kpiActionExtent = AppSpacing.buttonCompact + AppSpacing.x3;
const double _kpiSparklineHeight = SharedSpacingTokens.homeSparklineHeight;

/// Full-width KPI strip spanning both dashboard columns (SC-007 tablet,
/// banner slot of `VitTwoColumnTabletDashboard`). Replaces the phone hero
/// card: the same portfolio facts compressed into one horizontal band so
/// the viewport below stays free for the dense market watchlist — the
/// monitor-first composition this surface is built around.
class HomeTabletKpiStrip extends StatelessWidget {
  const HomeTabletKpiStrip({
    super.key,
    required this.snapshot,
    required this.balanceHidden,
    required this.onToggleBalance,
    required this.onNavigate,
  });

  final HomeSnapshot snapshot;
  final bool balanceHidden;
  final VoidCallback onToggleBalance;
  final ValueChanged<String> onNavigate;

  bool get _isEmpty => snapshot.totalBalance <= 0;

  /// Below this width (the dashboard's single-column fallback territory)
  /// the strip reflows into two rows — metrics first, breakdown + actions
  /// below — instead of overflowing the fixed-width action toolbar.
  static const double _compactBreakpoint = 760;

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return _buildEmptyStrip(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _compactBreakpoint;
        return _buildStrip(context, compact: compact);
      },
    );
  }

  Widget _buildStrip(BuildContext context, {required bool compact}) {
    final pnlPositive = snapshot.dailyPnl >= 0;
    final trend = snapshot.portfolioTrend7d;
    final trendPositive = trend.length >= 2
        ? trend.last >= trend.first
        : pnlPositive;
    final masked = balanceHidden ? '••••••' : null;

    final balanceBlock = Expanded(
      flex: 3,
      child: _KpiBlock(
        label: 'Tổng tài sản ước tính',
        value:
            masked ?? formatUsd(snapshot.totalBalance, forceTwoDecimals: true),
        valueStyle: AppTextStyles.heroNumber.copyWith(
          color: AppColors.onAccent,
          letterSpacing: 0,
        ),
        subline: masked != null
            ? 'Số dư đang ẩn'
            : '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC · Quy USD',
      ),
    );
    final pnlBlock = Expanded(
      flex: 3,
      child: _KpiBlock(
        label: 'PnL hôm nay',
        value:
            masked ??
            '${pnlPositive ? '+' : ''}${formatUsd(snapshot.dailyPnl.abs())}',
        valueStyle: AppTextStyles.base.copyWith(
          color: pnlPositive ? AppColors.buy : AppColors.sell,
          fontWeight: AppTextStyles.bold,
        ),
        subline: masked ?? formatPct(snapshot.dailyPct),
        sublineTone: pnlPositive ? AppColors.buy : AppColors.sell,
      ),
    );
    final trendBlock = Expanded(
      flex: 2,
      child: _KpiBlock(
        label: 'Biến động 7 ngày',
        value: masked,
        valueStyle: AppTextStyles.caption.copyWith(
          color: AppColors.portfolioTextMuted,
        ),
        trailingBelow: masked == null && trend.length >= 2
            ? SizedBox(
                width: double.infinity,
                height: _kpiSparklineHeight,
                child: VitSparkline(
                  values: trend,
                  color: trendPositive ? AppColors.buy : AppColors.sell,
                ),
              )
            : null,
      ),
    );
    final breakdownBlock = Expanded(
      flex: 2,
      child: _KpiBreakdown(
        spot: masked ?? formatUsd(snapshot.spotBalance),
        earn: masked ?? formatUsd(snapshot.earnBalance),
        funding: masked ?? formatUsd(snapshot.fundingBalance),
        onNavigate: onNavigate,
      ),
    );
    final toggle = Semantics(
      button: true,
      label: balanceHidden ? 'Hiện số dư' : 'Ẩn số dư',
      child: VitInlineIconAction(
        tooltip: balanceHidden ? 'Hiện số dư' : 'Ẩn số dư',
        onPressed: onToggleBalance,
        icon: balanceHidden
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: AppColors.portfolioTextDim,
      ),
    );
    final actions = _KpiActionRow(onNavigate: onNavigate);

    if (compact) {
      return VitCard(
        key: HomeTabletKeys.portfolioCard,
        radius: VitCardRadius.standard,
        clip: true,
        padding: SharedSpacingTokens.homeCardPaddingDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  balanceBlock,
                  const _KpiDivider(),
                  pnlBlock,
                  const _KpiDivider(),
                  trendBlock,
                  const SizedBox(
                    width: HomeSpacingTokens.homePortfolioActionSpacing,
                  ),
                  toggle,
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Row(
              children: [
                breakdownBlock,
                const SizedBox(
                  width: HomeSpacingTokens.homePortfolioActionSpacing,
                ),
                actions,
              ],
            ),
          ],
        ),
      );
    }

    return VitCard(
      key: HomeTabletKeys.portfolioCard,
      radius: VitCardRadius.standard,
      clip: true,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            balanceBlock,
            const _KpiDivider(),
            pnlBlock,
            const _KpiDivider(),
            trendBlock,
            const _KpiDivider(),
            breakdownBlock,
            const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
            toggle,
            const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
            actions,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStrip(BuildContext context) {
    return VitCard(
      key: HomeTabletKeys.portfolioCard,
      radius: VitCardRadius.standard,
      clip: true,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.portfolioTextDim,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chưa có tài sản',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Nạp USDT để bắt đầu giao dịch trên VitTrade.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ],
            ),
          ),
          VitCtaButton(
            key: HomeTabletKeys.portfolioDeposit,
            height: _kpiActionExtent,
            density: VitDensity.compact,
            fullWidth: false,
            onPressed: () => onNavigate('/wallet/deposit/USDT'),
            leading: const Icon(Icons.file_download_outlined),
            child: const Text('Nạp ngay'),
          ),
          const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
          VitCtaButton(
            height: _kpiActionExtent,
            density: VitDensity.compact,
            fullWidth: false,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => onNavigate('/markets'),
            leading: const Icon(Icons.insights_outlined),
            child: const Text('Xem thị trường'),
          ),
        ],
      ),
    );
  }
}

class _KpiBlock extends StatelessWidget {
  const _KpiBlock({
    required this.label,
    this.value,
    required this.valueStyle,
    this.subline,
    this.sublineTone,
    this.trailingBelow,
  });

  final String label;
  final String? value;
  final TextStyle valueStyle;
  final String? subline;
  final Color? sublineTone;
  final Widget? trailingBelow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.portfolioTextMuted,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        if (value != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            value!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          ),
        ],
        if (subline != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            subline!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: sublineTone ?? AppColors.portfolioTextDim,
            ),
          ),
        ],
        if (trailingBelow != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          trailingBelow!,
        ],
      ],
    );
  }
}

class _KpiDivider extends StatelessWidget {
  const _KpiDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      thickness: AppSpacing.dividerHairline,
      width: AppSpacing.x3 * 2 + AppSpacing.dividerHairline,
      color: AppColors.divider,
    );
  }
}

/// Spot/Earn/Funding quick figures — the phone hero card's breakdown rows
/// compressed into one stacked block; tapping opens the wallet.
class _KpiBreakdown extends StatelessWidget {
  const _KpiBreakdown({
    required this.spot,
    required this.earn,
    required this.funding,
    required this.onNavigate,
  });

  final String spot;
  final String earn;
  final String funding;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value) => Text(
      '$label · $value',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.micro.copyWith(color: AppColors.portfolioTextMuted),
    );

    return InkWell(
      onTap: () => onNavigate(AppRoutePaths.wallet),
      borderRadius: AppRadii.inputRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Phân bổ ví',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          row('Spot', spot),
          row('Earn', earn),
          row('Funding', funding),
        ],
      ),
    );
  }
}

class _KpiActionRow extends StatelessWidget {
  const _KpiActionRow({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    Widget action(
      String label,
      IconData icon,
      String path, {
      VitCtaButtonVariant variant = VitCtaButtonVariant.secondary,
      Key? key,
    }) {
      return VitCtaButton(
        key: key,
        height: _kpiActionExtent,
        density: VitDensity.compact,
        fullWidth: false,
        variant: variant,
        onPressed: () => onNavigate(path),
        leading: Icon(icon),
        child: Text(label),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        action(
          'Nạp',
          Icons.file_download_outlined,
          '/wallet/deposit/USDT',
          variant: VitCtaButtonVariant.primary,
          key: HomeTabletKeys.portfolioDeposit,
        ),
        const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
        action('Rút', Icons.file_upload_outlined, '/wallet/withdraw/USDT'),
        const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
        action(
          'Ví',
          Icons.account_balance_wallet_outlined,
          AppRoutePaths.wallet,
        ),
      ],
    );
  }
}
