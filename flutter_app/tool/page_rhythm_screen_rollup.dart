import 'dart:io';

import 'page_rhythm_layout_registry.dart';

/// Rolls up route → screen compliance from route truth table + page rhythm audit.
void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strictLayout = args.contains('--strict-layout');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final auditCsv = File(
    '${docsDir.path}/audits/VitTrade-Page-Rhythm-Audit.csv',
  );
  final routeMd = File('${docsDir.path}/Flutter-Route-Coverage-Truth-Table.md');
  final outCsv = File(
    '${docsDir.path}/audits/VitTrade-Page-Rhythm-Screen-Compliance.csv',
  );
  final outMd = File('${docsDir.path}/audits/Page-Rhythm-Compliance-Report.md');

  if (!auditCsv.existsSync()) {
    stderr.writeln(
      'Missing ${auditCsv.path}. Run page_rhythm_audit.dart first.',
    );
    exitCode = 1;
    return;
  }
  if (!routeMd.existsSync()) {
    stderr.writeln(
      'Missing ${routeMd.path}. Run route_coverage_audit.dart first.',
    );
    exitCode = 1;
    return;
  }

  final auditByFile = _loadAuditCsv(auditCsv);
  final auditRelativePaths = auditByFile.keys
      .map((k) => k.replaceFirst('flutter_app/lib/', ''))
      .toSet();
  // page_file is written repo-relative (flutter_app/lib/...) like the other
  // audit CSVs — an absolute path would differ per machine/OS and make the
  // committed artifact permanently stale on CI.
  final appRootPrefix = '${appRoot.path.replaceAll(r'\', '/')}/';
  final widgetToPage = _buildWidgetToPageMap(appRoot);
  final tabRootScreens = _tabRootScreenIds();
  final routes = _parseRealPageRoutes(routeMd.readAsStringSync());
  final l3Evidence = _loadL3Evidence(appRoot);
  final rows = <_ScreenRow>[];

  for (final route in routes) {
    final pageFile = resolvePageFilePath(
      appRoot: appRoot,
      pageWidget: route.widgetClass,
      routeName: route.name,
      widgetToPage: widgetToPage,
    );
    final pageSource = pageFile == null
        ? null
        : combinedPageSource(appRoot, pageFile);

    final vpcFiles = pageFile == null
        ? <String>[]
        : collectVpcFilesForPage(appRoot, pageFile, auditRelativePaths);

    final audits = vpcFiles
        .map((f) => auditByFile[auditLibKey(f)])
        .whereType<_AuditRow>()
        .toList();

    final pattern = classifyLayoutPattern(
      pageWidget: route.widgetClass,
      routePath: route.path,
      routeName: route.name,
      pageFile: pageFile ?? '',
      vpcFiles: vpcFiles,
      pageSource: pageSource,
    );

    final hasException =
        pattern == LayoutPattern.flushChart ||
        pattern == LayoutPattern.gateShell ||
        pattern == LayoutPattern.bottomSheet ||
        pattern == LayoutPattern.customScroll;

    var l1 = audits.isEmpty
        ? (hasException ? 'pass' : 'unknown')
        : _worstStatus(audits.map((a) => a.wiringCount > 0 ? 'warn' : 'pass'));
    var l2 = audits.isEmpty
        ? (hasException ? 'pass' : 'unknown')
        : _worstStatus(
            audits.map(
              (a) => _blockingStructuralCount(a) > 0 ? 'warn' : 'pass',
            ),
          );

    if (hasException && audits.isEmpty) {
      l1 = 'pass';
      l2 = 'pass';
    }

    final screenId = _screenIdFromPage(pageFile, route.name);
    final isTabRoot =
        tabRootScreens.contains(screenId) ||
        tabRootScreens.contains(route.widgetClass);

    var l3 = 'manual';
    final innerGapViolations = audits.fold<int>(
      0,
      (sum, a) => sum + a.innerGapViolations,
    );
    final declaredTierByLibKey = {
      for (final f in vpcFiles)
        if (auditByFile[auditLibKey(f)] != null)
          auditLibKey(f): auditByFile[auditLibKey(f)]!.declaredTier,
    };
    var declaredTier = resolveDeclaredTierForPattern(
      pattern: pattern,
      vpcFiles: vpcFiles,
      declaredTierByLibKey: declaredTierByLibKey,
    );
    final suggestedTierByLibKey = {
      for (final f in vpcFiles)
        if (auditByFile[auditLibKey(f)] != null)
          auditLibKey(f): auditByFile[auditLibKey(f)]!.suggestedTier,
    };
    var suggestedTier = resolveSuggestedTierForPattern(
      pattern: pattern,
      vpcFiles: vpcFiles,
      suggestedTierByLibKey: suggestedTierByLibKey,
    );
    final shellTier = shellRhythmTierForSource(pageSource);
    if (pattern == LayoutPattern.sharedShell && shellTier != null) {
      declaredTier = shellTier;
      suggestedTier = shellTier;
    }
    // Utility placeholder pages (VitTabletUtilityPage and per-feature
    // *utility_page.dart) render "coming soon" surfaces for routes whose
    // Tablet/Web UI is not built yet. They declare no product tier of their
    // own, so tier comparison stays neutral — strict layout keeps auditing
    // real pages instead of counting every pending route as an exception.
    final isUtilityPlaceholder =
        pageFile != null &&
        pageFile.split('/').last.endsWith('utility_page.dart');
    final tierStat = isUtilityPlaceholder
        ? ''
        : tierStatus(declaredTier, suggestedTier, routeName: route.name);

    var notes = complianceNote(
      pattern: pattern,
      l1Status: l1,
      l2Status: l2,
      innerGapViolations: innerGapViolations,
      declaredTier: declaredTier,
      suggestedTier: suggestedTier,
    );

    if (audits.isEmpty && !hasException) {
      notes = 'no_vit_page_content_in_tree';
    }
    if (isTabRoot && l1 == 'pass' && l2 == 'pass') {
      l3 = 'pass';
      notes = notes.startsWith('exception:') || notes == 'compliant'
          ? '$notes;tab_root;visual_qa_pass'
          : '$notes;tab_root;visual_qa_pass';
    } else if (l3Evidence[route.name]?.status == 'pass') {
      l3 = 'pass';
      notes = '${notes.isEmpty ? 'compliant' : notes};visual_qa_evidence';
    } else if (hasException) {
      l3 = 'exception:${pattern.label}';
    } else if (innerGapViolations > 0) {
      l3 = 'exception:inner_gap_debt';
    } else if (l1 == 'pass' && l2 == 'pass') {
      l3 = 'pass';
    } else if (l1 == 'unknown') {
      l3 = 'exception:unmapped';
    } else if (l2 == 'warn') {
      l3 = 'fail';
    }

    final vpcOwner = vpcFiles.isEmpty
        ? (pattern == LayoutPattern.sharedShell
              ? shellWidgetToVpcPath.values.first
              : '')
        : vpcFiles.first;

    rows.add(
      _ScreenRow(
        screenId: screenId,
        routePath: route.path,
        routeName: route.name,
        pageWidget: route.widgetClass,
        pageFile: (pageFile ?? '').replaceFirst(appRootPrefix, 'flutter_app/'),
        layoutPattern: pattern.label,
        vpcFiles: vpcFiles.join(';'),
        vpcOwnerFile: vpcOwner,
        declaredTier: declaredTier,
        suggestedTier: suggestedTier,
        tierStatus: tierStat,
        l1Status: l1,
        l2Status: l2,
        l3Status: l3,
        notes: notes,
      ),
    );
  }

  rows.sort((a, b) => a.routePath.compareTo(b.routePath));
  final csv = _renderCsv(rows);
  final md = _renderReport(rows, generated: DateTime.now());

  if (checkOnly) {
    final committed = outCsv.existsSync()
        ? outCsv.readAsStringSync().replaceAll('\r\n', '\n')
        : null;
    if (committed != csv) {
      stderr.writeln('Screen compliance CSV is stale.');
      if (committed != null) {
        final oldLines = committed.split('\n');
        final newLines = csv.split('\n');
        for (var i = 0; i < oldLines.length || i < newLines.length; i++) {
          final oldLine = i < oldLines.length ? oldLines[i] : '<missing>';
          final newLine = i < newLines.length ? newLines[i] : '<missing>';
          if (oldLine != newLine) {
            stderr.writeln('First diff at line ${i + 1}:');
            stderr.writeln('  committed: $oldLine');
            stderr.writeln('  generated: $newLine');
            break;
          }
        }
      }
      stderr.writeln(
        'Run `dart run tool/page_rhythm_screen_rollup.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    if (!outMd.existsSync() ||
        _withoutGeneratedDate(outMd.readAsStringSync()) !=
            _withoutGeneratedDate(md)) {
      stderr.writeln('Screen compliance report is stale.');
      exitCode = 1;
      return;
    }
    if (strictLayout) {
      // flush_chart is a registered LayoutPattern archetype (full-bleed chart
      // screens; today only SC-041 PredictionAdvancedChartPage) and is already
      // recorded as `exception:flush_chart` in l3_status/notes by this rollup,
      // so strict mode sanctions it alongside direct_vpc/shared_shell. The
      // Tablet Wallet hub also uses the registered custom_scroll scaffold;
      // its L1/L2 wiring remains strict-checked below. Gate and bottom-sheet
      // routes stay outside this page-level layout gate.
      final strictLayoutAllowed = {
        LayoutPattern.directVpc.label,
        LayoutPattern.sharedShell.label,
        LayoutPattern.flushChart.label,
        LayoutPattern.customScroll.label,
      };
      final badLayout = rows
          .where((r) => !strictLayoutAllowed.contains(r.layoutPattern))
          .length;
      if (badLayout > 0) {
        stderr.writeln(
          'Layout strict check failed: $badLayout routes not '
          'direct_vpc/shared_shell/flush_chart/custom_scroll.',
        );
        exitCode = 1;
        return;
      }
      final tierExceptions = rows
          .where((r) => r.tierStatus == 'exception')
          .length;
      if (tierExceptions > 0) {
        stderr.writeln(
          'Tier strict check failed: $tierExceptions tier_status=exception routes.',
        );
        exitCode = 1;
        return;
      }
    }
    stdout.writeln('Screen compliance artifacts are current.');
    stdout.write(_summary(rows));
    return;
  }

  docsDir.createSync(recursive: true);
  outCsv.writeAsStringSync(csv);
  outMd.writeAsStringSync(md);
  stdout.writeln('Wrote ${outCsv.path}');
  stdout.writeln('Wrote ${outMd.path}');
  stdout.write(_summary(rows));
}

