import 'dart:io';

final class GlobalAccessEntry {
  const GlobalAccessEntry({
    required this.kind,
    required this.scope,
    required this.file,
    required this.line,
    required this.allowed,
    required this.issue,
    required this.notes,
  });

  final String kind;
  final String scope;
  final String file;
  final int line;
  final bool allowed;
  final String issue;
  final String notes;

  bool get hasIssue => issue != '-';
}

final class GlobalAccessReport {
  const GlobalAccessReport({
    required this.entries,
    required this.sourceIssues,
    required this.contentSearchControls,
    required this.contentNotificationIcons,
  });

  final List<GlobalAccessEntry> entries;
  final List<String> sourceIssues;
  final int contentSearchControls;
  final int contentNotificationIcons;

  int get globalSearchActions =>
      entries.where((entry) => entry.scope == 'global_search').length;

  int get moduleSearchActions =>
      entries.where((entry) => entry.scope == 'module_search').length;

  int get globalNotificationActions =>
      entries.where((entry) => entry.scope == 'global_notification').length;

  int get contextNotificationActions =>
      entries.where((entry) => entry.scope == 'context_notification').length;

  int get policyViolations =>
      entries.where((entry) => entry.hasIssue).length + sourceIssues.length;
}

const _globalSearchAllowlist = <String>{
  'lib/features/home/presentation/widgets/phone/home_header.dart',
  'lib/features/home/presentation/widgets/tablet/home_header.dart',
};

const _moduleSearchAllowlist = <String>{
  'lib/features/discovery/presentation/phone/pages/topic_hub_page.dart',
  'lib/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart',
};

const _globalNotificationAllowlist = <String>{
  'lib/features/home/presentation/widgets/phone/home_header.dart',
  'lib/features/home/presentation/widgets/tablet/home_header.dart',
};

