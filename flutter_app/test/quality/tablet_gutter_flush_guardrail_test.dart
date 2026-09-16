// Guardrail: Tablet-Spacing-Gutter-Standard — Rule S6 (gutter-flush) gắn
// NGỮ CẢNH ROUTE, scanner tool/tablet_gutter_flush_audit.dart.
//
// Lỗi gốc rễ audits trước không bắt được (bug 32dp predictions 2026-09-16):
// tablet_fullbleed_guardrail soi call-site VitPageContent( trực tiếp — mù
// với trang dựng qua VitTabletSectionFrame/Body (fullBleed nằm trong wrapper
// còn wrapper tự cấp contentPad 20dp cho idiom top-level). Audit này phân
// lớp route theo predicate shell của tablet_route_tree (markets / profile /
// wallet-history) và yêu cầu mọi trang trong detail column theo 1 trong 3
// idiom flush: frame gutterFlush:true | hub fullBleed:true | *PaneScaffold.
// Khóa TUYỆT ĐỐI 0 vi phạm — không baseline, không ratchet.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

bool normalizedEndsWith(String value, String suffix) => value.endsWith(suffix);

String _dartExecutable() {
  final executable = Platform.resolvedExecutable.replaceAll('\\', '/');
  if (normalizedEndsWith(executable, '/dart.exe') ||
      normalizedEndsWith(executable, '/dart')) {
    return executable;
  }

  const cacheMarker = '/flutter/bin/cache/';
  final cacheIndex = executable.indexOf(cacheMarker);
  if (cacheIndex >= 0) {
    final cacheRoot = executable.substring(0, cacheIndex + cacheMarker.length);
    return '${cacheRoot}dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return '$flutterRoot/bin/cache/dart-sdk/bin/dart';
  }
  return 'dart';
}

void main() {
  test('tablet gutter flush audit: 0 vi phạm + artifact current (S6)', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/tablet_gutter_flush_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Trang thêm vào detail column của shell (markets/profile/'
          'wallet-history) phải theo 1 idiom gutter-flush: '
          'VitTabletSectionFrame/Body(gutterFlush: true), '
          'VitPageContent(fullBleed: true), hoặc *PaneScaffold. '
          'Đổi cây trang xong chạy `dart run tool/tablet_gutter_flush_audit.dart` '
          'từ flutter_app/ và commit artifact cùng code.',
    );
  });
}
