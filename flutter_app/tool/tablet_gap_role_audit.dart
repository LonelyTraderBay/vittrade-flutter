// Tablet Gap ROLE Audit — scanner nhận diện SAI ROLE của khoảng cách
// (Tablet-Spacing-Gutter-Standard, Rule 1 + Rule 6).
//
//   Lỗ hổng được bịt (2026-09-16, module predictions): guardrail
//   tablet_gap_12 chỉ khóa "token nằm trong whitelist", KHÔNG khóa
//   "đúng role cho đúng quan hệ". 5 lớp lỗi role đã lọt CI:
//
//   R1-card-sibling — gap giữa 2 card sibling (dọc HOẶC ngang, kể cả
//        trong spread `...[`) phải là 12 (`x4`/`cardGap`), không phải 8.
//   R2-hero-padding — VitCard(variant: hero) không được ép `padding:`
//        ngoài họ cardPaddingHero* (role hero = 24).
//   R3-wrap-micro — `Wrap(spacing:)` là cụm pill/badge (role micro 4)
//        — giá trị 8/12 trong Wrap là sai role.
//   R4-label-control — gap Text-label → control form (VitInput/
//        VitSegmentedChoice/VitTabBar/VitSearchBar/VitChoicePill/
//        VitPresetChipRow/SingleChildScrollView) phải là 8 (x3/rowGap).
//   R5-expanded-item — gap giữa 2 `Expanded` sibling phải ≥ 8 (x3/x4),
//        không được là micro 4.
//
// Scanner mini-lexer (stack thống nhất như tablet_text_stack_gap_audit):
// string literal + `${}` + comment xử lý đúng; item neo theo depth của
// `children: [` và spread `...[`; dòng `if (cond) const SizedBox(...)`
// được nhận là item gap. Span (VitCard/Wrap) capture bằng slice-regex
// giữa vị trí mở/đóng — không stateemachine giúp chắn.
//
// Baseline: ratchet path|rule|count (`test/quality/tablet_gap_role_baseline.txt`)
// — CHỈ ĐƯỢC GIẢM. Nợ module khác ghi baseline trả dần; predictions
// phải giữ 0.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_gap_role_audit.dart                   # regen artifact
//   dart run tool/tablet_gap_role_audit.dart --check           # CI: artifact + baseline
//   dart run tool/tablet_gap_role_audit.dart --regen-baseline  # chỉ khi trả nợ có tài liệu
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Gap-Role-Audit.csv';
const _baselinePath = 'test/quality/tablet_gap_role_baseline.txt';
const _libDir = 'lib';

const _microTokens = {'x1', 'x2'};
const _itemTokens = {'x3', 'rowGap'};
const _blockTokens = {'x4', 'cardGap', 'pageRhythmStandardSectionGap'};
const _controls = {
  'VitInput',
  'VitSegmentedChoice',
  'VitTabBar',
  'VitSearchBar',
  'VitChoicePill',
  'VitPresetChipRow',
  'SingleChildScrollView',
};

final _widgetOpenRe = RegExp(r'([A-Za-z_][A-Za-z0-9_]*)\($');
final _childrenRe = RegExp(r'children\s*:\s*');
final _wordRe = RegExp(r'[A-Za-z_][A-Za-z0-9_]*');
final _itemStartRe = RegExp(
  r'^\s*(?:if \([^)]*\)\s*)?(?:const\s+)?([A-Z][A-Za-z0-9_]*)\(',
);
final _gapTokenRe = RegExp(
  r'(?:height|width)\s*:\s*TabletSpacingTokens\.([A-Za-z0-9_]+)',
);
final _gapHasChildRe = RegExp(r'\bchild\s*:');
final _expandedInnerRe = RegExp(
  r'child\s*:\s*(?:const\s+)?([A-Z][A-Za-z0-9_]*)',
);
final _spanVariantHeroRe = RegExp(r'variant\s*:\s*VitCardVariant\.hero');
final _spanPaddingRe = RegExp(
  r'padding\s*:\s*TabletSpacingTokens\.([A-Za-z0-9_]+)',
);
final _spanSpacingRe = RegExp(
  r'spacing\s*:\s*TabletSpacingTokens\.([A-Za-z0-9_]+)',
);