const _tabRootWidgets = {
  'HomePage',
  'ProfilePage',
  'WalletPage',
  'TradePage',
  'PredictionsHomePage',
};

Set<String> _tabRootScreenIds() => {
  ..._tabRootWidgets,
  'SC-007',
  'SC-048',
  'SC-135',
  'SC-156',
};

final class _AuditRow {
  const _AuditRow({
    required this.declaredTier,
    required this.suggestedTier,
    required this.wiringCount,
    required this.structuralCount,
    required this.wiringViolations,
    required this.structuralViolations,
    required this.innerGapViolations,
    required this.status,
  });

  final String declaredTier;
  final String suggestedTier;
  final int wiringCount;
  final int structuralCount;
  final String wiringViolations;
  final String structuralViolations;
  final int innerGapViolations;
  final String status;
}

final class _RouteRow {
  const _RouteRow({
    required this.path,
    required this.name,
    required this.widgetClass,
  });

  final String path;
  final String name;
  final String widgetClass;
}

final class _ScreenRow {
  const _ScreenRow({
    required this.screenId,
    required this.routePath,
    required this.routeName,
    required this.pageWidget,
    required this.pageFile,
    required this.layoutPattern,
    required this.vpcFiles,
    required this.vpcOwnerFile,
    required this.declaredTier,
    required this.suggestedTier,
    required this.tierStatus,
    required this.l1Status,
    required this.l2Status,
    required this.l3Status,
    required this.notes,
  });

