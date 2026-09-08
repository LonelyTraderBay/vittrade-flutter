import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Biến động thị trường (SC-010): tab nhóm + timeframe +
/// bảng mover độ dày tablet (một hàng đầy đủ trường, khác bố cục card
/// 2 dòng của phone — re-compose theo chuẩn density tablet).
class MarketsMoversPane extends ConsumerStatefulWidget {
  const MarketsMoversPane({super.key});

  static const contentKey = Key('sc010_tablet_content');

  @override
  ConsumerState<MarketsMoversPane> createState() => _MarketsMoversPaneState();
}

class _MarketsMoversPaneState extends ConsumerState<MarketsMoversPane> {
  String _tab = 'Tăng mạnh';
  String _timeframe = '24h';
  final String _category = 'Tất cả';
  String _sort = 'change';

  double _changeFor(MarketMover mover) {
    return switch (_timeframe) {
      '1h' => mover.change1h,
      '7d' => mover.change7d,
      _ => mover.change24h,
    };
  }

  List<MarketMover> _visibleMovers(MarketMoversSnapshot snapshot) {
    Iterable<MarketMover> movers = snapshot.movers;
    if (_category != 'Tất cả') {
      movers = movers.where((mover) => mover.category == _category);
    }
    switch (_tab) {
      case 'Giảm mạnh':
        movers = movers.where((mover) => _changeFor(mover) < 0);
      case 'KL bất thường':
        movers = movers.where((mover) => mover.volumeChange24h > 0);
      case 'Mới niêm yết':
        movers = movers.where((mover) => mover.isNew);
      case 'Hoạt động':
        break;
      case 'Tăng mạnh':
      default:
        movers = movers.where((mover) => _changeFor(mover) > 0);
    }
    final sorted = movers.toList();
    switch (_sort) {
      case 'volume':
        if (_tab == 'KL bất thường') {
          sorted.sort((a, b) => b.volumeChange24h.compareTo(a.volumeChange24h));
        } else {
          sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
        }
      case 'market_cap':
        sorted.sort((a, b) => b.marketCap.compareTo(a.marketCap));
      case 'change':
      default:
        if (_tab == 'Giảm mạnh') {
          sorted.sort((a, b) => _changeFor(a).compareTo(_changeFor(b)));
        } else {
          sorted.sort((a, b) => _changeFor(b).compareTo(_changeFor(a)));
        }
    }
    if (_tab == 'Hoạt động' && _sort == 'change') {
      sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final moversAsync = ref.watch(marketMoversSnapshotProvider);

    return MarketsPaneScaffold(
      title: 'Biến động thị trường',
      subtitle: 'Tăng/giảm · Khối lượng',
      scrollKey: MarketsMoversPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketMoversSnapshotProvider);
        await ref.read(marketMoversSnapshotProvider.future);
      },
      children: moversAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được biến động thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketMoversSnapshotProvider),
          ),
        ],
        data: (snapshot) {
          final movers = _visibleMovers(snapshot);
          return [
            VitSegmentedTabBar(
              tabs: [
                for (final tab in snapshot.tabs)
                  VitTabItem(key: tab, label: tab),
              ],
              activeKey: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Row(
              children: [
                for (final timeframe in snapshot.timeframes) ...[
                  VitFilterChip(
                    label: timeframe,
                    active: _timeframe == timeframe,
                    onTap: () => setState(() => _timeframe = timeframe),
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                ],
                const Spacer(),
                VitFilterChip(
                  label: 'Sắp: Biến động',
                  active: _sort == 'change',
                  onTap: () => setState(() => _sort = 'change'),
                  color: AppColors.primary,
                ),
                const SizedBox(width: TabletSpacingTokens.x3),
                VitFilterChip(
                  label: 'Khối lượng',
                  active: _sort == 'volume',
                  onTap: () => setState(() => _sort = 'volume'),
                  color: AppColors.primary,
                ),
                const SizedBox(width: TabletSpacingTokens.x3),
                VitFilterChip(
                  label: 'Vốn hóa',
                  active: _sort == 'market_cap',
                  onTap: () => setState(() => _sort = 'market_cap'),
                  color: AppColors.primary,
                ),
              ],
            ),
            _MoversTable(movers: movers, changeFor: _changeFor),
          ];
        },
      ),
    );
  }
}

class _MoversTable extends StatelessWidget {
  const _MoversTable({required this.movers, required this.changeFor});

  final List<MarketMover> movers;
  final double Function(MarketMover) changeFor;

  @override
  Widget build(BuildContext context) {
    if (movers.isEmpty) {
      return const VitEmptyState(
        icon: Icons.swap_vert_rounded,
        title: 'Không có mover phù hợp',
        message: 'Thử đổi tab, timeframe hoặc nhóm tài sản.',
      );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < movers.length; i++) ...[
            _MoverRow(mover: movers[i], changeFor: changeFor),
            if (i < movers.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({required this.mover, required this.changeFor});

  final MarketMover mover;
  final double Function(MarketMover) changeFor;

  @override
  Widget build(BuildContext context) {
    final change = changeFor(mover);
    final changeColor = change >= 0 ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text.rich(
              TextSpan(
                text: '${mover.symbol} ',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  color: AppColors.text1,
                ),
                children: [
                  TextSpan(
                    text: mover.isNew ? '· Mới' : '',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatMarketPriceAdaptive(mover.price),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
              style: AppTextStyles.caption.copyWith(
                color: changeColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatMarketCompact(mover.volume24h, prefix: '\$'),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatMarketCompact(mover.marketCap, prefix: '\$'),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