/// Stack entry: 'b' bracket (widget gắn khi '('), 's' string, 'i' interpolation.
class _Entry {
  const _Entry(this.kind, this.bracket, this.widget, this.quote);
  final String kind;
  final String bracket;
  final String? widget;
  final String quote;
}

class _Item {
  const _Item(this.kind, this.line, this.gapToken, this.openOffset);
  final String kind; // 'gap' hoặc tên widget / 'Text' / 'Expanded'
  final int line;
  final String gapToken; // rỗng nếu không phải gap
  final int openOffset; // offset dòng bắt đầu item (dò inner của Expanded)
}

class _ListCtx {
  _ListCtx(this.depth, this.spread, this.parent);
  final int depth;
  final bool spread;
  final String parent; // widget sở hữu children-list ('Column', 'Row', ...)
  final items = <_Item>[];
}

class _SpanCtx {
  _SpanCtx(this.widget, this.openPos, this.depth, this.line, this.entry);
  final String widget;
  final int openPos;
  final int depth; // depth stack SAU '(' mở
  final int line;
  final _Entry entry; // entry '(' tương ứng — pop theo identity
}

class RoleRow {
  const RoleRow(this.path, this.line, this.rule, this.detail);
  final String path;
  final int line;
  final String rule;
  final String detail;

  String toCsv() => '$rule,$path,$line,"${detail.replaceAll('"', '""')}"';
}

class _Scanner {
  final String src;
  final String rel;
  final List<RoleRow> rows = [];

  _Scanner(this.src, this.rel);

  final _stack = <_Entry>[];
  final _lists = <_ListCtx>[];
  final _spans = <_SpanCtx>[];
  var _pos = 0;
  var _line = 1;

  int get _n => src.length;

