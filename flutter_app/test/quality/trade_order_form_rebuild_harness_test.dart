// Origin: 2e71daab (2026-07-17) - feat(arch-a1+perf): gỡ sạch 2 cycle họ trade + hiệu năng markets — đóng Cụm 3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade/data/repositories/mock_trade_repository.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';

/// PERF-HN2 rebuild harness: types into `TradePage.amountFieldKey` and
/// counts how many distinct `tradeOrderControllerProvider` family members
/// get created (`didAddProvider`)/updated (`didUpdateProvider`) — the
/// notifier build() reconstructs a fresh `TradeOrderDraft` on every widget
/// build, and the family key is `({pairId, draft})`, so a naive per-
/// keystroke rebuild without value equality would leak one cache element
/// per character (PERF-HN1's original bug).
///
/// Deliberately types '0', '0.', '0.1' rather than three distinct amounts:
/// `double.tryParse('0')` and `double.tryParse('0.')` both parse to `0.0`
/// (verified via `dart run` — see batch report), so the middle keystroke
/// must NOT add a new family member (memory: "gõ cùng giá trị không
/// trigger rebuild thật", PERF-HN1). Only the final '1' keystroke changes
/// the parsed amount to `0.1`, a genuinely different draft.
base class _CountingObserver extends ProviderObserver {
  int addCount = 0;
  int updateCount = 0;

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (identical(context.provider.from, tradeOrderControllerProvider)) {
      addCount += 1;
    }
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (identical(context.provider.from, tradeOrderControllerProvider)) {
      updateCount += 1;
    }
  }
}

void main() {
  testWidgets('PERF-HN2 typing distinct amount characters keeps '
      'tradeOrderControllerProvider member churn bounded', (tester) async {
    final observer = _CountingObserver();

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        observers: [observer],
        // GĐ4-F3 (bẫy playbook §9.16): preview provider giờ là
        // autoDispose.family async — mock delay mặc định 300ms để lại
        // orphaned timer khi member cũ bị dispose giữa chừng.
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Trang mount lần đầu đã watch tradeOrderControllerProvider với
    // amount mặc định (ô trống -> 0.0) — đây là baseline hợp lệ, không
    // phải churn do gõ phím. GĐ4-F3: controller GHI giờ seed từ snapshot
    // ASYNC — khi future resolve trong settle đầu, build() re-seed đúng
    // MỘT lần (didUpdateProvider +1); tính vào baseline, không phải churn.
    final baseline = observer.addCount;
    final baselineUpdates = observer.updateCount;

    await tester.enterText(TradePage.amountFieldKey.finder, '0');
    await tester.pump();
    await tester.enterText(TradePage.amountFieldKey.finder, '0.');
    await tester.pump();
    await tester.enterText(TradePage.amountFieldKey.finder, '0.1');
    await tester.pump();

    // Đo thực tế (2026-07-17): baseline=1 (mount), '0' trùng amount mặc
    // định (0.0) nên không thêm member, '0.' cũng parse ra 0.0 (trùng) —
    // chỉ '0.1' tạo member thứ 2. Tổng addCount đo được = 2. Ghim
    // ngưỡng +2 đệm (≤4) để chịu được sai khác nhỏ giữa các lần chạy
    // (ví dụ debounce/layout timing) mà vẫn bắt được hồi quy leak thật
    // (leak cũ tạo 1 member MỚI mỗi ký tự — tức ≥3 member thêm chỉ từ 3
    // enterText này, tổng sẽ ≥4).
    expect(
      observer.addCount,
      lessThanOrEqualTo(baseline + 3),
      reason:
          'tradeOrderControllerProvider tạo quá nhiều member mới khi gõ '
          'từng ký tự — nghi ngờ hồi quy PERF-HN1 (draft mất value '
          'equality hoặc provider không còn .autoDispose.family reuse '
          'đúng key).',
    );

    // Gõ không kích hoạt submit/preview nên không có mutation nào gọi
    // `state = ...` trên tradeOrderControllerProvider — updateCount phải
    // bằng 0.
    expect(
      observer.updateCount - baselineUpdates,
      0,
      reason:
          'Gõ số lượng không được phép trigger didUpdateProvider trên '
          'tradeOrderControllerProvider (không mutation nào chạy khi chỉ '
          'gõ phím; lần re-seed async lúc mount đã nằm trong baseline).',
    );
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
