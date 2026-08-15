import 'dart:io';

final class HeaderRouteEntry {
  const HeaderRouteEntry({
    required this.routeGroup,
    required this.path,
    required this.pageClass,
    required this.feature,
    required this.pageFile,
    required this.classification,
    required this.variant,
  });

  final String routeGroup;
  final String path;
  final String pageClass;
  final String feature;
  final String pageFile;
  final String classification;
  final String variant;
}

final class PageGroup {
  const PageGroup({
    required this.file,
    required this.feature,
    required this.source,
    required this.classification,
    required this.variant,
  });

  final String file;
  final String feature;
  final String source;
  final String classification;
  final String variant;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final outputFile = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/audits/VitTrade-Top-Header-Behavior-Audit.md',
  );

  final entries = _collectHeaderRouteEntries(appRoot, repoRoot);
  final content = _renderMarkdown(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    if (!outputFile.existsSync()) {
      stderr.writeln('Top header behavior artifact is missing.');
      stderr.writeln(
        'Run `dart run tool/top_header_behavior_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    final current = outputFile.readAsStringSync();
    if (current != content) {
      stderr.writeln(
        'Top header behavior artifact is stale. Run '
        '`dart run tool/top_header_behavior_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Top header behavior artifact is current.');
    return;
  }

  outputFile.writeAsStringSync(content);
  stdout.writeln('Wrote ${outputFile.path}');
  stdout.write(summary);
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

List<HeaderRouteEntry> _collectHeaderRouteEntries(
  Directory appRoot,
  String repoRoot,
) {
  final pageIndex = _PageIndex(appRoot, repoRoot);
  final routeGroups = Directory('${appRoot.path}/lib/app/router/route_groups');
  final entries = <HeaderRouteEntry>[];

  final files =
      routeGroups
          .listSync()
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') &&
                !file.path.endsWith('surface_route_helpers.dart'),
          )
          .toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );

  for (final file in files) {
    final text = file.readAsStringSync();
    final routeGroup = _relativePath(file, repoRoot);
    final usesTabletUtilityFamily =
        routeGroup.endsWith('earn_savings_routes.dart') ||
        routeGroup.endsWith('earn_staking_routes.dart') ||
        routeGroup.endsWith('trade_bots_routes.dart') ||
        routeGroup.endsWith('trade_copy_routes.dart') ||
        routeGroup.endsWith('trade_compliance_routes.dart') ||
        routeGroup.endsWith('markets_routes.dart');
    var index = 0;

    while (true) {
      final start = text.indexOf('GoRoute(', index);
      if (start == -1) break;

      final blockEnd = _findBalancedEnd(text, start + 'GoRoute'.length);
      if (blockEnd == -1) break;

      final block = text.substring(start, blockEnd + 1);
      index = blockEnd + 1;

      if (block.contains('redirect:') && !block.contains('builder:')) {
        continue;
      }

      final path = _extractNamedArgument(block, 'path') ?? '-';
      final pageClass =
          usesTabletUtilityFamily && path != 'AppRoutePaths.markets'
          ? 'VitTabletUtilityPage'
          : _extractPageClass(block);
      final page = pageClass == 'VitTabletUtilityPage'
          ? _tabletUtilityPageGroup(appRoot, routeGroup)
          : pageIndex.find(pageClass);

      entries.add(
        HeaderRouteEntry(
          routeGroup: routeGroup,
          path: path,
          pageClass: pageClass,
          feature: page?.feature ?? _featureFromRouteGroup(routeGroup),
          pageFile: page?.file ?? 'unresolved',
          classification: page?.classification ?? 'unresolved',
          variant: page?.variant ?? 'unresolved',
        ),
      );
    }
  }

  entries.sort((a, b) {
    final featureCompare = a.feature.compareTo(b.feature);
    if (featureCompare != 0) return featureCompare;
    return a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/'));
  });

  return entries;
}

PageGroup? _tabletUtilityPageGroup(Directory appRoot, String routeGroup) {
  final file = File(
    '${appRoot.path}/lib/shared/layout/vit_tablet_utility_page.dart',
  );
  if (!file.existsSync()) return null;
  final source = file.readAsStringSync();
  return PageGroup(
    file: 'flutter_app/lib/shared/layout/vit_tablet_utility_page.dart',
    feature: _featureFromRouteGroup(routeGroup),
    source: source,
    classification: _classifyHeaderBehavior(source, source),
    variant: _classifyHeaderVariant(source),
  );
}

String _extractPageClass(String block) {
  if (block.contains('AuthRouteShell')) {
    if (block.contains('LoginPage')) return 'LoginPage';
    if (block.contains('RegisterPage')) return 'RegisterPage';
    if (block.contains('buildOtpPage')) return 'OTPPage';
    if (block.contains('TwoFASetupPage')) return 'TwoFASetupPage';
    if (block.contains('ForgotPasswordPage')) return 'ForgotPasswordPage';
    if (block.contains('ResetPasswordPage')) return 'ResetPasswordPage';
  }

  for (final pattern in [
    RegExp(r'child:\s*(?:const\s+)?([A-Z]\w*)\s*\('),
    RegExp(r'=>\s*(?:const\s+)?([A-Z]\w*)\s*\('),
    RegExp(r'return\s+(?:const\s+)?([A-Z]\w*)\s*\('),
  ]) {
    final match = pattern.firstMatch(block);
    if (match == null) continue;
    final pageClass = match.group(1)!;
    if (pageClass == 'InternalSurfaceGate' || pageClass == 'AuthRouteShell') {
      continue;
    }
    return pageClass;
  }

  return 'unresolved';
}

String? _extractNamedArgument(String block, String name) {
  final match = RegExp('$name:\\s*([^,\\n]+)').firstMatch(block);
  return match?.group(1)?.trim();
}

String _featureFromRouteGroup(String routeGroup) {
  final fileName = routeGroup.split('/').last;
  return fileName.replaceAll('_routes.dart', '');
}

final class _PageIndex {
  _PageIndex(Directory appRoot, String repoRoot) {
    _build(appRoot, repoRoot);
  }

  final _classes = <String, PageGroup>{};

  PageGroup? find(String pageClass) => _classes[pageClass];

  void _build(Directory appRoot, String repoRoot) {
    final featuresDir = Directory('${appRoot.path}/lib/features');
    final sourceByGroup = <String, List<File>>{};

    final files =
        featuresDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort(
            (a, b) => a.path
                .replaceAll(r'\', '/')
                .compareTo(b.path.replaceAll(r'\', '/')),
          );

    for (final file in files) {
      final source = file.readAsStringSync();
      final partOf = RegExp(r"part of '([^']+)';").firstMatch(source);
      final groupFile = partOf == null
          ? file
          : File(file.uri.resolve(partOf.group(1)!).toFilePath());
      final relativeGroup = _relativePath(groupFile, repoRoot);
      sourceByGroup.putIfAbsent(relativeGroup, () => []).add(file);
    }

    for (final entry in sourceByGroup.entries) {
      final baseSource = entry.value
          .map((file) {
            return file.readAsStringSync();
          })
          .join('\n');
      final source = [
        baseSource,
        ..._extraSourceForPageGroup(appRoot, entry.key, baseSource),
      ].join('\n');
      final pageGroup = PageGroup(
        file: entry.key,
        feature: _featureFromFeaturePath(entry.key),
        source: source,
        classification: _classifyHeaderBehavior(source, baseSource),
        variant: _classifyHeaderVariant(source),
      );

      for (final match in RegExp(
        r'\bclass\s+([A-Z]\w*)\b',
      ).allMatches(source)) {
        _classes[match.group(1)!] = pageGroup;
      }
    }
  }
}

/// A shell/wrapper widget reference used as extra classification source.
/// When [className] is null, the whole file at [path] is safe to include
/// (it defines exactly one relevant shell class). When [className] is
/// set, the file defines *multiple* shell classes (e.g.
/// `trade_module_layout.dart`), so only that one class's body is
/// extracted via brace matching — including the whole file would leak an
/// unrelated sibling class's behavior into the classification.
typedef _ShellSourceRef = ({String path, String? className});

/// Resolves indirection through shared wrapper/shell widgets that this
/// tool's `part of`-only grouping can't see on its own: [baseSource] is
/// the routed page's own literal source, and this returns extra source
/// text for whichever shared shells it calls, so their header behavior
/// (e.g. `VitAutoHideHeaderScaffold(` inside `VitAutoHidePageScaffold`)
/// is visible to [_classifyHeaderBehavior]/[_classifyHeaderVariant].
/// Mirrors `tool/top_header_visual_archetype_audit.dart`'s
/// `_extraSourceForPageGroup`, which resolves the same indirection for a
/// different classification axis (visual archetype vs. scroll behavior).
List<String> _extraSourceForPageGroup(
  Directory appRoot,
  String relativeGroup,
  String baseSource,
) {
  final extraPaths = <String>[];

  if (relativeGroup ==
      'flutter_app/lib/features/markets/presentation/phone/pages/market_list_page.dart') {
    extraPaths.add(
      'lib/features/markets/presentation/widgets/market_list_header.dart',
    );
  }

  const tradeModuleLayout =
      'lib/features/trade_core/presentation/widgets/trade_module_layout.dart';

  final shellSources = <String, List<_ShellSourceRef>>{
    'VitTradeHubScaffold(': [
      (path: tradeModuleLayout, className: 'VitTradeHubScaffold'),
    ],
    'VitTradeDetailScaffold(': [
      (path: tradeModuleLayout, className: 'VitTradeDetailScaffold'),
    ],
    'VitTradeSimpleShell(': [
      (
        path:
            'lib/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart',
        className: null,
      ),
      // VitTradeSimpleShell always wraps VitTradeHubScaffold (never
      // VitTradeDetailScaffold) — see vit_trade_simple_shell.dart's build().
      (path: tradeModuleLayout, className: 'VitTradeHubScaffold'),
    ],
    'VitTradeWorkspaceScaffold(': [
      (path: tradeModuleLayout, className: 'VitTradeWorkspaceScaffold'),
    ],
    'VitWalletDetailScaffold(': [
      (
        path:
            'lib/features/wallet/presentation/widgets/vit_wallet_detail_scaffold.dart',
        className: null,
      ),
    ],
    'CrossModuleTabbedPageShell(': [
      (
        path:
            'lib/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart',
        className: null,
      ),
    ],
    'VitAutoHidePageScaffold(': [
      (
        path: 'lib/shared/layout/vit_auto_hide_page_scaffold.dart',
        className: null,
      ),
    ],
    'VitP2PFlowScaffold(': [
      (
        path:
            'lib/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart',
        className: null,
      ),
    ],
  };

  final extraSources = <String>[];
  for (final binding in shellSources.entries) {
    if (!baseSource.contains(binding.key)) continue;
    for (final ref in binding.value) {
      final file = File('${appRoot.path}/${ref.path}');
      if (!file.existsSync()) continue;
      final content = file.readAsStringSync();
      if (ref.className == null) {
        extraSources.add(content);
        continue;
      }
      final body = _extractClassBody(content, ref.className!);
      if (body != null) extraSources.add(body);
    }
  }

  return [
    for (final path in extraPaths)
      if (File('${appRoot.path}/$path').existsSync())
        File('${appRoot.path}/$path').readAsStringSync(),
    ...extraSources,
  ];
}

/// Extracts the brace-matched body of `class [className] ... { ... }` from
/// [source], from the `class` keyword through its balanced closing brace.
/// Returns null if the class isn't found. Plain-text depth counting, not
/// an AST parse — matches this file's existing substring-based
/// classification approach.
String? _extractClassBody(String source, String className) {
  final match = RegExp('class\\s+$className\\b[^{]*\\{').firstMatch(source);
  if (match == null) return null;

  var depth = 1;
  var i = match.end;
  while (i < source.length && depth > 0) {
    final char = source[i];
    if (char == '{') depth++;
    if (char == '}') depth--;
    i++;
  }
  return source.substring(match.start, i);
}

String _featureFromFeaturePath(String path) {
  final parts = path.split('/');
  final featuresIndex = parts.indexOf('features');
  if (featuresIndex == -1 || featuresIndex + 1 >= parts.length) return '-';
  return parts[featuresIndex + 1];
}

/// Classifies how [source] renders its top header. [baseSource] is the
/// page's own literal source with no extras appended — the "is the header
/// inline inside a scroll view" ordering check below is only meaningful
/// when [source] and [baseSource] describe the *same* widget's layout.
/// When `VitHeader(` is found only inside appended extra source (a shared
/// shell the page merely calls, not a header the page builds inline),
/// text position relative to a scroll-container mention elsewhere in the
/// page's own, unrelated body is meaningless — string concatenation order
/// isn't widget-tree order — so that case always resolves to
/// `fixed_vit_header`.
String _classifyHeaderBehavior(String source, [String? baseSource]) {
  if (source.contains('VitAutoHideHeaderScaffold(')) {
    return 'auto_hide_header';
  }
  if (source.contains('RewardsArenaPointsBridge(')) {
    return 'auto_hide_header';
  }
  if (source.contains('_CollapsibleHomeHeader') ||
      (source.contains('_headerVisible') &&
          (source.contains('UserScrollNotification') ||
              source.contains('ScrollUpdateNotification')))) {
    return 'auto_hide_header';
  }

  final headerIndex = source.indexOf('VitHeader(');
  if (headerIndex >= 0) {
    final headerInBaseSource =
        baseSource == null || headerIndex < baseSource.length;
    final scrollIndex = headerInBaseSource
        ? _firstIndexOfAny(source, const [
            'SingleChildScrollView',
            'ListView',
            'CustomScrollView',
            'NestedScrollView',
          ])
        : -1;
    if (scrollIndex >= 0 && scrollIndex < headerIndex) {
      return 'custom_scroll_header';
    }
    return 'fixed_vit_header';
  }

  if (source.contains('_TradeHeader') || source.contains('MarketListHeader')) {
    return 'custom_scroll_header';
  }

  return 'no_top_header';
}

String _classifyHeaderVariant(String source) {
  if (source.contains('VitAutoHideHeaderScaffold(')) {
    return 'shared_auto_hide_scaffold';
  }
  if (source.contains('RewardsArenaPointsBridge(')) {
    return 'shared_auto_hide_scaffold';
  }
  if (source.contains('_CollapsibleHomeHeader')) {
    return 'home_collapsible_custom';
  }
  if (source.contains('_TradeHeader')) return 'trade_custom_in_scroll';
  if (source.contains('MarketListHeader')) return 'market_custom_in_scroll';
  if (!source.contains('VitHeader(')) return 'no_top_header';
  if (source.contains('variant: VitHeaderVariant.custom')) {
    return 'vit_header_custom';
  }
  if (source.contains('trailing:') || source.contains('action:')) {
    return 'vit_header_default_with_actions';
  }
  if (source.contains('subtitle:')) {
    return 'vit_header_default_title_subtitle';
  }
  return 'vit_header_default_title_only';
}

int _firstIndexOfAny(String source, List<String> needles) {
  final indexes = <int>[];
  for (final needle in needles) {
    final index = source.indexOf(needle);
    if (index >= 0) indexes.add(index);
  }
  if (indexes.isEmpty) return -1;
  indexes.sort();
  return indexes.first;
}

String _renderMarkdown(List<HeaderRouteEntry> entries) {
  final counts = _classificationCounts(entries);

  final featureFixedCounts = <String, int>{};
  for (final entry in entries) {
    if (entry.classification != 'fixed_vit_header') continue;
    featureFixedCounts.update(
      entry.feature,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  final buffer = StringBuffer()
    ..writeln('# VitTrade Top Header Behavior Audit')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/top_header_behavior_audit.dart`.',
    )
    ..writeln()
    ..writeln('```text')
    ..writeln('total_routed_screens=${entries.length}')
    ..writeln('fixed_vit_header_remaining=${counts['fixed_vit_header'] ?? 0}')
    ..writeln('auto_hide_header=${counts['auto_hide_header'] ?? 0}')
    ..writeln('custom_scroll_header=${counts['custom_scroll_header'] ?? 0}')
    ..writeln('no_top_header=${counts['no_top_header'] ?? 0}')
    ..writeln('unresolved=${counts['unresolved'] ?? 0}')
    ..writeln('```')
    ..writeln()
    ..writeln('## Fixed Header Count By Feature')
    ..writeln()
    ..writeln('| Feature | Fixed-header routes |')
    ..writeln('| --- | ---: |');

  final sortedFeatures = featureFixedCounts.entries.toList()
    ..sort((a, b) {
      final countCompare = b.value.compareTo(a.value);
      if (countCompare != 0) return countCompare;
      return a.key.compareTo(b.key);
    });
  for (final entry in sortedFeatures) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Route Header Inventory')
    ..writeln()
    ..writeln(
      '| Feature | Route | Page | Header behavior | Variant | Page file |',
    )
    ..writeln('| --- | --- | --- | --- | --- | --- |');

  for (final entry in entries) {
    buffer.writeln(
      '| ${entry.feature} | `${_escape(entry.path)}` | '
      '`${entry.pageClass}` | ${entry.classification} | ${entry.variant} | '
      '`${entry.pageFile}` |',
    );
  }

  return buffer.toString();
}

String _renderSummary(List<HeaderRouteEntry> entries) {
  final counts = _classificationCounts(entries);

  final buffer = StringBuffer()
    ..writeln('total_routed_screens=${entries.length}')
    ..writeln('fixed_vit_header_remaining=${counts['fixed_vit_header'] ?? 0}')
    ..writeln('auto_hide_header=${counts['auto_hide_header'] ?? 0}')
    ..writeln('custom_scroll_header=${counts['custom_scroll_header'] ?? 0}')
    ..writeln('no_top_header=${counts['no_top_header'] ?? 0}');
  return buffer.toString();
}

Map<String, int> _classificationCounts(List<HeaderRouteEntry> entries) {
  final counts = <String, int>{};
  for (final entry in entries) {
    counts.update(
      entry.classification,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  return counts;
}

String _escape(String value) {
  return value.replaceAll('|', r'\|');
}

String _relativePath(File file, String repoRoot) {
  return file.path
      .replaceAll('\\', '/')
      .replaceFirst(repoRoot.replaceAll('\\', '/'), '');
}

int _findBalancedEnd(String text, int openParenIndex) {
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = openParenIndex; i < text.length; i++) {
    final char = text[i];

    if (escaping) {
      escaping = false;
      continue;
    }
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (char == '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) continue;

    if (char == '(') {
      depth += 1;
    } else if (char == ')') {
      depth -= 1;
      if (depth == 0) return i;
    }
  }

  return -1;
}