  void run() {
    while (_pos < _n) {
      final ch = src[_pos];
      if (ch == '\n') {
        _line++;
        _pos++;
        _onNewline();
        continue;
      }
      final top = _stack.isEmpty ? null : _stack.last;
      if (top != null && top.kind == 's') {
        if (ch == r'\') {
          _pos += 2;
          continue;
        }
        if (ch == r'$' && _pos + 1 < _n && src[_pos + 1] == '{') {
          _stack.add(const _Entry('i', '', null, ''));
          _pos += 2;
          continue;
        }
        if (ch == top.quote) _stack.removeLast();
        _pos++;
        continue;
      }
      if (top != null && top.kind == 'i') {
        if (ch == r'\') {
          _pos += 2;
          continue;
        }
        if (ch == "'" || ch == '"') {
          _stack.add(_Entry('s', '', null, ch));
          _pos++;
          continue;
        }
        if (ch == '{') {
          _stack.add(const _Entry('b', '{', null, ''));
          _pos++;
          continue;
        }
        if (ch == '}') {
          if (_stack.last.bracket == '{') {
            _stack.removeLast();
          } else {
            _stack.removeLast(); // đóng ('i')
          }
          _closeByDepth();
        }
        _pos++;
        continue;
      }
      // CODE state
      if (ch == "'" || ch == '"') {
        _stack.add(_Entry('s', '', null, ch));
        _pos++;
        continue;
      }
      if (ch == '/' && _pos + 1 < _n && src[_pos + 1] == '/') {
        while (_pos < _n && src[_pos] != '\n') {
          _pos++;
        }
        continue;
      }
      if (ch == '/' && _pos + 1 < _n && src[_pos + 1] == '*') {
        _pos += 2;
        while (_pos + 1 < _n && !(src[_pos] == '*' && src[_pos + 1] == '/')) {
          if (src[_pos] == '\n') _line++;
          _pos++;
        }
        _pos += 2;
        continue;
      }
      if (ch == '(' || ch == '[' || ch == '{') {
        String? name;
        if (ch == '(') {
          final from = _pos >= 45 ? _pos - 45 : 0;
          final m = _widgetOpenRe.firstMatch(src.substring(from, _pos + 1));
          name = m?.group(1);
        }
        final depthAfterOpen = _stack.length + 1;
        if (ch == '[') {
          final before = src
              .substring(_pos >= 12 ? _pos - 12 : 0, _pos)
              .trimRight();
          final isSpread = before.endsWith('...');
          final isChildren =
              RegExp(r'children\s*:\s*$').hasMatch(before) || _pendingChildren;
          if (isSpread || isChildren) {
            _lists.add(
              _ListCtx(
                depthAfterOpen,
                isSpread,
                _stack.isEmpty ? '' : (_stack.last.widget ?? ''),
              ),
            );
          }
          _pendingChildren = false;
        }
        final pushed = _Entry('b', ch, name, '');
        if (name == 'VitCard' || name == 'Wrap') {
          _spans.add(_SpanCtx(name!, _pos, depthAfterOpen, _line, pushed));
        }
        _stack.add(pushed);
        _pos++;
        continue;
      }
      if (ch == ')' || ch == ']' || ch == '}') {
        if (_stack.isNotEmpty) {
          final closing = _stack.removeLast();
          if (closing.bracket == '(' &&
              (closing.widget == 'VitCard' || closing.widget == 'Wrap')) {
            _closeSpan(closing);
          }
        }
        _closeByDepth();
        _pos++;
        continue;
      }
      final childrenMatch = _childrenRe.matchAsPrefix(src, _pos);
      if (childrenMatch != null) {
        _pendingChildren = true;
        _pos = childrenMatch.end;
        continue;
      }
      final word = _wordRe.matchAsPrefix(src, _pos);
      if (word != null) {
        _pos = word.end;
        continue;
      }
      _pos++;
    }
  }

  var _pendingChildren = false;

  void _closeByDepth() {
    while (_lists.isNotEmpty && _lists.last.depth > _stack.length) {
      _closeList(_lists.removeLast());
    }
  }

  void _onNewline() {
    if (_lists.isEmpty) return;
    final top = _lists.last;
    if (_stack.length != top.depth) return;
    // Item detection trên dòng kế — neo ^, không quét xuyên newline.
    final rest = src.substring(_pos, _n < _pos + 400 ? _n : _pos + 400);
    final nextLine = rest.contains('\n')
        ? rest.substring(0, rest.indexOf('\n'))
        : rest;
    if (nextLine.trimLeft().startsWith('for (') ||
        nextLine.trimLeft().startsWith('//')) {
      return;
    }
    final m = _itemStartRe.firstMatch(nextLine);
    if (m == null) return;
    final kind = m.group(1)!;
    if (kind == 'SizedBox') {
      final token = _gapTokenRe.firstMatch(nextLine)?.group(1) ?? '';
      final hasChild = _gapHasChildRe.hasMatch(nextLine);
      if (!hasChild && token.isNotEmpty) {
        top.items.add(_Item('gap', _line + 1, token, _pos));
        return;
      }
    }
    top.items.add(_Item(kind, _line + 1, '', _pos));
  }

