// Origin: 60a7f124 (2026-06-04) - feat: chuẩn hóa header và điều hướng Flutter
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app code uses clamping scroll physics consistently', () {
    final scanRoots = [
      Directory('lib/app'),
      Directory('lib/features'),
      Directory('lib/shared'),
    ];
    final violations = <String>[];

    for (final root in scanRoots) {
      if (!root.existsSync()) {
        continue;
      }

      for (final entity in root.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }

        final path = entity.path.replaceAll('\\', '/');
        final lines = entity.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          if (lines[index].contains('BouncingScrollPhysics')) {
            violations.add('$path:${index + 1}: ${lines[index].trim()}');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use ClampingScrollPhysics for project-wide scroll consistency.\n'
          '${violations.join('\n')}',
    );
  });

  test('shrinkWrap: true đi kèm NeverScrollableScrollPhysics '
      '(hoặc allowlist bottom-sheet có chủ đích)', () {
    // PERF-HN7 (A-Plus GĐ3): shrinkWrap ép list đo toàn bộ con ngay khi
    // layout — chấp nhận được KHI list không tự cuộn (Never physics, thường
    // là list lồng trong SingleChildScrollView). shrinkWrap + cuộn được là
    // mùi hiệu năng (đo hết con mà vẫn cuộn). Baseline 2026-07-18: 55/64
    // chỗ đã đúng cặp; 9 chỗ dưới đây là bottom-sheet/trang transfer nơi
    // list LỒNG TRONG SHEET tự cuộn có chủ đích — allowlist theo file
    // (không ghim số dòng để không gãy khi file xê dịch), CHỈ ĐƯỢC GIẢM.
    const allowlist = {
      'lib/features/profile/presentation/widgets/device_management_page_sections.dart',
      'lib/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart',
      'lib/features/trade/presentation/widgets/tablet/vit_trade_confirm_sheet.dart',
      'lib/features/wallet/presentation/pages/assets/buy_crypto_page.dart',
      'lib/features/wallet/presentation/phone/pages/deposit_page.dart',
      'lib/features/wallet/presentation/phone/pages/transfer_page.dart',
      'lib/features/wallet/presentation/widgets/transfer/wallet_transfer_confirm_sheet.dart',
      'lib/features/wallet/presentation/widgets/transfer/withdraw_network_picker.dart',
      'lib/features/wallet/presentation/widgets/transfer/withdraw_preview_sheet.dart',
    };

    final violations = <String>[];
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
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (!lines[i].contains('shrinkWrap: true')) continue;
        final windowStart = i - 3 < 0 ? 0 : i - 3;
        final windowEnd = i + 4 > lines.length ? lines.length : i + 4;
        final window = lines.sublist(windowStart, windowEnd).join('\n');
        if (window.contains('NeverScrollableScrollPhysics')) continue;
        if (allowlist.contains(path)) continue;
        violations.add('$path:${i + 1}');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'shrinkWrap: true không kèm NeverScrollableScrollPhysics trong ±3 '
          'dòng và không thuộc allowlist bottom-sheet — hoặc thêm physics, '
          'hoặc bỏ shrinkWrap (dùng list lười), hoặc nếu là sheet tự cuộn '
          'có chủ đích thì thêm file vào allowlist kèm lý do: $violations',
    );
  });
}
