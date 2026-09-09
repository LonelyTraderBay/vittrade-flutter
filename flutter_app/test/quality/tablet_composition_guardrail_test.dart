// Guardrail: COMPOSITION — hợp đồng khung trang tablet (Chuẩn Tablet
// Spacing & Gutter, companion của `VitTabletSectionFrame`, 2026-09-09).
//
// Bối cảnh: ~50 khung tự chế `Center + ConstrainedBox(maxWidth: …)` rải rác
// 1080/1120/1180/1200/1240 làm nội dung thưa trôi giữa viewport (lỗi
// "khoảng trống khổng lồ trên/dưới" user báo 2026-09-09) và mép lệch
// header — token đúng chữ nhưng sai composition nên mọi guardrail literal
// cũ đều xanh. Bộ 3 rule dưới đây khóa LỚP composition:
//
// C1 — reading-width literal: file tablet không được viết `maxWidth: 1xxx`
//      tay; độ rộng đọc là `TabletDashboardWidths.readingContentMaxWidth`.
// C2 — khung Center dọc: cấm `Center(child: ConstrainedBox(…))` — cột đọc
//      phải top-start anchored (Align), không bao giờ căn giữa dọc.
// C3 — rò `.name`: presentation không render identifier enum/entity trực
//      tiếp (tiếng Anh camelCase lộ UI, mù với guardrail i18n literal) —
//      phải qua nhãn tiếng Việt (extension viLabel / reference data).
//
// Cả 3 rule là ratchet CHỈ ĐƯỢC GIẢM (pattern baseline của
// i18n_vi_only_baseline): baseline txt lưu số site hiện có theo từng file;
// file đã sạch mà tái xuất hoặc file MỚI mang match thì fail CI ngay. Hết
// nợ (về 0) sẽ chuyển zero-tolerance tuyệt đối như tablet_spacing_guardrail.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _readingWidthLiteralRe = RegExp(r'maxWidth:\s*1[0-9]{3}');
final _centerFrameRe = RegExp(r'Center\s*\(\s*child:\s*ConstrainedBox');
final _dotNameRe = RegExp(r'\.name\b');

bool _isTabletSurface(String key) =>
    key.contains('/tablet/') || key.split('/').last.contains('tablet');

bool _isPresentation(String key) => key.contains('/presentation/');

/// Đọc baseline dạng `<path-lib-relative> <số-site>`, bỏ dòng `#`.
Map<String, int> _loadBaseline(String fileName) {
  final counts = <String, int>{};
  final file = File('test/quality/$fileName');
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final parts = trimmed.split(RegExp(r'\s+'));
    counts[parts[0]] = int.parse(parts[1]);
  }
  return counts;
}

/// Quét lib/ đếm số match theo file; strip comment dòng `//` như
/// tablet_fullbleed_guardrail (doc comment từng nhắc pattern làm
/// false-positive).
Map<String, int> _scan(bool Function(String) pathFilter, RegExp re) {
  final counts = <String, int>{};
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    final key = normalized.startsWith('lib/')
        ? normalized.substring(4)
        : normalized;
    if (!pathFilter(key)) continue;
    final source = entity
        .readAsLinesSync()
        .map((line) => line.trimLeft().startsWith('//') ? '' : line)
        .join('\n');
    final count = re.allMatches(source).length;
    if (count > 0) counts[key] = count;
  }
  return counts;
}

String _renderCurrent(Map<String, int> current) {
  final lines = [
    for (final entry
        in current.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
      '${entry.key} ${entry.value}',
  ];
  return lines.isEmpty ? '(trống — đã sạch)' : lines.join('\n');
}

void _expectRatchet(
  String ruleId,
  String baselineFile,
  Map<String, int> current,
) {
  final baseline = _loadBaseline(baselineFile);
  final offenders = <String>[];
  for (final entry in current.entries) {
    final allowed = baseline[entry.key] ?? 0;
    if (entry.value > allowed) {
      offenders.add(
        '$ruleId VI PHẠM: ${entry.key} có ${entry.value} match '
        '(baseline cho phép $allowed)',
      );
    }
  }
  expect(
    offenders,
    isEmpty,
    reason:
        '$ruleId FAIL:\n${offenders.join('\n')}\n\n'
        'Trạng thái hiện tại — cập nhật baseline (chỉ GIẢM) khi trả nợ:\n'
        '${_renderCurrent(current)}',
  );
}

void main() {
  test(
    'C1 ratchet: không thêm reading-width literal mới trong file tablet',
    () {
      _expectRatchet(
        'C1',
        'tablet_composition_c1_reading_width_baseline.txt',
        _scan(_isTabletSurface, _readingWidthLiteralRe),
      );
    },
  );

  test('C2 ratchet: không thêm khung Center dọc mới trong file tablet', () {
    _expectRatchet(
      'C2',
      'tablet_composition_c2_center_frame_baseline.txt',
      _scan(_isTabletSurface, _centerFrameRe),
    );
  });

  test('C3 ratchet: không thêm site .name mới trong presentation', () {
    _expectRatchet(
      'C3',
      'tablet_composition_c3_dot_name_baseline.txt',
      _scan(_isPresentation, _dotNameRe),
    );
  });
}
