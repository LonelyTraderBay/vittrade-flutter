import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
    // Dải ghim dưới scroll (không cuộn) — dùng cho desk footer của pane
    // pair (giá + MUA/BÁN luôn nhìn thấy). Null = không có dải ghim.
    this.footer,
    // Terminal thuần (2026-08-30): khi != null, THAY TOÀN BỘ vùng cuộn —
    // pane tự vẽ grid cố định chiếm hết chiều cao (children/scrollKey bị
    // bỏ qua). Chỉ pane pair desk dùng; các pane khác giữ children.
    this.body,
    // Detail scroll ⇒ tier standard (section gap 13dp) theo bảng
    // Page-Rhythm; pane chart/terminal (depth) khai báo flush riêng.
    this.rhythm = VitPageRhythm.standard,
  });

  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final RefreshCallback? onRefresh;
  final List<VitHeaderActionItem>? headerActions;
  final VitPageRhythm rhythm;
  final Key? scrollKey;
  final Widget? footer;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    Widget scrollArea = SingleChildScrollView(
      key: scrollKey,
      physics: onRefresh == null ? null : const AlwaysScrollableScrollPhysics(),
      child: VitPageContent(
        rhythm: rhythm,
        // density: compact quyết top padding + section gap (padding: sẽ bị
        // density override toàn bộ — không truyền để khỏi gây hiểu nhầm).
        density: VitDensity.compact,
        fullBleed: true,
        children: children,
      ),
    );
    if (onRefresh != null) {
      scrollArea = RefreshIndicator(onRefresh: onRefresh!, child: scrollArea);
    }

    final headerTitle = title;
    return Column(
      children: [
        if (headerTitle != null)
          Builder(
            builder: (context) {
              // Back chỉ cần nơi master list không còn nằm kề pane — do
              // độ RỘNG CỦA SHELL quyết định (màn hình trừ nav rail) đối
              // chiếu với ngưỡng SPLIT của master-detail, không phải độ
              // rộng cột pane: cả hai tầng split (wide ≥900 căn giữa,
              // portrait 680–899 với master hẹp 308) đều giữ master list
              // kề pane, mũi tên back ở đó trùng lặp với danh sách luôn
              // hiện; chỉ tầng stacked fallback dưới ngưỡng split render
              // pane toàn chiều rộng cần đường quay lại riêng.
              final narrow =
                  MediaQuery.sizeOf(context).width - VitNavigationRail.width <
                  TabletDashboardWidths.masterDetailSplitMinWidth;
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
        Expanded(child: body ?? scrollArea),
        if (footer != null) ...[
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          footer!,
        ],
      ],
    );
  }
}
