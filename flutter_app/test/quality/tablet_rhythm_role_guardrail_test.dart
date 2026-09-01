// Guardrail: tier Page-Rhythm phải đúng role trên bề mặt Tablet
// (Page-Rhythm-Standard, bảng "Role → VitPageRhythm").
//
// Bug 2026-08-28 (user X đỏ "khoảng trống giữa tiêu đề vẫn rộng" — chỉ
// trang Markets tablet): hub SC-008 dùng `relaxed` (24dp — tier của
// hero/onboarding) trong khi bảng chuẩn ghi tab root = `compact` (8dp);
// pane chi tiết = `standard` (12dp); chart/terminal = `flush`. Mọi token
// đơn lẻ đều "hợp lệ" — sai nằm ở THAM SỐ chọn tier.
//
// Vì sao audit không bắt trước đây: `page_rhythm_audit._tabRootPages` (rule
// "tab root phải compact") là DANH SÁCH FILE chỉ có 5 hub phone + Markets
// tablet thêm sau đó — hub tablet khác không nằm trong danh sách. Guardrail
// này đóng 2 lỗ:
//
//   PR-T1 (absolute): `VitPageRhythm.relaxed` bị CẤM trên bề mặt tablet —
//     tier hero/onboarding; duy nhất whitelist là wrapper secondary của
//     VitTwoColumnTabletDashboard (by design của dashboard 2 cột).
//   PR-T2 (ratchet exact-map): hub tablet của 5 tab (`<module>_tablet_page
//     .dart`) phải compact — hoặc rhythm sống ở layout ('none'). Hub tablet
//     MỚI khai báo non-compact → fail CI ngay.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Whitelist PR-T1 — relaxed hợp lệ duy nhất tại đây (secondary dashboard).
const Set<String> kRelaxedWhitelist = {
  'shared/layout/vit_two_column_tablet_dashboard.dart',
};

/// Baseline PR-T2 — tier hiện tại của từng hub tablet (2026-08-28).
/// 'none' = rhythm do layout/widget con sở hữu (file page không khai báo).
/// Giá trị KHÁC compact là NỢ: migrate khi module được chạm rồi cập nhật
/// map — chỉ được tiến về 'compact'/'none', không lùi.
const Map<String, Set<String>> kTabletHubTiers = {
  'features/home/presentation/tablet/pages/home_tablet_page.dart': {'none'},
  // Luật 12dp (2026-08-31): hub tablet chuẩn standard(12) — compact(8)
  // không còn là tier hợp lệ cho hub tablet.
  'features/markets/presentation/tablet/pages/markets_tablet_page.dart': {
    'standard',
  },
  'features/trade/presentation/tablet/pages/trade_tablet_page.dart': {'none'},
  'features/wallet/presentation/tablet/pages/wallet_tablet_page.dart': {'none'},
  'features/profile/presentation/tablet/pages/profile_tablet_page.dart': {
    'compact',
  },
};

final _tabletHubPattern = RegExp(
  r'features/(home|markets|trade|wallet|profile)'
  r'/presentation/tablet/pages/(home|markets|trade|wallet|profile)_tablet_page\.dart$',
);
final _tierRe = RegExp(r'VitPageRhythm\.(compact|standard|form|relaxed|flush)');

bool _isTabletSurface(String normalized) {
  final fileName = normalized.split('/').last;
  return normalized.contains('/tablet/') || fileName.contains('tablet');
}

