// Origin: bc10382c (2026-07-17) - feat(i18n+format): chinh sach vi-VN-only + locale vi + facade VitFormat — dong Cum 5
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// I18N-1 (A-Plus GĐ2, DEC-i18n Nhánh A — vi-VN-only): ratchet chặn chuỗi
/// tiếng Anh user-facing MỚI trong presentation layer. Chính sách đầy đủ:
/// AGENTS.md mục "Chính sách ngôn ngữ (vi-VN-only)".
///
/// Thiết kế BASELINE-DIFF, không language-detect: nợ tiếng Anh hiện trạng
/// được ghim trong `i18n_vi_only_baseline.txt` (khóa `path|literal`); test
/// chỉ fail khi xuất hiện khóa MỚI ngoài baseline (chuỗi tiếng Anh mới, hoặc
/// SỬA chuỗi baseline mà chưa dịch — chạm là dịch luôn), và khi baseline còn
/// khóa đã biến mất (đã dịch/xóa → dọn baseline cho nợ chỉ giảm).
///
/// Heuristic nhận diện "tiếng Anh user-facing" (đã né bẫy tiếng Việt không
/// dấu kiểu "mua nhanh" — xem memory ASCII-only language detection):
/// literal có DẤU CÁCH (câu chữ thật, loại path/Key/id), KHÔNG có dấu tiếng
/// Việt, và chứa >= 2 từ marker tiếng Anh đứng riêng. Chuỗi 1 từ ("Cancel")
/// nằm ngoài tầm quét — chấp nhận, đổi lấy zero false-positive.
///
/// Tái sinh baseline (chỉ khi CHỦ ĐÍCH trả nợ dịch):
///   I18N_BASELINE_WRITE=1 flutter test test/quality/i18n_vi_only_guardrail_test.dart
/// Generator và checker là CÙNG một hàm quét — không lệch nhau được.
const _baselinePath = 'test/quality/i18n_vi_only_baseline.txt';

const _markerWords = {
  'the',
  'and',
  'or',
  'of',
  'to',
  'for',
  'with',
  'your',
  'you',
  'all',
  'new',
  'not',
  'no',
  'please',
  'try',
  'again',
  'loading',
  'error',
  'failed',
  'success',
  'submit',
  'cancel',
  'confirm',
  'settings',
  'manage',
  'create',
  'delete',
  'update',
  'view',
  'from',
  'this',
  'are',
  'is',
  'be',
  'will',
  'can',
  'has',
  'have',
  'more',
  'less',
  'show',
  'hide',
  'add',
  'remove',
  'edit',
  'save',
  'close',
  'open',
  'back',
  'next',
  'done',
  'search',
  'filter',
  'sort',
  'select',
  'choose',
  'enter',
  'required',
  'invalid',
  'available',
  'balance',
  'price',
  'amount',
  'total',
  'market',
  'order',
  'trade',
  'buy',
  'sell',
  'wallet',
  'account',
  'history',
  'details',
  'info',
  'data',
  'network',
  'connection',
  'retry',
  'refresh',
  // Marker bổ sung 2026-08-29 (P1 depth-pane): các cụm thuật ngữ chart/lệnh
  // từng trượt heuristic vì mỗi chuỗi chỉ đếm được 0-1 từ marker cũ
  // ('Depth Chart', 'Order Book', 'Whale Alert', 'Bid Wall', 'Spread').
  'depth',
  'chart',
  'book',
  'whale',
  'alert',
  'spread',
  'wall',
  'bid',
  'ask',
};

final _vietnameseDiacritics = RegExp(
  '[àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợ'
  'ùúủũụưừứửữựỳýỷỹỵđ]',
  caseSensitive: false,
);
final _stringLiteral = RegExp(r"'((?:[^'\\\n]|\\.){4,})'");
final _asciiWord = RegExp('[A-Za-z]+');

Set<String> _scanEnglishLookingLiterals() {
  final found = <String>{};
  final files =
      Directory('lib').listSync(recursive: true).whereType<File>().toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );
  for (final file in files) {
    final path = file.path.replaceAll(r'\', '/');
    if (!path.endsWith('.dart')) continue;
    final userFacing =
        path.contains('/presentation/') || path.startsWith('lib/shared/');
    if (!userFacing) continue;

    for (final rawLine in file.readAsLinesSync()) {
      final line = rawLine.trim();
      if (line.startsWith('//') ||
          line.startsWith('import ') ||
          line.startsWith('export ') ||
          line.startsWith('part ')) {
        continue;
      }
      if (line.contains('semanticIdentifier') || line.contains('Key(')) {
        continue;
      }
      for (final match in _stringLiteral.allMatches(rawLine)) {
        final text = match.group(1)!;
        if (!text.contains(' ')) continue;
        if (text.contains('package:') || text.startsWith('/')) continue;
        if (_vietnameseDiacritics.hasMatch(text)) continue;
        final words = _asciiWord
            .allMatches(text)
            .map((m) => m.group(0)!.toLowerCase())
            .toSet();
        if (words.intersection(_markerWords).length < 2) continue;
        found.add('$path|$text');
      }
    }
  }
  return found;
}

void main() {
  test('presentation layer không thêm chuỗi tiếng Anh user-facing mới', () {
    final found = _scanEnglishLookingLiterals();

    final baselineFile = File(_baselinePath);
    if (Platform.environment['I18N_BASELINE_WRITE'] == '1') {
      final sorted = found.toList()..sort();
      baselineFile.writeAsStringSync('${sorted.join('\n')}\n');
      return;
    }

    expect(
      baselineFile.existsSync(),
      isTrue,
      reason:
          'Thiếu $_baselinePath — tái sinh bằng I18N_BASELINE_WRITE=1 '
          'flutter test test/quality/i18n_vi_only_guardrail_test.dart',
    );
    final baseline = baselineFile
        .readAsLinesSync()
        .where((l) => l.trim().isNotEmpty)
        .toSet();

    final fresh = found.difference(baseline).toList()..sort();
    final stale = baseline.difference(found).toList()..sort();

    expect(
      fresh,
      isEmpty,
      reason:
          'Chuỗi tiếng Anh user-facing MỚI (hoặc chuỗi baseline bị sửa mà '
          'chưa dịch) — chính sách vi-VN-only (AGENTS.md): viết copy tiếng '
          'Việt có dấu đầy đủ thay vì tiếng Anh: $fresh',
    );
    expect(
      stale,
      isEmpty,
      reason:
          'Chuỗi đã được dịch/xóa nhưng còn trong baseline — dọn để nợ chỉ '
          'giảm: chạy I18N_BASELINE_WRITE=1 flutter test '
          'test/quality/i18n_vi_only_guardrail_test.dart rồi commit '
          'baseline mới: $stale',
    );
  });
}
