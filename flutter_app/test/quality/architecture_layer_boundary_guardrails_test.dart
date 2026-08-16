// Origin: 9abb7118 (2026-07-18) - feat(gd3-d): golden 4 module + tach 2 guardrail lon + tool duplicate-widget — dong Cum D GD3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'architecture_baseline_guardrails_test_utils.dart';

void main() {
  group('architecture baseline guardrails - layer boundaries', () {
    test(
      'all feature modules expose domain, data, and presentation layers',
      () {
        // A-Plus roadmap ARCH-A6 (2026-07-17): `trade` was a documented
        // presentation-only exception during the trade module split, but
        // Phase 5 (see the history comment on the "non-controller direct
        // feature data imports" test below) gave `trade` its own
        // independent `domain/`/`data/` layers, so the exception no longer
        // applies — every feature module now exposes all 3 layers.
        const presentationOnlyModules = <String>{};

        final featureDirs = Directory(
          'lib/features',
        ).listSync().whereType<Directory>().toList();
        final missing = <String>[];

        for (final feature in featureDirs) {
          final path = normalizePath(feature.path);
          final moduleName = path.split('/').last;
          if (presentationOnlyModules.contains(moduleName)) continue;
          for (final layer in ['domain', 'data', 'presentation']) {
            final layerPath = '$path/$layer';
            if (!Directory(layerPath).existsSync()) {
              missing.add(layerPath);
            }
          }
        }

        expect(missing, isEmpty);
      },
    );

    test('presentation page and widget files do not import data facades', () {
      final imports = sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data",
        ),
        pathFilter: (path) =>
            path.contains('/presentation/pages/') ||
            path.contains('/presentation/widgets/') ||
            RegExp(
              r'/presentation/(phone|tablet|web)/(pages|widgets)/',
            ).hasMatch(path),
      );

      expect(
        imports,
        isEmpty,
        reason: 'Pages/widgets must read domain/controller facades, not data.',
      );
    });

    test('presentation controllers avoid mock and remote repositories', () {
      final imports = sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data/repositories/(mock|remote)_",
        ),
        pathFilter: (path) => path.contains('/presentation/controllers/'),
      );

      expect(
        imports,
        isEmpty,
        reason:
            'Presentation controllers may depend on same-feature providers, '
            'but must not expose mock or remote repositories.',
      );
    });

    test('presentation controller data-provider exposure does not increase', () {
      final imports = sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data/providers/",
        ),
        pathFilter: (path) => path.contains('/presentation/controllers/'),
      );

      expect(
        imports.length,
        lessThanOrEqualTo(0),
        reason:
            'Controller files may temporarily bridge same-feature providers, '
            'but this exposure must trend down to zero.',
      );
    });

    test('presentation controllers exist for migrated high-risk state', () {
      final controllers = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<Directory>()
          .where((directory) {
            final path = normalizePath(directory.path);
            return path.endsWith('/presentation/controllers');
          })
          .toList();

      expect(controllers, isNotEmpty);
    });
  });
}
