import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Gap #1 (2026-09-01): `route_coverage_audit` (nguồn Truth Table) chỉ quét
/// cây legacy `lib/app/router/route_groups/` — cây phục vụ Web compat. Hai
/// cây production độc lập là `phone/route_groups/` và `tablet_route_tree`
/// (tablet đã khóa qua surface_app_router_test: manifest ↔ Truth Table ↔
/// router thật). Cây Phone phải giữ parity path tuyệt đối với cây legacy:
/// thêm/bớt/đổi path ở một cây mà cây chuẩn không biết là fail sớm ở đây.
final RegExp _pathArg = RegExp(r"path:\s*([A-Za-z0-9_.]+|'[^']+')");

Map<String, int> _collectPathTokens(Directory dir) {
  final counts = <String, int>{};
  for (final file in dir.listSync().whereType<File>()) {
    if (!file.path.endsWith('_routes.dart')) continue;
    for (final match in _pathArg.allMatches(file.readAsStringSync())) {
      final token = match.group(1)!;
      counts[token] = (counts[token] ?? 0) + 1;
    }
  }
  return counts;
}

List<String> _parityDiff(Map<String, int> legacy, Map<String, int> phone) {
  final issues = <String>[];
  for (final key
      in legacy.keys.toSet().union(phone.keys.toSet()).toList()..sort()) {
    final l = legacy[key] ?? 0;
    final p = phone[key] ?? 0;
    if (l != p) {
      issues.add('$key: legacy=$l phone=$p');
    }
  }
  return issues;
}

void main() {
  test(
    'phone route tree giữ parity path với cây legacy (nguồn Truth Table)',
    () {
      final legacy = _collectPathTokens(
        Directory('lib/app/router/route_groups'),
      );
      final phone = _collectPathTokens(
        Directory('lib/app/router/phone/route_groups'),
      );
      expect(legacy, isNotEmpty);
      expect(
        _parityDiff(legacy, phone),
        isEmpty,
        reason:
            'Hai cây lệch parity — route chỉ tồn tại một cây sẽ nằm ngoài tầm '
            'route_coverage_audit hoặc rendering sai so với Truth Table.',
      );
    },
  );

  test('parity self-test: phát hiện thêm, thiếu và lệch số lần khai báo', () {
    final base = {'AppRoutePaths.home': 1, "'/literal'": 1};
    expect(_parityDiff(base, {...base, 'AppRoutePaths.extra': 1}), isNotEmpty);
    expect(
      _parityDiff(base, {'AppRoutePaths.home': 2, "'/literal'": 1}),
      isNotEmpty,
    );
    expect(_parityDiff(base, Map.of(base)), isEmpty);
  });
}
