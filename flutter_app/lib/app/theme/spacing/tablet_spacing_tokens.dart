import 'package:flutter/material.dart';

/// BỘ TOKEN KHOẢNG CÁCH RIÊNG CỦA SURFACE TABLET (user chốt tách hoàn toàn
/// 2026-09-01; chuyển sang hệ Base-8-derived cùng ngày theo hướng A user
/// duyệt): mọi file
/// tablet đọc số liệu khoảng cách/kích thước từ đây, KHÔNG còn đọc
/// `AppSpacing` của phone. Nền căn chỉnh là 4dp; public role scale đóng là
/// 4·8·12·16·24·32·56 — Base-8-derived, không phải lưới 8dp thuần.
/// Gap khối/section chính của Tablet = 12; micro-gap, item-gap và kích thước
/// control dùng token theo vai trò bên dưới. Đổi giá trị ở đây chỉ ảnh hưởng
/// Tablet, Phone bất động.
///
/// Quy ước:
/// - Mọi giá trị inline kèm `// nguồn: AppSpacing.<tên>` để truy vết
///   snapshot; sau này chỉnh giá trị thì cập nhật comment nguồn thành
///   lý do mới (đừng xoá — lịch sử giúp audit).
/// - Luật Base-8-derived (2026-09-01) vẫn thắng: gap khối Tablet là 12.
/// - Guardrail `tablet_gap_12_guardrail_test.dart` whitelist namespace này
///   và không cho gap call-site quay về AppSpacing của Phone.
final class TabletSpacingTokens {
  const TabletSpacingTokens._();

  // ---- Closed Base-8-derived role scale (2026-09-01) ----
  static const double x1 = 4; // micro role (nguồn cũ AppSpacing.x1 = 3)
  static const double x2 = 4; // micro role (nguồn cũ AppSpacing.x2 = 5)
  static const double x3 = 8; // item / compact-section role
  static const double x4 = 12; // block / section role (nguồn cũ 13)
  static const double x5 = 24; // relaxed / hero padding role (nguồn cũ 21)
  static const double x6 = 32; // page-end breathing role (nguồn cũ 34)
  static const double x7 = 56; // reserved extended metric role (nguồn cũ 55)

  // ---- Zero / hairline ----
  static const double zero = 0; // nguồn: AppSpacing.zero
  static const EdgeInsets zeroInsets =
      EdgeInsets.zero; // nguồn: AppSpacing.zeroInsets
  static const double dividerHairline = 1; // nguồn: AppSpacing.dividerHairline
  static const double hairlineStroke = 2; // nguồn: AppSpacing.hairlineStroke
  static const double borderWidth = 1.5; // nguồn: AppSpacing.borderWidth

  // ---- Kích thước control / icon (metric, không phải khoảng trắng) ----
  static const double buttonCompact = 34; // nguồn: AppSpacing.buttonCompact
  static const double buttonStandard = 55; // nguồn: AppSpacing.buttonStandard
  static const double inputHeight = 52; // nguồn: AppSpacing.inputHeight
  static const double ctaHeight = 52; // nguồn: AppSpacing.ctaHeight
  static const double formFieldLabelGap =
      x3; // nguồn cũ AppSpacing = 6; Tablet = 8
  static const double iconSm = 13; // nguồn: AppSpacing.iconSm
  static const double iconMd = 21; // nguồn: AppSpacing.iconMd
  static const double iconLg = 34; // nguồn: AppSpacing.iconLg
  static const double searchBarCompactHeight =
      44; // nguồn: AppSpacing.searchBarCompactHeight
  static const double serviceTileMinHeight =
      54; // nguồn: AppSpacing.serviceTileMinHeight
  static const double accentIconBoxSize =
      34; // nguồn: AppSpacing.accentIconBoxSize (= buttonCompact)

