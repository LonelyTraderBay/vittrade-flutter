// Guardrail: CB-R6/R7 — padding VitCard phải đúng role & tường minh
// (Chuẩn Tablet Card & Border, Rule 4).
//
// Bug 2026-08-28 ("card bó sát quá"): pulse card KPI tái dùng token
// `marketListPairCompactHeaderPadding` (12 ngang / 0 dọc — role của sort
// header bảng pair) → chữ chạm viền card; và bẫy API VitCard:
// `padding ?? density?.cardPadding` — CẢ HAI NULL ⇒ KHÔNG bọc Padding (0),
// khiến "bỏ override" tưởng có mặc định 8dp là sai.
//
//   CB-R6 (absolute): tham số `padding:` của VitCard không được tham chiếu
//     token mang role PHẦN TỬ CON (`…Header…Padding` / `…Row…Padding` /
//     `…Cell…Padding`) — đó là padding của hàng/header, không phải card.
//   CB-R7 (ratchet path|count): mọi VitCard phải TƯỜNG MINH `padding:` hoặc
//     `density:` — thiếu cả hai là dựa vào bẫy mặc định-0. Nợ legacy được
//     ghim theo SỐ LƯỢNG MỖI FILE (miễn nhiễm dịch dòng); chỉ được giảm.
//     VitCard mới thiếu → count tăng → fail CI.
//
// Scanner lưu ý (bài học 2026-08-28): strip comment thuần bằng cách THAY
// DÒNG RỖNG — comment chứa dấu phẩy bên trong constructor làm vỡ
// comma-splitting depth-0 (chính rule này từng misparse 2 chỗ do comment
// của người vá).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Baseline CB-R7 — 2026-08-28: 99 VitCard legacy trên 33 file (khung chứa
/// nội dung tự quản padding). Migrate on touch: khi thêm `padding:` tường
/// minh, giảm count; khi file về 0 thì xóa entry.
const Map<String, int> kBaselineImplicitPaddingCards = {
  'features/home/presentation/widgets/tablet/home_discovery_panel.dart': 1,
  'features/home/presentation/widgets/tablet/home_market_watchlist_panel.dart':
      1,
  'features/home/presentation/widgets/tablet/home_recent_products_section.dart':
      1,
  'features/home/presentation/widgets/tablet/home_status_content.dart': 2,
  'features/markets/presentation/widgets/tablet/markets_status_content.dart': 1,
  'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart': 3,
  'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart':
      1,
  'features/profile/presentation/widgets/tablet/profile_kyc_pane.dart': 2,
  'features/profile/presentation/widgets/tablet/profile_menu_panel.dart': 1,
  'features/profile/presentation/widgets/tablet/profile_security_pane.dart': 2,
  'features/profile/presentation/widgets/tablet/profile_settings_pane.dart': 2,
  'features/profile/presentation/widgets/tablet/profile_status_content.dart': 2,
  'features/profile/presentation/widgets/tablet/profile_vip_pane.dart': 1,
  'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart': 3,
  'features/trade/presentation/widgets/tablet/trade_ticker_strip.dart': 1,
  'features/wallet/presentation/tablet/pages/address_book_tablet_page.dart': 1,
  'features/wallet/presentation/tablet/pages/asset_detail_tablet_page.dart': 3,
  'features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart': 2,
  'features/wallet/presentation/tablet/pages/deposit_tablet_page.dart': 4,
  'features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart':
      4,
  'features/wallet/presentation/tablet/pages/network_status_tablet_page.dart':
      11,
  'features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart':
      2,
  'features/wallet/presentation/tablet/pages/portfolio_analytics_tablet_page.dart':
      4,
  'features/wallet/presentation/tablet/pages/transaction_detail_tablet_page.dart':
      1,
  'features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart':
      2,
  'features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart':
      7,
  'features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart':
      7,
  'features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart':
      5,
  'features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart':
      6,
  'features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart':
      6,
  'features/wallet/presentation/widgets/tablet/wallet_page_asset_sections.dart':
      3,
  'shared/layout/vit_tablet_utility_page.dart': 3,
};

final _vitCardStartRe = RegExp(r'\bVitCard\s*\(');
final _childRolePaddingTokenRe = RegExp(
  r'(Header|Row|Cell)\w*Padding|Padding\w*(Header|Row|Cell)',
);

