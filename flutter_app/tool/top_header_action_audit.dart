import 'dart:io';

final class HeaderActionEntry {
  const HeaderActionEntry({
    required this.category,
    required this.file,
    required this.line,
    required this.owner,
    required this.sourceWidget,
    required this.actionSource,
    required this.trailingKind,
    required this.icon,
    required this.classification,
    required this.canonicalAction,
    required this.canonicalIcon,
    required this.needsMigration,
    required this.notes,
  });

  final String category;
  final String file;
  final int line;
  final String owner;
  final String sourceWidget;
  final String actionSource;
  final String trailingKind;
  final String icon;
  final String classification;
  final String canonicalAction;
  final String canonicalIcon;
  final bool needsMigration;
  final String notes;
}

final class HeaderActionReport {
  const HeaderActionReport({
    required this.entries,
    required this.vitHeaderCount,
    required this.vitHeaderWithTrailingCount,
    required this.vitHeaderWithLegacyActionCount,
    required this.customHeaderCount,
    required this.bannedIconCount,
    required this.customImplementationCount,
    required this.oversizedActionGroupCount,
  });

  final List<HeaderActionEntry> entries;
  final int vitHeaderCount;
  final int vitHeaderWithTrailingCount;
  final int vitHeaderWithLegacyActionCount;
  final int customHeaderCount;
  final int bannedIconCount;
  final int customImplementationCount;
  final int oversizedActionGroupCount;

  int get migrationCandidateCount =>
      entries.where((entry) => entry.needsMigration).length;
}

const _canonicalIcons = <String, (String action, String canonicalIcon)>{
  'chevron_left_rounded': ('back', 'Icons.chevron_left_rounded'),
  'close_rounded': ('close', 'Icons.close_rounded'),
  'search_rounded': ('search', 'Icons.search_rounded'),
  'notifications_none_rounded': (
    'notifications',
    'Icons.notifications_none_rounded',
  ),
  'tune_rounded': ('filter', 'Icons.tune_rounded'),
  'settings_outlined': ('settings', 'Icons.settings_outlined'),
  'download_rounded': ('export', 'Icons.download_rounded'),
  'share_outlined': ('share', 'Icons.share_outlined'),
  'star_rounded': ('favoriteOn', 'Icons.star_rounded'),
  'star_border_rounded': ('favoriteOff', 'Icons.star_border_rounded'),
  'add_rounded': ('add', 'Icons.add_rounded'),
  'history_rounded': ('history', 'Icons.history_rounded'),
  'bar_chart_rounded': ('analytics', 'Icons.bar_chart_rounded'),
  'business_center_outlined': ('portfolio', 'Icons.business_center_outlined'),
  'monitor_heart_outlined': ('overview', 'Icons.monitor_heart_outlined'),
  'layers_rounded': ('sectors', 'Icons.layers_rounded'),
  'refresh_rounded': ('refresh', 'Icons.refresh_rounded'),
  'help_outline_rounded': ('help', 'Icons.help_outline_rounded'),
  'error_outline_rounded': ('emergency', 'Icons.error_outline_rounded'),
  'more_vert_rounded': ('more', 'Icons.more_vert_rounded'),
};

const _bannedIcons = <String, (String action, String canonicalIcon)>{
  'ios_share_rounded': ('share', 'Icons.share_outlined'),
  'file_download_outlined': ('export', 'Icons.download_rounded'),
  'filter_alt_outlined': ('filter', 'Icons.tune_rounded'),
  'favorite_rounded': ('favoriteOn', 'Icons.star_rounded'),
  'favorite_border_rounded': ('favoriteOff', 'Icons.star_border_rounded'),
  'add': ('add', 'Icons.add_rounded'),
  'person_add_alt_1_rounded': ('add', 'Icons.add_rounded'),
  'chevron_right_rounded': ('more_or_content_cta', 'VitHeaderActionType.more'),
};

