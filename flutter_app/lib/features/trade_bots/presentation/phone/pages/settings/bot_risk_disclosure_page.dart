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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_risk_disclosure_page_sections.dart';
part '../../../widgets/settings/bot_risk_disclosure_page_common.dart';

const _botRiskRed = AppColors.sell;
const _botRiskAmber = AppColors.caution;
const _botRiskPurple = AppColors.accent;
const _botRiskPrimary = AppColors.primary;
const _botRiskGreen = AppColors.buy;
const _riskSpace = AppSpacing.x2;
const _riskTinySpace = AppSpacing.x1;
const _riskIconTile = AppSpacing.iconLg;
const _riskActionHeight = AppSpacing.searchBarCompactHeight;
const _riskLineTight = 1.2;

class BotRiskDisclosurePage extends ConsumerStatefulWidget {
  const BotRiskDisclosurePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc118_bot_risk_content');
  static const acknowledgmentKey = Key('sc118_bot_risk_acknowledgment');
  static const ctaKey = Key('sc118_bot_risk_cta');
  static Key categoryKey(String id) => Key('sc118_bot_risk_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotRiskDisclosurePage> createState() =>
      _BotRiskDisclosurePageState();
}

class _BotRiskDisclosurePageState extends ConsumerState<BotRiskDisclosurePage> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotRiskDisclosureProvider);
    return VitTradeHubScaffold(
      title: 'Công bố rủi ro',
      subtitle: 'Công bố rủi ro trước khi dùng bot',
      semanticLabel: 'Công bố rủi ro khi sử dụng bot giao dịch',
      semanticIdentifier: 'SC-118',
      contentKey: BotRiskDisclosurePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được công bố rủi ro',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotRiskDisclosureProvider),
          ),
        ],
        data: (snapshot) => [
          VitBotSubpageHero(
            primaryLabel: 'Nhóm rủi ro',
            primaryValue: '${snapshot.categories.length}',
            secondaryLabel: 'Xác nhận',
            secondaryValue: _acknowledged ? 'Đã đọc' : 'Chưa đọc',
            secondaryColor: _acknowledged ? _botRiskGreen : _botRiskAmber,
          ),
          VitTradeSection(
            title: 'Cảnh báo rủi ro cao',
            child: _HighRiskBanner(snapshot: snapshot),
          ),
          VitTradeSection(
            title: 'Hiệu suất quá khứ',
            child: _PastPerformanceCard(snapshot: snapshot),
          ),
          VitTradeSection(
            title: snapshot.riskSectionLabel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final category in snapshot.categories)
                  _RiskCategoryCard(category: category),
              ],
            ),
          ),
          VitTradeSection(
            title: snapshot.additionalWarningsLabel,
            child: _AdditionalWarningsCard(
              warnings: snapshot.additionalWarnings,
            ),
          ),
          VitTradeSection(
            title: snapshot.regulatoryNoticeLabel,
            child: _RegulatoryNoticeCard(snapshot: snapshot),
          ),
          VitTradeSection(
            title: snapshot.acknowledgmentLabel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AcknowledgmentCard(
                  snapshot: snapshot,
                  acknowledged: _acknowledged,
                  onTap: () => setState(() => _acknowledged = !_acknowledged),
                ),
                _RiskCta(
                  snapshot: snapshot,
                  acknowledged: _acknowledged,
                  onPressed: () => context.go(snapshot.nextPath),
                ),
              ],
            ),
          ),
          VitTradeSection(
            title: 'Hỗ trợ',
            child: _HelpCard(snapshot: snapshot),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại công bố rủi ro Bot',
            message:
                'Hiệu suất quá khứ, rủi ro theo hạng mục, thông báo quy định, xác nhận và bước tiếp theo được xem lại trước khi cấp quyền truy cập bot.',
            contractId: 'bot-risk-disclosure-review',
            statusLabel: 'Cần xác nhận',
            status: VitStatusPillStatus.error,
          ),
        ],
      ),
    );
  }
}
