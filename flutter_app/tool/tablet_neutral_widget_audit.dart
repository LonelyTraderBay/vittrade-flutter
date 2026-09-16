// Tablet Neutral Widget Audit — Surface-Architecture-Standard, section
// "Module Composition Pattern" (khóa 2026-09-16).
//
//   N-tablet-only — đường trung tính `features/*/presentation/widgets/**`
//   (path KHÔNG khai báo bề mặt: không chứa /tablet/, /phone/, /web/) chỉ
//   được chứa widget dual-surface. Widget chỉ tablet-dùng (trực tiếp HOẶC
//   qua chuỗi import — bẫy wallet address-add: phone vào transitively qua
//   wallet_address_add_sections.dart, không phải import trực tiếp) phải nằm
//   ở `presentation/widgets/tablet/`.
//
//   N-tablet-part — part file của library tablet không được đặt ở đường
//   trung tính (part phải cùng thư mục lib cha — ARCH-A4).
//
//   Widget phone-only ở đường trung tính là nợ đội phone — audit này KHÔNG
//   bắt (scope tablet-only chốt 2026-09-16).
//
// Usage (from flutter_app/):
//   dart run tool/tablet_neutral_widget_audit.dart                   # regen artifact
//   dart run tool/tablet_neutral_widget_audit.dart --check           # CI: artifact + baseline
//   dart run tool/tablet_neutral_widget_audit.dart --regen-baseline  # chỉ khi trả nợ
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Neutral-Widget-Audit.csv';
const _baselinePath = 'test/quality/tablet_neutral_widget_baseline.txt';
const _scanRoot = 'lib';
const _pkgPrefix = 'package:vit_trade_flutter/';

final _importOrExportRe = RegExp(
  r"^(?:import|export)\s+'([^']+)';",
  multiLine: true,
);
final _partOfRe = RegExp(r"^part\s+of\s+'([^']+)';", multiLine: true);
final _neutralWidgetRe = RegExp(
  r'^lib/features/[a-z0-9_]+/presentation/widgets/.+\.dart$',
);
final _surfaceSegRe = RegExp(r'/(tablet|phone|web)/');

bool _isNeutralWidget(String p) =>
    _neutralWidgetRe.hasMatch(p) && !_surfaceSegRe.hasMatch(p);

bool _isPhoneRoot(String p) =>
    (p.startsWith('lib/features/') && p.contains('/presentation/phone/')) ||
    p.startsWith('lib/app/shell/phone/') ||
    p.startsWith('lib/app/router/phone/');

bool _isTabletRoot(String p) =>
    (p.startsWith('lib/features/') && p.contains('/presentation/tablet/')) ||
    p.startsWith('lib/app/shell/tablet/') ||
    p.startsWith('lib/app/router/tablet/');

/// Giải URI import (package:vit_trade_flutter hoặc relative) về path dưới
/// lib/; trả null cho dart:/package ngoài app và URI không phải file .dart.
String? _resolveImport(String fromFile, String uri) {
  if (uri.startsWith(_pkgPrefix)) {
    final rest = uri.substring(_pkgPrefix.length);
    return rest.endsWith('.dart') ? 'lib/$rest' : null;
  }
  if (uri.startsWith('dart:') || uri.startsWith('package:')) return null;
  if (!uri.endsWith('.dart')) return null;
  final segs = fromFile.split('/')..removeLast();
  for (final seg in uri.split('/')) {
    if (seg.isEmpty || seg == '.') continue;
    if (seg == '..') {
      if (segs.isNotEmpty) segs.removeLast();
      continue;
    }
    segs.add(seg);
  }
  return segs.join('/');
}

class _WidgetRow {
  const _WidgetRow(this.rule, this.path, this.detail);
  final String rule;
  final String path;
  final String detail;

  String toCsv() => '$rule,$path,"${detail.replaceAll('"', '""')}"';
}

/// Tập file được surface dùng: root + mọi file mở (trực tiếp hoặc qua chuỗi
/// import/export) ra một file đã thuộc tập — BFS trên đồ thị đảo.
Set<String> _usedBy(
  Map<String, List<String>> imports,
  Set<String> files,
  bool Function(String) isRoot,
) {
  final reverse = <String, List<String>>{};
  imports.forEach((from, targets) {
    for (final t in targets) {
      reverse.putIfAbsent(t, () => []).add(from);
    }
  });
  final seen = <String>{};
  final queue = <String>[
    for (final f in files)
      if (isRoot(f)) f,
  ];
  for (var i = 0; i < queue.length; i++) {
    final cur = queue[i];
    if (!seen.add(cur)) continue;
    for (final importer in reverse[cur] ?? const <String>[]) {
      if (!seen.contains(importer)) queue.add(importer);
    }
  }
  return seen;
}

