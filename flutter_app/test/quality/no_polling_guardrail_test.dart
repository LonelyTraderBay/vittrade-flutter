// Origin: a7cadd94 (2026-07-18) - feat(gd4-f7): realtime — 3 Stream surface loi (ticker/depth/candles) + no-polling guardrail + ADR-009
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// GD4 Cụm F7 (REALTIME): dữ liệu realtime phải đến từ repository Stream
/// (`MarketRepository.watchTicker`/`watchDepth`,
/// `SpotTradeRepository.watchCandles`) — cấm UI tự polling bằng
/// `Timer.periodic` trong `lib/features/**/presentation/` và `lib/shared/`.
///
/// 3 site hiện có trong allowlist KHÔNG phải polling dữ liệu — chúng chỉ
/// đếm ngược/tự động chuyển trang cục bộ (không gọi lại repository):
/// - `otp_page.dart`: đếm ngược giây gửi lại OTP.
/// - `home_announcement_banner.dart`: tự động chuyển slide carousel.
///
/// Baseline CỐ ĐỊNH ở 2 — không tự nới allowlist khi thêm site mới; nếu một
/// tính năng cần cập nhật dữ liệu định kỳ, thêm method Stream vào repository
/// tương ứng (khuôn `watchTicker`/`watchDepth`/`watchCandles`) thay vì
/// `Timer.periodic` trong UI.
const _allowlist = {
  'lib/features/auth/presentation/pages/otp_page.dart',
  'lib/features/home/presentation/widgets/phone/home_announcement_banner.dart',
  'lib/features/home/presentation/widgets/tablet/home_announcement_banner.dart',
};

List<String> _timerPeriodicViolations() {
  final violations = <String>[];

  void scanDir(String root, {required bool presentationOnly}) {
    final dir = Directory(root);
    if (!dir.existsSync()) return;
    for (final file in dir.listSync(recursive: true).whereType<File>()) {
      final path = file.path.replaceAll('\\', '/');
      if (!path.endsWith('.dart')) continue;
      if (presentationOnly && !path.contains('/presentation/')) continue;
      if (_allowlist.contains(path)) continue;

      final source = file.readAsStringSync();
      if (source.contains('Timer.periodic')) {
        violations.add(path);
      }
    }
  }

  scanDir('lib/features', presentationOnly: true);
  scanDir('lib/shared', presentationOnly: false);
  return violations;
}

void main() {
  test(
    'presentation/shared code does not hand-roll Timer.periodic polling',
    () {
      final violations = _timerPeriodicViolations();

      expect(
        violations,
        isEmpty,
        reason:
            'Timer.periodic mới trong lib/features/**/presentation/ hoặc '
            'lib/shared/ — dữ liệu realtime phải đến từ repository Stream '
            '(watchTicker/watchDepth/watchCandles), không polling cục bộ '
            'trong UI: $violations',
      );
    },
  );

  test('allowlist entries still exist and still use Timer.periodic', () {
    // Bảo vệ chiều ngược lại: nếu 2 site này bị xoá/đổi tên mà quên dọn
    // allowlist, guardrail vẫn phải phát hiện được (không âm thầm pass vì
    // allowlist trỏ vào file không còn tồn tại).
    for (final path in _allowlist) {
      final file = File(path);
      expect(
        file.existsSync(),
        isTrue,
        reason: '$path không còn tồn tại — dọn allowlist.',
      );
      expect(
        file.readAsStringSync().contains('Timer.periodic'),
        isTrue,
        reason: '$path không còn dùng Timer.periodic — dọn allowlist.',
      );
    }
  });
}
