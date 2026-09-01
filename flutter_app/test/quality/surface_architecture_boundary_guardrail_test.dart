import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _surfacePathRe = RegExp(
  r'/presentation/(?:pages/|widgets/)?(phone|tablet|web)(?:/|$)',
);

String _normalize(String path) => path.replaceAll('\\', '/');

String? _surfaceFor(String path) =>
    _surfacePathRe.firstMatch(_normalize(path))?.group(1);

Iterable<File> _presentationFiles() sync* {
  final root = Directory('lib/features');
  if (!root.existsSync()) return;
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (_surfaceFor(entity.path) != null) yield entity;
  }
}

File? _resolveLocalImport(File source, String uri) {
  if (uri.startsWith('package:vit_trade_flutter/')) {
    return File('lib/${uri.substring('package:vit_trade_flutter/'.length)}');
  }
  if (uri.startsWith('.')) {
    return File('${source.parent.path}/$uri');
  }
  return null;
}

Iterable<File> _localImports(File source) sync* {
  final importPattern = RegExp(r"(?:import|export)\s+'([^']+)'\s*;");
  for (final match in importPattern.allMatches(source.readAsStringSync())) {
    final target = _resolveLocalImport(source, match.group(1)!);
    if (target != null && target.existsSync()) yield target;
  }
}

void main() {
  test('surface presentation không import chéo Phone/Tablet/Web', () {
    final violations = <String>[];

    for (final file in _presentationFiles()) {
      final path = _normalize(file.path);
      final surface = _surfaceFor(path)!;
      final forbidden = switch (surface) {
        'phone' => const [
          'presentation/pages/tablet/',
          'presentation/widgets/tablet/',
          'presentation/tablet/',
          'presentation/pages/web/',
          'presentation/widgets/web/',
          'presentation/web/',
        ],
        'tablet' => const [
          'presentation/pages/phone/',
          'presentation/widgets/phone/',
          'presentation/phone/',
          'presentation/pages/web/',
          'presentation/widgets/web/',
          'presentation/web/',
          'presentation/pages/hub/',
          'presentation/widgets/hub/',
        ],
        'web' => const [
          'presentation/pages/phone/',
          'presentation/widgets/phone/',
          'presentation/phone/',
          'presentation/pages/tablet/',
          'presentation/widgets/tablet/',
          'presentation/tablet/',
        ],
        _ => const <String>[],
      };

      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trimLeft();
        if (!trimmed.startsWith('import ') && !trimmed.startsWith('export ')) {
          continue;
        }
        for (final token in forbidden) {
          if (line.contains(token)) {
            violations.add('$path imports $token');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Surface UI must not import another surface or legacy hub UI: '
          '$violations',
    );
  });

  test('Tablet presentation không import router facade chứa Phone/Web UI', () {
    final violations = <String>[];

    for (final file in _presentationFiles()) {
      final path = _normalize(file.path);
      if (_surfaceFor(path) != 'tablet') continue;

      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line ==
            "import 'package:vit_trade_flutter/app/router/app_router.dart';") {
          violations.add('$path:${i + 1}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Tablet presentation chỉ được dùng app_route_contracts.dart cho '
          'route constants; không import app_router.dart vì facade này kéo '
          'Phone/Web composition vào dependency graph: $violations',
    );
  });

  test('dependency graph của Tablet không kéo Phone/Web UI vào', () {
    final roots = _presentationFiles().where((file) {
      return _surfaceFor(file.path) == 'tablet';
    });
    final pending = <File>[...roots];
    final visited = <String>{};
    final violations = <String>[];

    while (pending.isNotEmpty) {
      final file = pending.removeLast();
      final path = _normalize(file.path);
      if (!visited.add(path)) continue;

      if (path.endsWith('/app/router/app_router.dart') ||
          RegExp(
            r'/presentation/(?:pages/|widgets/)?(?:phone|web)(?:/|$)',
          ).hasMatch(path)) {
        violations.add(path);
      }
      pending.addAll(_localImports(file));
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Tablet dependency graph must stay independent of Phone/Web UI and '
          'the app router facade: $violations',
    );
  });

  test('Tablet router composition root không kéo Phone/Web UI vào', () {
    final root = File('lib/app/router/tablet/tablet_app_router.dart');
    final pending = <File>[root];
    final visited = <String>{};
    final violations = <String>[];

    while (pending.isNotEmpty) {
      final file = pending.removeLast();
      final path = _normalize(file.path);
      if (!visited.add(path)) continue;

      if (path.endsWith('/app/router/app_router.dart') ||
          RegExp(
            r'/presentation/(?:pages/|widgets/)?(?:phone|web)(?:/|$)',
          ).hasMatch(path)) {
        violations.add(path);
      }
      pending.addAll(_localImports(file));
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Tablet router phải lắp ráp trực tiếp Tablet/neutral UI, không '
          'được kéo app_router hoặc Phone/Web UI: $violations',
    );
  });

  test('Phone router composition root không kéo Tablet/Web UI vào', () {
    final root = File('lib/app/router/phone/phone_app_router.dart');
    final pending = <File>[root];
    final visited = <String>{};
    final violations = <String>[];

    while (pending.isNotEmpty) {
      final file = pending.removeLast();
      final path = _normalize(file.path);
      if (!visited.add(path)) continue;

      if (path.endsWith('/app/router/app_router.dart') ||
          RegExp(
            r'/presentation/(?:pages/|widgets/)?(?:tablet|web)(?:/|$)',
          ).hasMatch(path)) {
        violations.add(path);
      }
      pending.addAll(_localImports(file));
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Phone router phải lắp ráp trực tiếp Phone/neutral UI, không được '
          'kéo app_router hoặc Tablet/Web UI: $violations',
    );
  });

  test(
    'Phone route groups là composition cố định, không còn surface selector',
    () {
      final root = Directory('lib/app/router/phone/route_groups');
      final violations = <String>[];
      if (root.existsSync()) {
        for (final entity in root.listSync(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.dart')) continue;
          final path = _normalize(entity.path);
          final source = entity.readAsStringSync();
          if (source.contains('app_router.dart') ||
              source.contains('surface_route_helpers.dart') ||
              RegExp(r'AppSurface\.(tablet|web)').hasMatch(source) ||
              RegExp(
                r"/presentation/(?:pages/|widgets/)?(?:tablet|web)/",
              ).hasMatch(source)) {
            violations.add(path);
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Phone route groups phải cố định builder Phone và không được chứa '
            'selector/import Tablet/Web: $violations',
      );
    },
  );

  test('shared primitives không đọc trực tiếp token geometry của Phone', () {
    final violations = <String>[];
    final root = Directory('lib/shared');
    if (root.existsSync()) {
      for (final entity in root.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = _normalize(entity.path);
        final source = entity.readAsStringSync();
        if (source.contains('app_spacing.dart') ||
            RegExp(r'\bAppSpacing\.[A-Za-z0-9_]+').hasMatch(source)) {
          violations.add(path);
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Shared geometry phải đi qua AppSurfaceSpacing; Phone/Tablet '
          'không được chia sẻ trực tiếp AppSpacing: $violations',
    );
  });
}
