// Tablet Sheet Chrome — audit scanner (Bottom-Sheet-Standard, tablet).
//
//   S-chrome — RATCHET lock (2026-09-13): mọi LIBRARY tablet (main + part
//     files; path chứa `/tablet/` hoặc tên file `vit_tablet*`) mở bottom
//     sheet qua `showVitBottomSheet` phải dựng khung bằng `VitSheetPanel`
//     (trực tiếp, qua part file, hoặc qua API chuyên dụng đã bọc panel:
//     showVitNoticeSheet / showVitPreviewConfirmSheet /
//     showVitTradeConfirmSheet / widget sheet panel-backed ở file khác).
//     Đồng thời KHÔNG tự chế chrome: cấm `VitSheetHandle(` /
//     `VitSheetSurface(` trực tiếp ngoài shared/widgets (mọi file vật lý
//     tablet). Nợ ghim trong test/quality/tablet_sheet_chrome_baseline.txt
//     (equality ratchet — sửa file nào thì gỡ dòng đó).
//
//   Pop-over cap 480dp + tier chiều cao KHÔNG do audit này kiểm — chúng nằm
//   trong chính wrapper/panel (behavior unit-test ở
//   test/shared/widgets/vit_bottom_sheet_test.dart), mọi call site tự đúng.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_sheet_audit.dart                   # regen artifact
//   dart run tool/tablet_sheet_audit.dart --check           # CI: artifact + baseline
//   dart run tool/tablet_sheet_audit.dart --regen-baseline  # only when retiring debt
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Sheet-Chrome-Audit.csv';
const _baselinePath = 'test/quality/tablet_sheet_chrome_baseline.txt';
const _scanRoot = 'lib';

final _rawSheetCallRe = RegExp(r'showVitBottomSheet\s*[<(]');
final _partOfRe = RegExp(r"^part\s+of\s+'([^']+)';", multiLine: true);
final _classDefRe = RegExp(
  r'^\s*(?:sealed\s+|base\s+|final\s+|abstract\s+)*class\s+([A-Z][A-Za-z0-9_]*)',
  multiLine: true,
);

class SheetRow {
  const SheetRow(this.rule, this.path, this.detail);
  final String rule;
  final String path;
  final String detail;

  String toCsv() => '$rule,$path,"${detail.replaceAll('"', '""')}"';
}

bool _isTabletFile(String normalizedPath) {
  if (normalizedPath.startsWith('lib/shared/widgets/')) return false;
  return normalizedPath.contains('/tablet/') ||
      normalizedPath.split('/').last.startsWith('vit_tablet');
}

List<SheetRow> scanLib() {
  final root = Directory(_scanRoot);
  if (!root.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  final all = <String, String>{}; // rel lib/ path -> source (toàn lib).
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (!normalized.endsWith('.dart')) continue;
    if (!normalized.startsWith('lib/')) continue;
    if (normalized.contains('/.mimosa/')) continue;
    all[normalized] = entity.readAsStringSync();
  }

  // Pass 1 — lớp "panel-backed": mọi class định nghĩa trong file có dùng
  // VitSheetPanel. Call site ủy quyền sang lớp này (sheet widget ở file
  // khác) coi như hợp chuẩn.
  final panelBackedClasses = <String>[];
  for (final src in all.values) {
    if (!src.contains('VitSheetPanel')) continue;
    for (final m in _classDefRe.allMatches(src)) {
      panelBackedClasses.add(m.group(1)!);
    }
  }

  // Pass 2 — nhóm library tablet (main + parts) theo khuôn tier audit.
  final tabletFiles = all.keys.where(_isTabletFile).toList()..sort();
  final rows = <SheetRow>[];

  // S-chrome-leak — theo file vật lý (tuyệt đối cho mọi file tablet).
  for (final rel in tabletFiles) {
    final src = all[rel]!;
    if (src.contains('VitSheetHandle(') || src.contains('VitSheetSurface(')) {
      rows.add(
        SheetRow(
          'S-chrome-leak',
          rel.replaceFirst('lib/', ''),
          'dùng trực tiếp VitSheetHandle/VitSheetSurface',
        ),
      );
    }
  }

  // S-no-panel — theo library (main + parts).
  final partOwners = <String, String>{};
  for (final rel in tabletFiles) {
    final match = _partOfRe.firstMatch(all[rel]!);
    if (match == null) continue;
    final owner = match.group(1)!.split('/').last;
    final main = rel.substring(0, rel.lastIndexOf('/') + 1) + owner;
    if (all.containsKey(main)) partOwners[rel] = main;
  }
  final tabletMains = tabletFiles
      .where((rel) => _partOfRe.firstMatch(all[rel]!) == null)
      .toList();
  for (final main in tabletMains) {
    final libSrc = StringBuffer(all[main]!);
    partOwners.forEach((part, owner) {
      if (owner == main) libSrc.write(all[part]);
    });
    final src = libSrc.toString();
    if (!_rawSheetCallRe.hasMatch(src)) continue;
    if (src.contains('VitSheetPanel')) continue;
    final delegates = panelBackedClasses.any((name) => src.contains('$name('));
    if (!delegates) {
      rows.add(
        SheetRow(
          'S-no-panel',
          main.replaceFirst('lib/', ''),
          'library mở showVitBottomSheet mà không có VitSheetPanel',
        ),
      );
    }
  }

  rows.sort((a, b) {
    final byRule = a.rule.compareTo(b.rule);
    return byRule != 0 ? byRule : a.path.compareTo(b.path);
  });
  return rows;
}