void main() {
  final roleMisuse = <String>[];
  final implicitByFile = <String, int>{};

  setUpAll(() {
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final fileName = normalized.split('/').last;
      final isTabletSurface =
          normalized.contains('/tablet/') || fileName.contains('tablet');
      if (!isTabletSurface) continue;
      if (normalized.contains('/app/theme/') ||
          normalized.contains('/shared/widgets/')) {
        continue;
      }

      // Comment thuần → dòng rỗng (giữ số dòng; chống phẩy trong comment
      // làm vỡ comma-splitting depth-0).
      final source = entity
          .readAsLinesSync()
          .map((l) => l.trimLeft().startsWith('//') ? '' : l)
          .join('\n');

      for (final match in _vitCardStartRe.allMatches(source)) {
        final openParen = source.indexOf('(', match.start);
        final closeParen = _matchingParen(source, openParen);
        if (closeParen < 0) continue;
        final args = _topLevelArgs(source.substring(openParen + 1, closeParen));
        final paddingArg = args
            .where((a) => a.startsWith('padding:'))
            .followedBy(const <String>[''])
            .first;

        if (paddingArg.isNotEmpty &&
            _childRolePaddingTokenRe.hasMatch(paddingArg)) {
          final lineNo =
              '\n'.allMatches(source.substring(0, match.start)).length + 1;
          final rel = normalized.replaceFirst('lib/', '');
          roleMisuse.add('$rel|$lineNo');
        }

        final hasDensity = args.any((a) => a.startsWith('density:'));
        if (paddingArg.isEmpty && !hasDensity) {
          final rel = normalized.replaceFirst('lib/', '');
          implicitByFile[rel] = (implicitByFile[rel] ?? 0) + 1;
        }
      }
    }
  });

  test('CB-R6 absolute: padding VitCard không dùng token role phần tử con', () {
    expect(
      roleMisuse,
      isEmpty,
      reason:
          'VitCard dùng padding token của phần tử con (Header/Row/Cell):\n'
          '${roleMisuse.join('\n')}\n\n'
          'Padding card là của CARD — dùng EdgeInsetsDirectional.all(token) '
          'hoặc module card token; token *Header/*Row/*Cell là của hàng/'
          'header bên trong (bug pulse card 2026-08-28: 12/0 làm chữ chạm '
          'viền).',
    );
  });

  test(
    'CB-R7 ratchet: VitCard thiếu padding+density chỉ giảm (path|count)',
    () {
      final grew = <String>[];
      implicitByFile.forEach((file, count) {
        final base = kBaselineImplicitPaddingCards[file] ?? 0;
        if (count > base) grew.add('$file: $base -> $count');
      });
      expect(
        grew,
        isEmpty,
        reason:
            'File có VitCard MỚI thiếu cả padding lẫn density (CB-R7):\n'
            '${grew.join('\n')}\n\n'
            'Bẫy VitCard: padding & density cùng null ⇒ KHÔNG có Padding nào '
            '(mặc định 0, không phải 8). Luôn truyền tường minh một trong hai '
            '— card khung full-bleed thì `padding: AppSpacing.zeroInsets`.',
      );

      final stale = <String>[];
      kBaselineImplicitPaddingCards.forEach((file, base) {
        final now = implicitByFile[file] ?? 0;
        if (now < base) stale.add('$file: $base -> $now');
      });
      expect(
        stale,
        isEmpty,
        reason:
            'Baseline CB-R7 có file đã giảm nợ (đã tường minh hóa):\n'
            '${stale.join('\n')}\n\n'
            'Cập nhật count/xóa entry trong kBaselineImplicitPaddingCards — '
            'nợ chỉ được giảm.',
      );
    },
  );
}

int _matchingParen(String text, int open) {
  var depth = 0;
  var inStr = false;
  var quote = ' ';
  for (var i = open; i < text.length; i++) {
    final c = text[i];
    if (inStr) {
      if (c == quote && (i == 0 || text[i - 1] != r'\')) inStr = false;
      continue;
    }
    if (c == "'" || c == '"') {
      inStr = true;
      quote = c;
      continue;
    }
    if (c == '(') depth++;
    if (c == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

List<String> _topLevelArgs(String body) {
  final out = <String>[];
  var depth = 0;
  var start = 0;
  var inStr = false;
  var quote = ' ';
  for (var i = 0; i < body.length; i++) {
    final c = body[i];
    if (inStr) {
      if (c == quote && (i == 0 || body[i - 1] != r'\')) inStr = false;
      continue;
    }
    if (c == "'" || c == '"') {
      inStr = true;
      quote = c;
      continue;
    }
    if (c == '(' || c == '[' || c == '{') {
      depth++;
    } else if (c == ')' || c == ']' || c == '}') {
      depth--;
    } else if (c == ',' && depth == 0) {
      out.add(body.substring(start, i));
      start = i + 1;
    }
  }
  out.add(body.substring(start));
  return out.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
