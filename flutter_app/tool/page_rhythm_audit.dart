import 'dart:io';

/// Audits page rhythm: VitPageContent wiring, structural layout, rhythm tier.
void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strict = args.contains('--strict');
  final strictFull = args.contains('--strict-full');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final csvFile = File('${docsDir.path}/audits/VitTrade-Page-Rhythm-Audit.csv');

  final libDir = Directory('${appRoot.path}/lib');
  final rows = <_AuditRow>[];
  final visualDebt = <_VisualDebtRow>[];

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final relative = entity.path.replaceAll('\\', '/').split('/lib/').last;

    final isSharedTabletUtility =
        relative == 'shared/layout/vit_tablet_utility_page.dart';
    if (!relative.contains('/presentation/') && !isSharedTabletUtility) {
      continue;
    }

    final source = entity.readAsStringSync();
    final hasVitPageContent = source.contains('VitPageContent');
    final hasTradeRhythmScaffold = _hasTradeRhythmScaffold(source);
    final hasRhythmOwnerSurface = hasVitPageContent || hasTradeRhythmScaffold;
    final isPartOrWidget =
        relative.contains('_part_') ||
        relative.contains('/presentation/widgets/');

    if (!hasRhythmOwnerSurface && !isPartOrWidget) continue;

    final tier = hasVitPageContent ? _suggestTier(relative) : _Tier.standard;
    final wiring = _scanPhase2bPresentationDebt(source);
    final structural = <String>[];
    var innerGap = const _InnerGapScan(count: 0, violations: 0);
    _Tier? declared;

    if (hasVitPageContent) {
      if (!source.contains('rhythm:') &&
          !source.contains('customGap:') &&
          !source.contains('VitPageRhythm.')) {
        wiring.add('no_rhythm_or_custom_gap');
      }

      final orphanCount = _countOrphanRhythmOwnerSizedBox(source);
      if (orphanCount > 0) {
        wiring.add('orphan_page_rhythm_sizedbox:$orphanCount');
      }

      if (_hasStructuralNestedVitPageContent(source)) {
        wiring.add('nested_vit_page_content');
      }
    } else if (hasTradeRhythmScaffold) {
      final orphanCount = _countOrphanRhythmOwnerSizedBox(source);
      if (orphanCount > 0) {
        wiring.add('orphan_page_rhythm_sizedbox:$orphanCount');
      }
    }

    final moduleMatches = _countModuleSectionGapUsage(source);
    final orphanMajor = _countOrphanMajorColumnSizedBox(source);
    visualDebt.addAll(
      _visualDebtEntries(
        relative: relative,
        source: source,
        moduleGapCount: moduleMatches,
        orphanMajorCount: orphanMajor,
      ),
    );

    if (hasVitPageContent) {
      if (_isPageFile(relative) &&
          !source.contains('page-rhythm: allow-single-child')) {
        if (_hasSingleChildSectionColumn(source)) {
          structural.add('single_child_section_column');
        }
      }

      declared = _extractDeclaredTier(source);
      if (declared != null &&
          _isTabRootPage(relative) &&
          declared != _Tier.compact) {
        structural.add('tab_root_wrong_tier:${declared.name}');
      }
      if (_isTabRootLayout(relative) && !_tabRootLayoutTierOk(source)) {
        structural.add('tab_root_wrong_tier:standard');
      }
    }

    innerGap = _scanInnerGapCompliance(source);
    if (innerGap.violations > 0) {
      structural.add('section_header_missing_inner_gap:${innerGap.violations}');
    }

    final status =
        wiring.isEmpty &&
            _blockingStructural(structural).isEmpty &&
            innerGap.violations == 0
        ? 'pass'
        : 'warn';
    rows.add(
      _AuditRow(
        feature: relative.split('/').elementAtOrNull(1) ?? '',
        file: 'flutter_app/lib/$relative',
        suggestedTier: tier.name,
        declaredTier: declared?.name ?? '',
        hasVitPageContent: hasVitPageContent,
        wiringCount: wiring.length,
        wiringViolations: wiring.join(';'),
        structuralCount: structural.length,
        structuralViolations: structural.join(';'),
        innerGapCount: innerGap.count,
        innerGapViolations: innerGap.violations,
        status: status,
      ),
    );
  }

  rows.sort((a, b) => a.file.compareTo(b.file));
  final csv = _renderCsv(rows);
  final summary = _renderSummary(rows);

  final manifestFile = File(
    '${docsDir.path}/audits/VitTrade-Page-Rhythm-Visual-Debt-Manifest.csv',
  );

  if (checkOnly) {
    if (!csvFile.existsSync()) {
      stderr.writeln('Page rhythm CSV artifact is missing.');
      stderr.writeln(
        'Run `dart run tool/page_rhythm_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    if (csvFile.readAsStringSync() != csv) {
      stderr.writeln('Page rhythm CSV artifact is stale.');
      stderr.writeln(
        'Run `dart run tool/page_rhythm_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    final manifestCsv = _renderVisualDebtCsv(visualDebt);
    if (!manifestFile.existsSync() ||
        manifestFile.readAsStringSync() != manifestCsv) {
      stderr.writeln('Page rhythm visual debt manifest is stale.');
      stderr.writeln(
        'Run `dart run tool/page_rhythm_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    stdout.write(summary);
    stdout.writeln('Page rhythm audit artifact is current.');
    final openVisualDebt = visualDebt
        .where((row) => row.status == 'open')
        .length;
    if (strictFull && openVisualDebt > 0) {
      stderr.writeln(
        '--strict-full: $openVisualDebt open visual-debt row(s) in manifest.',
      );
      exitCode = 1;
      return;
    }
    if (strictFull &&
        rows.any((r) => r.status == 'warn' && _strictFullBlocks(r))) {
      stderr.writeln('--strict-full: repository has page rhythm warnings.');
      exitCode = 1;
      return;
    }
    if (strict && rows.any((r) => r.status == 'warn' && _strictBlocks(r))) {
      stderr.writeln('--strict: repository has page rhythm warnings.');
      exitCode = 1;
    }
    return;
  }

  docsDir.createSync(recursive: true);
  csvFile.writeAsStringSync(csv);
  manifestFile.writeAsStringSync(_renderVisualDebtCsv(visualDebt));
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.writeln('Wrote ${manifestFile.path}');
  stdout.write(summary);
}

/// Bottom-nav tab roots — must use [VitPageRhythm.compact] and direct section children.
const _tabRootPages = {
  'features/home/presentation/phone/pages/home_page.dart',
  'features/profile/presentation/phone/pages/profile_page.dart',
  'features/wallet/presentation/phone/pages/wallet_page.dart',
  'features/trade/presentation/phone/pages/trade_page.dart',
  'features/predictions/presentation/phone/pages/predictions_home_page.dart',
  // Tablet hubs KHÔNG còn trong compact-tier contract: luật 13dp
  // (2026-08-31) đưa mọi section-gap tablet về standard(13) — Markets
  // terminal hub đã chuyển standard cùng đợt sweep toàn dự án.
};

/// Tab rhythm lives in layout widgets when the page file has no [VitPageContent].
const _tabRootLayouts = {
  'features/trade_core/presentation/widgets/trade_module_layout.dart',
};

bool _isTabRootPage(String relativePath) =>
    _tabRootPages.contains(relativePath);

bool _isTabRootLayout(String relativePath) =>
    _tabRootLayouts.contains(relativePath);

bool _tabRootLayoutTierOk(String source) {
  final start = source.indexOf('class VitTradeWorkspaceScaffold');
  if (start < 0) return false;
  final end = source.indexOf('class ', start + 1);
  final body = end > start
      ? source.substring(start, end)
      : source.substring(start);
  return body.contains('rhythm: VitPageRhythm.compact');
}

List<String> _blockingStructural(List<String> structural) {
  return structural
      .where((v) => !v.startsWith('section_header_missing_inner_gap'))
      .toList();
}

bool _strictBlocks(_AuditRow row) {
  if (row.wiringCount > 0) return true;
  return _blockingStructural(row.structuralViolations.split(';')).isNotEmpty;
}

bool _strictFullBlocks(_AuditRow row) {
  if (row.wiringCount > 0) return true;
  if (row.innerGapViolations > 0) return true;
  return _blockingStructural(row.structuralViolations.split(';')).isNotEmpty;
}

final class _InnerGapScan {
  const _InnerGapScan({required this.count, required this.violations});
  final int count;
  final int violations;
}

_InnerGapScan _scanInnerGapCompliance(String source) {
  const headerNames = {'VitSectionHeader', 'VitModuleSectionHeader'};
  var count = 0;
  var violations = 0;
  var index = 0;
  while (index < source.length) {
    String? matched;
    var matchStart = -1;
    for (final name in headerNames) {
      final idx = source.indexOf('$name(', index);
      if (idx >= 0 && (matchStart < 0 || idx < matchStart)) {
        matchStart = idx;
        matched = name;
      }
    }
    if (matched == null || matchStart < 0) break;

    count++;
    final callEnd = _findMatchingParen(source, matchStart + matched.length);
    if (callEnd < 0) {
      index = matchStart + matched.length + 1;
      continue;
    }
    final callBody = source.substring(matchStart, callEnd + 1);
    if (!_headerHasInnerGap(callBody, source, matchStart)) {
      violations++;
    }
    index = callEnd + 1;
  }
  return _InnerGapScan(count: count, violations: violations);
}

bool _headerHasInnerGap(String callBody, String source, int callStart) {
  if (RegExp(
    r'bottomGap:\s*(?:AppSpacing\.pageRhythm\w+InnerGap|VitDensity\.|VitContentGap\.)',
  ).hasMatch(callBody)) {
    return true;
  }

  // Luật 13dp (2026-08-31): bottomGap: AppSpacing.x4 (13dp) là khai báo
  // inner-gap hợp lệ của tablet — tách giá trị khỏi tier phone.
  if (RegExp(
    r'bottomGap:\s*(?:AppSpacing\.x4|AppSpacing\.cardGap)',
  ).hasMatch(callBody)) {
    return true;
  }

  if (callBody.startsWith('VitModuleSectionHeader(') &&
      !RegExp(r'bottomGap:\s*0(?:\.0)?').hasMatch(callBody)) {
    return true;
  }

  final afterEnd = callStart + callBody.length;
  final after = source.substring(
    afterEnd,
    (afterEnd + 640).clamp(0, source.length),
  );
  if (RegExp(
    r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:tradePageContentGap|pageRhythm\w+InnerGap|x[23])',
  ).hasMatch(after)) {
    return true;
  }

  if (_headerInEnclosingClass(source, callStart, 'VitTradeSection')) {
    return true;
  }
  if (_headerInEnclosingClass(source, callStart, 'VitPageSection')) {
    return true;
  }

  final contextStart = (callStart - 400).clamp(0, callStart);
  final prefix = source.substring(contextStart, callStart);
  if (prefix.contains('VitPageSection(') &&
      (prefix.contains('label:') || prefix.contains('innerGap:'))) {
    return true;
  }
  return false;
}

bool _headerInEnclosingClass(String source, int callStart, String className) {
  final marker = 'class $className';
  final sectionStart = source.lastIndexOf(marker, callStart);
  if (sectionStart < 0) return false;
  final nextClass = source.indexOf('\nclass ', sectionStart + marker.length);
  final end = nextClass < 0 ? source.length : nextClass;
  return callStart >= sectionStart && callStart < end;
}

int _findMatchingParen(String source, int openIndex) {
  if (openIndex >= source.length || source[openIndex] != '(') return -1;
  var depth = 0;
  for (var i = openIndex; i < source.length; i++) {
    final char = source[i];
    if (char == '(') depth++;
    if (char == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

bool _isPageFile(String relative) {
  return relative.contains('/presentation/pages/') ||
      RegExp(r'/presentation/(?:phone|tablet|web)/pages/').hasMatch(relative);
}

enum _Tier { compact, standard, form, relaxed, flush }

_Tier _suggestTier(String relativePath) {
  if (_isTabRootPage(relativePath) || _isTabRootLayout(relativePath)) {
    return _Tier.compact;
  }

  if (relativePath.contains('/auth/') ||
      relativePath.contains('/onboarding/') ||
      relativePath.contains('kyc') ||
      relativePath.contains('dispute') ||
      relativePath.contains('payment_method_add') ||
      relativePath.contains('p2p_create_ad') ||
      relativePath.contains('pre_copy_assessment')) {
    return _Tier.form;
  }
  if (relativePath.contains('/home/') ||
      relativePath.contains('/discovery/') ||
      relativePath.contains('/news/') ||
      relativePath.contains('/notifications/') ||
      (relativePath.contains('/markets/') && !relativePath.contains('depth')) ||
      (relativePath.contains('/predictions/') &&
          (relativePath.contains('predictions_home') ||
              relativePath.contains('breaking') ||
              relativePath.contains('leaderboard') ||
              relativePath.contains('activity') ||
              relativePath.contains('search') ||
              relativePath.contains('rewards'))) ||
      (relativePath.contains('/arena/') &&
          (relativePath.contains('leaderboard') ||
              relativePath.contains('my_arena') ||
              relativePath.contains('arena_home')))) {
    return _Tier.compact;
  }
  if (relativePath.contains('/dev/')) {
    return _Tier.flush;
  }
  if (relativePath.contains('advanced_charts')) {
    return _Tier.flush;
  }
  if (relativePath.contains('depth') ||
      relativePath.contains('chart') ||
      relativePath.contains('terminal')) {
    return _Tier.flush;
  }
  if (relativePath.contains('/wallet/') ||
      relativePath.contains('/trade/') ||
      relativePath.contains('/p2p/') ||
      relativePath.contains('/earn/') ||
      relativePath.contains('/profile/')) {
    return _Tier.standard;
  }
  return _Tier.standard;
}

_Tier? _extractDeclaredTier(String source) {
  final match = RegExp(r'rhythm:\s*VitPageRhythm\.(\w+)').firstMatch(source);
  if (match == null) return null;
  return switch (match.group(1)) {
    'compact' => _Tier.compact,
    'standard' => _Tier.standard,
    'form' => _Tier.form,
    'relaxed' => _Tier.relaxed,
    'flush' => _Tier.flush,
    _ => null,
  };
}

bool _hasSingleChildSectionColumn(String source) {
  var index = 0;
  while (true) {
    final start = source.indexOf('VitPageContent', index);
    if (start < 0) return false;

    final childrenIndex = source.indexOf('children:', start);
    if (childrenIndex < 0 || childrenIndex > start + 800) {
      index = start + 1;
      continue;
    }

    final listStart = source.indexOf('[', childrenIndex);
    if (listStart < 0) {
      index = childrenIndex + 1;
      continue;
    }

    final listEnd = _findMatchingBracket(source, listStart);
    if (listEnd < 0) {
      index = listStart + 1;
      continue;
    }

    final listBody = source.substring(listStart + 1, listEnd);
    final items = _splitTopLevelListItems(
      listBody,
    ).map((item) => item.trim()).where((item) => item.isNotEmpty).toList();

    if (items.length == 1 && _looksLikeSectionAggregator(items.first)) {
      return true;
    }
    index = listEnd + 1;
  }
}

bool _looksLikeSectionAggregator(String item) {
  var trimmed = item.trimLeft();
  if (trimmed.startsWith('if (')) return false;
  if (trimmed.startsWith('const ')) {
    trimmed = trimmed.substring('const '.length).trimLeft();
  }
  if (trimmed.startsWith('Column(') || trimmed.startsWith('switch (')) {
    return true;
  }
  if (RegExp(r'^_\w+Body\b').hasMatch(trimmed)) return true;
  if (RegExp(r'^_\w+(Content|Sections|ScrollBody)\b').hasMatch(trimmed)) {
    return true;
  }
  return false;
}

final class _AuditRow {
  const _AuditRow({
    required this.feature,
    required this.file,
    required this.suggestedTier,
    required this.declaredTier,
    required this.hasVitPageContent,
    required this.wiringCount,
    required this.wiringViolations,
    required this.structuralCount,
    required this.structuralViolations,
    required this.innerGapCount,
    required this.innerGapViolations,
    required this.status,
  });

  final String feature;
  final String file;
  final String suggestedTier;
  final String declaredTier;
  final bool hasVitPageContent;
  final int wiringCount;
  final String wiringViolations;
  final int structuralCount;
  final String structuralViolations;
  final int innerGapCount;
  final int innerGapViolations;
  final String status;
}

String _renderCsv(List<_AuditRow> rows) {
  final buffer = StringBuffer(
    'feature,file,suggested_tier,declared_tier,wiring_count,wiring_violations,'
    'structural_count,structural_violations,inner_gap_count,inner_gap_violations,'
    'status\n',
  );
  for (final row in rows) {
    buffer.writeln(
      '${_csv(row.feature)},${_csv(row.file)},${row.suggestedTier},'
      '${row.declaredTier},${row.wiringCount},${_csv(row.wiringViolations)},'
      '${row.structuralCount},${_csv(row.structuralViolations)},'
      '${row.innerGapCount},${row.innerGapViolations},${row.status}',
    );
  }
  return buffer.toString();
}

String _renderSummary(List<_AuditRow> rows) {
  final pass = rows.where((r) => r.status == 'pass').length;
  final warn = rows.where((r) => r.status == 'warn').length;
  final structural = rows.where((r) => r.structuralCount > 0).length;
  final innerGapDebt = rows.where((r) => r.innerGapViolations > 0).length;
  final vpcFiles = rows.where((r) => r.hasVitPageContent).length;
  final phase2bDebt = rows
      .where(
        (r) =>
            r.wiringViolations.contains('legacy_section_title') ||
            r.wiringViolations.contains('legacy_section_gap'),
      )
      .length;
  return 'Page rhythm audit: ${rows.length} presentation files '
      '($vpcFiles with VitPageContent wiring), '
      '$pass pass, $warn warn ($structural structural, $innerGapDebt inner gap, '
      '$phase2bDebt phase2b legacy).\n';
}

/// Phase 2b: local section title wrappers and legacy 20px section gap.
List<String> _scanPhase2bPresentationDebt(String source) {
  final debt = <String>[];
  if (RegExp(r'class _SectionTitle\b').hasMatch(source)) {
    debt.add('legacy_section_title');
  }
  final legacyGap = RegExp(
    r'SizedBox\s*\(\s*height:\s*AppSpacing\.sectionGap\b',
  ).allMatches(source).length;
  if (legacyGap > 0) {
    debt.add('legacy_section_gap:$legacyGap');
  }
  return debt;
}

String _csv(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

final _orphanMajorSizedBoxLine = RegExp(
  r'^\s*(?:const\s+)?SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x[5-7])[^)]*\)\s*,?\s*$',
);

/// Legacy Fibonacci scale (x5–x7) in vertical SizedBox — includes compound expressions.
final _legacyScaleSizedBoxHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*[^)]*AppSpacing\.(?:x[5-7])',
);

/// Plain x3/x4 vertical SizedBox (Phase 5 semantic debt).
final _legacyX34PlainHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x3|x4)\b',
);

/// Plain x2 vertical SizedBox (Phase 6 semantic debt).
final _legacyX2PlainHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.x2\b',
);

/// Raw customGap on Fibonacci scale (Phase 6).
final _legacyCustomGapRawScale = RegExp(r'customGap:\s*AppSpacing\.(x[1-7])\b');

/// Compound x3/x4 in vertical rhythm SizedBox (Phase 6).
final _legacyCompoundX34Height = RegExp(
  r'SizedBox\s*\(\s*height:\s*[^)]*AppSpacing\.(?:x3|x4)[^)]*[+\-][^)]*\)',
);

/// Magic literal (+ digit) in rhythm SizedBox (Phase 6).
final _magicNumberRhythmSizedBox = RegExp(
  r'SizedBox\s*\(\s*(?:height|width):\s*[^)]*AppSpacing\.x[0-7]\s*\+\s*[0-9]',
);

/// Orphan x1 between major column siblings (Phase 6).
final _orphanX1MajorSizedBoxLine = RegExp(
  r'^\s*(?:const\s+)?SizedBox\s*\(\s*height:\s*AppSpacing\.x1\b[^)]*\)\s*,?\s*$',
);

int _countOrphanMajorColumnSizedBox(String source) {
  var count = 0;
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (!_orphanMajorSizedBoxLine.hasMatch(line)) continue;
    if (_lineInsideVitCard(source, i)) continue;
    if (_lineInColumnChildrenContext(lines, i)) count++;
  }
  return count;
}

bool _lineInsideVitCard(String source, int lineIndex) {
  final lines = source.split('\n');
  var depth = 0;
  for (var i = 0; i <= lineIndex && i < lines.length; i++) {
    final line = lines[i];
    if (line.contains('VitCard(')) depth++;
    if (line.contains('),') && depth > 0 && i < lineIndex) {
      // Imperfect but avoids most in-card gaps.
    }
  }
  final prefix = lines.take(lineIndex + 1).join('\n');
  final opens = 'VitCard('.allMatches(prefix).length;
  final inners = 'variant: VitCardVariant.inner'.allMatches(prefix).length;
  return opens > inners + 2;
}

bool _lineInColumnChildrenContext(List<String> lines, int lineIndex) {
  for (var i = lineIndex; i >= 0 && i > lineIndex - 12; i--) {
    if (lines[i].contains('children: [')) return true;
  }
  return false;
}

bool _orphanX1DirectChild(String item) {
  final trimmed = item.trim();
  if (trimmed.contains('...') || trimmed.startsWith('if (')) return false;
  var work = trimmed;
  if (work.startsWith('const ')) work = work.substring(6).trimLeft();
  return work.startsWith('SizedBox(') &&
      _orphanX1MajorSizedBoxLine.hasMatch(trimmed);
}

bool _lineInRhythmOwnerDirectChildItem(
  String source,
  int lineIndex,
  bool Function(String item) isOrphanItem,
) {
  final lines = source.split('\n');
  if (lineIndex < 0 || lineIndex >= lines.length) return false;

  for (final owner in _rhythmOwnerWidgets) {
    var index = 0;
    while (true) {
      final start = source.indexOf(owner, index);
      if (start < 0) break;

      final childrenIndex = source.indexOf('children:', start);
      if (childrenIndex < 0 || childrenIndex > start + 800) {
        index = start + 1;
        continue;
      }

      final listStart = source.indexOf('[', childrenIndex);
      if (listStart < 0) {
        index = childrenIndex + 1;
        continue;
      }

      final listEnd = _findMatchingBracket(source, listStart);
      if (listEnd < 0) {
        index = listStart + 1;
        continue;
      }

      final listBody = source.substring(listStart + 1, listEnd);
      for (final item in _splitTopLevelListItems(listBody)) {
        if (!isOrphanItem(item)) continue;
        final trimmed = item.trim();
        final itemStart = source.indexOf(trimmed, listStart);
        if (itemStart < 0) continue;
        final itemStartLine =
            source.substring(0, itemStart).split('\n').length - 1;
        final itemEndLine =
            source.substring(0, itemStart + trimmed.length).split('\n').length -
            1;
        if (lineIndex >= itemStartLine && lineIndex <= itemEndLine) {
          return true;
        }
      }
      index = listEnd + 1;
    }
  }
  return false;
}

final class _VisualDebtRow {
  const _VisualDebtRow({
    required this.file,
    required this.line,
    required this.token,
    required this.px,
    required this.category,
    required this.batch,
    required this.status,
  });

  final String file;
  final int line;
  final String token;
  final int px;
  final String category;
  final String batch;
  final String status;
}

List<_VisualDebtRow> _visualDebtEntries({
  required String relative,
  required String source,
  required int moduleGapCount,
  required int orphanMajorCount,
}) {
  final file = 'flutter_app/lib/$relative';
  final entries = <_VisualDebtRow>[];
  final lines = source.split('\n');
  final isDepthFlush = relative.contains('market_depth');
  final isFormSurface =
      relative.contains('wallet_buy') ||
      relative.contains('payment_method') ||
      relative.contains('token_approval');

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final moduleMatch = _moduleSectionGapSizedBox.firstMatch(line);
    if (moduleMatch != null) {
      final token = moduleMatch.group(1)!;
      entries.add(
        _VisualDebtRow(
          file: file,
          line: i + 1,
          token: token,
          px: 16,
          category: 'module_section_gap',
          batch: isDepthFlush || isFormSurface ? 'documented' : '16',
          status: isDepthFlush || isFormSurface ? 'exception' : 'open',
        ),
      );
    }
    if (_legacyScaleSizedBoxHeight.hasMatch(line) &&
        !line.contains('pageRhythm')) {
      final inCard = _lineInsideVitCard(source, i);
      final inColumn = _lineInColumnChildrenContext(lines, i);
      if (inColumn || inCard) {
        final scaleMatch = RegExp(r'AppSpacing\.(x[5-7])').firstMatch(line);
        entries.add(
          _VisualDebtRow(
            file: file,
            line: i + 1,
            token: scaleMatch?.group(1) ?? 'x5',
            px: scaleMatch?.group(1) == 'x6'
                ? 34
                : scaleMatch?.group(1) == 'x7'
                ? 55
                : 21,
            category: inCard
                ? 'legacy_scale_sizedbox_in_card'
                : 'orphan_major_sizedbox',
            batch: '22',
            status: 'open',
          ),
        );
      }
    }
    if (_legacyX34PlainHeight.hasMatch(line) &&
        !line.contains('+') &&
        !line.contains('-') &&
        !line.contains('pageRhythm')) {
      final inColumn = _lineInColumnChildrenContext(lines, i);
      if (inColumn || _lineInsideVitCard(source, i)) {
        final tokenMatch = RegExp(r'AppSpacing\.(x[34])').firstMatch(line);
        // Luật 13dp (2026-08-31): SizedBox khe x4 (13dp) trong file tablet
        // presentation là PHÁP ĐỊNH — mọi khoảng trống dọc+ngang trên
        // tablet đều 13, guardrail tablet_gap_13_guardrail_test khóa
        // zero-tolerance. Chỉ còn debt khi x4 nằm ngoài tablet (phone/web
        // chưa áp luật) hoặc khi giá trị là x3 (8 ≠ 13).
        final isTabletPresentation =
            file.contains('/presentation/tablet/') ||
            file.contains('/presentation/widgets/tablet/') ||
            file.contains('/app/shell/tablet/');
        final tokenIsLawful13 = tokenMatch?.group(1) == 'x4';
        if (!(isTabletPresentation && tokenIsLawful13)) {
          entries.add(
            _VisualDebtRow(
              file: file,
              line: i + 1,
              token: tokenMatch?.group(1) ?? 'x3',
              px: tokenMatch?.group(1) == 'x4' ? 13 : 8,
              category: 'legacy_scale_sizedbox_x3_x4',
              batch: '32',
              status: 'open',
            ),
          );
        }
      }
    }
    final customGapMatch = _legacyCustomGapRawScale.firstMatch(line);
    // Luật 13dp (2026-08-31): customGap: AppSpacing.x4 (13dp) trong file
    // tablet presentation là PHÁP ĐỊNH — mọi khoảng trống tablet = 13.
    final customGapTabletLawful =
        customGapMatch != null &&
        customGapMatch.group(1) == 'x4' &&
        (file.contains('/presentation/tablet/') ||
            file.contains('/presentation/widgets/tablet/'));
    if (customGapMatch != null && !customGapTabletLawful) {
      entries.add(
        _VisualDebtRow(
          file: file,
          line: i + 1,
          token: customGapMatch.group(1)!,
          px: 0,
          category: 'legacy_customgap_raw_scale',
          batch: '41',
          status: 'open',
        ),
      );
    }
    if (_legacyCompoundX34Height.hasMatch(line) &&
        !line.contains('pageRhythm')) {
      entries.add(
        _VisualDebtRow(
          file: file,
          line: i + 1,
          token: 'x3/x4 compound',
          px: 0,
          category: 'legacy_compound_sizedbox_x34',
          batch: '42',
          status: 'open',
        ),
      );
    }
    if (_magicNumberRhythmSizedBox.hasMatch(line)) {
      entries.add(
        _VisualDebtRow(
          file: file,
          line: i + 1,
          token: 'magic literal',
          px: 0,
          category: 'magic_number_spacing',
          batch: '43',
          status: 'open',
        ),
      );
    }
    if (_legacyX2PlainHeight.hasMatch(line) && !line.contains('pageRhythm')) {
      final inColumn = _lineInColumnChildrenContext(lines, i);
      if (inColumn && !_lineInsideVitCard(source, i)) {
        entries.add(
          _VisualDebtRow(
            file: file,
            line: i + 1,
            token: 'x2',
            px: 5,
            category: 'legacy_scale_sizedbox_x2',
            batch: '44',
            status: 'open',
          ),
        );
      }
    }
    if (_orphanX1MajorSizedBoxLine.hasMatch(line) &&
        _lineInRhythmOwnerDirectChildItem(source, i, _orphanX1DirectChild)) {
      entries.add(
        _VisualDebtRow(
          file: file,
          line: i + 1,
          token: 'x1',
          px: 3,
          category: 'orphan_x1_major_gap',
          batch: '45',
          status: 'open',
        ),
      );
    }
    if (_orphanPageRhythmSizedBoxLine.hasMatch(line) &&
        _lineInRhythmOwnerDirectChildItem(
          source,
          i,
          _isOrphanSizedBoxDirectChild,
        )) {
      final tokenMatch = RegExp(
        r'AppSpacing\.(pageRhythm\w+)',
      ).firstMatch(line);
      entries.add(
        _VisualDebtRow(
          file: file,
          line: i + 1,
          token: tokenMatch?.group(1) ?? 'pageRhythm',
          px: 0,
          category: 'orphan_page_rhythm_sizedbox',
          batch: '50',
          status: 'open',
        ),
      );
    }
  }

  if (entries.isEmpty && moduleGapCount == 0 && orphanMajorCount == 0) {
    return entries;
  }
  return entries;
}

