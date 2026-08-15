// Origin: 60a7f124 (2026-06-04) - feat: chuẩn hóa header và điều hướng Flutter
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('top header primitives keep the shared token contract', () {
    final tokenSource = File(
      'lib/app/theme/app_top_header_tokens.dart',
    ).readAsStringSync();
    for (final token in [
      'detailMinHeight',
      'rootMinHeight',
      'instrumentMinHeight',
      'horizontalPadding',
      'actionGap',
      'buttonSize',
      'badgeMinSize',
      'surfaceColor',
      'dividerColor',
    ]) {
      expect(tokenSource, contains(token), reason: 'Missing token: $token');
    }

    for (final path in [
      'lib/shared/layout/vit_top_chrome.dart',
      'lib/shared/layout/vit_header.dart',
      'lib/shared/layout/vit_header_action_button.dart',
    ]) {
      final source = File(path).readAsStringSync();
      expect(
        source,
        contains('app_top_header_tokens.dart'),
        reason: '$path must import the shared top-header token source.',
      );
      expect(
        source,
        contains('AppTopHeaderTokens.'),
        reason: '$path must consume AppTopHeaderTokens metrics/colors.',
      );
    }
  });

  test('top header visual archetype audit artifact is strict-clean', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/top_header_visual_archetype_audit.dart',
      '--check',
      '--strict',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/top_header_visual_archetype_audit.dart` '
          'from flutter_app/ and resolve strict visual header violations.',
    );
  });

  test('screen-level audit contract keeps product hubs at root module level', () {
    final markdown = File(
      '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Top-Header-Visual-Archetype-Audit.md',
    ).readAsStringSync();
    final csv = File(
      '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Top-Header-Visual-Archetype-Audit.csv',
    ).readAsStringSync();

    expect(markdown, contains('screen_level_mismatches=0'));
    expect(csv, contains('screenLevel,expectedArchetype,screenLevelMismatch'));

    for (final routePath in [
      'AppRoutePaths.marketsPredictions',
      'AppRoutePaths.dca',
      'AppRoutePaths.arena',
      'AppRoutePaths.launchpad',
      'AppRoutePaths.earn',
      'AppRoutePaths.earnSavings',
    ]) {
      expect(
        csv,
        matches(
          RegExp(
            '"[^"]+","$routePath","VitTabletUtilityPage","[^"]+",'
            '"fixed_vit_header","vit_header_default_title_subtitle",'
            '"rootModule","L1_productModuleHub","rootModule","no"',
          ),
        ),
        reason:
            '$routePath Tablet composition must stay a root product module.',
      );
    }
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
    return '$flutterRoot/bin/cache/dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  return 'dart';
}
