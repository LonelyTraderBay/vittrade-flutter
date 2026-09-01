import 'dart:io';

/// Flags per-module spacing-token constants (`lib/app/theme/spacing/*.dart`)
/// whose value is a bare numeric literal that exactly matches one of the 7
/// core `AppSpacing` scale steps (`x1..x7`) — i.e. the value already has a
/// canonical name in the core scale, but was reinvented under a
/// module-specific name instead of referencing `AppSpacing.xN` directly.
///
/// Deliberately scoped to only the 7 scale steps, not the ~200 other
/// semantic tokens in `app_spacing.dart` — those cover narrow, named
/// purposes (e.g. `serviceTileIconContainer = 26`) where a coincidental
/// value match is not evidence of duplication. See
/// `docs/02_FLUTTER_MIGRATION/standards/Spacing-Token-Duplication-Standard.md`.
/// The Tablet namespace is excluded: it is an intentionally independent
/// Base-8-derived scale, not a Phone `AppSpacing` mirror.
final class DuplicationEntry {
  const DuplicationEntry({
    required this.module,
    required this.file,
    required this.constantName,
    required this.value,
    required this.coreToken,
  });

  final String module;
  final String file;
  final String constantName;
  final double value;
  final String coreToken;
}

// Core scale steps from lib/app/theme/app_spacing.dart. Kept as a literal
// copy (not imported) because this is a standalone `dart run` script, same
// pattern as every other tool/*_audit.dart in this repo.
const _coreScale = <String, double>{
  'x1': 3,
  'x2': 5,
  'x3': 8,
  'x4': 13,
  'x5': 21,
  'x6': 34,
  'x7': 55,
};

const _excludedModules = {'tablet'};

