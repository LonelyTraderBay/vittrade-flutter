// Guardrail: Tablet Spacing & Gutter Standard (docs/02_FLUTTER_MIGRATION/
// standards/Tablet-Spacing-Gutter-Standard.md) — rule S7.
//
// Khóa TUYỆT ĐỐI (không baseline): children trực tiếp của các scaffold
// sở hữu section gap (`MarketsPaneScaffold`, `ProfilePaneScaffold`,
// `VitTwoColumnTabletDashboard`) KHÔNG được bọc trong `Padding` mang
// thành phần DỌC dương — scaffold đã chèn section gap (13dp tier
// standard) giữa mọi cặp children, margin dọc của children cộng dồn lên
// đó và phá nhịp trang (lỗi pane pair-detail 2026-08-29: gap 23–29dp
// thay vì 13dp do token margin Phone như `pairRiskMargin` 10/13 được
// mang nguyên sang). Token-blind: kể cả tokenized margin cũng vi phạm —
// port Phone → Tablet là TÁI LẬP nhịp, không phải mang khung.
//
// Dạng được PHÉP làm wrapper trực tiếp: `EdgeInsets.symmetric(
// horizontal: …)`, `EdgeInsetsDirectional.symmetric(horizontal: …)`,
// `EdgeInsets.only(left/right:…)`, `EdgeInsetsDirectional.only(
// start/end:…)`, `EdgeInsets.fromLTRB(x, 0, x, 0)`, `.zero`. Khoảng thở
// đáy cuộn nằm bên TRONG widget cuối (pattern `_Disclaimer`), không
// phải wrapper của children list.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Exact-set ratchet: token duoc chung minh horizontal-only bang test
/// khoa gia tri rieng — them token moi phai khai bao lai o day kem kiem
/// tra gia tri tuong ung (bump cung commit, nhu Rule 5 T3).
const Set<String> _allowedHorizontalTokens = {
  'MarketsSpacingTokens.pairPaneChildFlushPadding',
};

final _scaffoldCtorRe = RegExp(
  r'\b(MarketsPaneScaffold|ProfilePaneScaffold|VitTwoColumnTabletDashboard)\(',
);

final _childrenArgRe = RegExp(
  r'(children|primaryChildren|secondaryChildren)\s*:\s*(?:<\s*Widget\s*>\s*)?\[',
);

final _paddingArgRe = RegExp(r'\bpadding\s*:');

class _Violation {
  _Violation(this.relPath, this.line, this.preview);

  final String relPath;
  final int line;
  final String preview;

  @override
  String toString() => '$relPath|$line|S7-vertical-inset|$preview';
}

void main() {
  test('tablet pane/dashboard children carry no vertical inset (S7)', () {
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final fileName = normalized.split('/').last;
      final isTabletSurface =
          normalized.contains('/tablet/') || fileName.contains('tablet');
      if (!isTabletSurface || !normalized.endsWith('.dart')) continue;

      final src = _stripCommentLines(entity.readAsStringSync());
      final rel = normalized.replaceFirst('lib/', '');
      for (final v in _scanSource(src, rel)) {
        violations.add(v.toString());
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Padding wrapper có thành phần dọc trong children của scaffold '
          'pane/dashboard (chuẩn Tablet-Spacing-Gutter S7 — khóa tuyệt '
          'đối):\n${violations.join('\n')}\n\n'
          'Scaffold owns section gap. Children chỉ inset ngang '
          '(symmetric(horizontal:)/only(left,right)/fromLTRB(x,0,x,0)/'
          '.zero); khoảng thở nằm bên trong widget, không phải wrapper.',
    );
  });

  test('scanner S7 — self-test các dạng hợp lệ', () {
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: const _PriceOverview(),
    ),
  ],
);
'''),
      isEmpty,
    );
    expect(
      _scanOnly('''
VitTwoColumnTabletDashboard(
  primaryChildren: [
    Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.contentPad, 0, AppSpacing.x3, 0),
      child: Menu(),
    ),
  ],
  secondaryChildren: [Pane()],
);
'''),
      isEmpty,
    );
    expect(
      _scanOnly('''
