import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

const _comparisonPrimary = AppColors.primary;
const _comparisonRed = AppColors.sell;
const _comparisonAmber = AppColors.caution;
const _comparisonGreen = AppColors.buy;

class ProviderComparisonPage extends ConsumerWidget {
  const ProviderComparisonPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc076_provider_comparison_content');
  static const addProviderActionKey = Key('sc076_add_provider_action');
  static const addProviderLinkKey = Key('sc076_add_provider_link');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeProviderComparisonProvider);

    return VitTradeHubScaffold(
      title: 'So sánh Providers',
      semanticLabel: 'So sánh Providers',
      semanticIdentifier: 'SC-076',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          key: addProviderActionKey,
          type: VitHeaderActionType.add,
          onPressed: () => context.push(AppRoutePaths.tradeCopyTrading),
        ),
      ],
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được dữ liệu so sánh provider',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeProviderComparisonProvider),
            ),
          ],
          data: (snapshot) => [
            VitTradeSection(
              title: 'Disclaimer',
              child: _WarningBanner(text: snapshot.disclaimer),
            ),
            VitTradeSection(
              title: 'So sánh',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Đang so sánh ${snapshot.selectedCount}/${snapshot.maxProviders} providers',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      if (snapshot.selectedCount < snapshot.maxProviders)
                        VitCtaButton(
                          key: addProviderLinkKey,
                          onPressed: () =>
                              context.push(AppRoutePaths.tradeCopyTrading),
                          variant: VitCtaButtonVariant.ghost,
                          fullWidth: false,
                          height: AppSpacing.buttonCompact,
                          padding:
                              AuthSpacingTokens.authInlineTextButtonPadding,
                          leading: const Icon(Icons.add_rounded),
                          child: const Text('+ Thêm provider'),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  _ComparisonTable(snapshot: snapshot),
                ],
              ),
            ),
            VitTradeSection(
              title: 'Chú thích',
              child: _LegendPanel(text: snapshot.legend),
            ),
            const VitTradeComplianceSection(
              title: 'Compliance review',
              density: VitDensity.tool,
              statusPill: VitStatusPill(
                label: 'Review required',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Scope',
                  value: 'Performance, risk, execution, fees, drawdown',
                ),
                VitTradeComplianceItem(
                  label: 'Action',
                  value: 'Review before adding or copying',
                ),
              ],
            ),
            const TradeBodyReviewSection(
              title: 'Rà soát nội dung so sánh provider',
              message: 'Nội dung so sánh provider đã được rà soát',
              detail:
                  'Miễn trừ trách nhiệm, provider đã chọn, chỉ số, chú thích, thao tác thêm và các trạng thái rà soát luôn hiển thị.',
              primary:
                  'Miễn trừ trách nhiệm luôn hiển thị trước các chỉ số so sánh provider.',
              secondary:
                  'Các nhóm rủi ro, thực thi, chi phí và hiệu suất được tách riêng để dễ theo dõi.',
              tertiary:
                  'Thao tác thêm provider vẫn bị giới hạn bởi mức so sánh tối đa và nội dung rà soát.',
            ),
          ],
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      borderColor: AppColors.warningBorder,
      padding: TradeSpacingTokens.providerComparisonPanelPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warningText,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warningText,
                height: TradeSpacingTokens.providerComparisonWarningLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const int _metricLabelColumnFlex = 2;

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.snapshot});

  final TradeProviderComparisonSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final providers = snapshot.providers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: TradeSpacingTokens.providerComparisonMetricHeaderPadding,
          child: Row(
            children: [
              Expanded(
                flex: _metricLabelColumnFlex,
                child: Text(
                  'Metric',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
              ),
              for (final provider in providers)
                Expanded(
                  child: Text(
                    provider.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        for (final group in TradeProviderComparisonCategory.values) ...[
          _CategoryRow(category: group),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (final metric in snapshot.metrics.where(
            (metric) => metric.category == group,
          )) ...[
            _MetricRow(metric: metric, providers: providers),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ],
        ],
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric, required this.providers});

  final TradeProviderComparisonMetric metric;
  final List<TradeProviderComparisonProvider> providers;

  @override
  Widget build(BuildContext context) {
    final bestProviderId = _bestProviderId(metric, providers);
    return Padding(
      padding: TradeSpacingTokens.providerComparisonMetricLabelPadding,
      child: SizedBox(
        height: AppSpacing.x5 + AppSpacing.x2,
        child: Row(
          children: [
            Expanded(
              flex: _metricLabelColumnFlex,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  metric.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ),
            for (final provider in providers)
              Expanded(
                child: _MetricValueCell(
                  value: metric.values[provider.id],
                  isBest: provider.id == bestProviderId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetricValueCell extends StatelessWidget {
  const _MetricValueCell({required this.value, required this.isBest});

  final String? value;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final text = value;
    if (text == null || text.isEmpty) {
      return Text(
        '—',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
    }
    final color = isBest ? _comparisonGreen : AppColors.text1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isBest) ...[
          const Icon(
            Icons.circle,
            color: _comparisonGreen,
            size: AppSpacing.x2,
          ),
          const SizedBox(width: AppSpacing.x1),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

final RegExp _metricNumberPattern = RegExp(r'-?\d+(?:\.\d+)?');

/// Parses the numeric part of a formatted metric value ('+342.5%', '0.8s',
/// '\$24.50'). Returns null when the value has no numeric component.
double? _parseMetricNumber(String? raw) {
  if (raw == null) {
    return null;
  }
  final match = _metricNumberPattern.firstMatch(raw.replaceAll(',', ''));
  if (match == null) {
    return null;
  }
  return double.tryParse(match.group(0)!);
}

/// Id of the provider holding the best-in-group value for [metric] per its
/// `higherIsBetter` direction (values are compared as signed numbers).
String? _bestProviderId(
  TradeProviderComparisonMetric metric,
  List<TradeProviderComparisonProvider> providers,
) {
  String? bestId;
  double? bestValue;
  for (final provider in providers) {
    final parsed = _parseMetricNumber(metric.values[provider.id]);
    if (parsed == null) {
      continue;
    }
    final isBetter =
        bestValue == null ||
        (metric.higherIsBetter ? parsed > bestValue : parsed < bestValue);
    if (isBetter) {
      bestValue = parsed;
      bestId = provider.id;
    }
  }
  return bestId;
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final TradeProviderComparisonCategory category;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (category) {
      TradeProviderComparisonCategory.performance => (
        'Performance',
        _comparisonPrimary,
        Icons.trending_up_rounded,
      ),
      TradeProviderComparisonCategory.risk => (
        'Risk',
        _comparisonRed,
        Icons.shield_outlined,
      ),
      TradeProviderComparisonCategory.execution => (
        'Execution',
        _comparisonPrimary,
        Icons.show_chart_rounded,
      ),
      TradeProviderComparisonCategory.cost => (
        'Cost',
        _comparisonAmber,
        Icons.attach_money_rounded,
      ),
    };

    return Padding(
      padding: TradeSpacingTokens.providerComparisonCategoryPadding,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.heavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendPanel extends StatelessWidget {
  const _LegendPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerComparisonPanelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: _comparisonGreen,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '= Giá trị tốt nhất trong nhóm',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: TradeSpacingTokens.providerComparisonLegendLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