const _legacyActionIcons = <String, (String action, String canonicalIcon)>{
  'bell': ('notifications', 'Icons.notifications_none_rounded'),
  'search': ('search', 'Icons.search_rounded'),
  'more': ('more', 'Icons.more_vert_rounded'),
};

const _canonicalActionIcons = <String, String>{
  'back': 'Icons.chevron_left_rounded',
  'close': 'Icons.close_rounded',
  'search': 'Icons.search_rounded',
  'notifications': 'Icons.notifications_none_rounded',
  'filter': 'Icons.tune_rounded',
  'settings': 'Icons.settings_outlined',
  'export': 'Icons.download_rounded',
  'share': 'Icons.share_outlined',
  'favoriteOn': 'Icons.star_rounded',
  'favoriteOff': 'Icons.star_border_rounded',
  'add': 'Icons.add_rounded',
  'history': 'Icons.history_rounded',
  'analytics': 'Icons.bar_chart_rounded',
  'portfolio': 'Icons.business_center_outlined',
  'overview': 'Icons.monitor_heart_outlined',
  'sectors': 'Icons.layers_rounded',
  'refresh': 'Icons.refresh_rounded',
  'help': 'Icons.help_outline_rounded',
  'emergency': 'Icons.error_outline_rounded',
  'more': 'Icons.more_vert_rounded',
};

const _selectorOrContentIcons = <String>{
  'keyboard_arrow_down_rounded',
  'arrow_drop_down_rounded',
};

