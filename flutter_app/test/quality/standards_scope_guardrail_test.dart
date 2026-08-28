// Guardrail: UI-Rule-Layer-Map — mọi chuẩn UI phải khai báo lớp phân cấp
// (chung / phone / tablet / module) bằng dòng `**Scope:**` và phải được
// liệt kê trong bản đồ phân lớp.
//
// Bối cảnh 2026-08-28: user thấy "nhiều quy định mâu thuẫn" — rà soát cho
// thấy không có xung đột GIÁ TRỊ, nhưng 25/33 chuẩn ra đời không dòng
// Scope (người đọc phải đoán chuẩn nào áp cho surface nào) và bảng
// Page-Rhythm hero-tier đọc như áp cả tablet (mâu thuẫn với PR-T1). Lớp
// phân cấp chuẩn hóa trong docs/.../standards/UI-Rule-Layer-Map.md; guard
// rail này giữ cho doc không lại rơi vào trạng thái mù phân lớp:
//   DS-1: mỗi file chuẩn phải có dòng `**Scope:**` chứa một label lớp
//         chuẩn hóa (both surfaces / phone surface / tablet surface /
//         module screens).
//   DS-2: mỗi file chuẩn phải được nhắc tên trong UI-Rule-Layer-Map.md —
//         chuẩn mới phải vào bản đồ cùng commit.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _standardsDir = '../docs/02_FLUTTER_MIGRATION/standards';
const _layerMapPath = '$_standardsDir/UI-Rule-Layer-Map.md';

const _layerLabels = [
  'both surfaces',
  'phone surface',
  'tablet surface',
  'module screens',
];

final _scopeRe = RegExp(r'^\*\*Scope:\*\*(.+)$', multiLine: true);

void main() {
  test('DS-1: mọi chuẩn có dòng Scope với label lớp chuẩn hóa', () {
    final missing = <String>[];
    final unlabeled = <String>[];
    for (final entity in Directory(_standardsDir).listSync()) {
      if (entity is! File || !entity.path.endsWith('.md')) continue;
      final name = entity.path.replaceAll('\\', '/').split('/').last;
      if (name == 'UI-Rule-Layer-Map.md') continue;
      final text = entity.readAsStringSync();
      final match = _scopeRe.firstMatch(text);
      if (match == null) {
        missing.add(name);
        continue;
      }
      final scopeText = match.group(1)!.toLowerCase();
      if (!_layerLabels.any(scopeText.contains)) {
        unlabeled.add('$name → "${match.group(1)!.trim()}"');
      }
    }
    expect(
      missing,
      isEmpty,
      reason:
          'Chuẩn thiếu dòng **Scope:** (DS-1 — UI-Rule-Layer-Map):\n'
          '${missing.join('\n')}\n\n'
          'Thêm `**Scope:** <label>` ngay sau Authority/Enforcement với '
          'label: both surfaces / phone surface / tablet surface / module '
          'screens.',
    );
    expect(
      unlabeled,
      isEmpty,
      reason:
          'Dòng Scope không chứa label lớp chuẩn hóa (DS-1):\n'
          '${unlabeled.join('\n')}\n\n'
          'Label hợp lệ: ${_layerLabels.join(' / ')}.',
    );
  });

  test('DS-2: mọi chuẩn xuất hiện trong UI-Rule-Layer-Map', () {
    final map = File(_layerMapPath).readAsStringSync();
    expect(map, isNotEmpty, reason: 'Thiếu $_layerMapPath');
    final missing = <String>[];
    for (final entity in Directory(_standardsDir).listSync()) {
      if (entity is! File || !entity.path.endsWith('.md')) continue;
      final name = entity.path.replaceAll('\\', '/').split('/').last;
      if (name == 'UI-Rule-Layer-Map.md') continue;
      // Map rows use display names without the .md suffix.
      if (!map.contains(name.replaceFirst('.md', ''))) missing.add(name);
    }
    expect(
      missing,
      isEmpty,
      reason:
          'Chuẩn chưa được phân lớp trong UI-Rule-Layer-Map (DS-2):\n'
          '${missing.join('\n')}\n\n'
          'Thêm dòng vào bảng đúng lớp của bản đồ — cùng commit với chuẩn mới.',
    );
  });
}
