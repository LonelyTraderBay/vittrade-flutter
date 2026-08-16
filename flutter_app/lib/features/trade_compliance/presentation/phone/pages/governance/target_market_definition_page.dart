import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

const _targetPrimary = AppColors.primary;
const _targetGreen = AppColors.buy;
const _targetRed = AppColors.sell;

class TargetMarketDefinitionPage extends ConsumerWidget {
  const TargetMarketDefinitionPage({
    super.key,
    this.productId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc101_target_market_content');
  static Key dimensionKey(String id) => Key('sc101_dimension_$id');

  final String? productId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedProductId = productId ?? 'prod-1';
    final async = ref.watch(
      tradeTargetMarketDefinitionProvider(resolvedProductId),
    );

    Widget scaffold({
      required String subtitle,
      required List<Widget> children,
    }) {
      return VitTradeHubScaffold(
        title: 'Target Market Definition',
        subtitle: subtitle,
        semanticLabel: 'Xác định thị trường mục tiêu sản phẩm',
        semanticIdentifier: 'SC-101',
        contentKey: contentKey,
        shellRenderMode: shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyProductGovernance,
          mode: BackNavigationMode.historyThenFallback,
        ),
        useCopyTradingInset: true,
        children: children,
      );
    }

    return async.when(
      loading: () => scaffold(
        subtitle: resolvedProductId,
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => scaffold(
        subtitle: resolvedProductId,
        children: [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              tradeTargetMarketDefinitionProvider(resolvedProductId),
            ),
          ),
        ],
      ),
      data: (snapshot) => scaffold(
        subtitle: snapshot.product.name,
        children: [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Target market review',
              message:
                  'Suitable audience, exclusions, knowledge level, capital capacity and distribution limits are reviewed before product action.',
              contractId: 'target-market-review',
              density: VitDensity.tool,
            ),
          ),
          VitTradeComplianceSection(
            title: 'Target market review',
            statusPill: const VitStatusPill(
              label: 'Review required',
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Product',
                value: snapshot.product.name,
              ),
              VitTradeComplianceItem(
                label: 'Criteria',
                value: '${snapshot.dimensions.length} dimensions',
              ),
            ],
          ),
          VitTradeSection(
            title: 'Product summary',
            child: VitTradeComplianceHero(
              title: snapshot.product.name,
              description:
                  'High-risk product requiring advanced knowledge and '
                  'significant capital.',
              icon: Icons.gps_fixed_rounded,
              accentColor: _targetPrimary,
            ),
          ),
          VitTradeSection(
            title: 'Target Market Criteria',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final dimension in snapshot.dimensions)
                  _DimensionCard(dimension: dimension),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.dimension});

  final TradeTargetMarketDimension dimension;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TargetMarketDefinitionPage.dimensionKey(dimension.id),
      padding: VitDensity.tool.cardPadding,
      radius: VitCardRadius.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dimension.category,
            style: AppTextStyles.control.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _CriteriaGroup(
            label: 'Suitable for:',
            color: _targetGreen,
            icon: Icons.check_circle_outline,
            values: dimension.suitableFor,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _CriteriaGroup(
            label: 'Not suitable for:',
            color: _targetRed,
            icon: Icons.info_outline,
            values: dimension.notSuitableFor,
          ),
        ],
      ),
    );
  }
}

class _CriteriaGroup extends StatelessWidget {
  const _CriteriaGroup({
    required this.label,
    required this.color,
    required this.icon,
    required this.values,
  });

  final String label;
  final Color color;
  final IconData icon;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.micro.copyWith(color: color)),
        const SizedBox(height: AppSpacing.x1),
        for (final value in values) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.normal,
                  ),
                ),
              ),
            ],
          ),
          if (value != values.last) const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}
