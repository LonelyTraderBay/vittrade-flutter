import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Ratchet GĐ8 (2026-09-09): sau đợt wiring pass, mọi module tablet của các
/// nhóm port giai đoạn sau phải giữ ít nhất một lệnh điều hướng trong trang
/// (`context.go`/`context.push`) — chống tái xuất hiện "module hòn đảo"
/// (route tồn tại nhưng không thể tới bằng thao tác UI).
///
/// Floor tổng (33) là số lệnh điều hướng đo được trên 10 module GĐ3+ khi
/// ratchet được tạo (tổng toàn tablet scope là ~197); chỉ được tăng, không
/// được giảm. Danh sách module là các nhóm GĐ3–GĐ6 từng bị đào tạo 0 cạnh
/// điều hướng trong báo cáo rà soát 2026-09-09.
void main() {
  test('GĐ8 ratchet: mọi module tablet GĐ3+ có điều hướng trong trang', () {
    const wiredModules = <String>{
      'arena',
      'predictions',
      'earn_staking',
      'earn_savings',
      'launchpad',
      'trade_bots',
      'trade_copy',
      'trade_compliance',
      'dca',
      'cross_module',
    };

    final navCallPattern = RegExp(r'context\.(go|push)\(');
    final moduleNavCounts = <String, int>{};
    var total = 0;
    for (final module in wiredModules) {
      final dir = Directory('lib/features/$module/presentation/tablet');
      if (!dir.existsSync()) {
        fail('Module $module không còn thư mục tablet — cập nhật ratchet.');
      }
      var count = 0;
      for (final entity in dir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final source = File(entity.path).readAsStringSync();
        count += navCallPattern.allMatches(source).length;
      }
      moduleNavCounts[module] = count;
      total += count;
    }

    final islands = [
      for (final entry in moduleNavCounts.entries)
        if (entry.value == 0) entry.key,
    ];
    expect(
      islands,
      isEmpty,
      reason:
          'Module tablet không có lệnh điều hướng nào (hòn đảo): $islands — '
          'mỗi hub/danh sách phải nối được sang trang con.',
    );
    expect(
      total,
      greaterThanOrEqualTo(33),
      reason:
          'Tổng lệnh điều hướng tablet của nhóm GĐ3+ tụt xuống $total '
          '(floor 33) — chỉ được tăng.',
    );
  });

  test('GĐ8 ratchet: tablet scope không còn nút bấm rỗng', () {
    final emptyHandlerPattern = RegExp(r'on(Pressed|Tap):\s*(\(\)\s*\{)?\s*\}');
    final tabletRoot = Directory('lib');
    final offenders = <String>[];
    for (final entity in tabletRoot.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (!entity.path.contains('tablet')) continue;
      if (emptyHandlerPattern.hasMatch(File(entity.path).readAsStringSync())) {
        offenders.add(entity.path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Tái xuất hiện nút bấm rỗng trong tablet: $offenders — nút không '
          'có hành vi thật phải chuyển sang stateful selection, điều hướng, '
          'hoặc onPressed: null (disabled).',
    );
  });
}
