// Phủ toàn bộ nhánh path của visual_qa_route_metadata (CI coverage 2026-09-10:
// 261 dòng chưa phủ — file này từng chỉ được dùng gián tiếp qua route probe).
// Chiến lược: duyệt TOÀN BỘ path trong tabletRouteManifest (nguồn sự thật
// route) qua cả hai hàm, cộng thêm các nhánh đặc biệt (query tab=arena,
// fallback path lạ).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_route_manifest.dart';
import 'package:vit_trade_flutter/app/router/visual_qa_route_metadata.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  group('activeDestinationForPath', () {
    test('mọi route trong manifest đều map về một destination hợp lệ', () {
      for (final spec in tabletRouteManifest) {
        final destination = activeDestinationForPath(spec.path);
        expect(
          VitBottomNavDestination.values.contains(destination),
          isTrue,
          reason: spec.path,
        );
      }
    });

    test('các nhóm path đặc biệt map đúng destination', () {
      expect(activeDestinationForPath('/news'), VitBottomNavDestination.home);
      expect(
        activeDestinationForPath('/topic/trading'),
        VitBottomNavDestination.home,
      );
      expect(
        activeDestinationForPath('/support/faq'),
        VitBottomNavDestination.home,
      );
      expect(
        activeDestinationForPath('/launchpad'),
        VitBottomNavDestination.trade,
      );
      expect(
        activeDestinationForPath('/launchpad/ido'),
        VitBottomNavDestination.trade,
      );
      expect(
        activeDestinationForPath('/pair/btc-usdt'),
        VitBottomNavDestination.markets,
      );
      expect(activeDestinationForPath('/admin'), VitBottomNavDestination.trade);
      expect(
        activeDestinationForPath('/referral/leaderboard'),
        VitBottomNavDestination.profile,
      );
      expect(
        activeDestinationForPath('/settings/security/password'),
        VitBottomNavDestination.profile,
      );
      // Fallback cuối: path lạ về home.
      expect(
        activeDestinationForPath('/khong-ton-tai'),
        VitBottomNavDestination.home,
      );
    });
  });

  group('visualQaStatusBarTimeForUri', () {
    test('mọi route trong manifest đều trả time HH:mm hợp lệ', () {
      final timePattern = RegExp(r'^\d{2}:\d{2}$');
      for (final spec in tabletRouteManifest) {
        final time = visualQaStatusBarTimeForUri(Uri(path: spec.path));
        expect(timePattern.hasMatch(time), isTrue, reason: spec.path);
      }
    });

    test('nhánh query tab=arena của rewards', () {
      expect(
        visualQaStatusBarTimeForUri(
          Uri(path: '/rewards', queryParameters: {'tab': 'arena'}),
        ),
        '23:34',
      );
      expect(
        visualQaStatusBarTimeForUri(
          Uri(path: '/rewards', queryParameters: {'tab': 'trading'}),
        ),
        '23:38',
      );
    });

    test('fallback path lạ về khung giờ mặc định', () {
      expect(visualQaStatusBarTimeForUri(Uri(path: '/khong-ton-tai')), '23:27');
    });
  });
}
