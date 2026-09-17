// Tablet Composition Tier — audit scanner.
//
//   T1 registry-scaffold — RATCHET lock (2026-09-13): every tablet page
//     LIBRARY (main file + its `part` files) under
//     lib/features/**/presentation/tablet/pages/ must construct at least one
//     sanctioned scaffold/surface from the registry below. Existing debt is
//     pinned in test/quality/tablet_composition_tier_baseline.txt
//     (regen only via --regen-baseline; baseline must EQUAL the current
//     failing set — fixing a file requires removing its entry).
//   T2 banned-pattern — ABSOLUTE lock: zero `VitAutoHidePageScaffold(`
//     (Tablet-Adaptive R9 anti-pattern) and zero hand-rolled
//     `class …Frame extends` page frames (tablet-gd56 debt class) in any
//     tablet page file. No baseline — any violation fails the run.
//
// The registry is the single source of truth for "which page skeleton a
// tablet screen may build" (New-Screen-Definition-of-Done §1 + the
// Tablet-Adaptive-Standard archetype table). Feature-level sanctioned
// surfaces (`AuthTabletSurface`, `TradeTabletDetailSurface`,
// `WalletTabletDetailSurface`, `*TabletMasterShell`, `*PaneScaffold`) match
// by substring so new feature shells are covered without editing this file.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_composition_tier_audit.dart                   # regen artifact
//   dart run tool/tablet_composition_tier_audit.dart --check           # CI: artifact + baseline
//   dart run tool/tablet_composition_tier_audit.dart --regen-baseline  # only when retiring debt
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Composition-Tier-Audit.csv';
const _baselinePath = 'test/quality/tablet_composition_tier_baseline.txt';
const _pagesGlobDir = 'lib/features';

/// Sanctioned tablet page scaffolds/surfaces (matched by constructor-call
/// substring anywhere in the library's source, main file + parts).
const _registryScaffolds = <String>[
  'VitTwoColumnTabletDashboard(',
  'VitTabletPaneWorkspace(',
  'VitTabletSectionFrame(',
  'VitTabletSectionBody(',
  'VitPageLayout(',
  'VitPageContent(',
  'VitTradeDetailScaffold(',
  'WalletTabletDetailSurface(',
  'TradeTabletDetailSurface(',
  'AuthTabletSurface(',
  'TabletMasterShell(',
  'PaneScaffold(',
];

final _partOfRe = RegExp(r"^part\s+of\s+'([^']+)';", multiLine: true);
final _frameClassRe = RegExp(r'^class\s+_?[A-Z][A-Za-z0-9_]*Frame\s');
const _bannedPatterns = <String, String>{
  'VitAutoHidePageScaffold(': 'T2-auto-hide-scaffold-r9',
};

class TierRow {
  const TierRow(this.rule, this.path, this.detail);
  final String rule;
  final String path;
  final String detail;

  String toCsv() => '$rule,$path,"${detail.replaceAll('"', '""')}"';
}

List<TierRow> scanLib() {
  final rows = <TierRow>[];
  final files = <File>[];
  final dir = Directory(_pagesGlobDir);
  if (!dir.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (!normalized.endsWith('.dart')) continue;
    if (!normalized.contains('/presentation/tablet/pages/')) continue;
    if (normalized.contains('/.mimosa/')) continue;
    files.add(entity);
  }
  final source = <String, String>{
    for (final f in files) f.path.replaceAll('\\', '/'): f.readAsStringSync(),
  };
  final mains = <String>[];
  final partOwners = <String, String>{};
  final allRel = <String>[];
  for (final abs in source.keys) {
    final rel = abs.replaceFirst('lib/', '');
    allRel.add(rel);
    final match = _partOfRe.firstMatch(source[abs]!);
    if (match == null) {
      mains.add(rel);
    } else {
      final owner = match.group(1)!.split('/').last;
      final main = abs.substring(0, abs.lastIndexOf('/') + 1) + owner;
      if (source.containsKey(main)) {
        partOwners[rel] = main.replaceFirst('lib/', '');
      }
    }
  }
  // T2 — banned patterns, absolute zero, per physical file.
  for (final rel in allRel) {
    final src = source['lib/$rel']!;
    for (final entry in _bannedPatterns.entries) {
      if (src.contains(entry.key)) {
        rows.add(TierRow(entry.value, rel, entry.key));
      }
    }
    for (final line in src.split('\n')) {
      if (line.trimLeft().startsWith('//')) continue;
      if (_frameClassRe.hasMatch(line)) {
        rows.add(TierRow('T2-frame-class', rel, line.trim()));
      }
    }
  }
  // T1 — per library (main + parts), must build a registry scaffold.
  for (final main in mains) {
    final libSrc = StringBuffer(source['lib/$main']!);
    source.forEach((abs, src) {
      final rel = abs.replaceFirst('lib/', '');
      if (partOwners[rel] == main) libSrc.write(src);
    });
    final usesRegistry = _registryScaffolds.any(libSrc.toString().contains);
    if (!usesRegistry) {
      rows.add(TierRow('T1-no-registry-scaffold', main, 'library'));
    }
  }
  rows.sort((a, b) {
    final byRule = a.rule.compareTo(b.rule);
    return byRule != 0 ? byRule : a.path.compareTo(b.path);
  });
  return rows;
}

