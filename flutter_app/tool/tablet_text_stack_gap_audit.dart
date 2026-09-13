// Tablet Text-Stack Gap (S8) — audit scanner (lexer-aware).
//
//   S8 — ABSOLUTE lock (2026-09-14): trong tablet presentation, một
//        `Column` children không được chứa hai widget `Text(` liền kề mà
//        không có gap token giữa chúng (tối thiểu `TabletSpacingTokens.x1`
//        = 4dp micro). 0dp không thuộc role scale — hai dòng chữ dính nhau
//        là lỗi "cell 2 dòng" đã đo bằng pixel trên emulator (staking
//        Sản phẩm, 2026-09-14).
//
// Scanner mini-lexer (stack thống nhất): chỉ tính bracket/widget trong
// CODE; nội dung string literal bỏ qua; `${...}` interpolation được track
// như code (lồng string bên trong xử lý đúng); `//` và `/* */` comment bỏ
// qua. Item detection CHỈ trên dòng kế tiếp (regex neo ^ — không quét
// xuyên newline, `if (cond)` + `Text(` của nhánh không bị ghép thành cặp).
// Chỉ flag cặp `Text` liền kề ở top-level của `children: [` có widget bao
// ngoài là `Column`; `Row` ngang và mọi widget xen giữa không flag.
//
// Baseline: ratchet đẳng thức qua
// `test/quality/tablet_text_stack_gap_baseline.txt` (RỖNG — zero tolerance
// sau sweep 2026-09-14: 142 site đã chèn gap micro qua 2 lượt codemod;
// ngoại lệ mới phải có lý do ghi rõ trong baseline).
//
// Usage (from flutter_app/):
//   dart run tool/tablet_text_stack_gap_audit.dart                   # regen artifact
//   dart run tool/tablet_text_stack_gap_audit.dart --check           # CI: artifact + baseline
//   dart run tool/tablet_text_stack_gap_audit.dart --regen-baseline  # chỉ khi trả nợ có tài liệu
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Text-Stack-Gap-Audit.csv';
const _baselinePath = 'test/quality/tablet_text_stack_gap_baseline.txt';
const _libDir = 'lib';

final _widgetOpenRe = RegExp(r'([A-Za-z_][A-Za-z0-9_]*)\($');
final _childrenRe = RegExp(r'children\s*:\s*\[');
final _itemStartRe = RegExp(r'^\s*(?:const\s+)?([A-Z][A-Za-z0-9_]*)\(');
final _wordRe = RegExp(r'[A-Za-z_][A-Za-z0-9_]*');

/// Stack entry: kind 'b' = bracket (widgetName chỉ cho '('), 's' = string
/// literal (quote), 'i' = vùng interpolation `${`.
class _Entry {
  _Entry(this.kind, this.bracket, this.widget, this.quote);
  final String kind; // b | s | i
  final String bracket;
  final String? widget;
  final String quote;
}

class StackGapRow {
  const StackGapRow(this.path, this.line);
  final String path;
  final int line;

  String toCsv() => 'S8-text-stack-no-gap,$path,$line';
}

class _ChildrenList {
  _ChildrenList(this.depth, this.widget, this.line);
  final int depth;
  final String widget;
  final int line;
  String? lastItem;
}

List<StackGapRow> scanLib() {
  final rows = <StackGapRow>[];
  final dir = Directory(_libDir);
  if (!dir.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (!normalized.endsWith('.dart')) continue;
    if (!normalized.contains('/tablet/') &&
        !normalized.split('/').last.contains('tablet')) {
      continue;
    }
    if (normalized.contains('/.mimosa/')) continue;
    final rel = normalized.replaceFirst('lib/', '');
    _scanSource(entity.readAsStringSync(), rel, rows);
  }
  rows.sort((a, b) {
    final byPath = a.path.compareTo(b.path);
    return byPath != 0 ? byPath : a.line.compareTo(b.line);
  });
  return rows;
}