const _customHeaderTargets = <String, List<String>>{
  'lib/features/home/presentation/phone/pages/home_page_state.dart': [
    '_HomeHeader',
  ],
  'lib/features/markets/presentation/widgets/market_list_header.dart': [
    'MarketListHeader',
  ],
  'lib/features/markets/presentation/widgets/pair_detail_header_widgets.dart': [
    '_PairHeader',
  ],
  'lib/features/trade/presentation/phone/pages/trade_page_state.dart': [
    '_TradeHeader',
  ],
  'lib/features/launchpad/presentation/widgets/launchpad_home_header_widgets.dart':
      ['LaunchpadHomeHeaderActions', '_HeaderActions'],
};

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strict = args.contains('--strict');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Action-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Action-Audit.csv',
  );

  final report = _collectHeaderActionReport(appRoot, repoRoot);
  final markdown = _renderMarkdown(report);
  final csv = _renderCsv(report.entries);
  final summary = _renderSummary(report);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('Top header action markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Top header action markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Top header action CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Top header action CSV artifact is stale.');
    }

    if (strict) {
      final blockingCount =
          report.vitHeaderWithTrailingCount +
          report.vitHeaderWithLegacyActionCount +
          report.migrationCandidateCount +
          report.bannedIconCount +
          report.customImplementationCount +
          report.oversizedActionGroupCount;
      if (blockingCount > 0) {
        failures.add('Strict top header action guardrail found violations.');
      }
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/top_header_action_audit.dart` from flutter_app/.',
      );
      if (strict) {
        stderr.writeln(
          'Strict mode requires zero legacy/custom top-header action usage.',
        );
      }
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Top header action artifacts are current.');
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
  if (Directory('${current.path}/lib/app/router/route_groups').existsSync()) {
    return current;
  }

  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/router/route_groups').existsSync()) {
    return nested;
  }

  throw StateError('Run from repo root or flutter_app/.');
}

HeaderActionReport _collectHeaderActionReport(
  Directory appRoot,
  String repoRoot,
) {
  final entries = <HeaderActionEntry>[];
  var vitHeaderCount = 0;
  var vitHeaderWithTrailingCount = 0;
  var vitHeaderWithLegacyActionCount = 0;
  var customHeaderCount = 0;
  var oversizedActionGroupCount = 0;

  final files =
      Directory('${appRoot.path}/lib')
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
    final relativeFile = _relativePath(file, repoRoot);
    final appRelativeFile = relativeFile.replaceFirst('flutter_app/', '');
    final source = file.readAsStringSync();

    var searchIndex = 0;
    while (true) {
      final start = source.indexOf('VitHeader(', searchIndex);
      if (start == -1) break;

      final openParen = source.indexOf('(', start);
      final end = _findBalancedEnd(source, openParen);
      if (end == -1) break;

      vitHeaderCount += 1;
      final block = source.substring(start, end + 1);
      final line = _lineNumber(source, start);
      final owner = _nearestClassName(source, start);
      searchIndex = end + 1;

      final showBack = _extractTopLevelArgument(block, 'showBack');
      if (showBack?.contains('true') ?? false) {
        entries.add(
          HeaderActionEntry(
            category: 'vit_header',
            file: relativeFile,
            line: line,
            owner: owner,
            sourceWidget: 'VitHeader',
            actionSource: 'showBack',
            trailingKind: '-',
            icon: 'Icons.chevron_left_rounded',
            classification: 'canonical',
            canonicalAction: 'back',
            canonicalIcon: 'Icons.chevron_left_rounded',
            needsMigration: false,
            notes: 'Back action is present.',
          ),
        );
      }

      final legacyAction = _extractLegacyHeaderAction(block);
      if (legacyAction != null && legacyAction != 'none') {
        vitHeaderWithLegacyActionCount += 1;
        final canonical =
            _legacyActionIcons[legacyAction] ?? ('unknown', 'unknown');
        entries.add(
          HeaderActionEntry(
            category: 'vit_header',
            file: relativeFile,
            line: line,
            owner: owner,
            sourceWidget: 'VitHeader',
            actionSource: 'legacy_action',
            trailingKind: 'VitHeaderAction.$legacyAction',
            icon: 'VitHeaderAction.$legacyAction',
            classification: 'legacy_built_in',
            canonicalAction: canonical.$1,
            canonicalIcon: canonical.$2,
            needsMigration: true,
            notes: 'Migrate to VitHeader.actions.',
          ),
        );
      }

      final trailing = _extractTopLevelArgument(block, 'trailing');
      if (trailing != null) {
        vitHeaderWithTrailingCount += 1;
        final trailingKind = _trailingKind(trailing);
        final trailingIcons = _extractIconNames(trailing);
        final trailingActionTypes = _extractHeaderActionTypes(trailing);
        final actionCount = _estimateHeaderActionCount(trailing);
        if (actionCount > 3) oversizedActionGroupCount += 1;

        if (trailingActionTypes.isNotEmpty) {
          for (final actionType in trailingActionTypes) {
            entries.add(
              _entryForActionType(
                category: 'vit_header',
                file: relativeFile,
                line: line,
                owner: owner,
                sourceWidget: 'VitHeader',
                actionSource: 'trailing',
                trailingKind: trailingKind,
                actionType: actionType,
                extraNotes: actionCount > 3
                    ? 'Action group exceeds 3; use more overflow.'
                    : '',
              ),
            );
          }
        } else if (trailingIcons.isEmpty) {
          entries.add(
            HeaderActionEntry(
              category: 'vit_header',
              file: relativeFile,
              line: line,
              owner: owner,
              sourceWidget: 'VitHeader',
              actionSource: 'trailing',
              trailingKind: trailingKind,
              icon: '-',
              classification: 'custom_trailing_widget',
              canonicalAction: '-',
              canonicalIcon: '-',
              needsMigration: true,
              notes: actionCount > 3
                  ? 'Custom trailing reference and action group exceeds 3.'
                  : 'Custom trailing reference requires component migration.',
            ),
          );
        } else {
          for (final icon in trailingIcons) {
            entries.add(
              _entryForIcon(
                category: 'vit_header',
                file: relativeFile,
                line: line,
                owner: owner,
                sourceWidget: 'VitHeader',
                actionSource: 'trailing',
                trailingKind: trailingKind,
                iconName: icon,
                customImplementation: true,
                extraNotes: actionCount > 3
                    ? 'Action group exceeds 3; use more overflow.'
                    : '',
              ),
            );
          }
        }
      }
    }

    final customTargets = _customHeaderTargets[appRelativeFile];
    if (customTargets == null) continue;

    for (final className in customTargets) {
      final classBlock = _extractClassBlock(source, className);
      if (classBlock == null) continue;
      customHeaderCount += 1;

      final icons = _extractIconNames(classBlock.block);
      final actionTypes = _extractHeaderActionTypes(classBlock.block);
      final actionCount = _estimateHeaderActionCount(classBlock.block);
      if (actionCount > 3) oversizedActionGroupCount += 1;

      if (actionTypes.isNotEmpty) {
        for (final actionType in actionTypes) {
          entries.add(
            _entryForActionType(
              category: 'custom_header',
              file: relativeFile,
              line: classBlock.line,
              owner: className,
              sourceWidget: className,
              actionSource: 'custom_header',
              trailingKind: className,
              actionType: actionType,
              extraNotes: actionCount > 3
                  ? 'Action group exceeds 3; use more overflow.'
                  : '',
            ),
          );
        }
      } else if (icons.isEmpty) {
        entries.add(
          HeaderActionEntry(
            category: 'custom_header',
            file: relativeFile,
            line: classBlock.line,
            owner: className,
            sourceWidget: className,
            actionSource: 'custom_header',
            trailingKind: className,
            icon: '-',
            classification: 'custom_header_no_direct_icon',
            canonicalAction: '-',
            canonicalIcon: '-',
            needsMigration: true,
            notes: 'Custom header must be reviewed against the action catalog.',
          ),
        );
      } else {
        for (final icon in icons) {
          entries.add(
            _entryForIcon(
              category: 'custom_header',
              file: relativeFile,
              line: classBlock.line,
              owner: className,
              sourceWidget: className,
              actionSource: 'custom_header',
              trailingKind: className,
              iconName: icon,
              customImplementation: true,
              extraNotes: actionCount > 3
                  ? 'Action group exceeds 3; use more overflow.'
                  : '',
            ),
          );
        }
      }
    }
  }

  entries.sort((a, b) {
    final fileCompare = a.file.compareTo(b.file);
    if (fileCompare != 0) return fileCompare;
    final lineCompare = a.line.compareTo(b.line);
    if (lineCompare != 0) return lineCompare;
    return a.icon.compareTo(b.icon);
  });

  final bannedIconCount = entries
      .where((entry) => entry.classification == 'banned_icon')
      .length;
  final customImplementationCount = entries
      .where((entry) => entry.classification == 'custom_action_button')
      .length;

  return HeaderActionReport(
    entries: entries,
    vitHeaderCount: vitHeaderCount,
    vitHeaderWithTrailingCount: vitHeaderWithTrailingCount,
    vitHeaderWithLegacyActionCount: vitHeaderWithLegacyActionCount,
    customHeaderCount: customHeaderCount,
    bannedIconCount: bannedIconCount,
    customImplementationCount: customImplementationCount,
    oversizedActionGroupCount: oversizedActionGroupCount,
  );
}

HeaderActionEntry _entryForActionType({
  required String category,
  required String file,
  required int line,
  required String owner,
  required String sourceWidget,
  required String actionSource,
  required String trailingKind,
  required String actionType,
  required String extraNotes,
}) {
  final canonicalIcon = _canonicalActionIcons[actionType];
  if (canonicalIcon == null) {
    return HeaderActionEntry(
      category: category,
      file: file,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      actionSource: actionSource,
      trailingKind: trailingKind,
      icon: 'VitHeaderActionType.$actionType',
      classification: 'unknown_action_type',
      canonicalAction: '-',
      canonicalIcon: '-',
      needsMigration: true,
      notes: _joinNotes(['Unknown header action type.', extraNotes]),
    );
  }

  return HeaderActionEntry(
    category: category,
    file: file,
    line: line,
    owner: owner,
    sourceWidget: sourceWidget,
    actionSource: actionSource,
    trailingKind: trailingKind,
    icon: 'VitHeaderActionType.$actionType',
    classification: 'canonical_action_type',
    canonicalAction: actionType,
    canonicalIcon: canonicalIcon,
    needsMigration: false,
    notes: _joinNotes([
      'Uses canonical VitHeaderActionButton catalog type.',
      extraNotes,
    ]),
  );
}

HeaderActionEntry _entryForIcon({
  required String category,
  required String file,
  required int line,
  required String owner,
  required String sourceWidget,
  required String actionSource,
  required String trailingKind,
  required String iconName,
  required bool customImplementation,
  required String extraNotes,
}) {
  final banned = _bannedIcons[iconName];
  if (banned != null) {
    return HeaderActionEntry(
      category: category,
      file: file,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      actionSource: actionSource,
      trailingKind: trailingKind,
      icon: 'Icons.$iconName',
      classification: 'banned_icon',
      canonicalAction: banned.$1,
      canonicalIcon: banned.$2,
      needsMigration: true,
      notes: _joinNotes([
        'Replace banned top-header icon.',
        if (customImplementation) 'Use VitHeaderActionButton.',
        extraNotes,
      ]),
    );
  }

  if (_selectorOrContentIcons.contains(iconName)) {
    return HeaderActionEntry(
      category: category,
      file: file,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      actionSource: actionSource,
      trailingKind: trailingKind,
      icon: 'Icons.$iconName',
      classification: 'selector_or_content_icon',
      canonicalAction: '-',
      canonicalIcon: '-',
      needsMigration: false,
      notes: _joinNotes([
        'Allowed only inside selector/body content, not as a header action.',
        extraNotes,
      ]),
    );
  }

  final canonical = _canonicalIcons[iconName];
  if (canonical != null) {
    return HeaderActionEntry(
      category: category,
      file: file,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      actionSource: actionSource,
      trailingKind: trailingKind,
      icon: 'Icons.$iconName',
      classification: customImplementation
          ? 'custom_action_button'
          : 'canonical',
      canonicalAction: canonical.$1,
      canonicalIcon: canonical.$2,
      needsMigration: customImplementation,
      notes: _joinNotes([
        if (customImplementation)
          'Canonical icon is used through a custom button; use VitHeaderActionButton.'
        else
          'Canonical catalog icon.',
        extraNotes,
      ]),
    );
  }

  return HeaderActionEntry(
    category: category,
    file: file,
    line: line,
    owner: owner,
    sourceWidget: sourceWidget,
    actionSource: actionSource,
    trailingKind: trailingKind,
    icon: 'Icons.$iconName',
    classification: 'non_catalog_icon',
    canonicalAction: '-',
    canonicalIcon: '-',
    needsMigration: true,
    notes: _joinNotes([
      'Map to the canonical action catalog or move into page content.',
      extraNotes,
    ]),
  );
}

String _renderMarkdown(HeaderActionReport report) {
  final classificationCounts = _countsBy(
    report.entries.map((entry) => entry.classification),
  );

  final buffer = StringBuffer()
    ..writeln('# VitTrade Top Header Action Audit')
    ..writeln()
    ..writeln('Generated from `flutter_app/tool/top_header_action_audit.dart`.')
    ..writeln()
    ..writeln('```text')
    ..writeln('vit_header_total=${report.vitHeaderCount}')
    ..writeln(
      'vit_header_with_custom_trailing=${report.vitHeaderWithTrailingCount}',
    )
    ..writeln(
      'vit_header_with_legacy_action=${report.vitHeaderWithLegacyActionCount}',
    )
    ..writeln('custom_header_targets=${report.customHeaderCount}')
    ..writeln('migration_candidates=${report.migrationCandidateCount}')
    ..writeln('banned_icon_usages=${report.bannedIconCount}')
    ..writeln('custom_button_usages=${report.customImplementationCount}')
    ..writeln('action_groups_over_limit=${report.oversizedActionGroupCount}')
    ..writeln('```')
    ..writeln()
    ..writeln('## Classification Counts')
    ..writeln()
    ..writeln('| Classification | Count |')
    ..writeln('| --- | ---: |');

  final sortedCounts = classificationCounts.entries.toList()
    ..sort((a, b) {
      final valueCompare = b.value.compareTo(a.value);
      if (valueCompare != 0) return valueCompare;
      return a.key.compareTo(b.key);
    });
  for (final entry in sortedCounts) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Action Inventory')
    ..writeln()
    ..writeln(
      '| Category | File | Line | Owner | Source | Icon/Action | Classification | Canonical | Needs migration | Notes |',
    )
    ..writeln('| --- | --- | ---: | --- | --- | --- | --- | --- | --- | --- |');

  for (final entry in report.entries) {
    final canonical = entry.canonicalAction == '-'
        ? '-'
        : '${entry.canonicalAction} / `${entry.canonicalIcon}`';
    buffer.writeln(
      '| ${entry.category} | `${_escape(entry.file)}` | ${entry.line} | '
      '`${_escape(entry.owner)}` | `${_escape(entry.actionSource)}` '
      '`${_escape(entry.trailingKind)}` | `${_escape(entry.icon)}` | '
      '${entry.classification} | $canonical | '
      '${entry.needsMigration ? 'yes' : 'no'} | ${_escape(entry.notes)} |',
    );
  }

  return buffer.toString();
}