  void _closeSpan(_Entry closing) {
    final idx = _spans.lastIndexWhere((s) => identical(s.entry, closing));
    if (idx < 0) return;
    final span = _spans.removeAt(idx);
    final widget = span.widget;
    final slice = src.substring(span.openPos, _pos + 1);
    if (widget == 'VitCard' &&
        _spanVariantHeroRe.hasMatch(slice) &&
        _spanPaddingRe.hasMatch(slice)) {
      final token = _spanPaddingRe.firstMatch(slice)!.group(1)!;
      if (!token.startsWith('cardPaddingHero')) {
        rows.add(
          RoleRow(
            rel,
            span.line,
            'R2-hero-padding',
            'VitCard hero ép padding $token — role hero = 24 '
                '(cardPaddingHero*); bỏ padding hoặc dùng token hero.',
          ),
        );
      }
    }
    if (widget == 'Wrap' && _spanSpacingRe.hasMatch(slice)) {
      final token = _spanSpacingRe.firstMatch(slice)!.group(1)!;
      if (!_microTokens.contains(token)) {
        rows.add(
          RoleRow(
            rel,
            span.line,
            'R3-wrap-micro',
            'Wrap spacing $token — Wrap là cụm pill/badge, role micro = 4 '
                '(x1/x2).',
          ),
        );
      }
    }
  }

  void _closeList(_ListCtx list) {
    final items = list.items;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.kind != 'gap') continue;
      final prev = i > 0 ? items[i - 1] : null;
      final next = i + 1 < items.length ? items[i + 1] : null;
      final token = item.gapToken;

      final prevCard = prev != null && _isCard(prev);
      final nextCard = next != null && _isCard(next);
      if (list.spread ? (prevCard || nextCard) : (prevCard && nextCard)) {
        if (!_blockTokens.contains(token)) {
          rows.add(
            RoleRow(
              rel,
              item.line,
              'R1-card-sibling',
              'Gap card sibling = $token — Rule 6 đòi 12 (x4/cardGap).',
            ),
          );
        }
      }

      if (prev != null &&
          prev.kind == 'Text' &&
          next != null &&
          _controls.contains(next.kind) &&
          !_itemTokens.contains(token)) {
        rows.add(
          RoleRow(
            rel,
            item.line,
            'R4-label-control',
            'Label→control = $token — role form field stack = 8 (x3/rowGap).',
          ),
        );
      }

      if (prev != null &&
          prev.kind == 'Expanded' &&
          next != null &&
          next.kind == 'Expanded' &&
          _microTokens.contains(token)) {
        rows.add(
          RoleRow(
            rel,
            item.line,
            'R5-expanded-item',
            'Gap giữa 2 Expanded = $token — role item = 8 (x3), không micro.',
          ),
        );
      }
    }

    // R6: Column trần chứa ≥2 khối (card/Row) kề nhau KHÔNG SizedBox ngăn —
    // render dính 0dp. Sinh từ bug tab Tổng quan SC-218 (đo pixel emulator
    // 2026-09-18); VitPageSection/VitPageContent là chủ gap đúng — bọc khối
    // tab content bằng section thay vì Column trần. Chỉ áp cho Column: Row
    // có idiom chia Expanded không gap hợp pháp; list spread (for ...[...])
    // không tính vì item của for không qua _onNewline.
    if (!list.spread && list.parent == 'Column') {
      for (var i = 1; i < items.length; i++) {
        final prev = items[i - 1];
        final cur = items[i];
        if (prev.kind == 'gap' || cur.kind == 'gap') continue;
        final prevBlock = _isCard(prev) || prev.kind == 'Row';
        final curBlock = _isCard(cur) || cur.kind == 'Row';
        if (prevBlock && curBlock) {
          rows.add(
            RoleRow(
              rel,
              cur.line,
              'R6-bare-block-list',
              'Column chứa 2 khối kề nhau không SizedBox ngăn (${prev.kind} → '
                  '${cur.kind}) — dính 0dp; bọc VitPageSection/chèn SizedBox.',
            ),
          );
        }
      }
    }
  }

  /// Card-like: tên widget là card, hoặc Expanded bọc card bên trong.
  bool _isCard(_Item item) {
    if (item.kind == 'VitCard' ||
        item.kind.endsWith('Card') ||
        item.kind.endsWith('CardTablet') ||
        item.kind.endsWith('Tile')) {
      return true;
    }
    if (item.kind == 'Expanded') {
      final sliceEnd = item.openOffset + 400 < _n ? item.openOffset + 400 : _n;
      final slice = src.substring(item.openOffset, sliceEnd);
      final inner = _expandedInnerRe.firstMatch(slice)?.group(1) ?? '';
      return inner == 'VitCard' ||
          inner.endsWith('Card') ||
          inner.endsWith('CardTablet') ||
          inner.endsWith('Tile');
    }
    return false;
  }
}