const _contextNotificationAllowlist = <String>{
  'lib/features/trade/presentation/widgets/convert_page_header_widgets.dart',
  'lib/features/launchpad/presentation/phone/pages/claim/launchpad_claim_receipt_page.dart',
  'lib/features/p2p_dispute/presentation/phone/pages/dispute/p2p_claim_detail_page_state.dart',
};

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Global-Access-Policy-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Global-Access-Policy-Audit.csv',
  );

  final report = _collectReport(appRoot, repoRoot);
  final markdown = _renderMarkdown(report);
  final csv = _renderCsv(report);
  final summary = _renderSummary(report);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('Global access policy markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Global access policy markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Global access policy CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Global access policy CSV artifact is stale.');
    }

    if (report.policyViolations > 0) {
      failures.add(
        'Global search/notification access policy found '
        '${report.policyViolations} violation(s).',
      );
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/top_header_global_access_policy_audit.dart` '
        'from flutter_app/ and resolve policy violations.',
      );
      stderr.write(summary);
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Global access policy artifacts are current.');
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

GlobalAccessReport _collectReport(Directory appRoot, String repoRoot) {
  final entries = <GlobalAccessEntry>[];
  var contentSearchControls = 0;
  var contentNotificationIcons = 0;

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

    if (!appRelativeFile.startsWith('lib/shared/')) {
      entries.addAll(
        _collectActionType(
          source: source,
          file: appRelativeFile,
          pattern: 'VitHeaderActionType.search',
          kind: 'search_action',
          classifier: _classifySearch,
        ),
      );
      entries.addAll(
        _collectActionType(
          source: source,
          file: appRelativeFile,
          pattern: 'VitHeaderActionType.notifications',
          kind: 'notification_action',
          classifier: _classifyNotification,
        ),
      );
    }

    if (appRelativeFile != 'lib/shared/layout/vit_header_action_button.dart') {
      contentSearchControls += _countOccurrences(
        source,
        'Icons.search_rounded',
      );
      contentNotificationIcons +=
          _countOccurrences(source, 'Icons.notifications_none_rounded') +
          _countOccurrences(source, 'Icons.notifications_rounded');
    }
  }

  return GlobalAccessReport(
    entries: entries,
    sourceIssues: _collectSourceIssues(appRoot),
    contentSearchControls: contentSearchControls,
    contentNotificationIcons: contentNotificationIcons,
  );
}

List<GlobalAccessEntry> _collectActionType({
  required String source,
  required String file,
  required String pattern,
  required String kind,
  required GlobalAccessEntry Function(String file, int line, String block)
  classifier,
}) {
  final entries = <GlobalAccessEntry>[];
  var index = 0;
  while (true) {
    final found = source.indexOf(pattern, index);
    if (found < 0) break;
    final block = _callBlock(source, found);
    entries.add(classifier(file, _lineNumber(source, found), block));
    index = found + pattern.length;
  }
  return entries;
}

GlobalAccessEntry _classifySearch(String file, int line, String block) {
  if (_globalSearchAllowlist.contains(file)) {
    final hasRoute =
        block.contains('/search') || block.contains('AppRoutePaths.search');
    return GlobalAccessEntry(
      kind: 'search_action',
      scope: 'global_search',
      file: file,
      line: line,
      allowed: hasRoute,
      issue: hasRoute ? '-' : 'global_search_missing_search_route',
      notes: 'Home global command search.',
    );
  }

  if (_moduleSearchAllowlist.contains(file)) {
    return GlobalAccessEntry(
      kind: 'search_action',
      scope: 'module_search',
      file: file,
      line: line,
      allowed: true,
      issue: '-',
      notes: 'Module/discovery search action is allowlisted.',
    );
  }

  return GlobalAccessEntry(
    kind: 'search_action',
    scope: 'unknown_search',
    file: file,
    line: line,
    allowed: false,
    issue: 'search_action_not_allowlisted',
    notes: 'Search actions must be global Home or explicit module search.',
  );
}

GlobalAccessEntry _classifyNotification(String file, int line, String block) {
  if (_globalNotificationAllowlist.contains(file)) {
    final hasRoute =
        block.contains('/notifications') ||
        block.contains('AppRoutePaths.notifications');
    return GlobalAccessEntry(
      kind: 'notification_action',
      scope: 'global_notification',
      file: file,
      line: line,
      allowed: hasRoute,
      issue: hasRoute ? '-' : 'global_notification_missing_inbox_route',
      notes: 'Home global notification inbox action.',
    );
  }

  if (_contextNotificationAllowlist.contains(file)) {
    final opensGlobalInbox =
        block.contains('/notifications') ||
        block.contains('AppRoutePaths.notifications');
    final hasTooltip = block.contains('tooltip:');
    String issue = '-';
    if (opensGlobalInbox) {
      issue = 'context_notification_opens_global_inbox';
    } else if (!hasTooltip) {
      issue = 'context_notification_missing_scope_tooltip';
    }

    return GlobalAccessEntry(
      kind: 'notification_action',
      scope: 'context_notification',
      file: file,
      line: line,
      allowed: issue == '-',
      issue: issue,
      notes: 'Context notification action must not masquerade as global inbox.',
    );
  }

  return GlobalAccessEntry(
    kind: 'notification_action',
    scope: 'unknown_notification',
    file: file,
    line: line,
    allowed: false,
    issue: 'notification_action_not_allowlisted',
    notes: 'Global bell is only allowlisted on Home.',
  );
}

List<String> _collectSourceIssues(Directory appRoot) {
  final issues = <String>[];

  final rootRoutes = File(
    '${appRoot.path}/lib/app/router/route_groups/root_routes.dart',
  );
  final rootSource = rootRoutes.readAsStringSync();
  if (rootSource.contains('HomeMockData.homeBadge')) {
    issues.add(
      'root_routes_uses_home_mock_badge: root shell must read '
      'notificationUnreadCountProvider instead of HomeMockData.homeBadge.',
    );
  }

  final homePart = File(
    '${appRoot.path}/lib/features/home/presentation/phone/pages/home_page_state.dart',
  );
  final homeSource = homePart.readAsStringSync();
  if (homeSource.contains('notifications: snapshot.notifications')) {
    issues.add(
      'home_header_uses_home_snapshot_notifications: Home header badge must '
      'read global notification state.',
    );
  }

  final notificationsPage = File(
    '${appRoot.path}/lib/features/notifications/presentation/phone/pages/notifications_page.dart',
  );
  final notificationSource = notificationsPage.readAsStringSync();
  if (notificationSource.contains(
        'List<AppNotificationDraft>? _notifications',
      ) ||
      notificationSource.contains('_notifications =')) {
    issues.add(
      'notifications_page_has_local_notification_list: notifications page '
      'must mutate global notification state.',
    );
  }

  return issues;
}

String _callBlock(String source, int index) {
  final start = source.lastIndexOf('VitHeaderActionItem(', index);
  final resolvedStart = start < 0 ? index : start;
  final end = source.indexOf('),', index);
  final resolvedEnd = end < 0 ? index + 800 : end + 2;
  return source.substring(
    resolvedStart,
    resolvedEnd.clamp(resolvedStart, source.length),
  );
}

int _lineNumber(String source, int index) {
  return '\n'.allMatches(source.substring(0, index)).length + 1;
}

int _countOccurrences(String source, String pattern) {
  var count = 0;
  var index = 0;
  while (true) {
    final found = source.indexOf(pattern, index);
    if (found < 0) return count;
    count++;
    index = found + pattern.length;
  }
}

String _renderSummary(GlobalAccessReport report) {
  return '''
global_search_actions=${report.globalSearchActions}
module_search_actions=${report.moduleSearchActions}
content_search_controls=${report.contentSearchControls}
global_notification_actions=${report.globalNotificationActions}
context_notification_actions=${report.contextNotificationActions}
content_notification_icons=${report.contentNotificationIcons}
policy_violations=${report.policyViolations}
''';
}

String _renderMarkdown(GlobalAccessReport report) {
  final buffer = StringBuffer()
    ..writeln('# VitTrade Top Header Global Access Policy Audit')
    ..writeln()
    ..writeln(
      'Generated by `flutter_app/tool/top_header_global_access_policy_audit.dart`.',
    )
    ..writeln()
    ..writeln('```text')
    ..write(_renderSummary(report))
    ..writeln('```')
    ..writeln()
    ..writeln('## Policy Entries')
    ..writeln()
    ..writeln('| Kind | Scope | File | Line | Allowed | Issue | Notes |')
    ..writeln('| --- | --- | --- | ---: | --- | --- | --- |');

  for (final entry in report.entries) {
    buffer.writeln(
      '| ${entry.kind} | ${entry.scope} | `${entry.file}` | ${entry.line} | '
      '${entry.allowed ? 'yes' : 'no'} | ${entry.issue} | ${entry.notes} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Source Issues')
    ..writeln();

  if (report.sourceIssues.isEmpty) {
    buffer.writeln('- None.');
  } else {
    for (final issue in report.sourceIssues) {
      buffer.writeln('- $issue');
    }
  }

  return buffer.toString();
}

String _renderCsv(GlobalAccessReport report) {
  final buffer = StringBuffer()
    ..writeln('kind,scope,file,line,allowed,issue,notes');
  for (final entry in report.entries) {
    buffer.writeln(
      [
        entry.kind,
        entry.scope,
        entry.file,
        '${entry.line}',
        entry.allowed ? 'yes' : 'no',
        entry.issue,
        entry.notes,
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

String _relativePath(File file, String repoRoot) {
  final relative = file.path.replaceFirst(repoRoot, '').replaceAll('\\', '/');
  return relative.startsWith('/') ? relative.substring(1) : relative;
}