String _renderCsv(List<HeaderActionEntry> entries) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'category',
        'file',
        'line',
        'owner',
        'sourceWidget',
        'actionSource',
        'trailingKind',
        'icon',
        'classification',
        'canonicalAction',
        'canonicalIcon',
        'needsMigration',
        'notes',
      ].join(','),
    );

  for (final entry in entries) {
    buffer.writeln(
      [
        entry.category,
        entry.file,
        entry.line.toString(),
        entry.owner,
        entry.sourceWidget,
        entry.actionSource,
        entry.trailingKind,
        entry.icon,
        entry.classification,
        entry.canonicalAction,
        entry.canonicalIcon,
        entry.needsMigration ? 'yes' : 'no',
        entry.notes,
      ].map(_csvCell).join(','),
    );
  }

  return buffer.toString();
}

String _renderSummary(HeaderActionReport report) {
  final buffer = StringBuffer()
    ..writeln('vit_header_total=${report.vitHeaderCount}')
    ..writeln(
      'vit_header_with_custom_trailing=${report.vitHeaderWithTrailingCount}',
    )
    ..writeln(
      'vit_header_with_legacy_action=${report.vitHeaderWithLegacyActionCount}',
    )
    ..writeln('custom_header_targets=${report.customHeaderCount}')
    ..writeln('migration_candidates=${report.migrationCandidateCount}')
    ..writeln('banned_icon_usages=${report.bannedIconCount}')
    ..writeln('custom_button_usages=${report.customImplementationCount}')
    ..writeln('action_groups_over_limit=${report.oversizedActionGroupCount}');
  return buffer.toString();
}

