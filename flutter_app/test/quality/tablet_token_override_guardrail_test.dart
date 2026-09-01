// Guardrail: Rule 5 — per-surface tablet-override tokens (Tablet Spacing &
// Gutter Standard, docs/02_FLUTTER_MIGRATION/standards/
// Tablet-Spacing-Gutter-Standard.md).
//
// Nguyên tắc: KHÔNG fork token set per-surface. Chênh lệch phone/tablet đi
// qua surface namespace + các lớp đúng thứ tự: context tier
// (VitDensity/VitPageRhythm) → TabletSpacingTokens → frame token
// (TabletDashboardWidths) → tablet-override cục bộ (ngoại lệ, 5 điều kiện
// Rule 5). Test khóa 3 điều kiểm tra được bằng máy:
//   T1 co-location: token `…Tablet…` phải khai báo cùng file với counterpart
//      phone (tên counterpart = tên token bỏ "Tablet");
//   T2 không rò rỉ: token `…Tablet…` chỉ được tham chiếu từ file bề mặt
//      tablet (path chứa `/tablet/` hoặc tên file chứa "tablet");
//   T3 ratchet exact-set: baseline dưới đây là nguồn sự thật về số lượng —
//      thêm override mới phải bump baseline CÙNG commit, sau khi đọc đủ 5
//      điều kiện trong chuẩn (đặc biệt điều 3: tier/frame đã thử trước).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Baseline 2026-09-01: 6 module spacing token là local override; toàn bộ
/// surface geometry đã tách vào `TabletSpacingTokens`. Hai override Wallet
/// giữ counterpart Phone vì filter padding và divider height có giá trị khác
/// nhau giữa hai surface.
const List<String> kBaselineTabletOverrideTokens = [
  'profileMenuTabletIcon',
  'profileMenuTabletIconBox',
  // Luật 12dp (2026-08-31): extent card expiry tablet 67 (gap mô tả 12) —
  // phone giữ 62 (gap 5), cùng role khác surface (Rule 5 đủ 5 điều kiện).
  'profileApiCreateTabletExpiryExtent',
  // Wallet Tablet 12dp / 1dp; Phone giữ token gốc riêng.
  'walletAddressTabletFilterPadding',
  'walletTabletHistoryDividerHeight',
  'walletTabletAllocationChartInset',
];

final _declarationRe = RegExp(r'static\s+const\s+\S+\s+(\w+)\s*=');

bool _isTabletSurface(String normalizedPath) {
  final fileName = normalizedPath.split('/').last;
  return normalizedPath.contains('/tablet/') || fileName.contains('tablet');
}

void main() {
  // name → đường dẫn file khai báo (đã chuẩn hóa "/").
  final overrideTokens = <String, String>{};
  final namesByFile = <String, Set<String>>{};

  setUpAll(() {
    for (final entity in Directory('lib/app/theme/spacing').listSync()) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final names = entity
          .readAsLinesSync()
          .map((line) => _declarationRe.firstMatch(line)?.group(1))
          .whereType<String>()
          .toSet();
      final rel = entity.path.replaceAll('\\', '/');
      namesByFile[rel] = names;
      for (final name in names) {
        // Case-sensitive: "Tablet" (camelCase) đánh dấu override;
        // "VipTableTitle" là "bảng VIP", không phải override.
        if (name.contains('Tablet')) overrideTokens[name] = rel;
      }
    }
  });

  test('T3 ratchet: tablet-override token set matches the baseline', () {
    expect(
      overrideTokens.keys.toList()..sort(),
      equals([...kBaselineTabletOverrideTokens]..sort()),
      reason:
          'Tập token override tablet lệch baseline Rule 5 (chuẩn Tablet-'
          'Spacing-Gutter).\n'
          'Hiện có: ${overrideTokens.keys.toList()..sort()}\n'
          'Baseline: $kBaselineTabletOverrideTokens\n\n'
          'Thêm override mới = đọc 5 điều kiện Rule 5 (tier/frame đã thử chưa?) '
          'rồi bump baseline cùng commit; xóa override thì bỏ tên khỏi baseline.',
    );
  });

  test('T1 co-location: mỗi override nằm cùng file với counterpart phone', () {
    final violations = <String>[];
    overrideTokens.forEach((name, file) {
      final counterpart = name.replaceFirst('Tablet', '');
      if (!(namesByFile[file] ?? const <String>{}).contains(counterpart)) {
        violations.add(
          '$file: "$name" thiếu counterpart "$counterpart" cùng file '
          '(điều 4 Rule 5 — override phải nằm cạnh token phone gốc)',
        );
      }
    });
    expect(
      violations,
      isEmpty,
      reason:
          'Token override tablet khai báo rời counterpart phone:\n'
          '${violations.join('\n')}',
    );
  });

  test('T2 no-leakage: override chỉ được tham chiếu từ file tablet', () {
    final violations = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      // Nơi khai báo (module spacing) không tính là rò rỉ.
      if (normalized.startsWith('lib/app/theme/spacing/')) continue;
      final lines = entity.readAsLinesSync();
      for (final name in overrideTokens.keys) {
        final useRe = RegExp('\\b$name\\b');
        for (var i = 0; i < lines.length; i++) {
          if (lines[i].trimLeft().startsWith('//')) continue;
          if (useRe.hasMatch(lines[i])) {
            if (!_isTabletSurface(normalized)) {
              violations.add(
                '$normalized|${i + 1}|dùng "$name" ngoài bề mặt tablet',
              );
            }
            break; // mỗi file chỉ báo một lần cho token này.
          }
        }
      }
    }
    expect(
      violations,
      isEmpty,
      reason:
          'Token override tablet bị dùng ngoài bề mặt tablet (T2 Rule 5):\n'
          '${violations.join('\n')}\n\n'
          'Token `…Tablet…` chỉ phục vụ layout tablet; file phone/shared phải '
          'dùng counterpart không có "Tablet".',
    );
  });
}
