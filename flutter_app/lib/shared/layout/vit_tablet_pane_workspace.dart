import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Workspace 2 cột cho trang render trong detail pane của một master-detail
/// shell (`VitTabletPaneWorkspace` — idiom "pane-workspace", predictions
/// redesign 2026-09-17). Khác `VitTwoColumnTabletDashboard` (trang top-level
/// cap + căn giữa cặp cột, ngưỡng 900), scaffold này sống TRONG pane ~840dp
/// của shell markets: không cap/căn giữa — cột chính `Expanded` nhận toàn bộ
/// width shell trao, panel phụ `SizedBox` cố định
/// [TabletDashboardWidths.paneWorkspaceSecondaryWidth].
///
/// Hợp đồng composition:
/// - **Gutter-flush bẩm sinh (S6):** shell đã sở hữu
///   `outerHorizontalMargin` nên workspace KHÔNG tự thêm mép ngang nào —
///   hai cột thẳng mép với header `horizontalPadding: zero` của trang. Đây
///   là idiom flush thứ 4 của audit `tablet_gutter_flush_audit`.
/// - **Hai cột scroll độc lập (R4):** mỗi cột một `SingleChildScrollView`
///   riêng — panel phụ cuộn riêng nên ticket/panel điều khiển luôn "sống"
///   cạnh nội dung chính đang cuộn.
/// - **Panel phụ đóng khung (R7):** `VitCardVariant.inner` + viền
///   `AppColors.borderSolid` + `VitContentPadding.relaxed` — cùng idiom
///   sidebar của dashboard chuẩn (fill đơn độc không đủ đọc thành panel).
/// - **R4 section gap:** cả hai cột dùng `VitPageContent` rhythm standard —
///   caller KHÔNG tự chèn SizedBox ngăn cách (S4); thở cuối trang
///   `pageEndBreathing` 32dp do workspace cấp (S7).
/// - **Fallback một cột:** dưới [splitMinWidth] (tablet portrait pane ~360dp)
///   render [narrowChildren] — trang tự khai thứ tự phone-parity, khác
///   dashboard chuẩn (primary+secondary nối tiếp) vì pane hẹp cần đúng nhịp
///   phone đã duyệt, không phải thứ tự cột tablet.
class VitTabletPaneWorkspace extends StatelessWidget {
  const VitTabletPaneWorkspace({
    super.key,
    required this.primaryChildren,
    required this.secondaryChildren,
    required this.narrowChildren,
    this.contentKey,
    this.secondaryContentKey,
    this.secondaryWidth = TabletDashboardWidths.paneWorkspaceSecondaryWidth,
    this.splitMinWidth = TabletDashboardWidths.paneWorkspaceSplitMinWidth,
  });

  /// Nội dung cột chính ở tầng workspace (thị trường/dữ liệu). Ở tầng hẹp
  /// không dùng — xem [narrowChildren].
  final List<Widget> primaryChildren;

  /// Nội dung panel phụ (ticket/điều khiển), đóng khung R7, scroll riêng.
  final List<Widget> secondaryChildren;

  /// Nội dung một cột khi pane hẹp hơn [splitMinWidth] — trang tự khai thứ
  /// tự phone-parity (thường là danh sách section gốc trước khi lên
  /// workspace).
  final List<Widget> narrowChildren;

  /// Key của vùng scroll cột chính / cột hẹp (probe/audit/test).
  final Key? contentKey;

  /// Key của vùng scroll panel phụ — test nhắm tương tác vào đúng cột.
  final Key? secondaryContentKey;

  /// Chiều rộng panel phụ. Mặc định token dùng chung; chỉ override kèm bằng
  /// chứng measured trên trang đó (R8), không bump vì "nhìn gần đúng".
  final double secondaryWidth;

  /// Độ rộng pane tối thiểu để tách 2 cột — xem
  /// [TabletDashboardWidths.paneWorkspaceSplitMinWidth].
  final double splitMinWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < splitMinWidth) {
          return SingleChildScrollView(
            key: contentKey,
            padding: const EdgeInsetsDirectional.only(
              bottom: TabletSpacingTokens.pageEndBreathing,
            ),
            child: VitPageContent(
              padding: VitContentPadding.compact,
              fullBleed: true,
              rhythm: VitPageRhythm.standard,
              children: narrowChildren,
            ),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: const EdgeInsetsDirectional.only(
                  bottom: TabletSpacingTokens.pageEndBreathing,
                ),
                // Không mép ngang riêng (idiom dashboard R5): cột chính và
                // khung panel nằm trên CÙNG một mặt phẳng nội dung, tách
                // nhau bằng gutter dưới.
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  rhythm: VitPageRhythm.standard,
                  customGap: TabletSpacingTokens.pageRhythmStandardSectionGap,
                  children: primaryChildren,
                ),
              ),
            ),
            const SizedBox(width: TabletDashboardWidths.columnGutter),
            SizedBox(
              width: secondaryWidth,
              child: SingleChildScrollView(
                key: secondaryContentKey,
                child: VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.standard,
                  padding: EdgeInsets.zero,
                  borderColor: AppColors.borderSolid,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      bottom: TabletSpacingTokens.pageEndBreathing,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      rhythm: VitPageRhythm.standard,
                      customGap:
                          TabletSpacingTokens.pageRhythmStandardSectionGap,
                      children: secondaryChildren,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