String? _extractTopLevelArgument(String block, String name) {
  final pattern = RegExp('(^|[,(])\\s*$name\\s*:', multiLine: true);
  final match = pattern.firstMatch(block);
  if (match == null) return null;

  final valueStart = match.end;
  var depthParen = 0;
  var depthBrace = 0;
  var depthBracket = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = valueStart; i < block.length; i++) {
    final char = block[i];

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

    switch (char) {
      case '(':
        depthParen += 1;
      case ')':
        if (depthParen == 0 && depthBrace == 0 && depthBracket == 0) {
          return block.substring(valueStart, i).trim();
        }
        depthParen -= 1;
      case '{':
        depthBrace += 1;
      case '}':
        depthBrace -= 1;
      case '[':
        depthBracket += 1;
      case ']':
        depthBracket -= 1;
      case ',':
        if (depthParen == 0 && depthBrace == 0 && depthBracket == 0) {
          return block.substring(valueStart, i).trim();
        }
    }
  }

  return block.substring(valueStart).trim();
}

String? _extractLegacyHeaderAction(String block) {
  final value = _extractTopLevelArgument(block, 'action');
  if (value == null) return null;
  final match = RegExp(r'VitHeaderAction\.(\w+)').firstMatch(value);
  return match?.group(1);
}

