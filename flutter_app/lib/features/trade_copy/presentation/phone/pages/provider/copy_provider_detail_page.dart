import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/phone/copy_trading_list.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

const _providerPrimary = AppColors.primary;
const _providerGreen = AppColors.buy;
const _providerRed = AppColors.sell;

class CopyProviderDetailPage extends ConsumerWidget {
  const CopyProviderDetailPage({
    super.key,
    required this.providerId,
    this.backPath,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc070_copy_provider_detail_content');
  static const assessmentKey = Key('sc070_copy_provider_assessment');
  static const notFoundKey = Key('sc070_copy_provider_not_found');

  final String providerId;
  final String? backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      tradeCopyProviderDetailProvider(providerId),
    );
    final resolvedBackPath = resolveSafeBackPath(
      candidate: backPath,
      fallbackPath: AppRoutePaths.tradeCopyTrading,
      allowedPrefixes: const [AppRoutePaths.trade],
    );

    return snapshotAsync.when(
      loading: () => VitTradeDetailScaffold(
        title: 'Chi tiết provider',
        semanticLabel: 'Chi tiết provider',
        semanticIdentifier: 'SC-070',
        contentKey: contentKey,
        shellRenderMode: shellRenderMode,
        useCopyTradingInset: true,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: resolvedBackPath,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitTradeDetailScaffold(
        title: 'Chi tiết provider',
        semanticLabel: 'Chi tiết provider',
        semanticIdentifier: 'SC-070',
        contentKey: contentKey,
        shellRenderMode: shellRenderMode,
        useCopyTradingInset: true,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: resolvedBackPath,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          VitErrorState(
            title: 'Không tải được chi tiết provider',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeCopyProviderDetailProvider(providerId)),
          ),
        ],
      ),
      data: (snapshot) =>
          _body(context, snapshot, snapshot.provider, resolvedBackPath),
    );
  }

  Widget _body(
    BuildContext context,
    TradeCopyProviderDetailSnapshot snapshot,
    TradeCopyTrader? provider,
    String resolvedBackPath,
  ) {
    if (provider == null) {
      return VitTradeDetailScaffold(
        title: 'Không tìm thấy provider',
        semanticLabel: 'Không tìm thấy provider',
        semanticIdentifier: 'SC-070',
        shellRenderMode: shellRenderMode,
        useCopyTradingInset: true,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: resolvedBackPath,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          VitTradeSection(
            title: 'Không tìm thấy',
            child: Column(
              key: CopyProviderDetailPage.notFoundKey,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.text3,
                  size: WalletSpacingTokens.walletTokenHeroIcon,
                ),
                const SizedBox(height: AppSpacing.cardGap),
                Text(
                  snapshot.notFoundMessage,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return VitTradeDetailScaffold(
      title: provider.name,
      semanticLabel: 'Chi tiết provider',
      semanticIdentifier: 'SC-070',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: resolvedBackPath,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        const CopyTradingRiskWarningCard(
          title: 'Copy trading không đảm bảo lợi nhuận',
          message:
              'Quá khứ không báo hiệu tương lai. Bạn có thể mất toàn bộ vốn khi sao chép chiến lược.',
          contractId: 'sc070-provider-risk',
        ),
        VitTradeSection(
          title: 'Đánh giá trước khi copy',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại trước khi sao chép',
                message:
                    'So sánh drawdown tối đa, giới hạn copier, phí và đánh giá phù hợp trước khi copy provider này.',
                contractId: 'copy-provider-detail-review',
                density: VitDensity.tool,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitCtaButton(
                key: assessmentKey,
                onPressed: () => context.push(
                  AppRoutePaths.tradeCopyProviderAssessment(providerId),
                ),
                density: VitDensity.tool,
                height: VitDensity.tool.controlHeight,
                leading: const Icon(Icons.fact_check_outlined),
                trailing: const Icon(Icons.chevron_right_rounded),
                child: Text(
                  'Đánh giá rủi ro',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
              ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'Hồ sơ provider',
          child: _ProviderCard(provider: provider),
        ),
        VitTradeSection(
          title: 'Chỉ số (kèm drawdown)',
          child: _MetricGrid(provider: provider),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x2,
          ),
          child: Text(
            'Copy trading không đảm bảo lợi nhuận. ROI luôn đi kèm drawdown tối đa.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: TradeSpacingTokens.copyProviderDetailDisclaimerLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      child: Row(
        children: [
          VitAssetAvatar(
            label: provider.avatar,
            accentColor: _providerPrimary,
            size: AppSpacing.x7,
            radius: AppRadii.avatarRadius,
            border: true,
          ),
          const SizedBox(width: AppSpacing.cardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.formFieldLabelGap),
                Wrap(
                  spacing: AppSpacing.formFieldLabelGap,
                  runSpacing: AppSpacing.formFieldLabelGap,
                  children: [
                    for (final tag in provider.tags)
                      _Pill(label: tag, color: AppColors.text2),
                    _Pill(
                      label: _riskLabel(provider.riskLevel),
                      color: _riskColor(provider.riskLevel),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  '${provider.totalTrades} lệnh · giữ trung bình ${provider.avgHoldingTime}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Lợi nhuận',
        '+${provider.totalPnlPct.toStringAsFixed(1)}%',
        _providerGreen,
      ),
      (
        'Drawdown tối đa',
        '${provider.maxDrawdown.toStringAsFixed(1)}%',
        _providerRed,
      ),
      ('Sharpe', provider.sharpeRatio.toStringAsFixed(2), _providerPrimary),
      (
        'Tỷ lệ thắng',
        '${provider.winRate.toStringAsFixed(1)}%',
        AppColors.text2,
      ),
      (
        'Copier',
        '${provider.copiers}/${provider.maxCopiers}',
        _providerPrimary,
      ),
      (
        'AUM',
        '\$${(provider.aum / 1000000).toStringAsFixed(1)}M',
        AppColors.caution,
      ),
    ];

    return GridView.count(
      crossAxisCount: TradeSpacingTokens.copyProviderDetailMetricColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      childAspectRatio: TradeSpacingTokens.copyProviderDetailMetricAspectRatio,
      children: [
        for (final metric in metrics)
          VitCardStat(
            padding: AppSpacing.cardPaddingCompact,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.$2,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: metric.$3,
                    fontWeight: AppTextStyles.extraBold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  metric.$1,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

Color _riskColor(TradeCopyRiskLevel level) {
  return switch (level) {
    TradeCopyRiskLevel.low => _providerGreen,
    TradeCopyRiskLevel.medium => AppColors.caution,
    TradeCopyRiskLevel.high => _providerRed,
  };
}

String _riskLabel(TradeCopyRiskLevel level) {
  return switch (level) {
    TradeCopyRiskLevel.low => 'Rủi ro thấp',
    TradeCopyRiskLevel.medium => 'Rủi ro trung bình',
    TradeCopyRiskLevel.high => 'Rủi ro cao',
  };
}
