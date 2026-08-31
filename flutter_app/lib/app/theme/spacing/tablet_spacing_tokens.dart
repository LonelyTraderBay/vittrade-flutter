import 'package:flutter/material.dart';

/// BỘ TOKEN KHOẢNG CÁCH RIÊNG CỦA SURFACE TABLET (user chốt tách hoàn toàn
/// 2026-09-01; chuyển LƯỚI 8PT cùng ngày theo hướng A user duyệt): mọi file
/// tablet đọc số liệu khoảng cách/kích thước từ đây, KHÔNG còn đọc
/// `AppSpacing` của phone. Thang bước là bội 4/8 (4·8·12·16·24·32·56) —
/// LUẬT TABLET: mọi khoảng trắng = 12. Đổi giá trị nào ở đây chỉ ảnh
/// hưởng tablet, phone bất động.
///
/// Quy ước:
/// - Mọi giá trị inline kèm `// nguồn: AppSpacing.<tên>` để truy vết
///   snapshot; sau này chỉnh giá trị thì cập nhật comment nguồn thành
///   lý do mới (đừng xoá — lịch sử giúp audit).
/// - Luật 8pt 12dp (2026-08-31) vẫn thắng: các token khoảng-trắng giữ 13.
/// - Guardrail `tablet_gap_13_guardrail_test.dart` whitelist cả namespace
///   này với cùng bộ tên như AppSpacing cũ.
final class TabletSpacingTokens {
  const TabletSpacingTokens._();

  // ---- Thang bước (mirror AppSpacing, 2026-09-01) ----
  static const double x1 = 4; // 8pt grid (nguồn cũ AppSpacing.x1 = 3)
  static const double x2 = 4; // 8pt grid (nguồn cũ AppSpacing.x2 = 5)
  static const double x3 = 8; // 8pt grid — đã đúng lưới
  static const double x4 = 12; // 8pt grid — LUẬT TABLET 12dp (nguồn cũ 13)
  static const double x5 = 24; // 8pt grid (nguồn cũ AppSpacing.x5 = 21)
  static const double x6 = 32; // 8pt grid (nguồn cũ AppSpacing.x6 = 34)
  static const double x7 = 56; // 8pt grid (nguồn cũ AppSpacing.x7 = 55)

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
  static const double ctaHeight = 52; // nguồn: AppSpacing.ctaHeight
  static const double iconSm = 13; // nguồn: AppSpacing.iconSm
  static const double iconMd = 21; // nguồn: AppSpacing.iconMd
  static const double iconLg = 34; // nguồn: AppSpacing.iconLg
  static const double searchBarCompactHeight =
      44; // nguồn: AppSpacing.searchBarCompactHeight
  static const double serviceTileMinHeight =
      54; // nguồn: AppSpacing.serviceTileMinHeight
  static const double accentIconBoxSize =
      34; // nguồn: AppSpacing.accentIconBoxSize (= buttonCompact)

  // ---- Khoảng trắng có vai trò ----
  /// LUẬT TABLET 12dp (8pt grid): gap giữa các card/section.
  static const double cardGap = 12;

  /// LUẬT TABLET 12dp (8pt grid): section gap tier standard.
  static const double pageRhythmStandardSectionGap = 12;

  /// Inner gap compact của phone — tablet dùng khi cần khớp nhịp cũ
  /// (nguồn cũ 5 — 8pt grid: 4).
  static const double pageRhythmCompactInnerGap = 4;

  /// Inner gap form của phone (nguồn: AppSpacing.pageRhythmFormInnerGap = 8).
  static const double pageRhythmFormInnerGap = 8;

  /// Row gap 8 (nguồn: AppSpacing.rowGap) — item gap trong section.
  static const double rowGap = 8;

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

  /// standard 16/16 (nguồn: VitDensity.standard = pageContentGapDefault).
  static const EdgeInsets cardPaddingStandardDensity = EdgeInsets.all(16);

  /// relaxed 24/24 (8pt grid; nguồn cũ 21).
  static const EdgeInsets cardPaddingRelaxedDensity = EdgeInsets.all(24);

  /// hero 20/24/20/20 (nguồn: VitDensity.hero).
  static const EdgeInsets cardPaddingHeroDensity = EdgeInsets.fromLTRB(
    20,
    24,
    20,
    20,
  );

  /// tool 12 ngang / 4 dọc (8pt grid; nguồn cũ 5).
  static const EdgeInsets cardPaddingToolDensity = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 4,
  );

  /// Cờ surface: composition root đặt true khi bootstrap chọn tablet —
  /// khi đó VitDensity.cardPadding* đọc các giá trị TRÊN (độc lập với
  /// phone). Mặc định false = đường phone nguyên vẹn.
  static bool tabletSurfaceActive = false;
}