List<_WidgetRow> _scanLib() {
  final root = Directory(_scanRoot);
  if (!root.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  final all = <String, String>{}; // path lib/ -> source
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (!normalized.endsWith('.dart')) continue;
    if (!normalized.startsWith('lib/')) continue;
    if (normalized.contains('/.mimosa/')) continue;
    all[normalized] = entity.readAsStringSync();
  }

  // Đồ thị import/export (chỉ cạnh tới file tồn tại trong lib/).
  final imports = <String, List<String>>{};
  for (final entry in all.entries) {
    final targets = <String>[];
    for (final m in _importOrExportRe.allMatches(entry.value)) {
      final resolved = _resolveImport(entry.key, m.group(1)!);
      if (resolved != null &&
          resolved != entry.key &&
          all.containsKey(resolved)) {
        targets.add(resolved);
      }
    }
    imports[entry.key] = targets;
  }

  final phoneUsed = _usedBy(imports, all.keys.toSet(), _isPhoneRoot);
  final tabletUsed = _usedBy(imports, all.keys.toSet(), _isTabletRoot);

  final rows = <_WidgetRow>[];
  for (final path in all.keys.where(_isNeutralWidget).toList()..sort()) {
    final src = all[path]!;
    final partOf = _partOfRe.firstMatch(src);
    if (partOf != null) {
      // Part file: usage xác định bởi library cha — tablet library không
      // được để part ở đường trung tính.
      final owner = _resolveImport(path, partOf.group(1)!);
      if (owner != null && all.containsKey(owner) && _isTabletRoot(owner)) {
        rows.add(
          _WidgetRow(
            'N-tablet-part',
            path.replaceFirst('lib/', ''),
            'part của library tablet ($owner) đặt ở đường trung tính — dời về cùng thư mục lib cha',
          ),
        );
      }
      continue;
    }
    if (tabletUsed.contains(path) && !phoneUsed.contains(path)) {
      rows.add(
        _WidgetRow(
          'N-tablet-only',
          path.replaceFirst('lib/', ''),
          'widget chỉ tablet dùng (trực tiếp/gián tiếp) — dời sang presentation/widgets/tablet/',
        ),
      );
    }
  }

  rows.sort(
    (a, b) => a.path.compareTo(b.path) != 0
        ? a.path.compareTo(b.path)
        : a.rule.compareTo(b.rule),
  );
  return rows;
}

String _artifactCsv(List<_WidgetRow> rows) {
  final buf = StringBuffer('rule,path,detail\n');
  for (final row in rows) {
    buf.writeln(row.toCsv());
  }
  return buf.toString();
}

void _selfTest() {
  if (_resolveImport(
            'lib/a/b.dart',
            'package:vit_trade_flutter/features/x/y.dart',
          ) !=
          'lib/features/x/y.dart' ||
      _resolveImport('lib/a/b/c.dart', '../d.dart') != 'lib/a/d.dart' ||
      _resolveImport('lib/a/b/c.dart', '../../e/f.dart') != 'lib/e/f.dart' ||
      _resolveImport('lib/a/b.dart', 'dart:io') != null ||
      _resolveImport('lib/a/b.dart', 'package:flutter/material.dart') != null) {
    stderr.writeln('selfTest: import resolution broken.');
    exit(3);
  }
  if (!_isNeutralWidget(
        'lib/features/wallet/presentation/widgets/address/wallet_address_add_common.dart',
      ) ||
      _isNeutralWidget(
        'lib/features/markets/presentation/widgets/tablet/markets_depth_pane.dart',
      ) ||
      _isNeutralWidget('lib/features/dca/presentation/widgets/phone/x.dart') ||
      _isNeutralWidget('lib/shared/widgets/vit_card.dart')) {
    stderr.writeln('selfTest: neutral-widget classification broken.');
    exit(3);
  }
  if (!_isPhoneRoot('lib/features/wallet/presentation/phone/pages/x.dart') ||
      _isTabletRoot('lib/features/wallet/presentation/phone/pages/x.dart') ||
      !_isTabletRoot('lib/features/wallet/presentation/tablet/pages/x.dart') ||
      !_isTabletRoot('lib/app/shell/tablet/tablet_app_shell.dart')) {
    stderr.writeln('selfTest: surface-root classification broken.');
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

  final rows = _scanLib();
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
      '`dart run tool/tablet_neutral_widget_audit.dart` (no --check) '
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
    stderr.writeln('Neutral-widget baseline drift — ratchet is equality:');
    for (final p in stale) {
      stderr.writeln('  fixed (remove from baseline): $p');
    }
    for (final p in novel) {
      stderr.writeln('  new violation (fix or baseline): $p');
    }
    exit(1);
  }
  stdout.writeln(
    'tablet_neutral_widget_audit: baseline ${baseline.length} file, '
    '${rows.length} vi phạm — OK.',
  );
}
