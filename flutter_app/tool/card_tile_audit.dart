import 'dart:io';

/// Full-repo card tile audit: classifies VitCard surfaces by tier A–E.
void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strictHome = args.contains('--strict-home');
  final strictFull = args.contains('--strict-full');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final auditCsv = File('${docsDir.path}/audits/VitTrade-Card-Tile-Audit.csv');
  final legacyManifest = File(
    '${docsDir.path}/audits/VitTrade-Card-Tile-Manifest.csv',
  );
  final reportMd = File(
    '${docsDir.path}/audits/Card-Tile-Compliance-Report.md',
  );

  final rows = <_AuditRow>[];
  final scanRoots = [
    Directory('${appRoot.path}/lib/features'),
    Directory('${appRoot.path}/lib/shared'),
  ];

  for (final root in scanRoots) {
    if (!root.existsSync()) continue;
    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relative = _relativeLibPath(entity.path, appRoot.path);
      if (relative.endsWith('shared/widgets/vit_card.dart')) continue;

      final source = entity.readAsStringSync();
      if (!source.contains('VitCard(')) continue;

      rows.add(_auditFile(relative, source));
    }
  }

  rows.sort((a, b) => a.file.compareTo(b.file));
  final csv = _renderAuditCsv(rows);
  final summary = _renderSummary(rows);
  final report = _renderComplianceReport(rows);

  if (checkOnly) {
    if (!auditCsv.existsSync()) {
      stderr.writeln('Card tile audit CSV is missing.');
      stderr.writeln(
        'Run `dart run tool/card_tile_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    if (_normalizeEol(auditCsv.readAsStringSync()) != _normalizeEol(csv)) {
      stderr.writeln('Card tile audit CSV is stale.');
      stderr.writeln(
        'Run `dart run tool/card_tile_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    stdout.write(summary);
    stdout.writeln('Card tile audit artifact is current.');
    if (strictHome &&
        rows.any((r) => r.feature == 'home' && _blocksCi(r.status))) {
      stderr.writeln('--strict-home: Home card tile violations remain.');
      exitCode = 1;
      return;
    }
    if (strictFull && rows.any((r) => r.status == 'fail')) {
      stderr.writeln('--strict-full: repository has card tile failures.');
      exitCode = 1;
    }
    return;
  }

  docsDir.createSync(recursive: true);
  auditCsv.writeAsStringSync(csv);
  reportMd.writeAsStringSync(report);
  legacyManifest.writeAsStringSync(_renderLegacyManifest(rows));
  stdout.writeln('Wrote ${auditCsv.path}');
  stdout.writeln('Wrote ${reportMd.path}');
  stdout.writeln('Wrote ${legacyManifest.path}');
  stdout.write(summary);
}

class _AuditRow {
  _AuditRow({
    required this.feature,
    required this.file,
    required this.vitCardCount,
    required this.fixedHeightCount,
    required this.stripFixedCount,
    required this.suggestedTier,
    required this.tierAViolations,
    required this.paddingTokenDebt,
    required this.skeletonDrift,
    required this.status,
    required this.notes,
  });

  final String feature;
  final String file;
  final int vitCardCount;
  final int fixedHeightCount;
  final int stripFixedCount;
  final String suggestedTier;
  final int tierAViolations;
  final int paddingTokenDebt;
  final int skeletonDrift;
  final String status;
  final String notes;
}

_AuditRow _auditFile(String relative, String source) {
  final feature = _featureFromPath(relative);
  final blocks = _extractVitCardBlocks(source);
  var fixedHeightCount = 0;
  var stripFixedCount = 0;
  var tierAViolations = 0;
  var paddingTokenDebt = 0;
  var skeletonDrift = 0;
  final notes = <String>[];
  final tiers = <String>[];

  if (source.contains('buttonStandard + AppSpacing.x6') &&
      source.contains('recent') &&
      !source.contains('homeRecentProductHeight')) {
    skeletonDrift++;
    notes.add('skeleton_height_drift');
  }

  for (final block in blocks) {
    final start = source.indexOf(block);
    final params = _vitCardParams(block);
    final allowStart =
        block.contains('card-tile: allow-start') ||
        _hasAllowStartComment(source, start);
    final fixed = _hasFixedHeightParams(params);

    if (!fixed) {
      if (params.contains('clip: true') || block.contains('clip: true')) {
        tiers.add('E');
      } else if (params.contains('radius: VitCardRadius.large')) {
        tiers.add('D');
      } else {
        tiers.add('C');
      }
      continue;
    }

    fixedHeightCount++;
    final inStrip = _isInHorizontalStripContext(source, start);
    final centered = params.contains(
      'contentAlign: VitCardContentAlign.center',
    );
    final canonicalPadding = params.contains('AppSpacing.cardTilePadding');

    if (inStrip) {
      stripFixedCount++;
      tiers.add('A');
      if (allowStart) continue;
      if (!centered) {
        tierAViolations++;
        notes.add('strip_missing_center');
      }
      if (!canonicalPadding &&
          !params.contains('VitCardVariant.inner') &&
          !params.contains('VitCardVariant.ghost')) {
        paddingTokenDebt++;
        notes.add('strip_missing_card_tile_padding');
      }
    } else {
      tiers.add('D');
      if (!allowStart && !centered) {
        notes.add('fixed_height_baseline');
      }
    }
  }

  if (source.contains('VitCompactProductCard') ||
      source.contains('VitMarketTickerCard')) {
    tiers.add('A');
  }
  if (source.contains('VitServiceTile') ||
      source.contains('VitActionTileGrid')) {
    tiers.add('B');
  }
  if (source.contains('VitNextActionCard') ||
      source.contains('VitDiscoveryActionCard')) {
    tiers.add('C');
  }

  final suggestedTier = _dominantTier(tiers);
  final status = tierAViolations > 0
      ? 'fail'
      : (paddingTokenDebt > 0 || skeletonDrift > 0
            ? 'warn'
            : (fixedHeightCount > 0 && notes.contains('fixed_height_baseline')
                  ? 'warn'
                  : 'pass'));

  return _AuditRow(
    feature: feature,
    file: 'flutter_app/lib/$relative',
    vitCardCount: blocks.length,
    fixedHeightCount: fixedHeightCount,
    stripFixedCount: stripFixedCount,
    suggestedTier: suggestedTier,
    tierAViolations: tierAViolations,
    paddingTokenDebt: paddingTokenDebt,
    skeletonDrift: skeletonDrift,
    status: status,
    notes: notes.isEmpty ? '-' : notes.toSet().join(';'),
  );
}

bool _hasAllowStartComment(String source, int vitCardStart) {
  final lineStart = source.lastIndexOf('\n', vitCardStart);
  final scanStart = lineStart <= 0 ? 0 : lineStart;
  final prefix = source.substring(
    scanStart > 400 ? vitCardStart - 400 : 0,
    vitCardStart,
  );
  return prefix.contains('card-tile: allow-start');
}

bool _hasFixedHeightParams(String params) {
  if (RegExp(r'\bheight:\s*').hasMatch(params)) return true;
  if (RegExp(r'minHeight:\s*[^0\s,)]').hasMatch(params)) return true;
  return false;
}

bool _isInHorizontalStripContext(String source, int vitCardStart) {
  final lineStart = source.lastIndexOf('\n', vitCardStart);
  final prefix = source.substring(0, lineStart < 0 ? vitCardStart : lineStart);
  final lines = prefix.split('\n');
  final start = lines.length > 80 ? lines.length - 80 : 0;
  for (var i = lines.length - 1; i >= start; i--) {
    if (lines[i].contains('scrollDirection: Axis.horizontal')) {
      return true;
    }
  }
  return false;
}

String _dominantTier(List<String> tiers) {
  if (tiers.isEmpty) return 'C';
  final counts = <String, int>{};
  for (final t in tiers) {
    counts[t] = (counts[t] ?? 0) + 1;
  }
  var best = tiers.first;
  var bestCount = 0;
  for (final entry in counts.entries) {
    if (entry.value > bestCount) {
      best = entry.key;
      bestCount = entry.value;
    }
  }
  return best;
}

String _featureFromPath(String relative) {
  if (relative.startsWith('shared/')) return 'shared';
  final parts = relative.split('/');
  if (parts.length > 1 && parts[0] == 'features') {
    return parts[1];
  }
  return 'unknown';
}

String _relativeLibPath(String absolute, String appRoot) {
  final norm = absolute.replaceAll('\\', '/');
  final root = appRoot.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');
  final suffix = norm.substring(root.length + 1);
  return suffix.startsWith('lib/') ? suffix.substring('lib/'.length) : suffix;
}

List<String> _extractVitCardBlocks(String source) {
  final blocks = <String>[];
  final pattern = RegExp(r'VitCard\s*\(', multiLine: true);
  for (final match in pattern.allMatches(source)) {
    final start = match.start;
    var depth = 0;
    var end = start;
    for (var i = start; i < source.length; i++) {
      final char = source[i];
      if (char == '(') depth++;
      if (char == ')') {
        depth--;
        if (depth == 0) {
          end = i + 1;
          break;
        }
      }
    }
    if (end > start) {
      blocks.add(source.substring(start, end));
    }
  }
  return blocks;
}

String _vitCardParams(String block) {
  final childIndex = block.indexOf('child:');
  if (childIndex <= 0) return block;
  return block.substring(0, childIndex);
}

bool _blocksCi(String status) => status == 'fail' || status == 'warn';

String _renderAuditCsv(List<_AuditRow> rows) {
  final buffer = StringBuffer(
    'feature,file,vit_card_count,fixed_height_count,strip_fixed_count,'
    'suggested_tier,tier_a_violations,padding_token_debt,skeleton_drift,status,notes\n',
  );
  for (final row in rows) {
    buffer.writeln(
      [
        row.feature,
        row.file,
        row.vitCardCount,
        row.fixedHeightCount,
        row.stripFixedCount,
        row.suggestedTier,
        row.tierAViolations,
        row.paddingTokenDebt,
        row.skeletonDrift,
        row.status,
        row.notes,
      ].join(','),
    );
  }
  return buffer.toString();
}

String _renderLegacyManifest(List<_AuditRow> rows) {
  final canonical = rows.where(
    (r) =>
        r.file.contains('vit_compact_product_card.dart') ||
        r.file.contains('vit_market_ticker.dart'),
  );
  final buffer = StringBuffer(
    'feature,tier,file,widget,pattern,fixed_height,center_align,padding_token,status,notes\n',
  );
  for (final row in canonical) {
    buffer.writeln(
      [
        row.feature,
        'A',
        row.file,
        row.file.contains('compact_product')
            ? 'VitCompactProductCard'
            : 'VitMarketTickerCard',
        'canonical',
        'yes',
        row.tierAViolations == 0 ? 'yes' : 'no',
        row.paddingTokenDebt == 0 ? 'cardTilePadding' : 'other',
        row.status,
        row.notes,
      ].join(','),
    );
  }
  for (final row in rows.where((r) => r.feature == 'home')) {
    buffer.writeln(
      [
        row.feature,
        row.suggestedTier,
        row.file,
        'file_summary',
        'home_scan',
        row.fixedHeightCount,
        '-',
        '-',
        row.status,
        row.notes,
      ].join(','),
    );
  }
  return buffer.toString();
}

String _renderSummary(List<_AuditRow> rows) {
  final pass = rows.where((r) => r.status == 'pass').length;
  final warn = rows.where((r) => r.status == 'warn').length;
  final fail = rows.where((r) => r.status == 'fail').length;
  return 'Card tile audit: ${rows.length} files ($pass pass, $warn warn, $fail fail)\n';
}

String _renderComplianceReport(List<_AuditRow> rows) {
  final byFeature = <String, List<_AuditRow>>{};
  for (final row in rows) {
    byFeature.putIfAbsent(row.feature, () => []).add(row);
  }

  final buffer = StringBuffer()
    ..writeln('# Card Tile Compliance Report')
    ..writeln()
    ..writeln(
      'Generated by `dart run tool/card_tile_audit.dart` from `flutter_app/`.',
    )
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('| Metric | Count |')
    ..writeln('| --- | --- |');

  final pass = rows.where((r) => r.status == 'pass').length;
  final warn = rows.where((r) => r.status == 'warn').length;
  final fail = rows.where((r) => r.status == 'fail').length;
  final tierAStrip = rows.fold<int>(0, (s, r) => s + r.stripFixedCount);
  final tierAFail = rows.fold<int>(0, (s, r) => s + r.tierAViolations);

  buffer
    ..writeln('| Files with VitCard | ${rows.length} |')
    ..writeln('| pass | $pass |')
    ..writeln('| warn | $warn |')
    ..writeln('| fail | $fail |')
    ..writeln('| Strip fixed-height VitCard blocks | $tierAStrip |')
    ..writeln('| Tier A violations (strip, no center) | $tierAFail |')
    ..writeln()
    ..writeln('## By module')
    ..writeln()
    ..writeln(
      '| Module | Files | pass | warn | fail | strip blocks | Tier A violations |',
    )
    ..writeln('| --- | --- | --- | --- | --- | --- | --- |');

  final features = byFeature.keys.toList()..sort();
  for (final feature in features) {
    final list = byFeature[feature]!;
    buffer.writeln(
      '| $feature | ${list.length} | '
      '${list.where((r) => r.status == 'pass').length} | '
      '${list.where((r) => r.status == 'warn').length} | '
      '${list.where((r) => r.status == 'fail').length} | '
      '${list.fold<int>(0, (s, r) => s + r.stripFixedCount)} | '
      '${list.fold<int>(0, (s, r) => s + r.tierAViolations)} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Failures (action required)')
    ..writeln();

  final failures = rows.where((r) => r.status == 'fail').toList();
  if (failures.isEmpty) {
    buffer.writeln('No failures.');
  } else {
    for (final row in failures) {
      buffer.writeln('- `${row.file}` — ${row.notes}');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Warnings (baseline / allow-start)')
    ..writeln();

  final warnings = rows.where((r) => r.status == 'warn').take(40).toList();
  buffer.writeln(
    'Showing first ${warnings.length} warn files (see CSV for full list).',
  );
  buffer.writeln();
  for (final row in warnings) {
    buffer.writeln('- `${row.file}` — ${row.notes}');
  }

  return '${buffer.toString().trimRight()}\n';
}

/// Normalizes CRLF/CR line endings to LF so the staleness check is not
/// sensitive to git's checkout-time EOL conversion (core.autocrlf) on
/// Windows worktrees. Generated content is always LF-only (StringBuffer
/// hardcodes '\n'), so without this the check would false-fail on any
/// fresh Windows checkout even when the artifact is up to date.
String _normalizeEol(String value) =>
    value.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

Directory _findAppRoot() {
  final dir = Directory.current;
  if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
  final nested = Directory('${dir.path}/flutter_app');
  if (File('${nested.path}/pubspec.yaml').existsSync()) return nested;
  throw StateError(
    'Run from flutter_app/ or repo root (flutter_app/pubspec.yaml not found).',
  );
}