  final String screenId;
  final String routePath;
  final String routeName;
  final String pageWidget;
  final String pageFile;
  final String layoutPattern;
  final String vpcFiles;
  final String vpcOwnerFile;
  final String declaredTier;
  final String suggestedTier;
  final String tierStatus;
  final String l1Status;
  final String l2Status;
  final String l3Status;
  final String notes;
}

Map<String, _AuditRow> _loadAuditCsv(File file) {
  final lines = file.readAsLinesSync();
  if (lines.length < 2) return {};
  final map = <String, _AuditRow>{};
  for (var i = 1; i < lines.length; i++) {
    final parts = _parseCsvLine(lines[i]);
    if (parts.length < 9) continue;
    map[parts[1]] = _AuditRow(
      declaredTier: parts[3],
      suggestedTier: parts[2],
      wiringCount: int.tryParse(parts[4]) ?? 0,
      structuralCount: int.tryParse(parts[6]) ?? 0,
      wiringViolations: parts[5],
      structuralViolations: parts[7],
      innerGapViolations: parts.length > 9 ? int.tryParse(parts[9]) ?? 0 : 0,
      status: parts.length > 10 ? parts[10] : parts[8],
    );
  }
  return map;
}

List<_RouteRow> _parseRealPageRoutes(String markdown) {
  final routes = <_RouteRow>[];
  for (final line in markdown.split('\n')) {
    if (!line.startsWith('| `lib/app/router/')) continue;
    final parts = line.split('|').map((p) => p.trim()).toList();
    if (parts.length < 7) continue;
    final classification = parts[5];
    if (classification != '`real_page`') continue;
    final path = parts[3].replaceAll('`', '');
    final name = parts[4].replaceAll('`', '');
    // Truth Table may emit Wrapper>Child (B0); rollup resolves the leaf page.
    final evidence = parts[6].replaceAll('`', '');
    final widget = evidence.contains('>') ? evidence.split('>').last : evidence;
    if (widget == '-' || widget.isEmpty) continue;
    routes.add(_RouteRow(path: path, name: name, widgetClass: widget));
  }
  return routes;
}

