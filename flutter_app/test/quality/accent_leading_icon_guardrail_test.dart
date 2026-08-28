import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// AIB-R6 — Accent-Icon-Box-Standard Rule 6: icon đứng ĐẦU một Row (leading
/// icon) cạnh khối nội dung text phải nằm trong một container icon
/// (`VitAccentIconBox`, box tint module-local...), KHÔNG phải `Icon` trần.
///
/// Lỗi gốc 2026-08-28 (Markets tablet, trang placeholder "Công cụ thị
/// trường"): hero banner render `Icon(size: iconLg)` trần cạnh mô tả 2 dòng —
/// glyph Material chỉ phủ ~80% khung (34dp → mực ~27dp) nên "ô nhỏ so với
/// nội dung"; mọi hàng icon khác trong app đều có khung tint + viền.
///
/// Hai tầng khóa:
/// - AIB-R6a: `lib/shared/layout/**` là composition primitive dùng chung —
///   cấm SẠCH icon trần đứng đầu Row (baseline rỗng).
/// - AIB-R6b: mọi file tablet dưới `lib/features/**` khóa ratchet path|count
///   (nợ hiện hữu trả dần khi chạm file; match mới phải giải trình + cập nhật
///   baseline cùng commit).
///
/// Scanner nhận diện: `Row(` có children-list mà top-level child ĐẦU TIÊN là
/// `Icon(` / `const Icon(`. Comment dòng thuần `//` được thay bằng DÒNG RỖNG
/// (giữ số dòng; comment chứa dấu phẩy sẽ phá tách top-level args).
void main() {
  test('AIB-R6 self-test: scanner bắt đúng pattern vi phạm', () {
    const violating = '''
Row(
  children: [
    Icon(
      icon,
      color: AppColors.primary,
      size: AppSpacing.iconLg,
    ),
    const SizedBox(width: AppSpacing.x3),
    Expanded(child: Text(description)),
  ],
)
''';
    const boxed = '''
Row(
  children: [
    VitAccentIconBox(icon: icon, color: AppColors.primary),
    const SizedBox(width: AppSpacing.x3),
    Expanded(child: Text(description)),
  ],
)
''';
    const iconNotFirst = '''
Row(
  children: [
    const SizedBox(width: 8),
    Icon(icon),
    Text('title'),
  ],
)
''';
    const columnIcon = '''
Column(
  children: [
    Icon(icon),
    Text('title'),
  ],
)
''';
    const commented = '''
Row(
  children: [
    // Icon(icon) — comment, không tính.
    VitAccentIconBox(icon: icon),
  ],
)
''';
    expect(_bareLeadingIconRows(_stripCommentLines(violating)), 1);
    expect(_bareLeadingIconRows(_stripCommentLines(boxed)), 0);
    expect(_bareLeadingIconRows(_stripCommentLines(iconNotFirst)), 0);
    expect(_bareLeadingIconRows(_stripCommentLines(columnIcon)), 0);
    expect(_bareLeadingIconRows(_stripCommentLines(commented)), 0);
  });

  test('AIB-R6a: lib/shared/layout cấm sạch icon trần đứng đầu Row', () {
    final hits = <String, int>{};
    _scanDirectory(Directory('lib/shared/layout'), hits);
    expect(
      hits,
      isEmpty,
      reason:
          'shared/layout là composition primitive dùng chung toàn app — '
          'icon leading phải nằm trong VitAccentIconBox '
          '(Accent-Icon-Box-Standard Rule 6).\n'
          'Vi phạm: $hits',
    );
  });

  test('AIB-R6b: ratchet icon-trần đứng đầu Row trên file tablet', () {
    // Nợ hiện hữu 2026-08-28 (46 match / 26 file): icon nhỏ (iconSm/iconMd)
    // đầu hàng list-tile của các pane thật. Trả dần khi chạm file — giảm thì
    // cập nhật map này cùng commit; TĂNG hay THÊM file mới là sai chuẩn.
    const baseline = <String, int>{
      '/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart': 1,
      '/features/home/presentation/widgets/tablet/home_portfolio_card.dart': 1,
      '/features/home/presentation/widgets/tablet/home_tablet_kpi_strip.dart':
          1,
      '/features/markets/presentation/widgets/tablet/market_list_movers.dart':
          1,
      '/features/markets/presentation/widgets/tablet/markets_token_info_pane_details.dart':
          4,
      '/features/markets/presentation/widgets/tablet/markets_token_info_pane_sections.dart':
          1,
      '/features/profile/presentation/widgets/tablet/profile_account_footer_actions.dart':
          1,
      '/features/profile/presentation/widgets/tablet/profile_activity_pane.dart':
          2,
      '/features/profile/presentation/widgets/tablet/profile_api_create_pane_sections.dart':
          2,
      '/features/profile/presentation/widgets/tablet/profile_api_pane_sections.dart':
          1,
      '/features/profile/presentation/widgets/tablet/profile_devices_pane_sections.dart':
          1,
      '/features/profile/presentation/widgets/tablet/profile_discovery_panel.dart':
          2,
      '/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart': 2,
      '/features/profile/presentation/widgets/tablet/profile_security_pane.dart':
          3,
      '/features/profile/presentation/widgets/tablet/profile_settings_pane.dart':
          1,
      '/features/profile/presentation/widgets/tablet/profile_sub_accounts_pane_sections.dart':
          3,
      '/features/profile/presentation/widgets/tablet/profile_vip_pane.dart': 1,
      '/features/trade/presentation/widgets/tablet/order_receipt_page_common.dart':
          2,
      '/features/wallet/presentation/tablet/pages/address_book_tablet_page.dart':
          2,
      '/features/wallet/presentation/tablet/pages/asset_detail_tablet_page.dart':
          1,
      '/features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart':
          1,
      '/features/wallet/presentation/tablet/pages/network_status_tablet_page.dart':
          2,
      '/features/wallet/presentation/tablet/pages/transaction_detail_tablet_page.dart':
          1,
      '/features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart':
          1,
      '/features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart':
          2,
      '/features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart':
          3,
    };

    final hits = <String, int>{};
    _scanDirectory(Directory('lib/features'), hits, tabletOnly: true);
    expect(
      hits,
      equals(baseline),
      reason:
          'Icon trần đứng đầu Row trên tablet: chỉ được GIẢM so với baseline '
          '(trả nợ khi chạm file). Thêm match/file mới ⇒ bọc icon trong '
          'VitAccentIconBox (Accent-Icon-Box-Standard Rule 6).\n'
          'Thực tế: $hits',
    );
  });
}

