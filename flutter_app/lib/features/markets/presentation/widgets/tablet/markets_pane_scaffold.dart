import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';

/// Scroll scaffold dùng chung cho các detail pane của Markets terminal
/// master-detail (pair detail / token info / depth): một [VitHeader] tuỳ
/// chọn (back chỉ hiện dưới ngưỡng 2 cột — nơi master list không còn kề
/// pane), đúng một `SingleChildScrollView` sở hữu scroll của pane, và
/// pull-to-refresh tuỳ chọn — cùng contract refresh với shared dashboard.
///
/// [children] cấp tối đa phải FLAT: `VitPageContent(rhythm:)` bên trong đã
/// chèn section gap giữa mọi cặp children, nên `SizedBox(height:)` đứng
/// thành phần tử của `children` cộng dồn lên gap đó và phá nhịp dọc —
/// khóa bởi `tablet_spacing_audit` rule S4.
class MarketsPaneScaffold extends StatelessWidget {
  const MarketsPaneScaffold({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.onBack,
    this.onRefresh,
    this.headerActions,
    this.scrollKey,
    this.rhythm = VitPageRhythm.relaxed,
  });

  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final RefreshCallback? onRefresh;
  final List<VitHeaderActionItem>? headerActions;
  final VitPageRhythm rhythm;
  final Key? scrollKey;

  @override
  Widget build(BuildContext context) {
    Widget body = SingleChildScrollView(
      key: scrollKey,
      physics: onRefresh == null ? null : const AlwaysScrollableScrollPhysics(),
      child: VitPageContent(
        rhythm: rhythm,
        padding: VitContentPadding.relaxed,
        density: VitDensity.compact,
        fullBleed: true,
        children: children,
      ),
    );
    if (onRefresh != null) {
      body = RefreshIndicator(onRefresh: onRefresh!, child: body);
    }

    final headerTitle = title;
    return Column(
      children: [
        if (headerTitle != null)
          Builder(
            builder: (context) {
              // Back chỉ cần nơi master list không còn nằm kề pane — do
              // độ RỘNG CỦA SHELL quyết định (màn hình trừ nav rail), không
              // phải độ rộng cột pane: trên tablet 1280dp pane chỉ ~720dp
              // (< twoColumnMinWidth) nhưng shell vẫn render master list
              // kề nó, mũi tên back ở đó trùng lặp với danh sách luôn hiện.
              final narrow =
                  MediaQuery.sizeOf(context).width - VitNavigationRail.width <
                  TabletDashboardWidths.twoColumnMinWidth;
              return VitHeader(
                title: headerTitle,
                subtitle: subtitle,
                showBack: narrow && onBack != null,
                onBack: onBack,
                actions: headerActions ?? const [],
                horizontalPadding: AppSpacing.zero,
              );
            },
          ),
        Expanded(child: body),
      ],
    );
  }
}
