// Audits every feature module against the structural patterns established by
// lib/features/home/presentation/** (the canonical UI reference per
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md, "SC-007
// HomePage"). Reuses the same divergence signals as
// design_token_consistency_audit.dart (raw Container/BoxDecoration instead of
// VitCard, BorderRadius.circular( instead of AppRadii.*, plus the other local
// token-debt categories) but aggregates strictly per module and hard-gates
// EVERY module (not just the 5 P0 ones) against its own frozen baseline.
//
// Usage (from flutter_app/):
//   dart run tool/home_reference_consistency_audit.dart          # regenerate
//   dart run tool/home_reference_consistency_audit.dart --check  # CI gate
import 'dart:io';

const String _generatedDate = '2026-07-07';

// Frozen at the point Phase 1+2 of the "home is the mandatory UI standard"
// migration completed. `--check` fails if a module's current divergence
// exceeds its own baseline here — this is a ratchet (regressions are
// blocked), not a demand for retroactive zero-debt everywhere at once.
const Map<String, int> _allModuleDivergenceBaselines = <String, int>{
  'admin': 0,
  'arena': 6,
  'auth': 0,
  'cross_module': 0,
  'dca': 1,
  'dev': 0,
  'discovery': 0,
  'earn_core': 0,
  'earn_savings': 0,
  'earn_staking': 0,
  'enterprise_states': 0,
  // Home is the canonical reference itself — locked at zero, not just a
  // frozen historical baseline. If this regresses above 0, home is no
  // longer clean and must not be trusted as the standard other modules are
  // measured against.
  'home': 0,
  'launchpad': 0,
  'markets': 0,
  'news': 1,
  'notifications': 1,
  'onboarding': 0,
  'p2p_account': 0,
  'p2p_core': 0,
  'p2p_dispute': 0,
  'p2p_marketplace': 0,
  'p2p_orders': 0,
  'p2p_security': 0,
  'predictions': 0,
  'profile': 0,
  'referral': 0,
  'rewards': 2,
  'support': 3,
  'trade': 0,
  'trade_bots': 0,
  'trade_compliance': 0,
  'trade_copy': 0,
  'trade_core': 0,
  'trade_terminal': 0,
  'wallet': 0,
};

const Set<String> _additionalRootPagePaths = <String>{
  'lib/features/admin/presentation/phone/pages/ab_test_dashboard_page.dart',
  'lib/features/admin/presentation/phone/pages/admin_home_page.dart',
  'lib/features/admin/presentation/phone/pages/analytics_dashboard_page.dart',
  'lib/features/admin/presentation/phone/pages/funnel_dashboard_page.dart',
  'lib/features/dev/presentation/phone/pages/performance_monitor.dart',
  'lib/features/cross_module/presentation/phone/pages/cross_module_analytics_page.dart',
  'lib/features/cross_module/presentation/phone/pages/smart_alert_center_page.dart',
  'lib/features/cross_module/presentation/phone/pages/tax_report_center_page.dart',
  'lib/features/cross_module/presentation/phone/pages/unified_portfolio_dashboard_page.dart',
  'lib/features/onboarding/presentation/phone/pages/onboarding_flow_page.dart',
  'lib/features/trade_copy/presentation/phone/pages/hub/copy_trading_card_demo.dart',
  'lib/features/dca/presentation/phone/pages/hub/dca_overview_demo.dart',
};

final class DivergenceFileMetric {
  const DivergenceFileMetric({
    required this.module,
    required this.scope,
    required this.path,
    required this.containerCount,
    required this.boxDecorationCount,
    required this.borderRadiusCircularCount,
    required this.radiusCircularCount,
    required this.edgeInsetsLiteralCount,
    required this.fixedWidthCount,
    required this.fixedHeightCount,
    required this.isException,
    required this.exceptionReason,
  });