String _renderVisualDebtCsv(List<_VisualDebtRow> rows) {
  final buffer = StringBuffer('file,line,token,px,category,batch,status\n');
  for (final row in rows) {
    buffer.writeln(
      '${_csv(row.file)},${row.line},${_csv(row.token)},${row.px},'
      '${_csv(row.category)},${_csv(row.batch)},${_csv(row.status)}',
    );
  }
  return buffer.toString();
}

final _moduleSectionGapSizedBox = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?!pageRhythm)(\w+SectionGap)',
);

int _countModuleSectionGapUsage(String source) {
  return _moduleSectionGapSizedBox.allMatches(source).length;
}

const _rhythmOwnerWidgets = [
  'VitPageContent',
  'VitTradeHubScaffold',
  'VitTradeDetailScaffold',
  'VitTradeSimpleShell',
];

bool _hasTradeRhythmScaffold(String source) {
  return source.contains('VitTradeHubScaffold') ||
      source.contains('VitTradeDetailScaffold') ||
      source.contains('VitTradeSimpleShell') ||
      source.contains('VitTwoColumnTabletDashboard');
}

final _orphanPageRhythmSizedBoxLine = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.pageRhythm',
);

int _countOrphanRhythmOwnerSizedBox(String source) {
  var count = 0;
  for (final owner in _rhythmOwnerWidgets) {
    var index = 0;
    while (true) {
      final start = source.indexOf(owner, index);
      if (start < 0) break;

      final childrenIndex = source.indexOf('children:', start);
      if (childrenIndex < 0 || childrenIndex > start + 800) {
        index = start + 1;
        continue;
      }

      final listStart = source.indexOf('[', childrenIndex);
      if (listStart < 0) {
        index = childrenIndex + 1;
        continue;
      }

      final listEnd = _findMatchingBracket(source, listStart);
      if (listEnd < 0) {
        index = listStart + 1;
        continue;
      }

      final listBody = source.substring(listStart + 1, listEnd);
      for (final item in _splitTopLevelListItems(listBody)) {
        if (_isOrphanSizedBoxDirectChild(item)) count++;
      }
      index = listEnd + 1;
    }
  }
  return count;
}