String _artifactCsv(List<TierRow> rows) {
  final buf = StringBuffer('rule,path,detail\n');
  for (final row in rows) {
    buf.writeln(row.toCsv());
  }
  return buf.toString();
}

void _selfTest() {
  const fakeLib = '''
part 'x_sections.dart';
class FakePage extends StatelessWidget {
  Widget build() => VitTwoColumnTabletDashboard(primaryChildren: const []);
}
''';
  if (!_registryScaffolds.any(fakeLib.contains)) {
    stderr.writeln('selfTest: registry substring match broken.');
    exit(3);
  }
  if (_registryScaffolds.any(
    'class BarePage extends StatelessWidget {}'.contains,
  )) {
    stderr.writeln('selfTest: registry matched an empty library.');
    exit(3);
  }
  if (!_frameClassRe.hasMatch(
        'class _MarketsFrame extends StatelessWidget {',
      ) ||
      _frameClassRe.hasMatch(
        'class MarketsFrameHostPage extends StatelessWidget {',
      )) {
    stderr.writeln('selfTest: frame-class regex broken.');
    exit(3);
  }
  if (_partOfRe.firstMatch("part of 'foo_tablet_page.dart';")?.group(1) !=
      'foo_tablet_page.dart') {
    stderr.writeln('selfTest: part-of regex broken.');
    exit(3);
  }
}

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');
  final regenBaseline = args.contains('--regen-baseline');

  final rows = scanLib();
  final t1 = rows.where((r) => r.rule == 'T1-no-registry-scaffold').toList();
  final t2 = rows.where((r) => r.rule.startsWith('T2-')).toList();
  final t1Paths = t1.map((r) => r.path).toList()..sort();

  if (regenBaseline) {
    if (t2.isNotEmpty) {
      stderr.writeln('T2 is absolute-zero — fix violations, do not baseline.');
      exit(1);
    }
    File(
      _baselinePath,
    ).writeAsStringSync('${t1Paths.join('\n')}${t1Paths.isEmpty ? '' : '\n'}');
    stdout.writeln(
      'Baseline regenerated: ${t1Paths.length} T1 entries, ${t2.length} T2.',
    );
  }

  final artifact = File(_artifactPath);
  final csv = _artifactCsv(rows);
  if (!checkOnly) {
    artifact
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(csv);
    stdout.writeln('Artifact written: $_artifactPath (${rows.length} rows).');
  } else if (!artifact.existsSync() || artifact.readAsStringSync() != csv) {
    stderr.writeln(
      'Stale artifact $_artifactPath — run '
      '`dart run tool/tablet_composition_tier_audit.dart` (no --check) '
      'and commit the artifact with the code.',
    );
    exit(1);
  }

  final baselineFile = File(_baselinePath);
  if (!baselineFile.existsSync()) {
    stderr.writeln('Missing baseline $_baselinePath — run --regen-baseline.');
    exit(1);
  }
  final baseline =
      baselineFile
          .readAsLinesSync()
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && !l.startsWith('#'))
          .toList()
        ..sort();
  final stale = baseline.where((p) => !t1Paths.contains(p)).toList();
  final novel = t1Paths.where((p) => !baseline.contains(p)).toList();
  if (stale.isNotEmpty || novel.isNotEmpty) {
    stderr.writeln('T1 baseline drift — ratchet is equality:');
    for (final p in stale) {
      stderr.writeln('  fixed (remove from baseline): $p');
    }
    for (final p in novel) {
      stderr.writeln('  new violation (fix or baseline): $p');
    }
    exit(1);
  }
  for (final row in t2) {
    stderr.writeln('${row.rule}: ${row.path} — ${row.detail}');
  }
  stdout.writeln(
    'tablet_composition_tier_audit: T1 baseline ${t1Paths.length}, '
    'T2 violations ${t2.length} — OK.',
  );
}