  final String module;
  final String scope;
  final String path;
  final int containerCount;
  final int boxDecorationCount;
  final int borderRadiusCircularCount;
  final int radiusCircularCount;
  final int edgeInsetsLiteralCount;
  final int fixedWidthCount;
  final int fixedHeightCount;
  final bool isException;
  final String exceptionReason;

  int get totalDivergence =>
      containerCount +
      boxDecorationCount +
      borderRadiusCircularCount +
      radiusCircularCount +
      edgeInsetsLiteralCount +
      fixedWidthCount +
      fixedHeightCount;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('$repoRoot/docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Home-Reference-Consistency-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Home-Reference-Consistency-Audit.csv',
  );

  final metrics = _collectMetrics(appRoot, repoRoot);
  final markdown = _renderMarkdown(metrics);
  final csv = _renderCsv(metrics);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add(
        'Missing home reference consistency markdown artifact: ${markdownFile.path}',
      );
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Home reference consistency markdown artifact is stale.');
    }
    if (!csvFile.existsSync()) {
      failures.add(
        'Missing home reference consistency CSV artifact: ${csvFile.path}',
      );
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Home reference consistency CSV artifact is stale.');
    }
    failures.addAll(_collectAllModuleGateFailures(metrics));

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/home_reference_consistency_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.writeln('Home reference consistency artifacts are current.');
    stdout.writeln(_renderGateSummary(metrics));
    return;
  }

  docsDir.createSync(recursive: true);
  markdownFile.writeAsStringSync(markdown);
  csvFile.writeAsStringSync(csv);
  stdout.writeln('Wrote ${markdownFile.path}');
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.writeln(_renderGateSummary(metrics));
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

// Normalizes a `File.path` into a stable identity key. `_collectBundleFiles`
// builds some paths via `Uri.resolve(...).toFilePath()` (backslash-only on
// Windows) while `Directory.listSync()` elsewhere in this file returns
// mixed-separator paths (forward slashes from the constructed root + a
// native-separator-joined leaf segment) — comparing those raw strings, even
// after `.toLowerCase()`, silently fails to dedupe the same on-disk file.
String _pathKey(String rawPath) => rawPath.toLowerCase().replaceAll('\\', '/');

List<DivergenceFileMetric> _collectMetrics(Directory appRoot, String repoRoot) {
  final rootPages = _collectRootPages(appRoot);
  final featureWidgets = _collectFeatureWidgets(appRoot);

  final reports = <DivergenceFileMetric>[];
  final seenBundleFiles = <String>{};

  for (final pageFile in rootPages) {
    for (final file in _collectBundleFiles(pageFile)) {
      final key = _pathKey(file.path);
      if (!seenBundleFiles.add(key)) continue;
      final metric = _analyzeFile(file, repoRoot, 'root_page');
      if (metric != null) reports.add(metric);
    }
  }
  for (final file in featureWidgets) {
    final key = _pathKey(file.path);
    // A `presentation/widgets/` file that is also `part of` a root page's
    // bundle (the pattern established by trade_compliance's
    // `arm_integration_providers.dart` and since reused by onboarding/
    // rewards) was already counted above via `_collectBundleFiles` — without
    // this guard it doubles that file's Container/BoxDecoration signal
    // counts, since both loops fed the same `reports` list.
    if (seenBundleFiles.contains(key)) continue;
    final metric = _analyzeFile(file, repoRoot, 'feature_widget');
    if (metric != null) reports.add(metric);
  }

  reports.sort((a, b) {
    final moduleCompare = a.module.compareTo(b.module);
    if (moduleCompare != 0) return moduleCompare;
    return a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/'));
  });
  return reports;
}

List<File> _collectRootPages(Directory appRoot) {
  final pages = <File>[];
  final featuresDir = Directory('${appRoot.path}/lib/features');
  if (!featuresDir.existsSync()) return pages;

  final candidates =
      featuresDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => _isAuditedRootPage(file, appRoot))
          .toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );

  final visited = <String>{};
  for (final file in candidates) {
    final key = _pathKey(file.path);
    if (!visited.add(key)) continue;
    pages.add(file);
  }
  return pages;
}

