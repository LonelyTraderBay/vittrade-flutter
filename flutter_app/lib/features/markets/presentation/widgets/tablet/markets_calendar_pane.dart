import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_calendar_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_calendar_events.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_calendar_filters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_calendar_month.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Lịch sự kiện (SC-017) — view tabs + bộ lọc type/impact +
/// list/month grid dùng lại widget public của trang phone.
class MarketsCalendarPane extends ConsumerStatefulWidget {
  const MarketsCalendarPane({super.key});

  static const contentKey = Key('sc017_tablet_content');

  @override
  ConsumerState<MarketsCalendarPane> createState() =>
      _MarketsCalendarPaneState();
}

class _MarketsCalendarPaneState extends ConsumerState<MarketsCalendarPane> {
  String _view = 'list';
  MarketCalendarTypeFilter _typeFilter = marketCalendarTypeFilters.first;
  MarketCalendarImpact? _impactFilter;
  String? _expandedId;

  void _setType(MarketCalendarTypeFilter filter) {
    setState(() {
      _typeFilter = filter;
      _expandedId = null;
    });
  }

  void _toggleImpact(MarketCalendarImpact impact) {
    setState(() {
      _impactFilter = _impactFilter == impact ? null : impact;
      _expandedId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = MarketCalendarQuery(
      type: _typeFilter.type,
      impact: _impactFilter,
    );
    final calendarAsync = ref.watch(marketCalendarSnapshotProvider(query));

    return MarketsPaneScaffold(
      title: 'Lịch sự kiện',
      subtitle: 'Sự kiện · Markets',
      scrollKey: MarketsCalendarPane.contentKey,
      children: [
        MarketCalendarViewTabs(
          activeView: _view,
          onChanged: (value) => setState(() => _view = value),
        ),
        calendarAsync.when(
          loading: () => const Column(children: [VitSkeletonList()]),
          error: (error, stackTrace) => Column(
            children: [
              VitErrorState(
                title: 'Không tải được lịch sự kiện',
                message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () =>
                    ref.invalidate(marketCalendarSnapshotProvider(query)),
              ),
            ],
          ),
          data: (snapshot) => Column(
            children: [
              MarketCalendarStatsSummary(stats: snapshot.stats),
              MarketCalendarTypeFilters(
                active: _typeFilter,
                onSelected: _setType,
              ),
              MarketCalendarImpactFilters(
                activeImpact: _impactFilter,
                onSelected: _toggleImpact,
              ),
              if (_view == 'list')
                if (snapshot.events.isEmpty)
                  const VitEmptyState(
                    icon: Icons.calendar_month_rounded,
                    title: 'Không có sự kiện phù hợp',
                    message: 'Thử đổi loại sự kiện hoặc mức tác động.',
                  )
                else
                  MarketCalendarEventGroups(
                    events: snapshot.events,
                    expandedId: _expandedId,
                    onToggle: (id) => setState(() {
                      _expandedId = _expandedId == id ? null : id;
                    }),
                  )
              else
                MarketCalendarMonthGrid(
                  events: snapshot.events,
                  onEventDaySelected: (event) => setState(() {
                    _view = 'list';
                    _expandedId = event.id;
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