ProfilePaneScaffold(
  children: [
    Padding(padding: EdgeInsets.zero, child: Hero()),
  ],
);
'''),
      isEmpty,
    );
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.contentPad,
        end: AppSpacing.contentPad,
      ),
      child: Row(),
    ),
  ],
);
'''),
      isEmpty,
    );
    // Child là widget thường — Padding BÊN TRONG child không thuộc phạm vi
    // wrapper trực tiếp (widget tự sở hữu padding nội bộ của nó).
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: const Card(),
        ),
      ],
    ),
  ],
);
'''),
      isEmpty,
    );
    // Token trong allowlist (đã kiểm giá trị chỉ ngang) — được phép.
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Padding(
      padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
      child: Overview(),
    ),
  ],
);
'''),
      isEmpty,
    );
    // `if (cond) Padding(...)` — unwrap điều kiện rồi kiểm tra widget.
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    if (showBanner)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: Banner(),
      ),
  ],
);
'''),
      isEmpty,
    );
  });

  test('S7 allowlist token thực sự horizontal-only (giá trị khóa)', () {
    // Giá trị của token allowlist phải là symmetric(horizontal-only) — nếu
    // ai đổi token này mang thành phần dọc, test fail ngay kèm chỉ dẫn.
    expect(
      _isHorizontalOnly(
        'EdgeInsets.symmetric(horizontal: AppSpacing.contentPad)',
      ),
      isTrue,
      reason:
          'MarketsSpacingTokens.pairPaneChildFlushPadding phải giữ '
          'symmetric(horizontal:) — đổi giá trị thì cập nhật allowlist + '
          'test này cùng commit.',
    );
  });

  test('scanner S7 — self-test các dạng vi phạm', () {
    // Token margin Phone mang nguyên sang — token-blind, vẫn vi phạm.
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Padding(
      padding: MarketsSpacingTokens.pairRiskMargin,
      child: Warning(),
    ),
  ],
);
'''),
      isNotEmpty,
    );
    expect(
      _scanOnly('''
ProfilePaneScaffold(
  children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        10,
        AppSpacing.contentPad,
        AppSpacing.x4,
      ),
      child: Ctas(),
    ),
  ],
);
'''),
      isNotEmpty,
    );
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(),
    ),
  ],
);
'''),
      isNotEmpty,
    );
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Header(),
    ),
  ],
);
'''),
      isNotEmpty,
    );
    expect(
      _scanOnly('''
VitTwoColumnTabletDashboard(
  primaryChildren: [
    Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Menu(),
    ),
  ],
  secondaryChildren: [Pane()],
);
'''),
      isNotEmpty,
    );
    // `if (cond) Padding(...)` bọc token dọc — vẫn bị bắt sau unwrap.
    expect(
      _scanOnly('''
MarketsPaneScaffold(
  children: [
    if (hasRisk)
      Padding(
        padding: MarketsSpacingTokens.pairLinkMargin,
        child: Link(),
      ),
  ],
);
'''),
      isNotEmpty,
    );
  });
}

List<String> _scanOnly(String src) =>
    _scanSource(src, 'fixture.dart').map((v) => v.toString()).toList();

