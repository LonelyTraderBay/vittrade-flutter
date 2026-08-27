// Guardrail: S5 — icon size phải là token (Chuẩn Tablet Spacing & Gutter).
//
// S1–S3 khóa literal trong SizedBox/EdgeInsets/thickness; icon size từng là
// mù: `Icon(size: 14)` lọt scanner vì không thuộc 3 pattern đó (bắt gặp
// 2026-08-27 ở Markets token info: 14/14/15 trong khi token là iconSm=13 /
// iconMd=21). S5 lấp chỗ trống: trong file tablet, tham số `size:` của icon
// phải lấy từ token (AppSpacing.iconSm/iconMd/iconLg, module spacing, hoặc
// biểu thức token) — số literal là vi phạm.
//
// Baseline exact-set (chỉ được GIẢM): 5 icon hero-trạng-thái của auth/wallet
// (56/72/144) là nợ legacy — migrate sang token khi chạm file, không thêm
// entry mới. Key là `path|source` (không phụ thuộc số dòng).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const List<String> kBaselineLegacyIconLiterals = [
  'features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart|size: 56,',
  'features/auth/presentation/tablet/pages/reset_password_tablet_page.dart|size: 56,',
  'features/auth/presentation/tablet/pages/two_fa_setup_tablet_page.dart|size: 72,',
  'features/wallet/presentation/tablet/pages/deposit_tablet_page.dart|size: 144,',
];

final _iconSizeLiteralRe = RegExp(r'\bsize:\s*\d');

void main() {
  test('S5 ratchet: icon-size literal chỉ tồn tại trong baseline legacy', () {
    final current = <String>{};
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final fileName = normalized.split('/').last;
      final isTabletSurface =
          normalized.contains('/tablet/') || fileName.contains('tablet');
      if (!isTabletSurface) continue;
      if (normalized.contains('/app/theme/')) continue;

      final lines = entity.readAsLinesSync();
      for (final line in lines) {
        if (line.trimLeft().startsWith('//')) continue;
        if (_iconSizeLiteralRe.hasMatch(line)) {
          final rel = normalized.replaceFirst('lib/', '');
          current.add('$rel|${line.trim()}');
        }
      }
    }

    final baseline = kBaselineLegacyIconLiterals.toSet();
    final fresh = current.difference(baseline).toList()..sort();
    expect(
      fresh,
      isEmpty,
      reason:
          'Icon size literal MỚI trong file tablet (S5 — Chuẩn Spacing):\n'
          '${fresh.join('\n')}\n\n'
          'Dùng token: AppSpacing.iconSm (13) / iconMd (21) / iconLg (34) '
          'hoặc module spacing token. KHÔNG thêm vào baseline.',
    );

    final stale = baseline.difference(current).toList()..sort();
    expect(
      stale,
      isEmpty,
      reason:
          'Baseline S5 còn entry đã biến mất (nợ đã trả):\n'
          '${stale.join('\n')}\n\n'
          'Xóa entry khỏi kBaselineLegacyIconLiterals để nợ chỉ được giảm.',
    );
  });
}
