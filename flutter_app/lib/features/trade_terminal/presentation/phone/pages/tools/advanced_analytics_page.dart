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
import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../../../widgets/tools/advanced_analytics_page_ai_signals.dart';
part '../../../widgets/tools/advanced_analytics_page_signal_card.dart';
part '../../../widgets/tools/advanced_analytics_page_risk_journal.dart';
part '../../../widgets/tools/advanced_analytics_page_sizing_footer.dart';
part '../../../widgets/tools/advanced_analytics_page_shared.dart';

const _advancedBorder = AppColors.borderSolid;
const _advancedPrimary = AppColors.primary;
const _advancedGreen = AppColors.buy;
const _advancedRed = AppColors.sell;
const _advancedPurple = AppColors.accent;
const _advancedAmber = AppColors.caution;

class AdvancedAnalyticsPage extends ConsumerStatefulWidget {
  const AdvancedAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc092_advanced_analytics_content');
  static Key tabKey(String id) => Key('sc092_advanced_tab_$id');
  static Key filterKey(String id) => Key('sc092_advanced_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedAnalyticsPage> createState() =>
      _AdvancedAnalyticsPageState();
}

class _AdvancedAnalyticsPageState extends ConsumerState<AdvancedAnalyticsPage> {
  String _tab = 'ai';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeAdvancedAnalyticsSnapshotProvider);

    return VitTradeHubScaffold(
      title: 'Phân tích nâng cao',
      subtitle: 'AI · Rủi ro · Nhật ký',
      semanticLabel: 'Phân tích nâng cao',
      semanticIdentifier: 'SC-092',
      contentKey: AdvancedAnalyticsPage.contentKey,
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
            title: 'Không tải được phân tích nâng cao',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeAdvancedAnalyticsSnapshotProvider),
          ),
        ],
        data: (snapshot) => [
          VitTradeSection(
            title: 'Tổng quan',
            child: VitTradeAnalyticsHero(
              icon: Icons.auto_awesome_rounded,
              title: 'Advanced Analytics',
              subtitle: 'AI-powered insights va professional trading tools',
              stats: [
                for (final stat in snapshot.stats)
                  VitTradeAnalyticsStat(
                    label: stat.label,
                    value: stat.value,
                    color: Color(stat.colorHex),
                  ),
              ],
            ),
          ),
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.tool,
            title: 'Xem lại phân tích nâng cao',
            message:
                'Tín hiệu AI, sizing và nhật ký chỉ hỗ trợ quyết định. Xác nhận giới hạn rủi ro trước khi dùng cho lệnh thật.',
            contractId: 'SC-092',
          ),
          _UnderlineTabs(
            activeId: _tab,
            onChanged: (id) => setState(() => _tab = id),
          ),
          if (_tab == 'ai')
            _AiSignalsTab(
              snapshot: snapshot,
              activeFilter: _filter,
              onFilterChanged: (id) => setState(() => _filter = id),
            )
          else if (_tab == 'risk')
            _RiskAnalysisTab(snapshot: snapshot)
          else if (_tab == 'journal')
            _TradeJournalTab(snapshot: snapshot)
          else
            _PositionSizingTab(snapshot: snapshot),
          const VitTradeSection(title: 'Model info', child: _ModelInfoCard()),
          VitTradeSection(
            title: 'Features',
            child: _FeaturesCard(features: snapshot.features),
          ),
        ],
      ),
    );
  }
}