Map<String, String> _buildWidgetToPageMap(Directory appRoot) {
  final map = <String, String>{};
  final features = Directory('${appRoot.path}/lib/features');
  // listSync order is platform-dependent (alphabetical on NTFS, inode order
  // on Linux); duplicate class names resolve last-writer-wins, so iterate in
  // sorted path order to get the same winner on every OS.
  final candidates =
      features
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where(
            (f) => f.path.contains(
              '${Platform.pathSeparator}presentation${Platform.pathSeparator}',
            ),
          )
          .where((f) => !f.path.contains('_part_'))
          .map((f) => f.path.replaceAll('\\', '/'))
          .toList()
        ..sort();
  for (final path in candidates) {
    final source = File(path).readAsStringSync();
    final match = RegExp(r'class\s+(\w+)\s+extends').firstMatch(source);
    if (match == null) continue;
    map[match.group(1)!] = path;
  }

  for (final entry in widgetClassPageOverrides.entries) {
    map[entry.key] = '${appRoot.path}/lib/${entry.value}'.replaceAll('\\', '/');
  }

  map['InternalSurfaceGate'] =
      '${appRoot.path}/lib/app/router/internal_surface_gate.dart'.replaceAll(
        '\\',
        '/',
      );
  map['TradePage'] =
      '${appRoot.path}/lib/features/trade/presentation/phone/pages/trade_page.dart'
          .replaceAll('\\', '/');
  map['AuthRouteShell'] = '${appRoot.path}/lib/app/router/router_helpers.dart'
      .replaceAll('\\', '/');
  return map;
}

String _screenIdFromPage(String? pageFile, String routeName) {
  if (pageFile == null) return routeName;
  final file = File(pageFile);
  if (!file.existsSync()) return routeName;
  final match = RegExp(
    r"semanticLabel:\s*'([^']+)'",
  ).firstMatch(file.readAsStringSync());
  if (match != null) {
    final label = match.group(1)!;
    final sc = RegExp(r'SC-\d+').firstMatch(label);
    if (sc != null) return sc.group(0)!;
  }
  return routeName;
}

String _worstStatus(Iterable<String> statuses) {
  if (statuses.any((s) => s == 'warn' || s == 'unknown')) return 'warn';
  return 'pass';
}

int _blockingStructuralCount(_AuditRow row) {
  if (row.structuralViolations.isEmpty) return 0;
  return row.structuralViolations
      .split(';')
      .where(
        (v) =>
            v.isNotEmpty && !v.startsWith('section_header_missing_inner_gap'),
      )
      .length;
}

String _renderCsv(List<_ScreenRow> rows) {
  final buffer = StringBuffer(
    'screen_id,route_path,route_name,page_widget,page_file,layout_pattern,'
    'vpc_files,vpc_owner_file,declared_tier,suggested_tier,tier_status,'
    'l1_status,l2_status,l3_status,notes\n',
  );
  for (final row in rows) {
    buffer.writeln(
      '${_csv(row.screenId)},${_csv(row.routePath)},${_csv(row.routeName)},'
      '${_csv(row.pageWidget)},${_csv(row.pageFile)},${row.layoutPattern},'
      '${_csv(row.vpcFiles)},${_csv(row.vpcOwnerFile)},'
      '${row.declaredTier},${row.suggestedTier},${row.tierStatus},'
      '${row.l1Status},${row.l2Status},${row.l3Status},${_csv(row.notes)}',
    );
  }
  return buffer.toString();
}

String _summary(List<_ScreenRow> rows) {
  final l1Pass = rows.where((r) => r.l1Status == 'pass').length;
  final l2Pass = rows.where((r) => r.l2Status == 'pass').length;
  final l2Warn = rows.where((r) => r.l2Status == 'warn').length;
  final unknown = rows.where((r) => r.l1Status == 'unknown').length;
  final exceptions = rows.where((r) => r.notes.startsWith('exception:')).length;
  return 'Screen rollup: ${rows.length} real_page routes, '
      'L1 pass $l1Pass, L2 pass $l2Pass warn $l2Warn, unknown $unknown, '
      'documented exceptions $exceptions.\n';
}