void _scanSource(String src, String rel, List<StackGapRow> rows) {
  final stack = <_Entry>[];
  final children = <_ChildrenList>[];
  var pos = 0;
  var line = 1;
  final n = src.length;
  while (pos < n) {
    final ch = src[pos];
    if (ch == '\n') {
      line++;
      pos++;
      if (children.isNotEmpty) {
        final top = children.last;
        if (stack.length == top.depth) {
          // Item detection CHỈ trên dòng kế tiếp — regex neo ^ trên dòng
          // đã tách, không quét xuyên newline.
          final rest = src.substring(pos, n < pos + 300 ? n : pos + 300);
          final nextLine = rest.contains('\n')
              ? rest.substring(0, rest.indexOf('\n'))
              : rest;
          final m = _itemStartRe.firstMatch(nextLine);
          final widget = m?.group(1);
          if (widget == 'Text' &&
              top.lastItem == 'Text' &&
              top.widget == 'Column') {
            rows.add(StackGapRow(rel, line));
          }
          top.lastItem = widget;
        }
      }
      continue;
    }
    final top = stack.isEmpty ? null : stack.last;
    // String literal: escape, `${` vào interpolation, quote đóng ra.
    if (top != null && top.kind == 's') {
      if (ch == r'\') {
        pos += 2;
        continue;
      }
      if (ch == r'$' && pos + 1 < n && src[pos + 1] == '{') {
        stack.add(_Entry('i', '', null, ''));
        pos += 2;
        continue;
      }
      if (ch == top.quote) {
        stack.removeLast();
      }
      pos++;
      continue;
    }
    // Interpolation `${...}`: quote lồng vào string, `{` lồng được track,
    // `}` đóng `{` lồng hoặc đóng chính interpolation.
    if (top != null && top.kind == 'i') {
      if (ch == r'\') {
        pos += 2;
        continue;
      }
      if (ch == "'" || ch == '"') {
        stack.add(_Entry('s', '', null, ch));
        pos++;
        continue;
      }
      if (ch == '{') {
        stack.add(_Entry('b', '{', null, ''));
        pos++;
        continue;
      }
      if (ch == '}') {
        if (stack.last.bracket == '{') {
          stack.removeLast();
        } else {
          stack.removeLast(); // đóng ('i')
        }
        while (children.isNotEmpty && children.last.depth > stack.length) {
          children.removeLast();
        }
      }
      pos++;
      continue;
    }
    // CODE state
    if (ch == "'" || ch == '"') {
      stack.add(_Entry('s', '', null, ch));
      pos++;
      continue;
    }
    if (ch == '/' && pos + 1 < n && src[pos + 1] == '/') {
      while (pos < n && src[pos] != '\n') {
        pos++;
      }
      continue;
    }
    if (ch == '/' && pos + 1 < n && src[pos + 1] == '*') {
      pos += 2;
      while (pos + 1 < n && !(src[pos] == '*' && src[pos + 1] == '/')) {
        if (src[pos] == '\n') {
          line++;
        }
        pos++;
      }
      pos += 2;
      continue;
    }
    if (ch == '(' || ch == '[' || ch == '{') {
      String? name;
      if (ch == '(') {
        final from = pos >= 45 ? pos - 45 : 0;
        final m = _widgetOpenRe.firstMatch(src.substring(from, pos + 1));
        name = m?.group(1);
      }
      stack.add(_Entry('b', ch, name, ''));
      pos++;
      continue;
    }
    if (ch == ')' || ch == ']' || ch == '}') {
      if (stack.isNotEmpty) stack.removeLast();
      while (children.isNotEmpty && children.last.depth > stack.length) {
        children.removeLast();
      }
      pos++;
      continue;
    }
    final childrenMatch = _childrenRe.matchAsPrefix(src, pos);
    if (childrenMatch != null) {
      String? enclosing;
      for (final entry in stack.reversed) {
        if (entry.kind == 'b' && entry.widget != null) {
          enclosing = entry.widget;
          break;
        }
      }
      children.add(_ChildrenList(stack.length + 1, enclosing ?? '?', line));
      stack.add(_Entry('b', '[', null, ''));
      pos = childrenMatch.end;
      continue;
    }
    final word = _wordRe.matchAsPrefix(src, pos);
    if (word != null) {
      pos = word.end; // matchAsPrefix: end tuyệt đối theo src — gán, không +=
      continue;
    }
    pos++;
  }
}