String _artifactCsv(List<SheetRow> rows) {
  final buf = StringBuffer('rule,path,detail\n');
  for (final row in rows) {
    buf.writeln(row.toCsv());
  }
  return buf.toString();
}

void _selfTest() {
  if (!_isTabletFile('lib/features/trade/presentation/tablet/pages/x.dart')) {
    stderr.writeln('selfTest: tablet-path detection broken (dir).');
    exit(3);
  }
  if (!_isTabletFile('lib/shared/layout/vit_tablet_utility_page.dart')) {
    stderr.writeln('selfTest: tablet-path detection broken (basename).');
    exit(3);
  }
  if (_isTabletFile('lib/shared/widgets/vit_sheet_handle.dart') ||
      _isTabletFile('lib/features/wallet/presentation/phone/pages/x.dart')) {
    stderr.writeln('selfTest: tablet-path detection over-matching.');
    exit(3);
  }
  if (!_rawSheetCallRe.hasMatch('await showVitBottomSheet<void>(x)') ||
      !_rawSheetCallRe.hasMatch('showVitBottomSheet<bool>(x)') ||
      _rawSheetCallRe.hasMatch('showVitNoticeSheet(x)')) {
    stderr.writeln('selfTest: raw-call regex broken.');
    exit(3);
  }
  if (_classDefRe.firstMatch('class FooBar extends X {')?.group(1) !=
          'FooBar' ||
      _classDefRe.firstMatch('  abstract class Pub extends Y {')?.group(1) !=
          'Pub' ||
      // Private class KHÔNG khớp: không thể được tham chiếu chéo file nên
      // không thuộc diện miễn trừ ủy quyền.
      _classDefRe.firstMatch('class _Priv extends Y {') != null ||
      _classDefRe.firstMatch('classy thing') != null) {
    stderr.writeln('selfTest: class-def regex broken.');
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
  final debtPaths = rows.map((r) => r.path).toSet().toList()..sort();

  if (regenBaseline) {
    File(_baselinePath).writeAsStringSync(
      '${debtPaths.join('\n')}${debtPaths.isEmpty ? '' : '\n'}',
    );
    stdout.writeln('Baseline regenerated: ${debtPaths.length} entries.');
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
      '`dart run tool/tablet_sheet_audit.dart` (no --check) '
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
  final stale = baseline.where((p) => !debtPaths.contains(p)).toList();
  final novel = debtPaths.where((p) => !baseline.contains(p)).toList();
  if (stale.isNotEmpty || novel.isNotEmpty) {
    stderr.writeln('Sheet-chrome baseline drift — ratchet is equality:');
    for (final p in stale) {
      stderr.writeln('  fixed (remove from baseline): $p');
    }
    for (final p in novel) {
      stderr.writeln('  new violation (fix or baseline): $p');
    }
    exit(1);
  }
  stdout.writeln(
    'tablet_sheet_audit: baseline ${baseline.length} file, '
    '${rows.length} vi phạm — OK.',
  );
}
