import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/margin/margin_trading_hub_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../../../widgets/margin/margin_trading_hub_hero_nav.dart';
part '../../../widgets/margin/margin_trading_hub_cards.dart';

const _hubBorder = AppColors.borderSolid;
const _hubPrimary = AppColors.primary;
const _hubGreen = AppColors.buy;
const _hubSpace = AppSpacing.x2;
const _hubTinySpace = AppSpacing.x1;
const _hubIconTile = AppSpacing.iconLg;
const _hubLineTight = 1.2;
const _hubLineBody = 1.24;
const _hubComplianceGridColumns =
    TradeSpacingTokens.marginTradingHubComplianceGridColumns;
const _hubComplianceGridExtent =
    TradeSpacingTokens.marginTradingHubComplianceGridExtent;

class MarginTradingHubPage extends ConsumerWidget {
  const MarginTradingHubPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc090_margin_trading_hub_content');
  static Key menuKey(String id) => Key('sc090_margin_hub_menu_$id');
  static Key featureKey(String id) => Key('sc090_margin_hub_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeMarginTradingHubProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();

    return VitTradeHubScaffold(
      title: 'Hub ký quỹ',
      subtitle: 'Công cụ · Tuân thủ',
      semanticLabel: 'Trung tâm giao dịch ký quỹ',
      semanticIdentifier: 'SC-090',
      contentKey: contentKey,
      shellRenderMode: mode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeMargin,
        mode: BackNavigationMode.historyThenFallback,
      ),
      activeProductId: 'margin',
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được hub ký quỹ',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeMarginTradingHubProvider),
          ),
        ],
        data: (snapshot) => [
          VitTradeHubHero(
            primaryLabel: snapshot.stats[0].label,
            primaryValue: snapshot.stats[0].value,
            primaryColor: Color(snapshot.stats[0].colorHex),
            secondaryLabel: snapshot.stats[1].label,
            secondaryValue: snapshot.stats[1].value,
            secondaryColor: Color(snapshot.stats[1].colorHex),
          ),
          VitTradeSection(
            title: 'Điều hướng',
            child: _NavigationCard(items: snapshot.menuItems),
          ),
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Xem lại rủi ro ký quỹ',
            message:
                'Kiểm tra hạn đòn bẩy, rủi ro thanh lý, phí và ký quỹ khả dụng trước khi mở bất kỳ luồng margin nào.',
            contractId: 'SC-090 margin hub review',
            density: VitDensity.tool,
          ),
          VitTradeSection(
            title: 'Tính năng',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final feature in snapshot.features) ...[
                  _FeatureCard(feature: feature),
                  if (feature != snapshot.features.last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                ],
              ],
            ),
          ),
          VitTradeSection(
            title: 'Tuân thủ',
            child: _ComplianceCard(compliance: snapshot.compliance),
          ),
        ],
      ),
    );
  }
}
