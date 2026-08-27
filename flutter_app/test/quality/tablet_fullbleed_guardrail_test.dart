// Guardrail: S6 — nội dung detail của master-detail shell phải gutter-flush
// (Chuẩn Tablet Spacing & Gutter, Rule 2 consequence).
//
// Bug 2026-08-28 (user X đỏ "khoảng trống rất nhiều chỗ"): trang tổng quan
// Markets tự lắp VitInsetScrollView + VitPageContent mà KHÔNG fullBleed —
// contentPad 20dp xếp chồng outerHorizontalMargin 20dp của shell (double
// gutter ngang) và pageContentTopRelaxed 16dp xếp chồng blockVerticalGap
// 16dp (double breathing dọc): 68dp trống đầu pane + card lệch 40px so khung
// master. Cùng lớp bug 4a171046, tái xuất vì overview/utility là "hub route"
// không đi qua PaneScaffold.
//
// S6: trong file tablet, MỌI constructor `VitPageContent(` phải khai báo
// top-level `fullBleed:` một cách tường minh — chủ ý gutter thuộc về wrapper
// ngoài (shell/master-detail/dashboard), không phải trang. Ngoại lệ legacy
// (VitPageContent LÀ chủ gutter của chính nó) được ghim trong baseline
// exact-set dưới đây: khung menu Profile + skeleton/error trong khung + 2
// wrapper của VitTwoColumnTabletDashboard. Chỉ được GIẢM; VitPageContent
// mới không fullBleed thì fail CI.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Baseline 2026-08-28 — 5 wrapper hợp lệ sở hữu gutter riêng.
/// Key `path|line`: nếu chỉ dịch dòng do edit phía trên, cập nhật số dòng
/// kèm một dòng giải trình trong commit.
const List<String> kBaselineNonFullBleedPageContents = [
  'features/profile/presentation/tablet/widgets/profile_tablet_master_shell.dart|190',
  'features/profile/presentation/tablet/widgets/profile_tablet_master_shell.dart|205',
  'features/profile/presentation/widgets/tablet/profile_master_menu.dart|47',
  'shared/layout/vit_two_column_tablet_dashboard.dart|202',
  'shared/layout/vit_two_column_tablet_dashboard.dart|296',
];

final _pageContentStartRe = RegExp(r'\bVitPageContent\s*\(');

void main() {
  test(
    'S6 ratchet: VitPageContent trong file tablet phải khai báo fullBleed',
    () {
      final current = <String>{};
      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        final fileName = normalized.split('/').last;
        final isTabletSurface =
            normalized.contains('/tablet/') || fileName.contains('tablet');
        if (!isTabletSurface) continue;
        if (normalized.contains('/app/theme/')) continue;

        // Bỏ dòng comment thuần (/// và //) — doc comment từng nhắc
        // `VitPageContent(rhythm:)` và làm false-positive (bài học 2026-08-27
        // với page_rhythm_audit). Thay bằng dòng RỖNG để số dòng file giữ
        // nguyên cho baseline.
        final source = entity
            .readAsLinesSync()
            .map((l) => l.trimLeft().startsWith('//') ? '' : l)
            .join('\n');

        for (final match in _pageContentStartRe.allMatches(source)) {
          final openParen = source.indexOf('(', match.start);
          final closeParen = _matchingParen(source, openParen);
          if (closeParen < 0) continue;
          final args = _topLevelArgs(
            source.substring(openParen + 1, closeParen),
          );
          final hasFullBleed = args.any((a) => a.startsWith('fullBleed:'));
          if (hasFullBleed) continue;
          final lineNo =
              '\n'.allMatches(source.substring(0, match.start)).length + 1;
          final rel = normalized.replaceFirst('lib/', '');
          current.add('$rel|$lineNo');
        }
      }

      final baseline = kBaselineNonFullBleedPageContents.toSet();
      final fresh = current.difference(baseline).toList()..sort();
      expect(
        fresh,
        isEmpty,
        reason:
            'VitPageContent KHÔNG fullBleed trong file tablet (S6 — Chuẩn '
            'Spacing Rule 2):\n'
            '${fresh.join('\n')}\n\n'
            'Nội dung detail của shell master-detail phải gutter-flush: thêm '
            '`fullBleed: true` (+ `density: VitDensity.compact`, header '
            '`horizontalPadding: AppSpacing.zero`). Wrapper sở hữu gutter riêng '
            'mới được vào baseline — kèm giải trình.',
      );

      final stale = baseline.difference(current).toList()..sort();
      expect(
        stale,
        isEmpty,
        reason:
            'Baseline S6 còn entry đã biến mất (đã fullBleed hoặc đã xóa):\n'
            '${stale.join('\n')}\n\n'
            'Xóa entry khỏi kBaselineNonFullBleedPageContents (nợ chỉ được '
            'giảm). Nếu chỉ dịch dòng, cập nhật số dòng.',
      );
    },
  );
}

int _matchingParen(String text, int open) {
  var depth = 0;
  var inStr = false;
  var quote = ' ';
  for (var i = open; i < text.length; i++) {
    final c = text[i];
    if (inStr) {
      if (c == quote && (i == 0 || text[i - 1] != r'\')) inStr = false;
      continue;
    }
    if (c == "'" || c == '"') {
      inStr = true;
      quote = c;
      continue;
    }
    if (c == '(') depth++;
    if (c == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

List<String> _topLevelArgs(String body) {
  final out = <String>[];
  var depth = 0;
  var start = 0;
  var inStr = false;
  var quote = ' ';
  for (var i = 0; i < body.length; i++) {
    final c = body[i];
    if (inStr) {
      if (c == quote && (i == 0 || body[i - 1] != r'\')) inStr = false;
      continue;
    }
    if (c == "'" || c == '"') {
      inStr = true;
      quote = c;
      continue;
    }
    if (c == '(' || c == '[' || c == '{') {
      depth++;
    } else if (c == ')' || c == ']' || c == '}') {
      depth--;
    } else if (c == ',' && depth == 0) {
      out.add(body.substring(start, i));
      start = i + 1;
    }
  }
  out.add(body.substring(start));
  return out.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