String _trailingKind(String trailing) {
  final trimmed = trailing.trim();
  final constructor = RegExp(
    r'^(?:const\s+)?([A-Za-z_]\w*)\s*\(',
  ).firstMatch(trimmed);
  if (constructor != null) return constructor.group(1)!;

  final identifier = RegExp(
    r'^(?:const\s+)?([A-Za-z_]\w*)\b',
  ).firstMatch(trimmed);
  return identifier?.group(1) ?? 'expression';
}

List<String> _extractIconNames(String source) {
  final icons = <String>[];
  for (final match in RegExp(r'Icons\.([A-Za-z0-9_]+)').allMatches(source)) {
    icons.add(match.group(1)!);
  }
  return icons;
}

List<String> _extractHeaderActionTypes(String source) {
  final types = <String>[];
  for (final match in RegExp(
    r'VitHeaderActionType\.([A-Za-z0-9_]+)',
  ).allMatches(source)) {
    types.add(match.group(1)!);
  }
  return types;
}

int _estimateHeaderActionCount(String source) {
  final widgets = [
    'VitHeaderActionButton(',
    'VitIconButton(',
    'IconButton(',
    '_HeaderActionButton(',
    '_HeaderSmallIcon(',
    '_HeaderButton(',
    '_HeaderSettingsButton(',
    '_HeaderCreateButton(',
    '_HeaderExportButton(',
    '_HeaderDownloadButton(',
    '_HeaderHistoryButton(',
    '_HeaderChartButton(',
    '_AddAddressButton(',
  ];
  var count = 0;
  for (final widget in widgets) {
    count += _countOccurrences(source, widget);
  }
  return count;
}

