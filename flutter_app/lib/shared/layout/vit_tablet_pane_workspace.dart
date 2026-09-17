import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Workspace 2 cột (cột chính + panel phụ đóng khung) cho trang tablet —
/// sinh cho redesign predictions (2026-09-17) và nâng lên tầng top-level
/// cùng ngày P2 tách route `/predictions/**`: predictions giờ là trang
/// top-level như Arena nên workspace TỰ sở hữu mép ngang và cap cặp cột
/// (idiom R5 của `VitTwoColumnTabletDashboard`), không còn dựa shell cấp.
///
/// Hợp đồng composition:
/// - **Mép ngang do workspace sở hữu:** [outerHorizontalMargin] mỗi bên ở
///   MỌI tầng (rộng lẫn hẹp). Trang render trong detail pane của một
///   master-detail shell TRUYỀN `outerHorizontalMargin: 0` để trả mép cho
///   shell (S6 — idiom flush thứ 4 của audit `tablet_gutter_flush_audit`).
/// - **Cap cặp cột kiểu dashboard (R5):** tầng rộng bọc `Center` +
///   `ConstrainedBox(maxWidth: [maxPairWidth])` quanh cả `Row` — cột chính
///   không phình vô hạn trên màn rất rộng (phone-phóng-to tầng trong), phần
///   thừa phân bổ đối xứng hai bên. Mặc định
///   `primaryColumnMaxWidth + secondaryWidth + columnGutter`.
/// - **Hai cột scroll độc lập (R4):** mỗi cột một `SingleChildScrollView`
///   riêng — panel phụ cuộn riêng nên ticket/panel điều khiển luôn "sống"
///   cạnh nội dung chính đang cuộn.
/// - **Panel phụ đóng khung (R7):** `VitCardVariant.inner` + viền
///   `AppColors.borderSolid` + `VitContentPadding.relaxed` — cùng idiom
///   sidebar của dashboard chuẩn (fill đơn độc không đủ đọc thành panel).
/// - **R4 section gap:** cả hai cột dùng `VitPageContent` rhythm standard —
///   caller KHÔNG tự chèn SizedBox ngăn cách (S4); thở cuối trang
///   `pageEndBreathing` 32dp do workspace cấp (S7).
/// - **Fallback một cột:** dưới [splitMinWidth] (tablet portrait ~704dp)
///   render [narrowChildren] — trang tự khai thứ tự phone-parity, khác
///   dashboard chuẩn (primary+secondary nối tiếp) vì cột hẹp cần đúng nhịp
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
    this.outerHorizontalMargin = TabletDashboardWidths.outerHorizontalMargin,
    this.maxPairWidth,
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

  /// Độ rộng tối thiểu để tách 2 cột — xem
  /// [TabletDashboardWidths.paneWorkspaceSplitMinWidth].
  final double splitMinWidth;

  /// Mép ngang mỗi bên workspace sở hữu ở mọi tầng. Mặc định LUẬT 12dp cho
  /// trang top-level; trang trong detail pane của master-detail shell truyền
  /// `0` (S6 gutter-flush — shell đã cấp mép).
  final double outerHorizontalMargin;

  /// Cap tổng bề rộng cặp cột ở tầng rộng (R5). `null` = tính từ
  /// `primaryColumnMaxWidth + secondaryWidth + columnGutter`.
  final double? maxPairWidth;

  @override
  Widget build(BuildContext context) {
    final pairCap =
        maxPairWidth ??
        TabletDashboardWidths.primaryColumnMaxWidth +
            secondaryWidth +
            TabletDashboardWidths.columnGutter;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < splitMinWidth) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: outerHorizontalMargin,
              end: outerHorizontalMargin,
            ),
            child: SingleChildScrollView(
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
            ),
          );
        }
        return Padding(
          padding: EdgeInsetsDirectional.only(
            start: outerHorizontalMargin,
            end: outerHorizontalMargin,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: pairCap),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: contentKey,
                      padding: const EdgeInsetsDirectional.only(
                        bottom: TabletSpacingTokens.pageEndBreathing,
                      ),
                      // Không mép ngang riêng (idiom dashboard R5): cột chính
                      // và khung panel nằm trên CÙNG một mặt phẳng nội dung,
                      // tách nhau bằng gutter dưới.
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        rhythm: VitPageRhythm.standard,
                        customGap:
                            TabletSpacingTokens.pageRhythmStandardSectionGap,
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
                            customGap: TabletSpacingTokens
                                .pageRhythmStandardSectionGap,
                            children: secondaryChildren,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
