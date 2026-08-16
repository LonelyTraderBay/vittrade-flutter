import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pLimitMajorGap = AppSpacing.x3;
const double _p2pLimitSectionGap = AppSpacing.x2;

class P2PLimitTrackerPage extends ConsumerStatefulWidget {
  const P2PLimitTrackerPage({super.key, this.shellRenderMode});

  static const periodTabsKey = Key('sc265_p2p_limit_period_tabs');
  static const usageHeroKey = Key('sc265_p2p_limit_usage_hero');
  static const progressKey = Key('sc265_p2p_limit_progress');
  static const historyKey = Key('sc265_p2p_limit_history');

  static Key periodKey(String period) => Key('sc265_p2p_limit_period_$period');

  static Key dayKey(String date) => Key('sc265_p2p_limit_day_$date');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLimitTrackerPage> createState() =>
      _P2PLimitTrackerPageState();
}

class _P2PLimitTrackerPageState extends ConsumerState<P2PLimitTrackerPage> {
  String _period = 'daily';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pLimitTrackerProvider);

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Theo dõi hạn mức P2P',
        semanticIdentifier: 'SC-265',
        onBack: () => context.go(AppRoutePaths.p2pLimits),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Theo dõi hạn mức P2P',
        semanticIdentifier: 'SC-265',
        onBack: () => context.go(AppRoutePaths.p2pLimits),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pLimitTrackerProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final usage = snapshot.usageFor(_period);
        return VitP2PFlowScaffold(
          title: snapshot.title,
          subtitle: snapshot.subtitle,
          semanticLabel: 'Theo dõi hạn mức P2P',
          semanticIdentifier: 'SC-265',
          shellRenderMode: widget.shellRenderMode,
          onBack: () => context.go(snapshot.parentRoute),
          children: [
            VitSegmentedChoice<String>(
              key: P2PLimitTrackerPage.periodTabsKey,
              selected: _period,
              height: AppSpacing.buttonCompact,
              padding: P2PSpacingTokens.p2pLimitTrackerPeriodTabPadding,
              options: [
                for (final usage in snapshot.usages)
                  VitSegmentedChoiceOption(
                    value: usage.period,
                    label: usage.label,
                    key: P2PLimitTrackerPage.periodKey(usage.period),
                    accentColor: AppModuleAccents.p2p,
                  ),
              ],
              onChanged: (period) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _period = period);
              },
            ),
            _UsageHero(usage: usage),
            _LimitBreakdownList(items: snapshot.breakdown),
            const VitCard(
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pLimitTrackerCompactPadding,
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại hạn mức P2P',
                message:
                    'Khoảng thời gian đã chọn, khối lượng đã dùng, hạn mức còn lại, phân tích lịch sử và bước quản lý hạn mức tiếp theo đã được xem trước khi hoạt động P2P thêm.',
                contractId: 'p2p-limit-tracker-review',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UsageHero extends StatelessWidget {
  const _UsageHero({required this.usage});

  final P2PLimitUsageDraft usage;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PLimitTrackerPage.usageHeroKey,
      color: AppModuleAccents.p2p,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardLargeRadius,
        side: BorderSide(color: AppModuleAccents.p2p),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pLimitTrackerCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Đã dùng',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent.withValues(alpha: .82),
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              '${_formatComma(usage.used, 0)} VND',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.numericDisplaySm.copyWith(
                color: AppColors.onAccent,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: _p2pLimitMajorGap),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: ColoredBox(
                color: AppColors.onAccent.withValues(alpha: .24),
                child: SizedBox(
                  key: P2PLimitTrackerPage.progressKey,
                  height: AppSpacing.x3,
                  child: FractionallySizedBox(
                    widthFactor: usage.percentage / 100,
                    alignment: Alignment.centerLeft,
                    child: const ColoredBox(color: AppColors.onAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              '${usage.percentage}% / ${_formatComma(usage.limit, 0)} VND',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent.withValues(alpha: .90),
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitBreakdownList extends StatelessWidget {
  const _LimitBreakdownList({required this.items});

  final List<P2PLimitBreakdownDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PLimitTrackerPage.historyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lịch sử gần đây',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pLimitSectionGap),
        for (var index = 0; index < items.length; index++) ...[
          _DayBreakdownCard(item: items[index]),
          if (index != items.length - 1)
            const SizedBox(height: _p2pLimitSectionGap),
        ],
      ],
    );
  }
}

class _DayBreakdownCard extends StatelessWidget {
  const _DayBreakdownCard({required this.item});

  final P2PLimitBreakdownDraft item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PLimitTrackerPage.dayKey(item.date),
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pLimitTrackerCompactPadding,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: P2PSpacingTokens.p2pComplianceCalendarIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item.date,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                'Tổng: ${_formatMillions(item.total)}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: _p2pLimitSectionGap),
          Row(
            children: [
              Expanded(
                child: _TradeSideBox(
                  label: 'MUA',
                  value: _formatMillions(item.buy),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: _p2pLimitSectionGap),
              Expanded(
                child: _TradeSideBox(
                  label: 'BÁN',
                  value: _formatMillions(item.sell),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TradeSideBox extends StatelessWidget {
  const _TradeSideBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      child: Padding(
        padding: P2PSpacingTokens.p2pLimitTrackerMetricPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatMillions(double value) {
  return '${(value / 1000000).round()}M';
}

String _formatComma(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (decimals == 0) return buffer.toString();
  return '$buffer.${parts.last}';
}
