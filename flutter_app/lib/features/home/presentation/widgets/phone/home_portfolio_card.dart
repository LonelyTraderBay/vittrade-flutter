// Phone-specific home portfolio card.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/phone/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

const double _heroActionExtent = AppSpacing.buttonCompact + AppSpacing.x2;
const double _homePortfolioTrendHeight =
    SharedSpacingTokens.homeSparklineHeight;

class HomePortfolioCard extends StatefulWidget {
  const HomePortfolioCard({
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

  @override
  State<HomePortfolioCard> createState() => _HomePortfolioCardState();
}

class _HomePortfolioCardState extends State<HomePortfolioCard> {
  bool _btcPrimary = false;

  HomeSnapshot get snapshot => widget.snapshot;
  bool get balanceHidden => widget.balanceHidden;

  bool get _isEmpty => snapshot.totalBalance <= 0;

  String get _primaryBalanceLabel {
    if (balanceHidden) return '••••••';
    if (_btcPrimary) {
      return '${snapshot.totalBtc.toStringAsFixed(8)} BTC';
    }
    return formatUsd(snapshot.totalBalance, forceTwoDecimals: true);
  }

  String get _secondaryBalanceLabel {
    if (balanceHidden) return '••••• BTC';
    if (_btcPrimary) {
      return formatUsd(snapshot.totalBalance, forceTwoDecimals: true);
    }
    return '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC';
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return _buildEmptyCard(context);
    }

    final showDelta = !balanceHidden;
    final pnlPositive = snapshot.dailyPnl >= 0;
    final trend = snapshot.portfolioTrend7d;
    final trendPositive = trend.length >= 2
        ? trend.last >= trend.first
        : pnlPositive;

    return VitCard(
      key: HomePage.portfolioCardKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      background: const VitHeroGlow(center: Alignment(0, -0.96)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _buildBalanceSection(),
          if (showDelta) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'PnL hôm nay',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.portfolioTextMuted,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                VitMetricDeltaPill(
                  label:
                      '${pnlPositive ? '+' : ''}${formatUsd(snapshot.dailyPnl.abs())} (${formatPct(snapshot.dailyPct)})',
                  tone: pnlPositive
                      ? VitMetricDeltaTone.positive
                      : VitMetricDeltaTone.negative,
                ),
              ],
            ),
            if (trend.length >= 2) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Biến động 7 ngày',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.portfolioTextMuted,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Theo giá trị tài sản',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.portfolioTextDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: _homePortfolioTrendHeight,
                      child: VitSparkline(
                        values: trend,
                        color: trendPositive ? AppColors.buy : AppColors.sell,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          HomePortfolioBreakdown(
            snapshot: snapshot,
            balanceHidden: balanceHidden,
            onNavigate: widget.onNavigate,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
              const SizedBox(height: AppSpacing.x1),
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
          tooltip: balanceHidden ? 'Hiện số dư' : 'Ẩn số dư',
          onPressed: widget.onToggleBalance,
          icon: balanceHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.portfolioTextDim,
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Semantics(
      button: true,
      label: balanceHidden
          ? 'Số dư đang ẩn. Chạm để mở trang ví.'
          : 'Tổng tài sản $_primaryBalanceLabel. Chạm để mở trang ví.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => widget.onNavigate('/wallet'),
            borderRadius: AppRadii.inputRadius,
            child: Text(
              _primaryBalanceLabel,
              style: AppTextStyles.heroNumber.copyWith(
                color: AppColors.onAccent,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Tooltip(
            message: balanceHidden
                ? 'Số dư đang ẩn'
                : 'Chạm để đổi hiển thị USD/BTC',
            child: InkWell(
              onTap: balanceHidden
                  ? null
                  : () => setState(() => _btcPrimary = !_btcPrimary),
              borderRadius: AppRadii.inputRadius,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!balanceHidden) ...[
                    const Icon(
                      Icons.swap_horiz_rounded,
                      size: SharedSpacingTokens.homePortfolioBadgeIcon,
                      color: AppColors.portfolioTextMuted,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                  ],
                  Text(
                    _secondaryBalanceLabel,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            onPressed: () => widget.onNavigate('/wallet/deposit/USDT'),
            leading: const Icon(Icons.file_download_outlined),
            child: const Text('Nạp'),
          ),
        ),
        const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
        Expanded(
          child: VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => widget.onNavigate('/wallet/withdraw/USDT'),
            leading: const Icon(Icons.file_upload_outlined),
            child: const Text('Rút'),
          ),
        ),
        const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
        Expanded(
          child: VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => widget.onNavigate('/wallet'),
            leading: const Icon(Icons.account_balance_wallet_outlined),
            child: const Text('Ví'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return VitCard(
      key: HomePage.portfolioCardKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      background: const VitHeroGlow(center: Alignment(0, -0.96)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                  children: [
                    Text(
                      'Chưa có tài sản',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Nạp USDT để bắt đầu giao dịch, earn và khám phá sản phẩm trên VitTrade.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: HomePage.portfolioDepositKey,
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            onPressed: () => widget.onNavigate('/wallet/deposit/USDT'),
            leading: const Icon(Icons.file_download_outlined),
            child: const Text('Nạp ngay'),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => widget.onNavigate('/markets'),
            leading: const Icon(Icons.insights_outlined),
            child: const Text('Xem thị trường'),
          ),
        ],
      ),
    );
  }
}

class HomePortfolioBreakdown extends StatelessWidget {
  const HomePortfolioBreakdown({
    super.key,
    required this.snapshot,
    required this.balanceHidden,
    required this.onNavigate,
  });

  final HomeSnapshot snapshot;
  final bool balanceHidden;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    String formatted(double value) => balanceHidden ? '••••' : formatUsd(value);

    return VitBalanceBreakdownRow(
      onNavigate: onNavigate,
      items: [
        VitBalanceBreakdownItem(
          label: 'Spot',
          value: formatted(snapshot.spotBalance),
          icon: Icons.swap_horiz_rounded,
          tooltip: 'Ví spot — tiền dùng mua/bán coin ngay lập tức',
          route: AppRoutePaths.wallet,
        ),
        VitBalanceBreakdownItem(
          label: 'Earn',
          value: formatted(snapshot.earnBalance),
          icon: Icons.savings_outlined,
          tooltip: 'Tài sản stake hoặc savings — sinh lãi theo thời gian',
          route: AppRoutePaths.earnStaking,
        ),
        VitBalanceBreakdownItem(
          label: 'Funding',
          value: formatted(snapshot.fundingBalance),
          icon: Icons.account_balance_outlined,
          tooltip: 'Ví funding cho margin, futures và chuyển nội bộ',
          route: AppRoutePaths.walletTransfer,
        ),
      ],
    );
  }
}
