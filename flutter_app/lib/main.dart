import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vit_trade_flutter/app/error_fallback_screen.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/observability/error_reporter.dart';
import 'package:vit_trade_flutter/core/observability/local_log_error_reporter.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/core/storage/secure_store.dart';

void main() {
  // GĐ4-F1: MỘT instance reporter duy nhất cho CẢ ba đường lỗi ngoài cây
  // widget (FlutterError.onError / PlatformDispatcher.onError /
  // runZonedGuarded) VÀ cho code in-tree qua override
  // `errorReporterProvider` bên dưới — hợp nhất hai đường report song song
  // trước đây. Vendor crash-reporting thật thay tại đây + provider (ADR-008).
  final LocalLogErrorReporter errorReporter = LocalLogErrorReporter();

  // Toàn bộ bootstrap (kể cả ensureInitialized) nằm TRONG zone để binding
  // và runApp cùng zone — tránh cảnh báo "Zone mismatch" của framework.
  // Fire-and-forget: bootstrap chạy trong zone tới khi app đóng, không có
  // điểm nào trong main() cần đợi Future này hoàn tất.
  unawaited(
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        _disableDebugVisualOverlays();

        FlutterError.onError = (FlutterErrorDetails details) {
          errorReporter.report(
            details.exception,
            details.stack ?? StackTrace.empty,
            context: 'FlutterError.onError: ${details.context}',
          );
          FlutterError.presentError(details);
        };

        ErrorWidget.builder = (FlutterErrorDetails details) =>
            const VitErrorFallbackScreen();

        PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
          errorReporter.report(
            error,
            stack,
            context: 'PlatformDispatcher.onError',
          );
          return true;
        };

        // Persistence khởi tạo TRƯỚC runApp để mọi phép đọc KeyValueStore
        // trong app là đồng bộ (SharedPreferences cache sẵn vào bộ nhớ).
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();

        runApp(
          VitTradeApp(
            // Splash logo chỉ phát ở app thật (opt-in) — test không bật.
            showSplash: true,
            overrides: [
              errorReporterProvider.overrideWithValue(errorReporter),
              keyValueStoreProvider.overrideWithValue(
                SharedPreferencesKeyValueStore(preferences),
              ),
              secureStoreProvider.overrideWithValue(const FlutterSecureStore()),
            ],
          ),
        );
      },
      (Object error, StackTrace stack) {
        errorReporter.report(error, stack, context: 'runZonedGuarded');
      },
    ),
  );
}

void _disableDebugVisualOverlays() {
  assert(() {
    debugPaintBaselinesEnabled = false;
    return true;
  }());
}