bool _isAuditedRootPage(File file, Directory appRoot) {
  final normalizedPath = file.path.replaceAll('\\', '/');
  if (!normalizedPath.contains('/presentation/pages/')) return false;
  if (normalizedPath.endsWith('_page.dart')) return true;

  final relativePath = _relativePath(
    file.path,
    appRoot.path,
  ).replaceFirst(RegExp(r'^/+'), '');
  return _additionalRootPagePaths.contains(relativePath);
}

List<File> _collectFeatureWidgets(Directory appRoot) {
  final widgetsDir = Directory('${appRoot.path}/lib/features');
  if (!widgetsDir.existsSync()) return const [];
  return widgetsDir
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (file) =>
            file.path.endsWith('.dart') &&
            file.path
                .replaceAll('\\', '/')
                .contains('/presentation/widgets/') &&
            !file.path.contains('.g.dart'),
      )
      .toList()
    ..sort(
      (a, b) =>
          a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/')),
    );
}

List<File> _collectBundleFiles(File rootPageFile) {
  final queue = <File>[rootPageFile];
  final visited = <String>{};
  final files = <File>[];

  while (queue.isNotEmpty) {
    final file = queue.removeAt(0);
    final key = _pathKey(file.path);
    if (!visited.add(key)) continue;
    if (!file.existsSync()) continue;
    files.add(file);

    final source = file.readAsStringSync();
    for (final match in _partPattern.allMatches(source)) {
      final uri = match.group(1)!;
      queue.add(File(file.uri.resolve(uri).toFilePath()));
    }
  }

  files.sort(
    (a, b) =>
        a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/')),
  );
  return files;
}

DivergenceFileMetric? _analyzeFile(File file, String repoRoot, String scope) {
  if (!file.existsSync()) return null;
  final source = file.readAsStringSync();
  final path = _relativePath(file.path, repoRoot);
  final module = _featureNameForPath(path);
  if (module == null) return null;

  final normalized = path.toLowerCase();
  final lowerSource = source.toLowerCase();
  final exception = _detectException(normalized, lowerSource);

  return DivergenceFileMetric(
    module: module,
    scope: scope,
    path: path,
    containerCount: _countPattern(source, _containerPattern),
    boxDecorationCount: _countPattern(source, _boxDecorationPattern),
    borderRadiusCircularCount: _countPattern(source, _borderRadiusPattern),
    radiusCircularCount: _countPattern(source, _radiusPattern),
    edgeInsetsLiteralCount: _countPattern(source, _edgeInsetsPattern),
    fixedWidthCount: _countDimensionBeyondThreshold(source, 'width', 320),
    fixedHeightCount: _countDimensionBeyondThreshold(source, 'height', 56),
    isException: exception != null,
    exceptionReason: exception ?? '-',
  );
}

String? _detectException(String path, String lowerSource) {
  for (final entry in _exceptionPathPatterns) {
    if (path.contains(entry)) return 'allowed_path_exception: $entry';
  }
  for (final keyword in _exceptionKeywords) {
    if (lowerSource.contains(keyword)) {
      return 'allowed_source_keyword: $keyword';
    }
  }
  return null;
}

Map<String, int> _collectModuleDivergence(List<DivergenceFileMetric> metrics) {
  final moduleTotals = <String, int>{};
  for (final metric in metrics) {
    if (metric.isException) continue;
    moduleTotals.update(
      metric.module,
      (value) => value + metric.totalDivergence,
      ifAbsent: () => metric.totalDivergence,
    );
  }
  return moduleTotals;
}

