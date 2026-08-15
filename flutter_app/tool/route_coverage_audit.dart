import 'dart:io';

final class RouteEntry {
  const RouteEntry({
    required this.file,
    required this.line,
    required this.path,
    required this.name,
    required this.classification,
    required this.evidence,
  });

  final String file;
  final int line;
  final String path;
  final String name;
  final String classification;
  final String evidence;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final outputFile = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md',
  );

  final entries = _collectRouteEntries(appRoot);
  final content = _renderMarkdown(
    entries,
    generatedDate: _formatGeneratedDate(DateTime.now()),
  );

  if (checkOnly) {
    if (!outputFile.existsSync()) {
      stderr.writeln('Route coverage artifact is missing: ${outputFile.path}');
      exitCode = 1;
      return;
    }
    final current = outputFile.readAsStringSync();
    if (_withoutGeneratedDate(current) != _withoutGeneratedDate(content)) {
      stderr.writeln(
        'Route coverage artifact is stale. Run '
        '`dart run tool/route_coverage_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    stdout.writeln('Route coverage artifact is current.');
    return;
  }

  outputFile.writeAsStringSync(content);
  stdout.writeln('Wrote ${outputFile.path}');

  final csvPaths = _writeRouteCsvArtifacts(repoRoot, entries);
  for (final path in csvPaths) {
    stdout.writeln('Wrote $path');
  }
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

List<RouteEntry> _collectRouteEntries(Directory appRoot) {
  final routeGroups = Directory('${appRoot.path}/lib/app/router/route_groups');
  final entries = <RouteEntry>[];

  for (final file
      in routeGroups.listSync().whereType<File>().where((file) {
        return file.path.endsWith('.dart') &&
            !file.path.endsWith('surface_route_helpers.dart');
      }).toList()..sort(
        (a, b) => a.path
            .replaceAll(r'\', '/')
            .compareTo(b.path.replaceAll(r'\', '/')),
      )) {
    final text = file.readAsStringSync();
    final relativeFile = file.path
        .replaceAll('\\', '/')
        .split('/flutter_app/')
        .last;

    entries.addAll(_parseDirectRoutes(text, relativeFile));
    entries.addAll(_parsePlaceholderCalls(text, relativeFile));
  }

  entries.sort((a, b) {
    final fileCompare = a.file.compareTo(b.file);
    if (fileCompare != 0) return fileCompare;
    return a.line.compareTo(b.line);
  });
  return entries;
}

List<RouteEntry> _parseDirectRoutes(String text, String file) {
  final entries = <RouteEntry>[];
  var index = 0;

  while (true) {
    final start = text.indexOf('GoRoute(', index);
    if (start == -1) break;

    final blockEnd = _findBalancedEnd(text, start + 'GoRoute'.length);
    if (blockEnd == -1) break;

    final block = text.substring(start, blockEnd + 1);
    index = blockEnd + 1;

    if (RegExp(r'path:\s*path\b').hasMatch(block)) {
      continue;
    }

    final path = _extractNamedArgument(block, 'path') ?? '-';
    final name = _extractNamedArgument(block, 'name') ?? '-';
    final classification = _classifyDirectRoute(block);
    final evidence = _directRouteEvidence(block, classification);

    entries.add(
      RouteEntry(
        file: file,
        line: _lineNumber(text, start),
        path: path,
        name: name,
        classification: classification,
        evidence: evidence,
      ),
    );
  }

  return entries;
}

List<RouteEntry> _parsePlaceholderCalls(String text, String file) {
  final entries = <RouteEntry>[];
  var index = 0;

  while (true) {
    final start = text.indexOf('_placeholderRoute(', index);
    if (start == -1) break;

    final prefixStart = start - 12 < 0 ? 0 : start - 12;
    final prefix = text.substring(prefixStart, start);
    final blockEnd = _findBalancedEnd(text, start + '_placeholderRoute'.length);
    if (blockEnd == -1) break;

    final block = text.substring(start, blockEnd + 1);
    index = blockEnd + 1;

    if (prefix.contains('GoRoute ')) {
      continue;
    }

    final args = _splitTopLevel(
      block.substring('_placeholderRoute('.length, block.length - 1),
    );
    final path = args.isNotEmpty ? args.first.trim() : '-';
    final title = args.length > 1 ? args[1].trim() : '-';

    entries.add(
      RouteEntry(
        file: file,
        line: _lineNumber(text, start),
        path: path,
        name: '-',
        classification: 'placeholder',
        evidence: 'title: $title',
      ),
    );
  }

  return entries;
}

String _classifyDirectRoute(String block) {
  if (block.contains('redirect:')) return 'redirect_alias';
  if (block.contains('_BottomNavRouteSkeleton')) return 'skeleton';
  if (block.contains('_UnportedRoutePlaceholder')) return 'placeholder_helper';
  return 'real_page';
}

const _wrapperBuilders = {'InternalSurfaceGate', 'AuthRouteShell'};

String _directRouteEvidence(String block, String classification) {
  if (classification == 'redirect_alias') {
    return _extractRedirectTarget(block) ?? 'redirect';
  }

  final widget = RegExp(
    r'=>\s*(?:const\s+)?([A-Za-z_]\w*)\s*\(',
  ).firstMatch(block);
  if (widget != null) {
    return _evidenceForBuilder(widget.group(1)!, block);
  }

  final constructor = RegExp(r'return\s+([A-Za-z_]\w*)\s*\(').firstMatch(block);
  if (constructor != null) {
    return _evidenceForBuilder(constructor.group(1)!, block);
  }

  return classification;
}

/// Gate/shell wrappers report `Wrapper>Child` so audits see the real page.
String _evidenceForBuilder(String builder, String block) {
  if (!_wrapperBuilders.contains(builder)) return builder;
  final child = _extractWrapperChild(block);
  if (child == null) return builder;
  return '$builder>$child';
}

/// Parses `child: Foo(` / `child: const Foo(` / `child: buildOtpPage(state)`.
String? _extractWrapperChild(String block) {
  final match = RegExp(
    r'child:\s*(?:const\s+)?([A-Za-z_]\w*)\s*\(',
  ).firstMatch(block);
  return match?.group(1);
}

String? _extractRedirectTarget(String block) {
  final match = RegExp(
    r'redirect:\s*\([^)]*\)\s*=>\s*([^,\n]+)',
  ).firstMatch(block);
  return match?.group(1)?.trim().replaceFirst(RegExp(r'\)+$'), '');
}

String? _extractNamedArgument(String block, String name) {
  final match = RegExp('$name:\\s*([^,\\n]+)').firstMatch(block);
  return match?.group(1)?.trim();
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

    if ((inSingleQuote || inDoubleQuote) && char == r'\') {
      escaping = true;
      continue;
    }

    if (!inDoubleQuote && char == "'") {
      inSingleQuote = !inSingleQuote;
      continue;
    }

    if (!inSingleQuote && char == '"') {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }

    if (inSingleQuote || inDoubleQuote) {
      continue;
    }

    if (char == '(') {
      depth++;
    } else if (char == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }

  return -1;
}

List<String> _splitTopLevel(String input) {
  final parts = <String>[];
  final buffer = StringBuffer();
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = 0; i < input.length; i++) {
    final char = input[i];

    if (escaping) {
      buffer.write(char);
      escaping = false;
      continue;
    }

    if ((inSingleQuote || inDoubleQuote) && char == r'\') {
      buffer.write(char);
      escaping = true;
      continue;
    }

    if (!inDoubleQuote && char == "'") {
      inSingleQuote = !inSingleQuote;
      buffer.write(char);
      continue;
    }

    if (!inSingleQuote && char == '"') {
      inDoubleQuote = !inDoubleQuote;
      buffer.write(char);
      continue;
    }

    if (!inSingleQuote && !inDoubleQuote) {
      if (char == '(' || char == '[' || char == '{') depth++;
      if (char == ')' || char == ']' || char == '}') depth--;
      if (char == ',' && depth == 0) {
        parts.add(buffer.toString());
        buffer.clear();
        continue;
      }
    }

    buffer.write(char);
  }

  final tail = buffer.toString();
  if (tail.trim().isNotEmpty) parts.add(tail);
  return parts;
}

int _lineNumber(String text, int index) {
  return '\n'.allMatches(text.substring(0, index)).length + 1;
}

String _formatGeneratedDate(DateTime dateTime) {
  final year = dateTime.year.toString().padLeft(4, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String _withoutGeneratedDate(String markdown) {
  return markdown.replaceFirst(
    RegExp(r'^Generated: .+$', multiLine: true),
    'Generated: <ignored>',
  );
}

String _renderMarkdown(
  List<RouteEntry> entries, {
  required String generatedDate,
}) {
  final byClassification = <String, int>{};
  for (final entry in entries) {
    byClassification.update(
      entry.classification,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
  }

  final buffer = StringBuffer()
    ..writeln('# Flutter Route Coverage Truth Table')
    ..writeln()
    ..writeln('Generated: $generatedDate')
    ..writeln()
    ..writeln(
      'This artifact is generated by '
      '`flutter_app/tool/route_coverage_audit.dart`. It classifies static '
      'router declarations so route count cannot be mistaken for completed '
      'screen count.',
    )
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('| Classification | Count |')
    ..writeln('| --- | ---: |');

  for (final classification in byClassification.keys.toList()..sort()) {
    buffer.writeln(
      '| `${_escape(classification)}` | ${byClassification[classification]} |',
    );
  }

  buffer
    ..writeln('| `total` | ${entries.length} |')
    ..writeln()
    ..writeln(
      'Evidence for `InternalSurfaceGate` / `AuthRouteShell` builders uses '
      '`Wrapper>Child` (e.g. `InternalSurfaceGate>AdminHomePage`, '
      '`AuthRouteShell>LoginPage`).',
    )
    ..writeln()
    ..writeln('## Classification Rules')
    ..writeln()
    ..writeln('| Classification | Meaning |')
    ..writeln('| --- | --- |')
    ..writeln(
      '| `real_page` | Route has a real builder target and is not a static redirect or placeholder helper. |',
    )
    ..writeln(
      '| `redirect_alias` | Route redirects to another canonical route. |',
    )
    ..writeln(
      '| `placeholder` | Route is created through `_placeholderRoute(...)`. |',
    )
    ..writeln(
      '| `placeholder_helper` | Internal helper constructor for placeholder routes; not counted when the helper uses dynamic `path`. |',
    )
    ..writeln(
      '| `skeleton` | Shell or bottom-nav skeleton route without feature content. |',
    )
    ..writeln()
    ..writeln('## Route Table')
    ..writeln()
    ..writeln('| File | Line | Path | Name | Classification | Evidence |')
    ..writeln('| --- | ---: | --- | --- | --- | --- |');

  for (final entry in entries) {
    buffer.writeln(
      '| `${_escape(entry.file)}` | ${entry.line} | '
      '`${_escape(entry.path)}` | `${_escape(entry.name)}` | '
      '`${_escape(entry.classification)}` | `${_escape(entry.evidence)}` |',
    );
  }

  return buffer.toString();
}

String _escape(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}

List<String> _writeRouteCsvArtifacts(
  String repoRoot,
  List<RouteEntry> entries,
) {
  final auditsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION/audits');
  final byModuleDir = Directory('${auditsDir.path}/route-paths-by-module');
  byModuleDir.createSync(recursive: true);

  final rows = entries.map(_toCsvRow).toList()
    ..sort((a, b) {
      final moduleCompare = a.module.compareTo(b.module);
      if (moduleCompare != 0) return moduleCompare;
      return a.routePathSymbol.compareTo(b.routePathSymbol);
    });

  final header =
      'module,classification,route_path_symbol,route_path_token,'
      'route_name_symbol,route_name_token,builder_evidence,source_file,'
      'source_line';

  final allPathsFile = File(
    '${auditsDir.path}/VitTrade-Route-Paths-By-Module.csv',
  );
  final realPagesFile = File(
    '${auditsDir.path}/VitTrade-Route-Real-Pages-By-Module.csv',
  );

  allPathsFile.writeAsStringSync(_renderCsv(header, rows));
  realPagesFile.writeAsStringSync(
    _renderCsv(
      header,
      rows.where((row) => row.classification == 'real_page').toList(),
    ),
  );

  final written = <String>[allPathsFile.path, realPagesFile.path];

  final byModule = <String, List<_CsvRow>>{};
  for (final row in rows) {
    if (row.classification != 'real_page') continue;
    byModule.putIfAbsent(row.module, () => []).add(row);
  }

  final modules = byModule.keys.toList()..sort();
  for (final module in modules) {
    final file = File('${byModuleDir.path}/$module.csv');
    file.writeAsStringSync(_renderCsv(header, byModule[module]!));
    written.add(file.path);
  }

  return written;
}

final class _CsvRow {
  const _CsvRow({
    required this.module,
    required this.classification,
    required this.routePathSymbol,
    required this.routePathToken,
    required this.routeNameSymbol,
    required this.routeNameToken,
    required this.builderEvidence,
    required this.sourceFile,
    required this.sourceLine,
  });

  final String module;
  final String classification;
  final String routePathSymbol;
  final String routePathToken;
  final String routeNameSymbol;
  final String routeNameToken;
  final String builderEvidence;
  final String sourceFile;
  final int sourceLine;
}

_CsvRow _toCsvRow(RouteEntry entry) {
  return _CsvRow(
    module: _moduleFromRouteFile(entry.file),
    classification: entry.classification,
    routePathSymbol: entry.path,
    routePathToken: _symbolToken(entry.path, 'AppRoutePaths.'),
    routeNameSymbol: entry.name,
    routeNameToken: _symbolToken(entry.name, 'AppRouteNames.'),
    builderEvidence: entry.evidence,
    sourceFile: entry.file,
    sourceLine: entry.line,
  );
}

String _moduleFromRouteFile(String file) {
  final base = file.split('/').last;
  const suffix = '_routes.dart';
  if (base.endsWith(suffix)) {
    return base.substring(0, base.length - suffix.length);
  }
  return base.replaceFirst(RegExp(r'\.dart$'), '');
}

String _symbolToken(String symbol, String prefix) {
  if (symbol == '-') return '-';
  if (symbol.startsWith(prefix)) {
    return symbol.substring(prefix.length);
  }
  return symbol;
}

String _renderCsv(String header, List<_CsvRow> rows) {
  final buffer = StringBuffer()..writeln(header);
  for (final row in rows) {
    buffer.writeln(
      [
        row.module,
        row.classification,
        row.routePathSymbol,
        row.routePathToken,
        row.routeNameSymbol,
        row.routeNameToken,
        row.builderEvidence,
        row.sourceFile,
        row.sourceLine.toString(),
      ].map(_csvEscape).join(','),
    );
  }
  return buffer.toString();
}

String _csvEscape(String value) {
  if (value.contains(',') ||
      value.contains('"') ||
      value.contains('\n') ||
      value.contains('\r')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