const _rowStart = 'Row(';

/// Đếm số Row có top-level child đầu tiên là `Icon(`/`const Icon(`.
int _bareLeadingIconRows(String src) {
  var count = 0;
  for (var i = 0; i < src.length - _rowStart.length + 1; i++) {
    if (!src.startsWith(_rowStart, i)) continue;
    // Không tính TableRow(, _FooRow( — ký tự trước phải không phải định danh.
    if (i > 0) {
      final unit = src.codeUnitAt(i - 1);
      final isIdent =
          (unit >= 0x61 && unit <= 0x7A) || // a-z
          (unit >= 0x41 && unit <= 0x5A) || // A-Z
          (unit >= 0x30 && unit <= 0x39) || // 0-9
          unit == 0x5F || // _
          unit == 0x2E; // .
      if (isIdent) continue;
    }
    final open = src.indexOf('(', i);
    final close = _matchingParen(src, open);
    if (close < 0) continue;
    final children = _childrenListBody(src.substring(open + 1, close));
    if (children == null) continue;
    final first = _topLevelChildren(children).firstOrNull;
    if (first == null) continue;
    final t = first.trim();
    if (t.startsWith('Icon(') || t.startsWith('const Icon(')) count++;
    // Nhảy qua phần thân Row vừa xét để không đếm lồng nhau.
    i = close;
  }
  return count;
}

void _scanDirectory(
  Directory dir,
  Map<String, int> hits, {
  bool tabletOnly = false,
}) {
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (tabletOnly && !normalized.contains('/tablet/')) continue;
    final src = _stripCommentLines(File(entity.path).readAsStringSync());
    final count = _bareLeadingIconRows(src);
    if (count > 0) {
      final key = normalized.substring(normalized.indexOf('/features/'));
      hits[key] = (hits[key] ?? 0) + count;
    }
  }
}

/// Thay từng dòng comment `//` thuần bằng DÒNG RỖNG — giữ nguyên số dòng để
/// số liệu ratchet ổn định khi thêm/bớt comment (comment chứa dấu phẩy sẽ phá
/// tách top-level args nên phải loại trước khi quét).
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

/// Trả về thân danh sách `children: [ ... ]` bên trong thân constructor,
/// hoặc null nếu không có.
String? _childrenListBody(String ctorBody) {
  final m = RegExp(
    r'children\s*:\s*(?:<\s*Widget\s*>\s*)?\[',
  ).firstMatch(ctorBody);
  if (m == null) return null;
  final open = ctorBody.indexOf('[', m.start);
  var depth = 0;
  String? quote;
  for (var i = open; i < ctorBody.length; i++) {
    final c = ctorBody[i];
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
      if (depth == 0) return ctorBody.substring(open + 1, i);
    }
  }
  return null;
}

/// Tách các phần tử top-level của danh sách children theo dấu phẩy depth-0.
List<String> _topLevelChildren(String listBody) {
  final parts = <String>[];
  var depth = 0;
  String? quote;
  final buf = StringBuffer();
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
      parts.add(buf.toString());
      buf.clear();
    } else {
      buf.write(c);
    }
  }
  final tail = buf.toString();
  if (tail.trim().isNotEmpty && tail.trim() != 'const') parts.add(tail);
  return parts
      .where((p) => p.trim().isNotEmpty && p.trim() != 'const')
      .toList();
}