String _artifactCsv(List<StackGapRow> rows) {
  final buf = StringBuffer('rule,path,line\n');
  for (final row in rows) {
    buf.writeln(row.toCsv());
  }
  return buf.toString();
}

void _selfTest() {
  const clean =
      "class X {\n  Widget build() => Column(children: [\n"
      "    Text('a (b)'),\n"
      "    const SizedBox(height: TabletSpacingTokens.x1),\n"
      "    Text('c \${x}'),\n  ]);\n}\n";
  const dirty =
      "class X {\n  Widget build() => Column(children: [\n    Text('a'),\n"
      "    Text('b'),\n  ]);\n}\n";
  const stringSafe =
      "class X {\n  Widget build() => Column(children: [\n"
      "    Text('ne (unbalanced'),\n    Text('b'),\n  ]);\n}\n";
  const conditional =
      "class X {\n  Widget build() => Column(children: [\n"
      "    Text('a'),\n    const SizedBox(height: TabletSpacingTokens.x4),\n"
      "    if (c)\n      Text('b'),\n  ]);\n}\n";
  var rows = <StackGapRow>[];
  _scanSource(clean, 't.dart', rows);
  if (rows.isNotEmpty) {
    stderr.writeln('selfTest: clean sample flagged.');
    exit(3);
  }
  rows = <StackGapRow>[];
  _scanSource(dirty, 't.dart', rows);
  if (rows.length != 1) {
    stderr.writeln('selfTest: dirty sample not flagged.');
    exit(3);
  }
  rows = <StackGapRow>[];
  _scanSource(stringSafe, 't.dart', rows);
  if (rows.length != 1) {
    stderr.writeln('selfTest: string-with-bracket desynced the scanner.');
    exit(3);
  }
  rows = <StackGapRow>[];
  _scanSource(conditional, 't.dart', rows);
  if (rows.isNotEmpty) {
    stderr.writeln('selfTest: collection-if branch cross-line flagged.');
    exit(3);
  }
}

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');
  final regenBaseline = args.contains('--regen-baseline');

  final rows = scanLib();

  if (regenBaseline) {
    final perFile = <String, int>{};
    for (final row in rows) {
      perFile[row.path] = (perFile[row.path] ?? 0) + 1;
    }
    final keys = perFile.keys.map((k) => '$k ${perFile[k]}').toList()..sort();
    File(
      _baselinePath,
    ).writeAsStringSync('${keys.join('\n')}${keys.isEmpty ? '' : '\n'}');
    stdout.writeln('Baseline regenerated: ${keys.length} file entries.');
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
      '`dart run tool/tablet_text_stack_gap_audit.dart` (no --check) '
      'and commit the artifact with the code.',
    );
    exit(1);
  }

  final baselineFile = File(_baselinePath);
  if (!baselineFile.existsSync()) {
    stderr.writeln('Missing baseline $_baselinePath.');
    exit(1);
  }
  final baseline =
      baselineFile
          .readAsLinesSync()
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && !l.startsWith('#'))
          .map((l) {
            final parts = l.split(RegExp(r'\s+'));
            return '${parts[0]} ${parts[1]}';
          })
          .toList()
        ..sort();
  final current = <String, int>{};
  for (final row in rows) {
    current[row.path] = (current[row.path] ?? 0) + 1;
  }
  final currentKeys = current.keys.map((k) => '$k ${current[k]}').toList()
    ..sort();
  final stale = baseline.where((e) => !currentKeys.contains(e)).toList();
  final novel = currentKeys.where((e) => !baseline.contains(e)).toList();
  if (stale.isNotEmpty || novel.isNotEmpty) {
    stderr.writeln('S8 baseline drift — ratchet is equality:');
    for (final e in stale) {
      stderr.writeln('  fixed (remove from baseline): $e');
    }
    for (final e in novel) {
      stderr.writeln('  new violation (fix or baseline): $e');
    }
    exit(1);
  }
  stdout.writeln(
    'tablet_text_stack_gap_audit: S8 violations ${rows.length} — OK.',
  );
}