List<String> _collectAllModuleGateFailures(List<DivergenceFileMetric> metrics) {
  final moduleTotals = _collectModuleDivergence(metrics);
  final failures = <String>[];
  for (final entry in _allModuleDivergenceBaselines.entries) {
    final current = moduleTotals[entry.key] ?? 0;
    if (current > entry.value) {
      failures.add(
        'Module divergence from home reference increased for ${entry.key}: '
        '$current > baseline ${entry.value}.',
      );
    }
  }
  // Modules present in the scan but missing a baseline entry would silently
  // never be gated — treat that as a hard failure so new features must be
  // added to _allModuleDivergenceBaselines explicitly.
  for (final module in moduleTotals.keys) {
    if (!_allModuleDivergenceBaselines.containsKey(module)) {
      failures.add(
        'Module "$module" has no entry in _allModuleDivergenceBaselines.',
      );
    }
  }
  return failures;
}

String _renderGateSummary(List<DivergenceFileMetric> metrics) {
  final moduleTotals = _collectModuleDivergence(metrics);
  final buffer = StringBuffer()
    ..writeln('generated=$_generatedDate')
    ..writeln('total_files=${metrics.length}')
    ..writeln('home_reference_gate=baseline_enforced_all_modules');
  final modules = _allModuleDivergenceBaselines.keys.toList()..sort();
  for (final module in modules) {
    final current = moduleTotals[module] ?? 0;
    final baseline = _allModuleDivergenceBaselines[module]!;
    final status = current <= baseline ? 'pass' : 'fail';
    buffer.writeln('module_${module}_divergence=$current/$baseline $status');
  }
  return buffer.toString();
}

String? _featureNameForPath(String path) {
  const prefix = 'flutter_app/lib/features/';
  if (!path.startsWith(prefix)) return null;
  final rest = path.substring(prefix.length);
  final slashIndex = rest.indexOf('/');
  if (slashIndex <= 0) return null;
  return rest.substring(0, slashIndex);
}