List<_Violation> _scanSource(String src, String relPath) {
  final violations = <_Violation>[];
  for (final match in _scaffoldCtorRe.allMatches(src)) {
    final open = match.end - 1;
    final close = _matchingParen(src, open);
    if (close < 0) continue;
    final ctorBody = src.substring(open + 1, close);
    final depthZero = _depthZeroMap(ctorBody);
    for (final argMatch in _childrenArgRe.allMatches(ctorBody)) {
      // Chỉ nhận `children:` là tham số TOP-LEVEL của scaffold — bỏ qua
      // `children:` lồng bên trong widget con (Column, ListView...).
      if (!depthZero[argMatch.start]) continue;
      final listOpen = ctorBody.indexOf('[', argMatch.end - 1);
      final listBody = _balancedListBody(ctorBody, listOpen);
      if (listBody == null) continue;
      for (final element in _topLevelChildren(listBody.body)) {
        final wrapper = _unwrapConditional(element.text);
        if (!wrapper.text.startsWith('Padding(')) continue;
        final paddingValue = _paddingArgument(wrapper.text);
        if (paddingValue == null) continue;
        if (!_isHorizontalOnly(paddingValue)) {
          final line = _lineOf(
            src,
            listBody.offset + element.offset + wrapper.offset,
          );
          violations.add(
            _Violation(relPath, line, _oneLine(paddingValue, maxChars: 60)),
          );
        }
      }
    }
  }
  return violations;
}

String _stripCommentLines(String src) => src
    .split('\n')
    .map((line) {
      final t = line.trimLeft();
      return t.startsWith('//') ? '' : line;
    })
    .join('\n');

