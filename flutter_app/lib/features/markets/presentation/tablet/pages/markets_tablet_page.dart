import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_discover.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_movers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_tools.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pulse_strip.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_status_content.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Markets tablet — overview pane (SC-008) của terminal master-detail
/// shell (`MarketsTabletMasterShell`): cùng route, cùng dữ liệu
/// [marketListSnapshotProvider] với trang Phone, nhưng nội dung tổng quan
/// (pulse banner + biến động nổi bật + công cụ + khám phá) render trong
/// detail pane một cột bên cạnh master list luôn hiện. Danh sách cặp đầy đủ
/// sống ở cột master — pane này chỉ còn phần tổng quan/watch-list-adjacent
/// không phụ thuộc filter. Header do shell sở hữu (R9) — pane không tự vẽ
/// top chrome.
class MarketsTabletPage extends ConsumerStatefulWidget {
  const MarketsTabletPage({super.key});

  @override
  ConsumerState<MarketsTabletPage> createState() => _MarketsTabletPageState();
}

class _MarketsTabletPageState extends ConsumerState<MarketsTabletPage> {
  void _go(String path) => context.go(path);

  Future<void> _refreshMarkets() async {
    ref.invalidate(marketListSnapshotProvider);
    await ref.read(marketListSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(marketListSnapshotProvider);

    return listAsync.when(
      loading: () => const MarketsLoadingContent(),
      error: (error, stackTrace) => VitInsetScrollView(
        key: MarketsTabletKeys.content,
        physics: const AlwaysScrollableScrollPhysics(),
        child: VitErrorState(
          title: 'Không tải được thị trường',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: _refreshMarkets,
        ),
      ),
      data: (_) => _buildOverview(),
    );
  }

  Widget _buildOverview() {
    final snapshot = ref.watch(
      marketListStateControllerProvider.select((state) => state.snapshot),
    );

    return RefreshIndicator(
      onRefresh: _refreshMarkets,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: VitInsetScrollView(
          key: MarketsTabletKeys.content,
          physics: const AlwaysScrollableScrollPhysics(),
          child: VitPageContent(
            // Tab root ⇒ tier compact theo bảng Page-Rhythm (section gap 8dp)
            // — relaxed 24dp là của hero/onboarding, làm pane terminal thưa
            // (user đánh dấu X 2026-08-28); wire pattern chuẩn tab root:
            // rhythm + padding + density đều compact.
            rhythm: VitPageRhythm.standard,
            padding: VitContentPadding.compact,
            density: VitDensity.compact,
            fullBleed: true,
            children: [
              MarketsPulseStrip(
                key: MarketsTabletKeys.pulseStrip,
                pairs: snapshot.marketPairs,
                lastUpdatedLabel: snapshot.lastUpdatedLabel,
              ),
              VitPageSection(
                label: 'Biến động nổi bật',
                headerVariant: VitSectionHeaderVariant.plain,
                innerGap: AppSpacing.x4,
                children: [MarketListTopMovers(pairs: snapshot.marketPairs)],
              ),
              VitPageSection(
                label: 'Công cụ thị trường',
                headerVariant: VitSectionHeaderVariant.plain,
                innerGap: AppSpacing.x4,
                children: [MarketListTools(onNavigate: _go, tablet: true)],
              ),
              const VitPageSection(
                label: 'Lối tắt từ Markets',
                headerVariant: VitSectionHeaderVariant.plain,
                innerGap: AppSpacing.x4,
                children: [MarketListDiscoverMoreSection()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
