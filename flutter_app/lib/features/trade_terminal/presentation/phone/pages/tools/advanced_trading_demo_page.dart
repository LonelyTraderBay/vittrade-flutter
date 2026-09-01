import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../../../widgets/tools/advanced_trading_demo_page_sections.dart';
part '../../../widgets/tools/advanced_trading_demo_page_common.dart';

const _advancedGreen = AppColors.buy;
const _advancedRed = AppColors.sell;
const _advancedPrimary = AppColors.primary;
const double _advancedSheetClearance =
    TradeSpacingTokens.copySettingsCircuitBreakerCollapsedHeight;
const double _advancedSpace = AppSpacing.x2;
const double _advancedTinySpace = AppSpacing.x1;
const double _advancedActionMinExtent = AppSpacing.searchBarCompactHeight;
const double _advancedSheetActionExtent = AppSpacing.searchBarCompactHeight;
const double _advancedLineBody = 1.24;

class AdvancedTradingDemoPage extends ConsumerStatefulWidget {
  const AdvancedTradingDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc088_advanced_trading_demo_content');
  static Key tabKey(String id) => Key('sc088_advanced_tab_$id');
  static Key modeKey(String id) => Key('sc088_position_mode_$id');
  static Key actionKey(String id) => Key('sc088_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedTradingDemoPage> createState() =>
      _AdvancedTradingDemoPageState();
}

class _AdvancedTradingDemoPageState
    extends ConsumerState<AdvancedTradingDemoPage> {
  String _tab = 'position';
  String _positionMode = 'one-way';
  String? _activeSheetTitle;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeAdvancedTradingDemoSnapshotProvider);

    return Stack(
      children: [
        VitTradeHubScaffold(
          title: 'Giao dịch nâng cao',
          subtitle: 'Vị thế & lệnh',
          semanticLabel: 'Giao dịch nâng cao',
          semanticIdentifier: 'SC-088',
          contentKey: AdvancedTradingDemoPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.tradeMargin,
            mode: BackNavigationMode.historyThenFallback,
          ),
          showProductTabs: true,
          navigationBuilder: buildTradeProductNavigation,
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title: 'Không tải được giao dịch nâng cao',
                message: 'Vui lòng kiểm tra kết nối và thử lại.',
                actionLabel: 'Thử lại',
                onAction: () =>
                    ref.invalidate(tradeAdvancedTradingDemoSnapshotProvider),
              ),
            ],
            data: (snapshot) => [
              _PositionModeCard(
                activeMode: _positionMode,
                onChanged: (mode) => setState(() => _positionMode = mode),
              ),
              _UnderlineTabs(
                activeId: _tab,
                onChanged: (id) => setState(() => _tab = id),
              ),
              if (_tab == 'position')
                _PositionTab(
                  snapshot: snapshot,
                  onAction: (action) =>
                      setState(() => _activeSheetTitle = action.label),
                )
              else if (_tab == 'orders')
                _OrdersTab(snapshot: snapshot)
              else
                _AnalyticsTab(snapshot: snapshot),
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Giới hạn demo thực thi',
                message:
                    'Điều khiển lệnh nâng cao chỉ hiển thị ở chế độ demo. Thực thi thật cần xem trước, ký quỹ, phí và rủi ro thanh lý.',
                contractId: 'SC-088',
                density: VitDensity.tool,
              ),
            ],
          ),
        ),
        if (_activeSheetTitle != null)
          _DemoSheet(
            title: _activeSheetTitle!,
            onClose: () => setState(() => _activeSheetTitle = null),
          ),
      ],
    );
  }
}