  // ---- Shared primitive snapshots (surface boundary) ----
  // Các token dưới đây giữ cùng metric với Phone khi chưa có yêu cầu thị giác
  // riêng; điểm tách là shared widget không còn đọc AppSpacing trực tiếp.
  static const double minTapTarget = 44; // nguồn: AppSpacing.minTapTarget
  static const double ctaLoadingIcon = 18; // nguồn: AppSpacing.ctaLoadingIcon
  static const double ctaStrokeWidth = 2; // nguồn: AppSpacing.ctaStrokeWidth
  static const double ctaElevationBlur =
      16; // nguồn: AppSpacing.ctaElevationBlur
  static const double ctaElevationSpread =
      -4; // nguồn: AppSpacing.ctaElevationSpread
  static const double ctaElevationYOffset =
      4; // nguồn: AppSpacing.ctaElevationYOffset
  static const double accentIconFillAlpha =
      0.14; // nguồn: AppSpacing.accentIconFillAlpha
  static const double accentIconBorderAlpha =
      0.24; // nguồn: AppSpacing.accentIconBorderAlpha
  static const double sectionGapCompact =
      x3; // Tablet compact/item role = 8 (nguồn cũ AppSpacing.sectionGapCompact = 13)
  static const double sectionGapRegular =
      pageRhythmStandardSectionGap; // Tablet block role = 12
  static const double sectionGapRelaxed =
      pageRhythmStandardSectionGap; // Tablet block role = 12
  static const EdgeInsets cardPaddingHero = EdgeInsets.fromLTRB(
    20,
    24,
    20,
    20,
  ); // nguồn: AppSpacing.cardPaddingHero
  static const EdgeInsetsDirectional cardTilePadding =
      EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: x2);
  static const double cardTileInnerGap =
      pageRhythmCompactInnerGap; // nguồn: AppSpacing.cardTileInnerGap
  static const EdgeInsets taskCardPadding = EdgeInsets.all(
    x4,
  ); // nguồn: AppSpacing.taskCardPadding
  static const double taskCardProgressHeight =
      x3; // nguồn: AppSpacing.taskCardProgressHeight
  static const int taskCardSubtitleMaxLines =
      3; // nguồn: AppSpacing.taskCardSubtitleMaxLines
  static const double taskCardTitleSubtitleGap =
      x1; // nguồn: AppSpacing.taskCardTitleSubtitleGap
  static const double taskCardProgressSectionGap =
      pageRhythmStandardSectionGap; // nguồn: AppSpacing.taskCardProgressSectionGap
  static const double taskCardRewardRowGap =
      x3; // nguồn: AppSpacing.taskCardRewardRowGap
  static const double taskCardListGap = x3; // nguồn: AppSpacing.taskCardListGap
  static const double searchBarFocusBorder =
      1.5; // nguồn: AppSpacing.searchBarFocusBorder
  static const double searchBarNormalBorder =
      1; // nguồn: AppSpacing.searchBarNormalBorder
  static const double searchBarHorizontalPadding =
      12; // nguồn: AppSpacing.searchBarHorizontalPadding
  static const double searchBarHorizontalTrailingPadding =
      x3; // nguồn cũ AppSpacing = 8
  static const double searchBarIcon = 18; // nguồn: AppSpacing.searchBarIcon
  static const double searchBarCompactFont =
      iconSm; // nguồn: AppSpacing.searchBarCompactFont
  static const double searchBarFont = 14; // nguồn: AppSpacing.searchBarFont
  static const double tabBarPillRadius =
      1; // nguồn: AppSpacing.tabBarPillRadius
  static const double statusPillHeightSm =
      20; // nguồn: AppSpacing.statusPillHeightSm
  static const double statusPillHeightMd =
      26; // nguồn: AppSpacing.statusPillHeightMd
  static const double statusPillHeightLg =
      32; // nguồn: AppSpacing.statusPillHeightLg
  static const double statusPillGapSm =
      x1; // nguồn cũ AppSpacing.statusPillGapSm = 3
  static const double statusPillGapMd = x1; // nguồn: AppSpacing.statusPillGapMd
  static const double statusPillGapLg =
      x2; // nguồn cũ AppSpacing.statusPillGapLg = 5
  static const double statusPillHorizontalPaddingSm =
      x3; // nguồn cũ AppSpacing = 6
  static const double statusPillHorizontalPaddingMd =
      10; // nguồn: AppSpacing.statusPillHorizontalPaddingMd
  static const double statusPillHorizontalPaddingLg =
      x4; // nguồn: AppSpacing.statusPillHorizontalPaddingLg
  static const double statusPillIconSizeSm =
      10; // nguồn: AppSpacing.statusPillIconSizeSm
  static const double statusPillIconSizeMd =
      12; // nguồn: AppSpacing.statusPillIconSizeMd
  static const double statusPillIconSizeLg =
      14; // nguồn: AppSpacing.statusPillIconSizeLg
  static const double statusPillBadgeOffset = x1; // nguồn cũ AppSpacing = 3
  static const double statusPillBadgeBlur =
      4; // nguồn: AppSpacing.statusPillBadgeBlur
  static const double statusPillCountPadding = x1; // nguồn cũ AppSpacing = 3
  static const double statusPillCountMinWidthFactor =
      0.65; // nguồn: AppSpacing.statusPillCountMinWidthFactor
  static const double statusPillCountHeightFactor =
      0.65; // nguồn: AppSpacing.statusPillCountHeightFactor
  static const double serviceTileTopStripeHeight =
      2; // nguồn: AppSpacing.serviceTileTopStripeHeight
  static const double serviceTileContentPadding =
      x3; // nguồn: AppSpacing.serviceTileContentPadding
  static const double serviceTileContentPaddingCompact =
      6; // nguồn: AppSpacing.serviceTileContentPaddingCompact
  static const double serviceTileBadgeOffset = x1; // nguồn cũ AppSpacing = 2
  static const double serviceTileBadgeMaxWidth =
      52; // nguồn: AppSpacing.serviceTileBadgeMaxWidth
  static const double serviceTileRiskBadgeMaxWidth =
      76; // nguồn: AppSpacing.serviceTileRiskBadgeMaxWidth
  static const double serviceTileBadgePaddingHorizontal =
      x2; // nguồn cũ AppSpacing = 5
  static const double serviceTileBadgePaddingVertical =
      2; // nguồn: AppSpacing.serviceTileBadgePaddingVertical
  static const double serviceTileBadgeFont =
      x3; // nguồn: AppSpacing.serviceTileBadgeFont
  static const double serviceTileBadgeReserveVertical =
      serviceTileBadgePaddingVertical * 2 +
      serviceTileBadgeFont +
      serviceTileBadgeOffset;
  static const double serviceTileBadgeReserveHorizontal =
      x3; // nguồn: AppSpacing.serviceTileBadgeReserveHorizontal
  static const double serviceTileIconContainer =
      26; // nguồn: AppSpacing.serviceTileIconContainer
  static const double serviceTileIconContainerCompact =
      22; // nguồn: AppSpacing.serviceTileIconContainerCompact
  static const double serviceTileIconSize =
      20; // nguồn: AppSpacing.serviceTileIconSize
  static const double serviceTileIconSizeCompact =
      16; // nguồn: AppSpacing.serviceTileIconSizeCompact
  static const double serviceTileGridAspectStandard =
      1.42; // nguồn: AppSpacing.serviceTileGridAspectStandard
  static const double serviceTileGridAspectCompact =
      1.40; // nguồn: AppSpacing.serviceTileGridAspectCompact
  static const double serviceTileLabelGap = x1; // nguồn cũ AppSpacing = 3
  static const double serviceTileLabelGapCompact =
      x1; // nguồn cũ AppSpacing = 2
  static const int serviceTileCrossAxisCount =
      3; // nguồn: AppSpacing.serviceTileCrossAxisCount
  static const double serviceTileAccentBarThickness =
      4; // nguồn: AppSpacing.serviceTileAccentBarThickness
  static const double serviceTileAccentBarHeight =
      28; // nguồn: AppSpacing.serviceTileAccentBarHeight
  static const double serviceTileSectionBarHeight =
      18; // nguồn: AppSpacing.serviceTileSectionBarHeight
  static const double serviceTileCompactLabelHeight =
      28; // nguồn: AppSpacing.serviceTileCompactLabelHeight
  static const double inputPrefixIcon = 18; // nguồn: AppSpacing.inputPrefixIcon
  static const double sheetPanelMaxHeightFactor =
      0.72; // nguồn: AppSpacing.sheetPanelMaxHeightFactor
  static const double vitPresetChipRowGap =
      x1; // nguồn: AppSpacing.vitPresetChipRowGap
  static const double vitPresetChipRowHeight =
      buttonCompact; // nguồn: AppSpacing.vitPresetChipRowHeight
  static const EdgeInsets vitChoicePillCompactPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets vitChoicePillComfortablePadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets vitFilterChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );

  // ---- Shared shell snapshots ----
  static const double bottomNavHorizontalInset =
      contentPad; // nguồn: AppSpacing.bottomNavHorizontalInset
  static const double bottomNavCapsuleHeightNative =
      56; // nguồn: AppSpacing.bottomNavCapsuleHeightNative
  static const double bottomNavCapsuleHeightVisual =
      58; // nguồn: AppSpacing.bottomNavCapsuleHeightVisual
  static const double bottomNavBottomGapNative = x3; // nguồn cũ AppSpacing = 8
  static const double bottomNavBottomGapVisual =
      20; // nguồn: AppSpacing.bottomNavBottomGapVisual
  static const double bottomNavHorizontalPadCompact =
      x1; // nguồn cũ AppSpacing = 3
  static const double bottomNavHorizontalPad = x2; // nguồn cũ AppSpacing = 6
  static const double bottomNavCenterButtonSizeNative =
      50; // nguồn: AppSpacing.bottomNavCenterButtonSizeNative
  static const double bottomNavCenterButtonSizeVisual =
      54; // nguồn: AppSpacing.bottomNavCenterButtonSizeVisual
  static const double bottomNavCenterButtonTopNative =
      -18; // nguồn: AppSpacing.bottomNavCenterButtonTopNative
  static const double bottomNavCenterButtonTopVisual =
      -22; // nguồn: AppSpacing.bottomNavCenterButtonTopVisual
  static const double bottomNavCenterIconSize =
      22; // nguồn: AppSpacing.bottomNavCenterIconSize
  static const double bottomNavItemHeight =
      52; // nguồn: AppSpacing.bottomNavItemHeight
  static const double bottomNavActiveDotOffset =
      -5; // nguồn: AppSpacing.bottomNavActiveDotOffset
  static const double bottomNavActiveDotSize =
      4; // nguồn: AppSpacing.bottomNavActiveDotSize
  static const double bottomNavLabelGap = x1; // nguồn cũ AppSpacing = 2
  static const double bottomNavBadgeMinWidth =
      16; // nguồn: AppSpacing.bottomNavBadgeMinWidth
  static const double bottomNavBadgeHeight =
      16; // nguồn: AppSpacing.bottomNavBadgeHeight
  static const double bottomNavBadgeHorizontalPadding =
      x1; // nguồn cũ AppSpacing = 4
  static const double bottomNavBadgeTopOffset =
      -6; // nguồn: AppSpacing.bottomNavBadgeTopOffset
  static const double bottomNavBadgeRightOffset =
      -10; // nguồn: AppSpacing.bottomNavBadgeRightOffset
  static const double bottomNavBottomOffsetCompact =
      x1; // nguồn cũ AppSpacing = 2
  static const double bottomNavBottomOffsetRegular =
      x1; // nguồn cũ AppSpacing = 4
  static const double bottomNavSurfaceShadowBlur =
      22; // nguồn: AppSpacing.bottomNavSurfaceShadowBlur
  static const double bottomNavSurfaceShadowOffsetY =
      10; // nguồn: AppSpacing.bottomNavSurfaceShadowOffsetY
  static const double bottomNavPrimaryShadowBlur =
      28; // nguồn: AppSpacing.bottomNavPrimaryShadowBlur
  static const double bottomNavPrimaryShadowOffsetY =
      -1; // nguồn: AppSpacing.bottomNavPrimaryShadowOffsetY
  static const double bottomNavCenterGlowBlur =
      16; // nguồn: AppSpacing.bottomNavCenterGlowBlur
  static const double bottomNavCenterGlowOffsetY =
      4; // nguồn: AppSpacing.bottomNavCenterGlowOffsetY
  static const double bottomNavCenterGlowWeakBlur =
      32; // nguồn: AppSpacing.bottomNavCenterGlowWeakBlur
  static const double bottomNavActiveDotBlur =
      x3; // nguồn: AppSpacing.bottomNavActiveDotBlur

  // ---- Khoảng trắng có vai trò ----
  /// Base-8-derived block role: gap giữa các card/section là 12dp.
  static const double cardGap = 12;

  /// Base-8-derived standard block role: section gap là 12dp.
  static const double pageRhythmStandardSectionGap = 12;

  /// Inner gap compact của phone — tablet dùng khi cần khớp nhịp cũ
  /// (nguồn cũ 5 — Tablet Base-8-derived: 4).
  static const double pageRhythmCompactInnerGap = 4;

  /// Content top padding compact (Tablet Base-8-derived; nguồn cũ 8).
  static const double pageContentTopCompact = x3;

  /// Content top padding mặc định (12dp).
  static const double pageContentTopDefault = x4;

  /// Content top padding relaxed (16dp).
  static const double pageContentTopRelaxed = 16;

  /// Content gap tight (Tablet Base-8-derived; nguồn cũ 8).
  static const double pageContentGapTight = x3;

  /// Content gap mặc định (12dp): Tablet block role.
  static const double pageContentGapDefault = pageRhythmStandardSectionGap;

  /// Content gap relaxed vẫn giữ block role 12dp trên Tablet.
  /// Khoảng 24dp chỉ dành cho card/hero padding, không phải gap khối.
  static const double pageContentGapRelaxed = pageRhythmStandardSectionGap;

  /// Content gap loose vẫn giữ block role 12dp trên Tablet.
  /// Khoảng thở cuối trang dùng [pageEndBreathing] riêng.
  static const double pageContentGapLoose = pageRhythmStandardSectionGap;

  /// Breathing cuối trang (32dp), không phải khoảng cách giữa các block.
  static const double pageEndBreathing = x6;

  /// Inner gap standard của section trên Tablet (12dp).
  static const double pageRhythmStandardInnerGap = x4;

  /// Inner gap form của phone (nguồn: AppSpacing.pageRhythmFormInnerGap = 8).
  static const double pageRhythmFormInnerGap = 8;

  /// Section gap form trên Tablet (12dp theo nhịp section chung).
  static const double pageRhythmFormSectionGap = pageRhythmStandardSectionGap;

  /// Row gap 8 (nguồn: AppSpacing.rowGap) — item gap trong section.
  static const double rowGap = 8;

  /// Row gap regular của các widget dùng chung (Tablet Base-8-derived).
  static const double rowGapRegular = rowGap;

  /// Vertical breathing of a shared list row on the Tablet Base-8-derived scale.
  static const double rowPy = 16;

  static const double pageSectionAccentWidth =
      x1 + dividerHairline; // nguồn: AppSpacing.pageSectionAccentWidth
  static const double pageSectionAccentHeight =
      rowPy; // nguồn: AppSpacing.pageSectionAccentHeight

  /// Grid gap 8 (nguồn: AppSpacing.gridGap).
  static const double gridGap = 8;

  // ---- Padding / inset ----
  /// Inset nội dung 20 (nguồn: AppSpacing.contentInsets = symmetric 20).
  static const EdgeInsets contentInsets = EdgeInsets.symmetric(horizontal: 20);

  /// Content pad 20 (nguồn: AppSpacing.contentPad).
  static const double contentPad = 20;

  /// Padding card compact 12 (nguồn: AppSpacing.cardPaddingCompact).
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(12);

  /// Padding card standard 16 (nguồn: AppSpacing.cardPadding).
  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  // ---- Padding card theo density (mirror VitDensity, snapshot 2026-09-01;
  // dùng khi [tabletSurfaceActive] bật — xem app_density.dart) ----
  /// compact 12/12 (nguồn: VitDensity.compact).
  static const EdgeInsets cardPaddingCompactDensity = EdgeInsets.all(12);

  /// Compact destructive/action button horizontal inset (8dp mỗi bên).
  /// Giữ các CTA compact của Tablet cùng một vai trò inline.
  static const EdgeInsets profileDeviceLogoutButtonPadding =
      EdgeInsets.symmetric(horizontal: x3);

  /// standard 16/16 (nguồn: VitDensity.standard = pageContentGapDefault).
  static const EdgeInsets cardPaddingStandardDensity = EdgeInsets.all(16);

  /// relaxed 24/24 (Tablet Base-8-derived; nguồn cũ 21).
  static const EdgeInsets cardPaddingRelaxedDensity = EdgeInsets.all(24);

  /// hero 20/24/20/20 (nguồn: VitDensity.hero).
  static const EdgeInsets cardPaddingHeroDensity = EdgeInsets.fromLTRB(
    20,
    24,
    20,
    20,
  );

  /// tool 12 ngang / 4 dọc (Tablet Base-8-derived; nguồn cũ 5).
  static const EdgeInsets cardPaddingToolDensity = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 4,
  );

  /// Cờ surface: composition root đặt true khi bootstrap chọn tablet —
  /// khi đó VitDensity.cardPadding* đọc các giá trị TRÊN (độc lập với
  /// phone). Mặc định false = đường phone nguyên vẹn.
  static bool tabletSurfaceActive = false;
}