({String block, int line})? _extractClassBlock(
  String source,
  String className,
) {
  final classMatch = RegExp(
    '\\bclass\\s+${RegExp.escape(className)}\\b',
  ).firstMatch(source);
  if (classMatch == null) return null;

  final openBrace = source.indexOf('{', classMatch.end);
  if (openBrace == -1) return null;
  final closeBrace = _findBalancedBraceEnd(source, openBrace);
  if (closeBrace == -1) return null;

  return (
    block: source.substring(classMatch.start, closeBrace + 1),
    line: _lineNumber(source, classMatch.start),
  );
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

int _findBalancedBraceEnd(String text, int openBraceIndex) {
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = openBraceIndex; i < text.length; i++) {
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

    if (char == '{') {
      depth += 1;
    } else if (char == '}') {
      depth -= 1;
      if (depth == 0) return i;
    }
  }

  return -1;
}

String _nearestClassName(String source, int beforeIndex) {
  final before = source.substring(0, beforeIndex);
  final matches = RegExp(r'\bclass\s+([A-Za-z_]\w*)\b').allMatches(before);
  if (matches.isEmpty) return '-';
  return matches.last.group(1)!;
}

int _lineNumber(String source, int index) {
  var line = 1;
  for (var i = 0; i < index && i < source.length; i++) {
    if (source.codeUnitAt(i) == 10) line += 1;
  }
  return line;
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts.update(value, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}

int _countOccurrences(String source, String needle) {
  var count = 0;
  var index = 0;
  while (true) {
    index = source.indexOf(needle, index);
    if (index == -1) return count;
    count += 1;
    index += needle.length;
  }
}

String _joinNotes(List<String> notes) {
  return notes.where((note) => note.trim().isNotEmpty).join(' ');
}

String _csvCell(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

String _escape(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}

String _relativePath(File file, String repoRoot) {
  return file.path
      .replaceAll('\\', '/')
      .replaceFirst(repoRoot.replaceAll('\\', '/'), '');
}