void main() {
  test(
    'PR-T1 absolute: relaxed bị cấm trên tablet (trừ whitelist dashboard)',
    () {
      final violations = <String>[];
      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        if (!_isTabletSurface(normalized)) continue;
        if (normalized.contains('/app/theme/')) continue;
        final rel = normalized.replaceFirst('lib/', '');
        if (kRelaxedWhitelist.contains(rel)) continue;

        final lines = entity.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          if (lines[i].trimLeft().startsWith('//')) continue;
          if (lines[i].contains('VitPageRhythm.relaxed')) {
            violations.add('$rel|${i + 1}');
          }
        }
      }
      expect(
        violations,
        isEmpty,
        reason:
            'VitPageRhythm.relaxed trong file tablet ngoài whitelist (PR-T1):\n'
            '${violations.join('\n')}\n\n'
            'relaxed (24dp) là tier hero/onboarding. Tra bảng Page-Rhythm theo '
            'role: tab root=compact, detail scroll=standard, form=KYC/auth, '
            'chart/terminal=flush. Dùng relaxed sai role làm trang thưa '
            '(bug Markets hub 2026-08-28).',
      );
    },
  );

  test(
    'PR-T2 ratchet: hub tablet của 5 tab phải compact (hoặc layout-owned)',
    () {
      final violations = <String>[];
      final stale = <String>[];

      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        final rel = normalized.replaceFirst('lib/', '');
        if (!_tabletHubPattern.hasMatch(rel)) continue;

        final tiers = _tierRe
            .allMatches(entity.readAsStringSync())
            .map((m) => m.group(1)!)
            .toSet();
        final allowed = kTabletHubTiers[rel];
        if (allowed == null) {
          if (tiers.any((t) => t != 'compact')) {
            violations.add(
              '$rel: hub tablet MỚI khai báo ${tiers.join('+')} — phải compact',
            );
          }
          continue;
        }
        if (allowed.contains('none') && tiers.isNotEmpty) {
          // Hub vốn layout-owned bắt đầu tự khai báo rhythm → phải compact.
          if (tiers.any((t) => t != 'compact')) {
            violations.add(
              '$rel: từng là layout-owned, giờ tự khai báo '
              '${tiers.join('+')} — phải compact',
            );
          }
          stale.add('$rel: baseline none → giờ có rhythm, cập nhật map');
          continue;
        }
        if (!tiers.every(allowed.contains) ||
            tiers.isEmpty && !allowed.contains('none')) {
          if (tiers.isEmpty && allowed.contains('none')) continue;
          if (!tiers.every(allowed.contains)) {
            violations.add(
              '$rel: ${tiers.isEmpty ? 'không khai báo' : tiers.join('+')} '
              'ngoài allowance ${allowed.join('+')}',
            );
          }
        }
        if (tiers.every(allowed.contains) &&
            !allowed.contains('compact') &&
            !allowed.contains('none')) {
          // đúng allowance debt — không sao.
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Hub tablet sai tier theo role (PR-T2 — bảng Page-Rhythm):\n'
            '${violations.join('\n')}\n\n'
            'Tab root ⇒ VitPageRhythm.compact (+ padding/density compact). '
            'Rhythm sống ở layout thì file page không khai báo.',
      );
      expect(
        stale,
        isEmpty,
        reason:
            'Baseline PR-T2 lệch thực trạng (hub đã migrate/dọn):\n'
            '${stale.join('\n')}\n\n'
            'Cập nhật kTabletHubTiers — chỉ tiến về compact/none.',
      );
    },
  );

  test(
    'PR-T3 absolute: content gap relaxed/loose không được dùng trong Tablet',
    () {
      final violations = <String>[];
      final forbidden = RegExp(r'VitContentGap\.(relaxed|loose)');

      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        if (!_isTabletSurface(normalized) ||
            normalized.contains('/app/theme/')) {
          continue;
        }
        final rel = normalized.replaceFirst('lib/', '');
        final lines = entity.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.trimLeft().startsWith('//')) continue;
          if (forbidden.hasMatch(line)) {
            violations.add('$rel|${i + 1}|${line.trim()}');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Tablet chỉ dùng content gap tight/default (8/12). Khoảng 24/32 '
            'chỉ dành cho card/hero padding hoặc page-end breathing; không '
            'dùng làm gap giữa các block:\n${violations.join('\n')}',
      );
    },
  );
}
