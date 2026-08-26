import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_navigation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

part 'markets_token_info_pane_sections.dart';
part 'markets_token_info_pane_details.dart';

/// Ba tab thông tin token — mirror `_TokenInfoTab` của trang Phone, đặt
/// public cho test tablet khóa theo key chuỗi.
enum MarketsTokenInfoTab { overview, onchain, project }

String marketsTokenInfoTabKey(MarketsTokenInfoTab tab) => switch (tab) {
  MarketsTokenInfoTab.overview => 'overview',
  MarketsTokenInfoTab.onchain => 'onchain',
  MarketsTokenInfoTab.project => 'project',
};

MarketsTokenInfoTab marketsTokenInfoTabFromKey(String key) => switch (key) {
  'onchain' => MarketsTokenInfoTab.onchain,
  'project' => MarketsTokenInfoTab.project,
  _ => MarketsTokenInfoTab.overview,
};

/// Detail pane thông tin token (SC-045) của Markets terminal master-detail:
/// port từ `TokenInfoPage` Phone theo R2 — các widget private của part
/// family Phone được viết lại thành section public của pane (copy chuẩn
/// widget + token, chuỗi copy được viết lại đủ dấu theo chính sách i18n).
/// Cùng provider `marketTokenInfoSnapshotProvider(pairId)`.
class MarketsTokenInfoPane extends ConsumerStatefulWidget {
  const MarketsTokenInfoPane({super.key, required this.pairId});

  final String pairId;

  @override
  ConsumerState<MarketsTokenInfoPane> createState() =>
      _MarketsTokenInfoPaneState();
}

class _MarketsTokenInfoPaneState extends ConsumerState<MarketsTokenInfoPane> {
  MarketsTokenInfoTab _tab = MarketsTokenInfoTab.overview;

  Future<void> _refresh() async {
    ref.invalidate(marketTokenInfoSnapshotProvider(widget.pairId));
    await ref.read(marketTokenInfoSnapshotProvider(widget.pairId).future);
  }

  @override
  Widget build(BuildContext context) {
    final infoAsync = ref.watch(marketTokenInfoSnapshotProvider(widget.pairId));
    final fallbackTitle = '${widget.pairId.toUpperCase()} · Thông tin';

    return infoAsync.when(
      loading: () => MarketsPaneScaffold(
        title: fallbackTitle,
        subtitle: 'Tokenomics · On-chain · Dự án',
        onBack: () => openMarketsDetailRoute(
          context,
          AppRoutePaths.pairDetail(widget.pairId),
        ),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => MarketsPaneScaffold(
        title: fallbackTitle,
        subtitle: 'Tokenomics · On-chain · Dự án',
        onBack: () => openMarketsDetailRoute(
          context,
          AppRoutePaths.pairDetail(widget.pairId),
        ),
        children: [
          VitErrorState(
            title: 'Không tải được thông tin token',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
      ),
      data: (snapshot) => MarketsPaneScaffold(
        title: '${snapshot.pair.baseAsset} · Thông tin',
        subtitle: 'Tokenomics · On-chain · Dự án',
        onBack: () => openMarketsDetailRoute(
          context,
          AppRoutePaths.pairDetail(snapshot.pair.id),
        ),
        onRefresh: _refresh,
        scrollKey: MarketsTabletKeys.tokenPaneContent,
        children: [
          _TokenTabs(
            active: _tab,
            onChanged: (tab) => setState(() => _tab = tab),
          ),
          if (_tab == MarketsTokenInfoTab.overview)
            _OverviewTab(snapshot: snapshot)
          else if (_tab == MarketsTokenInfoTab.onchain)
            _OnchainTab(snapshot: snapshot)
          else
            _ProjectTab(snapshot: snapshot),
          const _Disclaimer(),
        ],
      ),
    );
  }
}