String _renderMarkdown(List<DivergenceFileMetric> metrics) {
  final moduleTotals = _collectModuleDivergence(metrics);
  final modules = _allModuleDivergenceBaselines.keys.toList()..sort();
  final topDivergence =
      metrics.where((m) => !m.isException && m.totalDivergence > 0).toList()
        ..sort((a, b) => b.totalDivergence.compareTo(a.totalDivergence));

  final buffer = StringBuffer()
    ..writeln('# VitTrade Home Reference Consistency Audit')
    ..writeln()
    ..writeln('Generated: $_generatedDate')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/home_reference_consistency_audit.dart`. '
      'Measures structural divergence from the patterns established by '
      '`lib/features/home/presentation/**` — the canonical UI reference '
      '("SC-007 HomePage", see Flutter-Module-Identity-Standard.md): raw '
      '`Container`/`BoxDecoration` instead of `VitCard`, '
      '`BorderRadius.circular(`/`Radius.circular(` instead of `AppRadii.*`, '
      'raw `EdgeInsets.*(` literals, and oversized fixed width/height '
      'literals. Every module — not just a P0 subset — is hard-gated against '
      'its own frozen baseline below; regressions fail CI.',
    )
    ..writeln()
    ..writeln('## Module Gate (all modules, frozen baseline)')
    ..writeln()
    ..writeln('| module | current divergence | baseline | status |')
    ..writeln('| --- | ---: | ---: | --- |');
  for (final module in modules) {
    final current = moduleTotals[module] ?? 0;
    final baseline = _allModuleDivergenceBaselines[module]!;
    final status = current <= baseline ? 'pass' : 'fail';
    buffer.writeln('| $module | $current | $baseline | $status |');
  }

  buffer
    ..writeln()
    ..writeln('## Top Divergence Files (non-exception)')
    ..writeln(
      '| module | path | total | container | boxDecoration | borderRadius.circular | radius.circular | edgeInsets | fixedWidth | fixedHeight |',
    )
    ..writeln(
      '| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
    );
  for (final metric in topDivergence.take(120)) {
    buffer.writeln(
      '| ${metric.module} | `${metric.path}` | ${metric.totalDivergence} | '
      '${metric.containerCount} | ${metric.boxDecorationCount} | '
      '${metric.borderRadiusCircularCount} | ${metric.radiusCircularCount} | '
      '${metric.edgeInsetsLiteralCount} | ${metric.fixedWidthCount} | '
      '${metric.fixedHeightCount} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Verification Commands')
    ..writeln('```bash')
    ..writeln('cd flutter_app')
    ..writeln('dart run tool/home_reference_consistency_audit.dart')
    ..writeln('dart run tool/home_reference_consistency_audit.dart --check')
    ..writeln('```');
  return buffer.toString();
}

String _renderCsv(List<DivergenceFileMetric> metrics) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'module',
        'scope',
        'path',
        'container',
        'boxDecoration',
        'borderRadiusCircular',
        'radiusCircular',
        'edgeInsets',
        'fixedWidth',
        'fixedHeight',
        'totalDivergence',
        'exception',
        'exceptionReason',
      ].map(_csvEscape).join(','),
    );
  for (final metric in metrics) {
    buffer.writeln(
      [
        metric.module,
        metric.scope,
        metric.path,
        '${metric.containerCount}',
        '${metric.boxDecorationCount}',
        '${metric.borderRadiusCircularCount}',
        '${metric.radiusCircularCount}',
        '${metric.edgeInsetsLiteralCount}',
        '${metric.fixedWidthCount}',
        '${metric.fixedHeightCount}',
        '${metric.totalDivergence}',
        metric.isException ? 'yes' : 'no',
        metric.exceptionReason,
      ].map(_csvEscape).join(','),
    );
  }
  return buffer.toString();
}

int _countPattern(String source, RegExp pattern) =>
    pattern.allMatches(source).length;

int _countDimensionBeyondThreshold(
  String source,
  String dimension,
  double threshold,
) {
  final pattern = dimension == 'width' ? _widthPattern : _heightPattern;
  var count = 0;
  for (final match in pattern.allMatches(source)) {
    final value = double.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0;
    if (value >= threshold) count += 1;
  }
  return count;
}

String _relativePath(String filePath, String repoRoot) {
  final root = repoRoot.replaceAll('\\', '/');
  final path = filePath.replaceAll('\\', '/');
  if (path.startsWith(root)) return path.substring(root.length);
  final flutterApp = '/flutter_app/';
  final idx = path.indexOf(flutterApp);
  if (idx >= 0) return path.substring(idx + 1);
  return path;
}

String _csvEscape(String value) {
  final escaped = value.replaceAll('"', '""');
  if (escaped.contains(',') || escaped.contains('"')) {
    return '"$escaped"';
  }
  return escaped;
}

final RegExp _partPattern = RegExp(r'''part\s+['"]([^'"]+)['"]''');
final RegExp _edgeInsetsPattern = RegExp(
  r'EdgeInsets\.(all|symmetric|only|fromLTRB)\(',
);
final RegExp _borderRadiusPattern = RegExp(r'BorderRadius\.circular\(');
final RegExp _radiusPattern = RegExp(r'Radius\.circular\(');
final RegExp _containerPattern = RegExp(r'Container\(');
final RegExp _boxDecorationPattern = RegExp(r'BoxDecoration\(');
final RegExp _widthPattern = RegExp(r'width:\s*([0-9]+(?:\.[0-9]+)?)');
final RegExp _heightPattern = RegExp(r'height:\s*([0-9]+(?:\.[0-9]+)?)');

final List<String> _exceptionPathPatterns = <String>[
  '/dev/',
  '/internal/',
  '/visual',
  '/chart',
  '/charts',
  '/canvas',
];
final List<String> _exceptionKeywords = <String>[
  'custompainter',
  'extends custompainter',
  'trade chart',
  'orderbook',
  'candlestick',
  'order_book',
];
