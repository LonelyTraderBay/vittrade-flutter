// Guardrail: Tablet-Adaptive Standard R1 (docs/02_FLUTTER_MIGRATION/
// standards/Tablet-Adaptive-Standard.md).
//
// Khóa TUYỆT ĐỐI (không baseline, không ratchet): bề mặt tablet khởi tạo ở 0
// (2026-08-23) — presentation tablet không được query AppBreakpoints (surface
// đã chốt ở bootstrap; ngưỡng layout trong page dùng TabletDashboardWidths)
// và không được dùng compat dispatcher ResponsiveSurfacePage ngoài composition
// root. Router/theme layer được miễn (đó là nơi định nghĩa/chọn surface hợp
// pháp, kể cả nhánh compat `null` của createAppRouter facade).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _surfaceBreakpointRe = RegExp(r'\bAppBreakpoints\.');
final _compatDispatcherRe = RegExp(
  r'responsive_surface_page|ResponsiveSurfacePage',
);
const _compatAllowedPathFragments = <String>['/app/bootstrap/'];

void main() {
  test(
    'tablet presentation never re-dispatches the surface (absolute lock)',
    () {
      final violations = <String>[];

      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        final fileName = normalized.split('/').last;
        final isTabletSurface =
            normalized.contains('/tablet/') || fileName.contains('tablet');
        if (!isTabletSurface || !normalized.endsWith('.dart')) continue;
        final isRouterOrTheme =
            normalized.contains('/app/router/') ||
            normalized.contains('/app/theme/');
        final compatSanctioned = _compatAllowedPathFragments.any(
          normalized.contains,
        );

        final lines = entity.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.trimLeft().startsWith('//')) continue;
          final rel = normalized.replaceFirst('lib/', '');
          if (!isRouterOrTheme && _surfaceBreakpointRe.hasMatch(line)) {
            violations.add('$rel|${i + 1}|R1a-surface-breakpoint');
          }
          if (!compatSanctioned && _compatDispatcherRe.hasMatch(line)) {
            violations.add('$rel|${i + 1}|R1b-compat-dispatcher');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Presentation tablet tự chọn surface lúc runtime (chuẩn '
            'Tablet-Adaptive R1 — khóa tuyệt đối):\n${violations.join('\n')}\n\n'
            'Surface chốt một lần ở bootstrap; ngưỡng layout trong page dùng '
            'TabletDashboardWidths, không dùng AppBreakpoints; compat '
            'dispatcher ResponsiveSurfacePage chỉ thuộc composition root.',
      );
    },
  );

  test('tablet route-surface audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/tablet_route_surface_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/tablet_route_surface_audit.dart` from '
          'flutter_app/.',
    );
  });
}

String _dartExecutable() {
  final executable = Platform.resolvedExecutable;
  final normalized = executable.replaceAll('\\', '/');
  if (normalized.endsWith('/dart.exe') || normalized.endsWith('/dart')) {
    return executable;
  }

  const cacheMarker = '/flutter/bin/cache/';
  final cacheIndex = normalized.indexOf(cacheMarker);
  if (cacheIndex >= 0) {
    final cacheRoot = normalized.substring(0, cacheIndex + cacheMarker.length);
    return '${cacheRoot}dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return '$flutterRoot/bin/cache/dart-sdk/bin/dart';
  }
  return 'dart';
}
