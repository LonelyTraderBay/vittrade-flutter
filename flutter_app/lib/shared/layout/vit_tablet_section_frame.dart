import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Phần thân đọc của [VitTabletSectionFrame], tách public cho trang đã tự vẽ
/// header riêng (khối `Center + ConstrainedBox(maxWidth: 1080)` inline cũ):
/// cột top-start cap [TabletDashboardWidths.readingContentMaxWidth], mép
/// `contentPad`, thở cuối trang `pageEndBreathing`, section gap 12 do
/// `VitPageContent(rhythm: standard)` sở hữu (S4) — children KHÔNG tự chèn
/// SizedBox ngăn cách.
class VitTabletSectionBody extends StatelessWidget {
  const VitTabletSectionBody({
    super.key,
    required this.children,
    this.contentKey,
    this.gutterFlush = false,
  });

  /// Danh sách section — gap 12dp do body chèn giữa từng cặp.
  final List<Widget> children;

  /// Key của vùng scroll (probe/audit dùng để xác nhận nội dung render).
  final Key? contentKey;

  /// Trang render trong detail column của một master-detail shell phải là
  /// gutter-flush (S6 — Chuẩn Tablet Spacing & Gutter): shell đã sở hữu
  /// `outerHorizontalMargin`, nên trang không stack thêm `contentPad` lên
  /// trên (12 + 20 = 32dp mép phải — lớp bug stacking 2026-08-28). Khi
  /// bật, inset ngang của body về 0 — tổng inset từ mép màn hình do shell
  /// cấp; trang top-level (không nằm trong shell) giữ mặc định false.
  final bool gutterFlush;

  @override
  Widget build(BuildContext context) {
    final horizontalInset = gutterFlush
        ? TabletSpacingTokens.zero
        : TabletSpacingTokens.contentPad;
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TabletDashboardWidths.readingContentMaxWidth,
        ),
        child: SingleChildScrollView(
          key: contentKey,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: horizontalInset,
              end: horizontalInset,
              bottom: TabletSpacingTokens.pageEndBreathing,
            ),
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              fullBleed: true,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

/// Khung composition chuẩn cho trang tablet top-level dạng một cột
/// "header + danh sách section" (arena, hỗ trợ, quản trị, compliance…),
/// thay cho khuôn tự chế `Center + ConstrainedBox(maxWidth: …)` từng bị
/// copy-paste 44 lần (2026-09-09, lỗi "khoảng trống khổng lồ trên/dưới" do
/// `Center` căn giữa dọc nội dung thưa + mép trái lệch header).
///
/// Hợp đồng composition (Chuẩn Tablet Spacing & Gutter):
/// - Cột đọc top-start anchored, cap
///   [TabletDashboardWidths.readingContentMaxWidth] — KHÔNG `Center` dọc.
/// - [VitPageContent] `rhythm: standard` sở hữu section gap 12dp giữa các
///   [children] — caller KHÔNG tự chèn `SizedBox` ngăn cách (S4).
/// - Frame là chủ gutter ngang của chính nó: `fullBleed: true` (S6) +
///   `contentPad` 20dp trong frame, thẳng mép với `VitHeader` mặc định.
/// - Thở cuối trang `pageEndBreathing` 32dp do frame cấp (S7 — breathing
///   sống trong wrapper, không phải children).
///
/// Caller chỉ đưa [children] (card/section); loading/error render bằng cách
/// đưa skeleton/error state làm children — giữ trang top-aligned trong mọi
/// trạng thái. Trang đã tự vẽ header dùng [VitTabletSectionBody] thay cả
/// frame này.
class VitTabletSectionFrame extends StatelessWidget {
  const VitTabletSectionFrame({
    super.key,
    required this.semanticIdentifier,
    required this.semanticLabel,
    required this.title,
    required this.children,
    this.subtitle,
    this.contentKey,
    this.backFallback = AppRoutePaths.home,
    this.gutterFlush = false,
  });

  final String semanticIdentifier;
  final String semanticLabel;
  final String title;
  final String? subtitle;

  /// Danh sách section của trang — gap 12dp do frame chèn giữa từng cặp.
  final List<Widget> children;

  /// Key của vùng scroll (probe/audit dùng để xác nhận nội dung render).
  final Key? contentKey;

  /// Fallback khi stack lịch sử rỗng (back về tab gốc của module).
  final String backFallback;

  /// Gutter-flush (S6) cho trang render trong detail column của master-detail
  /// shell — body bỏ `contentPad` ngang, header `horizontalPadding: zero` để
  /// thẳng mép với nội dung full-bleed cùng cột (idiom Markets overview).
  final bool gutterFlush;

  @override
  Widget build(BuildContext context) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: Column(
        children: [
          VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            horizontalPadding: gutterFlush ? TabletSpacingTokens.zero : null,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: backFallback,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: VitTabletSectionBody(
              contentKey: contentKey,
              gutterFlush: gutterFlush,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