bool _isOrphanSizedBoxDirectChild(String item) {
  final trimmed = item.trim();
  if (trimmed.isEmpty) return false;
  if (trimmed.contains('...') || trimmed.startsWith('if (')) return false;
  if (trimmed.contains('Column(') ||
      trimmed.contains('Row(') ||
      trimmed.contains('VitTradeSection(') ||
      trimmed.contains('VitPageSection(')) {
    return false;
  }
  var work = trimmed;
  if (work.startsWith('const ')) work = work.substring(6).trimLeft();
  if (!work.startsWith('SizedBox(')) return false;
  return _orphanSizedBoxHeightPattern.hasMatch(trimmed);
}

final _orphanSizedBoxHeightPattern = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x[3-7]|sectionGap|sectionGapCompact|pageContentGap|pageRhythm(?:Compact|Standard|Form|Relaxed)(?:Inner|Section)Gap)',
);

bool _hasStructuralNestedVitPageContent(String source) {
  var index = 0;
  while (true) {
    final start = source.indexOf('VitPageContent', index);
    if (start < 0) return false;

    final childrenIndex = source.indexOf('children:', start);
    if (childrenIndex < 0 || childrenIndex > start + 800) {
      index = start + 1;
      continue;
    }

    final listStart = source.indexOf('[', childrenIndex);
    if (listStart < 0) {
      index = childrenIndex + 1;
      continue;
    }

    final listEnd = _findMatchingBracket(source, listStart);
    if (listEnd < 0) {
      index = listStart + 1;
      continue;
    }

    final listBody = source.substring(listStart + 1, listEnd);
    for (final item in _splitTopLevelListItems(listBody)) {
      if (_directChildIsVitPageContent(item)) return true;
    }
    index = listEnd + 1;
  }
}