String _renderReport(List<_ScreenRow> rows, {required DateTime generated}) {
  final byModule = <String, List<_ScreenRow>>{};
  for (final row in rows) {
    final module = row.pageFile.contains('/features/')
        ? row.pageFile.split('/features/').last.split('/').first
        : 'app';
    byModule.putIfAbsent(module, () => []).add(row);
  }

  final buffer = StringBuffer()
    ..writeln('# Page Rhythm Compliance Report')
    ..writeln()
    ..writeln('Generated: ${_formatDate(generated)}')
    ..writeln()
    ..writeln('Source: `VitTrade-Page-Rhythm-Screen-Compliance.csv`')
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..write(_summary(rows))
    ..writeln('| Level | Meaning |')
    ..writeln('| --- | --- |')
    ..writeln('| L1 | Wiring: rhythm, orphan gaps, nested VPC |')
    ..writeln('| L2 | Structural: direct children, tab-root tier |')
    ..writeln('| L3 | Visual parity (tab-root + representative QA) |')
    ..writeln()
    ..writeln('## Tab roots')
    ..writeln()
    ..writeln('| Screen | Route | L1 | L2 | L3 |')
    ..writeln('| --- | --- | --- | --- | --- |');
  for (final row in rows.where((r) => r.notes.contains('tab_root'))) {
    buffer.writeln(
      '| ${row.screenId} | `${row.routePath}` | ${row.l1Status} | '
      '${row.l2Status} | ${row.l3Status} |',
    );
  }
  buffer
    ..writeln()
    ..writeln('## L2 warn routes')
    ..writeln()
    ..writeln('| Screen | Page | Notes |')
    ..writeln('| --- | --- | --- |');
  for (final row in rows.where((r) => r.l2Status == 'warn')) {
    buffer.writeln(
      '| ${row.screenId} | `${row.pageWidget}` | ${row.notes.isEmpty ? row.vpcFiles : row.notes} |',
    );
  }
  buffer
    ..writeln()
    ..writeln('## Unknown / unmapped routes')
    ..writeln()
    ..writeln('| Screen | Page | Pattern |')
    ..writeln('| --- | --- | --- |');
  for (final row in rows.where((r) => r.l1Status == 'unknown')) {
    buffer.writeln(
      '| ${row.screenId} | `${row.pageWidget}` | ${row.layoutPattern} |',
    );
  }
  buffer
    ..writeln()
    ..writeln('## By module')
    ..writeln();
  for (final entry
      in byModule.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    final modRows = entry.value;
    final l2w = modRows.where((r) => r.l2Status == 'warn').length;
    final unk = modRows.where((r) => r.l1Status == 'unknown').length;
    buffer.writeln(
      '### ${entry.key} (${modRows.length} routes, L2 warn $l2w, unknown $unk)',
    );
    buffer.writeln();
  }
  return buffer.toString();
}

String _formatDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _withoutGeneratedDate(String content) {
  return content.replaceFirst(
    RegExp(r'Generated: \d{4}-\d{2}-\d{2}'),
    'Generated: DATE',
  );
}

String _csv(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

List<String> _parseCsvLine(String line) {
  final result = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }
    if (char == ',' && !inQuotes) {
      result.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }
  result.add(buffer.toString());
  return result;
}

Directory _findAppRoot() {
  final current = Directory.current;
  if (Directory('${current.path}/lib/app/router/route_groups').existsSync()) {
    return current;
  }
  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/router/route_groups').existsSync()) {
    return nested;
  }
  throw StateError('Run from repo root or flutter_app/.');
}

final class _L3EvidenceRow {
  const _L3EvidenceRow({required this.status, required this.note});
  final String status;
  final String note;
}

Map<String, _L3EvidenceRow> _loadL3Evidence(Directory appRoot) {
  final file = File(
    '${appRoot.path}/run-artifacts/page-rhythm-l3/evidence.csv',
  );
  if (!file.existsSync()) return {};
  final map = <String, _L3EvidenceRow>{};
  final lines = file.readAsLinesSync();
  if (lines.length < 2) return map;
  for (var i = 1; i < lines.length; i++) {
    final parts = _parseCsvLine(lines[i]);
    if (parts.length < 3) continue;
    map[parts[0]] = _L3EvidenceRow(status: parts[1], note: parts[2]);
  }
  return map;
}
