import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

/// Khóa composition của [VitTabletSectionFrame] — khung chuẩn thay khuôn
/// `Center + ConstrainedBox(maxWidth: …)` tự chế (2026-09-09):
/// gap section 12dp do frame sở hữu, cột đọc top-start anchored cap
/// [TabletDashboardWidths.readingContentMaxWidth], back wire qua
/// `goBackOrFallback`.
void main() {
  tearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);

  testWidgets('section gap 12dp, cột top-start cap 1080, mép contentPad', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: _frameRouter(
          frame: const VitTabletSectionFrame(
            semanticIdentifier: 'TEST-FRAME',
            semanticLabel: 'Khung thử nghiệm',
            title: 'Khung thử nghiệm',
            children: [
              SizedBox(key: Key('section_a'), height: 60),
              SizedBox(key: Key('section_b'), height: 60),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final rectA = tester.getRect(find.byKey(const Key('section_a')));
    final rectB = tester.getRect(find.byKey(const Key('section_b')));
    final headerRect = tester.getRect(find.byType(VitHeader));

    // Gap giữa 2 section đúng bằng section gap chuẩn của rhythm standard.
    expect(
      rectB.top - rectA.bottom,
      closeTo(TabletSpacingTokens.pageRhythmStandardSectionGap, 0.1),
    );

    // Cột đọc top-start anchored: nội dung nằm sát dưới header (compact top
    // padding), KHÔNG trôi giữa viewport như khuôn Center cũ.
    final topInset = rectA.top - headerRect.bottom;
    expect(topInset, greaterThanOrEqualTo(0));
    expect(topInset, lessThan(20));

    // Mép trái = contentPad, cap độ rộng đọc 1080 (1280 - 2*20 < 1080 nên
    // cột chiếm hết chỗ và stretch đúng 1040).
    expect(rectA.left, TabletSpacingTokens.contentPad);
    expect(
      rectA.width,
      TabletDashboardWidths.readingContentMaxWidth -
          2 * TabletSpacingTokens.contentPad,
    );

    // Top padding đúng preset compact của VitPageContent.
    expect(topInset, closeTo(AppSurfaceSpacing.pageContentTopCompact, 0.1));
  });

  testWidgets('push vào frame có nút back; tap back pop về trang trước', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = _frameRouter(
      initial: '/',
      frame: const VitTabletSectionFrame(
        semanticIdentifier: 'TEST-FRAME',
        semanticLabel: 'Khung thử nghiệm',
        title: 'Khung thử nghiệm',
        children: [SizedBox(height: 60)],
      ),
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // Không còn stack lịch sử: không render nút back rỗng.
    expect(find.byType(VitHeaderActionButton), findsNothing);

    await tester.tap(find.byKey(const Key('push_to_frame')));
    await tester.pumpAndSettle();
    expect(find.byType(VitHeaderActionButton), findsOneWidget);

    await tester.tap(find.byType(VitHeaderActionButton));
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.uri.path, '/');
  });
}

GoRouter _frameRouter({required Widget frame, String initial = '/frame'}) {
  return GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(
            child: FilledButton(
              key: const Key('push_to_frame'),
              onPressed: () => context.push('/frame'),
              child: const Text('Mở khung'),
            ),
          ),
        ),
      ),
      GoRoute(path: '/frame', builder: (context, state) => frame),
    ],
  );
}