// Frozen per-module baseline (ratchet) — captured 2026-07-09 from a fresh
// run against every lib/app/theme/spacing/*_spacing_tokens.dart file that
// exists today. `--check` fails only when current > baseline for a module,
// or when a scanned module is missing from this map entirely. Mirrors
// tool/home_reference_consistency_audit.dart's `_allModuleDivergenceBaselines`
// — this is a regression-only ratchet, not a demand to fix all 301 today.
// Ratchet paid down 2026-07-22: bare AppSpacing scale literals → AppSpacing.xN.
const _moduleBaselines = <String, int>{
  'admin': 0,
  'arena': 0,
  'auth': 0,
  'cross_module': 0,
  'dca': 0,
  'earn': 0,
  'enterprise_states': 0,
  'home': 0,
  'launchpad': 0,
  'markets': 0,
  'news': 0,
  'notifications': 0,
  'onboarding': 0,
  'p2p': 0,
  'predictions': 0,
  'profile': 0,
  'referral': 0,
  'shared': 0,
  'support': 0,
  'trade': 0,
  'trade_bots': 0,
  'trade_compliance': 0,
  'trade_copy': 0,
  'wallet': 0,
};

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Spacing-Token-Duplication-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Spacing-Token-Duplication-Audit.csv',
  );

  final entries = _collectEntries(appRoot, repoRoot);
  final markdown = _renderMarkdown(entries);
  final csv = _renderCsv(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('Spacing token duplication markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Spacing token duplication markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Spacing token duplication CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Spacing token duplication CSV artifact is stale.');
    }

    final byModule = <String, int>{};
    for (final entry in entries) {
      byModule[entry.module] = (byModule[entry.module] ?? 0) + 1;
    }

    for (final module in byModule.keys) {
      final current = byModule[module]!;
      final baseline = _moduleBaselines[module];
      if (baseline == null) {
        failures.add(
          'Module "$module" has spacing-token duplication entries but no '
          'baseline in _moduleBaselines — add it (even at 0) instead of '
          'silently passing.',
        );
      } else if (current > baseline) {
        failures.add(
          'Module "$module" spacing-token duplication regressed: '
          '$current found, baseline is $baseline.',
        );
      }
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/spacing_token_duplication_audit.dart` from '
        'flutter_app/.',
      );
      stderr.write(summary);
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Spacing token duplication artifacts are current.');
    return;
  }

  docsDir.createSync(recursive: true);
  markdownFile.writeAsStringSync(markdown);
  csvFile.writeAsStringSync(csv);
  stdout.writeln('Wrote ${markdownFile.path}');
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.write(summary);
}

Directory _findAppRoot() {
  final current = Directory.current;
  if (Directory('${current.path}/lib/app/theme/spacing').existsSync()) {
    return current;
  }

  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/theme/spacing').existsSync()) {
    return nested;
  }

  throw StateError('Run from repo root or flutter_app/.');
}

final _constDoubleLiteral = RegExp(
  r'static\s+const\s+double\s+(\w+)\s*=\s*(-?\d+(?:\.\d+)?)\s*;',
);

List<DuplicationEntry> _collectEntries(Directory appRoot, String repoRoot) {
  final entries = <DuplicationEntry>[];
  final spacingDir = Directory('${appRoot.path}/lib/app/theme/spacing');
  if (!spacingDir.existsSync()) return entries;

  final files =
      spacingDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('_spacing_tokens.dart'))
          .toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );

  for (final file in files) {
    final fileName = file.uri.pathSegments.last;
    final module = fileName.replaceAll('_spacing_tokens.dart', '');
    if (_excludedModules.contains(module)) continue;
    final source = file.readAsStringSync();
    final relativeFile = _relativePath(file, repoRoot);

    for (final match in _constDoubleLiteral.allMatches(source)) {
      final name = match.group(1)!;
      final value = double.parse(match.group(2)!);
      String? coreToken;
      for (final scaleEntry in _coreScale.entries) {
        if (scaleEntry.value == value) {
          coreToken = 'AppSpacing.${scaleEntry.key}';
          break;
        }
      }
      if (coreToken == null) continue;

      entries.add(
        DuplicationEntry(
          module: module,
          file: relativeFile,
          constantName: name,
          value: value,
          coreToken: coreToken,
        ),
      );
    }
  }

  entries.sort((a, b) {
    final moduleCompare = a.module.compareTo(b.module);
    if (moduleCompare != 0) return moduleCompare;
    final fileCompare = a.file.compareTo(b.file);
    if (fileCompare != 0) return fileCompare;
    return a.constantName.compareTo(b.constantName);
  });

  return entries;
}

String _relativePath(File file, String repoRoot) {
  final relative = file.path.replaceFirst(repoRoot, '').replaceAll('\\', '/');
  return relative.startsWith('/') ? relative.substring(1) : relative;
}

String _formatValue(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}

String _renderSummary(List<DuplicationEntry> entries) {
  final byModule = <String, int>{};
  for (final entry in entries) {
    byModule[entry.module] = (byModule[entry.module] ?? 0) + 1;
  }
  final buffer = StringBuffer()
    ..writeln('total_duplication_entries=${entries.length}')
    ..writeln('modules_with_entries=${byModule.length}');
  for (final module in byModule.keys.toList()..sort()) {
    buffer.writeln('  $module=${byModule[module]}');
  }
  return buffer.toString();
}

String _renderMarkdown(List<DuplicationEntry> entries) {
  final byModule = <String, int>{};
  for (final entry in entries) {
    byModule[entry.module] = (byModule[entry.module] ?? 0) + 1;
  }

  final buffer = StringBuffer()
    ..writeln('# VitTrade Spacing Token Duplication Audit')
    ..writeln()
    ..writeln(
      'Generated by `flutter_app/tool/spacing_token_duplication_audit.dart`.',
    )
    ..writeln()
    ..writeln(
      'Flags `lib/app/theme/spacing/<module>_spacing_tokens.dart` constants '
      'whose literal value exactly matches one of the 7 core `AppSpacing` '
      'scale steps (`x1`=3, `x2`=5, `x3`=8, `x4`=13, `x5`=21, `x6`=34, '
      '`x7`=55) — these should reference `AppSpacing.xN` directly instead of '
      'restating the literal under a module-specific name.',
    )
    ..writeln()
    ..writeln(
      'The Tablet namespace (`tablet_spacing_tokens.dart`) is intentionally '
      'excluded because Tablet uses its own closed Base-8-derived role scale '
      '(4/8/12/16/24/32/56).',
    )
    ..writeln()
    ..writeln('```text')
    ..write(_renderSummary(entries))
    ..writeln('```')
    ..writeln()
    ..writeln('## Module Gate (frozen baseline)')
    ..writeln()
    ..writeln('| module | current | baseline | status |')
    ..writeln('| --- | ---: | ---: | --- |');

  final allModules = {...byModule.keys, ..._moduleBaselines.keys}.toList()
    ..sort();
  for (final module in allModules) {
    final current = byModule[module] ?? 0;
    final baseline = _moduleBaselines[module];
    final status = baseline == null
        ? 'missing baseline'
        : (current > baseline ? 'FAIL' : 'pass');
    buffer.writeln('| $module | $current | ${baseline ?? '-'} | $status |');
  }

  buffer
    ..writeln()
    ..writeln('## Duplication Entries')
    ..writeln()
    ..writeln('| module | file | constant | value | should be |')
    ..writeln('| --- | --- | --- | ---: | --- |');

  for (final entry in entries) {
    buffer.writeln(
      '| ${entry.module} | `${entry.file}` | `${entry.constantName}` | '
      '${_formatValue(entry.value)} | `${entry.coreToken}` |',
    );
  }

  return buffer.toString();
}

String _renderCsv(List<DuplicationEntry> entries) {
  final buffer = StringBuffer()
    ..writeln('module,file,constant_name,value,core_token');
  for (final entry in entries) {
    buffer.writeln(
      [
        entry.module,
        entry.file,
        entry.constantName,
        _formatValue(entry.value),
        entry.coreToken,
      ].map(_csvCell).join(','),
    );
  }
  return buffer.toString();
}

String _csvCell(String value) {
  if (!value.contains(',') && !value.contains('"') && !value.contains('\n')) {
    return value;
  }
  return '"${value.replaceAll('"', '""')}"';
}