bool _directChildIsVitPageContent(String item) {
  var trimmed = item.trimLeft();
  if (trimmed.startsWith('const ')) {
    trimmed = trimmed.substring('const '.length).trimLeft();
  }
  return trimmed.startsWith('VitPageContent(');
}

List<String> _splitTopLevelListItems(String listBody) {
  final items = <String>[];
  final buffer = StringBuffer();
  var depth = 0;
  var parenDepth = 0;

  for (var i = 0; i < listBody.length; i++) {
    final char = listBody[i];
    if (char == '[') depth++;
    if (char == ']') depth--;
    if (char == '(') parenDepth++;
    if (char == ')') parenDepth--;

    if (char == ',' && depth == 0 && parenDepth == 0) {
      items.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }

  if (buffer.isNotEmpty) items.add(buffer.toString());
  return items;
}

int _findMatchingBracket(String source, int openIndex) {
  var depth = 0;
  for (var i = openIndex; i < source.length; i++) {
    final char = source[i];
    if (char == '[') depth++;
    if (char == ']') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
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

/// Exposed for guardrail tests — parse baseline structural debt from CSV row.
Map<String, String> parsePageRhythmBaselineRow(String line) {
  final parts = _parseCsvLine(line);
  if (parts.length < 9) return {};
  return {
    'file': parts[1],
    'structural_violations': parts.length > 7 ? parts[7] : '',
    'inner_gap_violations': parts.length > 9 ? parts[9] : '0',
  };
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