List<RoleRow> scanLib() {
  final rows = <RoleRow>[];
  final dir = Directory(_libDir);
  if (!dir.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (!normalized.endsWith('.dart')) continue;
    final isTablet =
        normalized.contains('/tablet/') ||
        normalized.split('/').last.contains('tablet');
    if (!isTablet) continue;
    if (normalized.contains('/.mimosa/') ||
        normalized.contains('/app/theme/')) {
      continue;
    }
    final rel = normalized.replaceFirst('lib/', '');
    final scanner = _Scanner(entity.readAsStringSync(), rel);
    scanner.run();
    rows.addAll(scanner.rows);
  }
  rows.sort((a, b) {
    final c = a.path.compareTo(b.path);
    return c != 0 ? c : a.line.compareTo(b.line);
  });
  return rows;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final regenBaseline = args.contains('--regen-baseline');

  final rows = scanLib();
  File(_artifactPath).writeAsStringSync(
    'rule,path,line,detail\n${rows.map((r) => r.toCsv()).join('\n')}\n',
  );

  if (regenBaseline) {
    final counts = <String, int>{};
    for (final r in rows) {
      final key = '${r.path}|${r.rule}';
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    File(_baselinePath).writeAsStringSync(
      '# Tablet gap role baseline — ratchet: entries may only be REMOVED '
      '(trả nợ dần theo module).\n'
      '# Format: path|rule count\n'
      '# Regenerate: dart run tool/tablet_gap_role_audit.dart '
      '--regen-baseline\n'
      '${entries.map((e) => '${e.key} ${e.value}').join('\n')}\n',
    );
    stdout.writeln(
      'Regenerated baseline: ${entries.length} entries, '
      '${rows.length} violations.',
    );
    return;
  }

  if (checkOnly) {
    final baselineFile = File(_baselinePath);
    if (!baselineFile.existsSync()) {
      stderr.writeln('Missing baseline $_baselinePath.');
      exit(1);
    }
    final counts = <String, int>{};
    for (final r in rows) {
      final key = '${r.path}|${r.rule}';
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final baseline = <String, int>{};
    for (final line in baselineFile.readAsLinesSync()) {
      if (line.isEmpty || line.startsWith('#')) continue;
      final parts = line.split(' ');
      if (parts.length == 2) baseline[parts[0]] = int.tryParse(parts[1]) ?? 0;
    }
    var drifted = false;
    for (final key in counts.keys) {
      if ((counts[key] ?? 0) > (baseline[key] ?? 0)) {
        stderr.writeln(
          'ROLE VI PHẠM MỚI: $key có ${counts[key]} '
          '(baseline cho phép ${baseline[key] ?? 0})',
        );
        drifted = true;
      }
    }
    for (final key in baseline.keys) {
      if ((counts[key] ?? 0) < baseline[key]!) {
        stderr.writeln(
          'Đã trả nợ — giảm baseline: $key ${baseline[key]} → '
          '${counts[key] ?? 0} (regen baseline + artifact cùng commit).',
        );
        drifted = true;
      }
    }
    if (drifted) {
      stderr.writeln(
        'Gap-role baseline drift — ratchet chỉ được GIẢM. Chạy '
        '`dart run tool/tablet_gap_role_audit.dart` và commit artifact.',
      );
      exit(1);
    }
    stdout.writeln(
      'tablet_gap_role_audit: ${rows.length} vi phạm (khớp baseline) — OK.',
    );
    return;
  }

  stdout.writeln(
    'Artifact written: $_artifactPath (${rows.length} rows). '
    '--check cho CI; --regen-baseline khi trả nợ.',
  );
}
