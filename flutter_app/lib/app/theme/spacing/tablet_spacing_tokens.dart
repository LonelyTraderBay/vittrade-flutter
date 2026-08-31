import 'package:flutter/material.dart';

/// BỘ TOKEN KHOẢNG CÁCH RIÊNG CỦA SURFACE TABLET (user chốt tách hoàn toàn
/// 2026-09-01): mọi file tablet đọc số liệu khoảng cách/kích thước từ đây,
/// KHÔNG còn đọc `AppSpacing` của phone. Giá trị khởi đầu sao chép nguyên
/// vẹn từ `AppSpacing` (snapshot 2026-09-01) nên đợt tách này KHÔNG đổi
/// một pixel nào — mục đích là quyền tự chủ: đổi giá trị nào ở đây chỉ
/// ảnh hưởng tablet, phone bất động.
///
/// Quy ước:
/// - Mọi giá trị inline kèm `// nguồn: AppSpacing.<tên>` để truy vết
///   snapshot; sau này chỉnh giá trị thì cập nhật comment nguồn thành
///   lý do mới (đừng xoá — lịch sử giúp audit).
/// - Luật 13dp (2026-08-31) vẫn thắng: các token khoảng-trắng giữ 13.
/// - Guardrail `tablet_gap_13_guardrail_test.dart` whitelist cả namespace
///   này với cùng bộ tên như AppSpacing cũ.
final class TabletSpacingTokens {
  const TabletSpacingTokens._();

  // ---- Thang bước (mirror AppSpacing, 2026-09-01) ----
  static const double x1 = 3; // nguồn: AppSpacing.x1
  static const double x2 = 5; // nguồn: AppSpacing.x2
  static const double x3 = 8; // nguồn: AppSpacing.x3
  static const double x4 = 13; // nguồn: AppSpacing.x4 — LUẬT 13dp
  static const double x5 = 21; // nguồn: AppSpacing.x5
  static const double x6 = 34; // nguồn: AppSpacing.x6
  static const double x7 = 55; // nguồn: AppSpacing.x7

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
  /// LUẬT 13dp: gap giữa các card/section — 13 (nguồn: AppSpacing.cardGap).
  static const double cardGap = 13;

  /// LUẬT 13dp: section gap tier standard — 13 (nguồn: pageRhythmStandardSectionGap).
  static const double pageRhythmStandardSectionGap = 13;

  /// Inner gap compact của phone — tablet dùng khi cần khớp nhịp cũ
  /// (nguồn: AppSpacing.pageRhythmCompactInnerGap = 5).
  static const double pageRhythmCompactInnerGap = 5;

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

  /// relaxed 21/21 (nguồn: VitDensity.relaxed = x5).
  static const EdgeInsets cardPaddingRelaxedDensity = EdgeInsets.all(21);

  /// hero 20/24/20/20 (nguồn: VitDensity.hero).
  static const EdgeInsets cardPaddingHeroDensity = EdgeInsets.fromLTRB(
    20,
    24,
    20,
    20,
  );

  /// tool 12 ngang / 5 dọc (nguồn: VitDensity.tool).
  static const EdgeInsets cardPaddingToolDensity = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 5,
  );

  /// Cờ surface: composition root đặt true khi bootstrap chọn tablet —
  /// khi đó VitDensity.cardPadding* đọc các giá trị TRÊN (độc lập với
  /// phone). Mặc định false = đường phone nguyên vẹn.
  static bool tabletSurfaceActive = false;
}
