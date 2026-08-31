// LUẬT 8PT/12DP (user chốt 2026-08-31): mọi khoảng trắng DỌC của terminal
// Trade tablet đều bằng 12dp — không ngoại lệ. Test này đo RenderBox thật
// của mọi cặp kề nhau (panel↔panel, mép panel→nội dung, nhãn→nội dung,
// giữa các khối trong cột đặt lệnh) ở tầng đầy đủ 1280×800. Chạm vào
// terminal mà quên khoảng 13 đâu đó thì test này đỏ đúng chỗ.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_simple_order_form.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';

void main() {
  testWidgets('Luật 12dp: mọi khoảng dọc kề nhau của terminal == 12.0', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: '/trade/btcusdt',
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Rect rect(Key key) {
      final ro = tester.renderObject<RenderBox>(find.byKey(key));
      return ro.localToGlobal(Offset.zero) & ro.size;
    }

    Rect rectOf(Finder finder) {
      final ro = tester.renderObject<RenderBox>(finder);
      return ro.localToGlobal(Offset.zero) & ro.size;
    }

    void expectGap13(String label, Rect upper, Rect lower) {
      expect(
        lower.top - upper.bottom,
        moreOrLessEquals(12.0, epsilon: 0.1),
        reason:
            '$label phải cách nhau đúng 12dp theo luật 8pt của tablet '
            '(thực tế ${lower.top - upper.bottom})',
      );
    }

    final meta = rect(TradeTabletKeys.metaStrip);
    final chart = rect(TradeTabletKeys.chartPanel);
    final bottom = rect(TradeTabletKeys.bottomPanel);
    final book = rect(TradeTabletKeys.bookPanel);
    final tape = rect(TradeTabletKeys.tapePanel);

    // Panel ↔ panel (gutter).
    expectGap13(
      'meta strip → product tabs',
      meta,
      rect(TradeTabletKeys.quickNav('spot')),
    );
    expectGap13(
      'product tabs → chart',
      rect(TradeTabletKeys.quickNav('spot')),
      chart,
    );
    expectGap13('chart → panel tab dưới', chart, bottom);
    expectGap13('sổ lệnh → tape', book, tape);

    // Mép panel → nội dung đầu tiên (so mép trên với mép trên).
    void expectTop13(String label, Rect panel, Rect content) {
      expect(
        content.top - panel.top,
        moreOrLessEquals(12.0, epsilon: 0.1),
        reason:
            '$label phải cách nhau đúng 12dp (thực tế '
            '${content.top - panel.top})',
      );
    }

    // Đo theo phần tử CHẠM MÉP flow (IconButton làm mới cao nhất hàng) —
    // các phần tử thấp hơn bị crossAxisAlignment.center làm lệch tâm,
    // không phải gap.
    expectTop13(
      'mép meta → hàng nội dung',
      meta,
      rect(TradeTabletKeys.refresh),
    );
    expectTop13(
      'mép chart → nút khung giờ đầu',
      chart,
      rect(TradeTabletKeys.timeframe('1m')),
    );
    // Tab pill bị center trong Row 40dp (IconButton "Xem tất cả" cao
    // nhất) — đo theo phần tử chạm mép flow là nút icon.
    expectTop13(
      'mép panel dưới → hàng tab',
      bottom,
      rect(TradeTabletKeys.bottomTab('view_all')),
    );

    // Nhãn → nội dung (padding đáy của nhãn).
    expectGap13(
      'nhãn SỔ LỆNH → mức giá đầu',
      rectOf(find.text('SỔ LỆNH')),
      rect(TradeTabletKeys.bookRow('ask', 11)),
    );
    expectGap13(
      'nhãn GIAO DỊCH → header cột',
      rectOf(find.text('GIAO DỊCH')),
      rectOf(
        find.descendant(
          of: find.byKey(TradeTabletKeys.tapePanel),
          matching: find.text('Khối lượng'),
        ),
      ),
    );

    // Cột đặt lệnh: nhãn → form → risk → disclaimer.
    final form = rectOf(find.byType(VitTradeSimpleOrderForm));
    expectGap13('nhãn ĐẶT LỆNH → form', rectOf(find.text('ĐẶT LỆNH')), form);
    expectGap13(
      'form → panel rủi ro',
      form,
      rectOf(find.byType(VitHighRiskStatePanel)),
    );
    expectGap13(
      'panel rủi ro → disclaimer',
      rectOf(find.byType(VitHighRiskStatePanel)),
      rectOf(
        find.text(
          'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
        ),
      ),
    );
    // Nội dung cuối → viền dưới panel đặt lệnh (cuộn nội bộ tới đáy).
    await tester.drag(
      find.byType(VitTradeSimpleOrderForm),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .renderObject<RenderBox>(find.byKey(TradeTabletKeys.entryPanel))
          .size,
      isNotNull,
    );
  });
}