int _matchingParen(String src, int open) {
  var depth = 0;
  String? quote;
  for (var i = open; i < src.length; i++) {
    final c = src[i];
    if (quote != null) {
      if (c == r'\') {
        i++;
      } else if (c == quote) {
        quote = null;
      }
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
    } else if (c == '(') {
      depth++;
    } else if (c == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

class _ListBody {
  _ListBody(this.body, this.offset);

  final String body;
  final int offset;
}

_ListBody? _balancedListBody(String src, int open) {
  var depth = 0;
  String? quote;
  for (var i = open; i < src.length; i++) {
    final c = src[i];
    if (quote != null) {
      if (c == r'\') {
        i++;
      } else if (c == quote) {
        quote = null;
      }
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
    } else if (c == '[') {
      depth++;
    } else if (c == ']') {
      depth--;
      if (depth == 0) return _ListBody(src.substring(open + 1, i), open + 1);
    }
  }
  return null;
}

class _Element {
  _Element(this.text, this.offset);

  final String text;
  final int offset;
}

List<_Element> _topLevelChildren(String listBody) {
  final parts = <_Element>[];
  var depth = 0;
  String? quote;
  final buf = StringBuffer();
  var elementStart = -1;
  for (var i = 0; i < listBody.length; i++) {
    final c = listBody[i];
    if (quote != null) {
      buf.write(c);
      if (c == r'\') {
        if (i + 1 < listBody.length) buf.write(listBody[i + 1]);
        i++;
      } else if (c == quote) {
        quote = null;
      }
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
      buf.write(c);
    } else if (c == '(' || c == '[' || c == '{') {
      depth++;
      buf.write(c);
    } else if (c == ')' || c == ']' || c == '}') {
      depth--;
      buf.write(c);
    } else if (c == ',' && depth == 0) {
      _flushPart(parts, buf, elementStart);
      elementStart = -1;
    } else {
      if (depth == 0 && c.trim().isNotEmpty && elementStart < 0) {
        elementStart = i;
      }
      buf.write(c);
    }
  }
  _flushPart(parts, buf, elementStart);
  return parts;
}

void _flushPart(List<_Element> parts, StringBuffer buf, int elementStart) {
  final text = buf.toString().trim();
  buf.clear();
  if (text.isEmpty || text == 'const' || text == '...') return;
  final offset = elementStart >= 0 ? elementStart : 0;
  parts.add(_Element(text, offset));
}

/// Bỏ tiền tố `if (cond)` của phần tử để lấy widget đứng sau điều kiện.
_Element _unwrapConditional(String element) {
  var text = element;
  var offset = 0;
  while (text.startsWith('if (') || text.startsWith('if(')) {
    final open = text.indexOf('(');
    final close = _matchingParen(text, open);
    if (close < 0) break;
    final rest = text.substring(close + 1).trimLeft();
    offset += text.length - rest.length;
    text = rest;
  }
  if (text.startsWith('const ')) {
    final rest = text.substring('const '.length).trimLeft();
    offset += text.length - rest.length;
    text = rest;
  }
  return _Element(text, offset);
}

/// Trích giá trị của tham số `padding:` đầu tiên trong `Padding(...)`.
String? _paddingArgument(String element) {
  final m = _paddingArgRe.firstMatch(element.substring(0, element.length));
  if (m == null) return null;
  final valueStart = m.end;
  var depth = 0;
  final buf = StringBuffer();
  for (var i = valueStart; i < element.length; i++) {
    final c = element[i];
    if (c == '(' || c == '[' || c == '{') {
      depth++;
      buf.write(c);
    } else if (c == ')' || c == ']' || c == '}') {
      if (depth == 0) break; // đóng `Padding(` — hết tham số.
      depth--;
      buf.write(c);
    } else if (c == ',' && depth == 0) {
      break; // tham số kế tiếp.
    } else {
      buf.write(c);
    }
  }
  final value = buf.toString().trim();
  return value.isEmpty ? null : value;
}

bool _isHorizontalOnly(String value) {
  final v = value.trim();
  final noConst = v.startsWith('const ') ? v.substring(6).trim() : v;
  if (noConst == 'EdgeInsets.zero' || noConst == 'EdgeInsetsDirectional.zero') {
    return true;
  }
  // Token ref (chuỗi định danh chấm, không phải constructor) — chỉ hợp lệ
  // khi nằm trong exact-set allowlist đã kiểm chứng giá trị.
  if (RegExp(r'^[A-Za-z_][\w.]*$').hasMatch(noConst)) {
    return _allowedHorizontalTokens.contains(noConst);
  }
  final symmetric = RegExp(
    r'^EdgeInsets(Directional)?\.symmetric\((.*)\)$',
  ).firstMatch(noConst);
  if (symmetric != null) {
    final params = symmetric.group(2)!;
    return RegExp(r'^\s*horizontal\s*:').hasMatch(params) &&
        !params.contains('vertical');
  }
  final only = RegExp(
    r'^EdgeInsets(Directional)?\.only\((.*)\)$',
    dotAll: true,
  ).firstMatch(noConst.replaceAll('\n', ' '));
  if (only != null) {
    final params = only.group(2)!;
    final named = params
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .map((p) => p.split(':').first.trim());
    final allowed = {'left', 'right', 'start', 'end'};
    return named.every(allowed.contains);
  }
  final fromLTRB = RegExp(
    r'^EdgeInsets\.fromLTRB\(\s*([^,]+),\s*([^,]+),\s*([^,]+),\s*([^)]+)\)$',
  ).firstMatch(noConst.replaceAll('\n', ' '));
  if (fromLTRB != null) {
    final top = fromLTRB.group(2)!.trim();
    final bottom = fromLTRB.group(4)!.trim();
    return top == '0' && bottom == '0';
  }
  return false;
}

int _lineOf(String src, int index) {
  var line = 1;
  for (var i = 0; i < index && i < src.length; i++) {
    if (src[i] == '\n') line++;
  }
  return line;
}

/// Bản đồ vị trí nằm ở depth 0 (ngoài mọi cặp ngoặc) của chuỗi — dùng để
/// chỉ nhận các tham số named top-level của constructor scaffold.
List<bool> _depthZeroMap(String src) {
  final flags = List<bool>.filled(src.length, false);
  var depth = 0;
  String? quote;
  for (var i = 0; i < src.length; i++) {
    final c = src[i];
    if (quote != null) {
      if (c == r'\') {
        i++;
      } else if (c == quote) {
        quote = null;
      }
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
    } else if (c == '(' || c == '[' || c == '{') {
      flags[i] = depth == 0;
      depth++;
      continue;
    } else if (c == ')' || c == ']' || c == '}') {
      depth--;
    } else {
      flags[i] = depth == 0;
    }
  }
  return flags;
}

String _oneLine(String text, {int maxChars = 60}) {
  final collapsed = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  return collapsed.length <= maxChars
      ? collapsed
      : '${collapsed.substring(0, maxChars)}…';
}
