import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/analytics/performance_attribution_summary_tabs.dart';
part '../../../widgets/analytics/performance_attribution_tabs.dart';
part '../../../widgets/analytics/performance_attribution_painters.dart';

const _attributionPrimary = AppColors.primary;
const _attributionPurple = AppColors.accent;
const _attributionGreen = AppColors.buy;
const _attributionRed = AppColors.sell;
const _attributionGray = AppColors.text3;
const _attributionChartHeight =
    TradeSpacingTokens.tradeBotAttributionCompactChartHeight;
const _attributionLargeChartHeight =
    TradeSpacingTokens.tradeBotAttributionReturnsCompactChartHeight;

class PerformanceAttributionPage extends ConsumerStatefulWidget {
  const PerformanceAttributionPage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc075_performance_attribution_content');

  static Key tabKey(String id) => Key('sc075_performance_attribution_tab_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceAttributionPage> createState() =>
      _PerformanceAttributionPageState();
}

class _PerformanceAttributionPageState
    extends ConsumerState<PerformanceAttributionPage> {
  String _activeTab = 'attribution';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradePerformanceAttributionProvider(widget.copyId),
    );

    return VitTradeDetailScaffold(
      title: 'Phân tích hiệu suất',
      semanticLabel: 'Phân bổ hiệu suất',
      semanticIdentifier: 'SC-075',
      contentKey: PerformanceAttributionPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyPerformance(widget.copyId),
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được phân bổ hiệu suất',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                tradePerformanceAttributionProvider(widget.copyId),
              ),
            ),
          ],
          data: (snapshot) => [
            const VitTradeSection(
              title: 'Đánh giá rủi ro',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.tool,
                title: 'Xem lại phân bổ hiệu suất',
                message:
                    'Xác nhận drawdown, mức phơi nhiễm, giới hạn và bước tiếp theo trước khi điều chỉnh phân bổ copy.',
              ),
            ),
            VitTradeSection(
              title: 'Tổng quan',
              child: _SummaryGrid(snapshot: snapshot),
            ),
            VitTradeSection(
              title: 'Phân tích',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AttributionTabs(
                    activeTab: _activeTab,
                    onChanged: (value) => setState(() => _activeTab = value),
                  ),
                  if (_activeTab == 'attribution')
                    _AttributionTab(snapshot: snapshot)
                  else if (_activeTab == 'drawdown')
                    _DrawdownTab(snapshot: snapshot)
                  else if (_activeTab == 'projection')
                    _ProjectionTab(snapshot: snapshot)
                  else
                    _CorrelationTab(snapshot: snapshot),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
