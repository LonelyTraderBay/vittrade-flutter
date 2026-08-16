import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Riverpod 3 giấu type `Override` khỏi export chính — misc.dart là nơi chuẩn.
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/bootstrap/surface_router_host.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_app_router.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/router/web/web_app_router.dart';
import 'package:vit_trade_flutter/app/session_bootstrap.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_theme.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

class VitTradeApp extends StatefulWidget {
  const VitTradeApp({
    super.key,
    this.routerConfig,
    this.shellRenderMode,
    this.surface,
    this.overrides = const [],
  });

  final GoRouter? routerConfig;
  final ShellRenderMode? shellRenderMode;

  /// Cho phép entrypoint/test chốt surface. Khi bỏ trống, bootstrap chọn
  /// Web hoặc Phone/Tablet theo viewport hiện tại.
  final AppSurface? surface;

  /// GĐ4-F1: điểm bơm DI runtime từ bootstrap (storage thật, error reporter
  /// hợp nhất). Test không truyền gì — provider mặc định là impl in-memory.
  final List<Override> overrides;

  @override
  State<VitTradeApp> createState() => _VitTradeAppState();
}

class _VitTradeAppState extends State<VitTradeApp> {
  GoRouter? _generatedRouter;

  @override
  void didUpdateWidget(covariant VitTradeApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routerConfig != widget.routerConfig &&
        oldWidget.routerConfig == null) {
      _disposeGeneratedRouter();
    }
    if (oldWidget.surface != widget.surface ||
        oldWidget.shellRenderMode != widget.shellRenderMode) {
      _disposeGeneratedRouter();
    }
  }

  @override
  void dispose() {
    _disposeGeneratedRouter();
    super.dispose();
  }

  void _disposeGeneratedRouter() {
    _generatedRouter?.dispose();
    _generatedRouter = null;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedShellRenderMode =
        widget.shellRenderMode ?? defaultShellRenderMode();
    final resolvedRouter =
        widget.routerConfig ?? _resolveRouter(context, resolvedShellRenderMode);

    return ProviderScope(
      overrides: [...authSessionNetworkOverrides(), ...widget.overrides],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.bg,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        // GĐ4-F1: khôi phục phiên đăng nhập từ SecureStore ngay khi cây
        // widget dựng — phải nằm DƯỚI ProviderScope để đọc được provider.
        child: SessionBootstrap(
          child: _VitTradeMaterialApp(routerConfig: resolvedRouter),
        ),
      ),
    );
  }

  GoRouter _createSurfaceRouter(
    BuildContext context,
    ShellRenderMode resolvedShellRenderMode,
  ) {
    final viewportWidth = _viewportWidth(context);
    final selectedSurface =
        widget.surface ??
        AppSurfaceResolver.resolve(viewportWidth: viewportWidth, isWeb: kIsWeb);
    final host = SurfaceRouterHost(
      phoneRouter: () =>
          createPhoneAppRouter(shellRenderMode: resolvedShellRenderMode),
      tabletRouter: () =>
          createTabletAppRouter(shellRenderMode: resolvedShellRenderMode),
      webRouter: () =>
          createWebAppRouter(shellRenderMode: resolvedShellRenderMode),
    );
    return host.createRouter(selectedSurface);
  }

  GoRouter _resolveRouter(
    BuildContext context,
    ShellRenderMode resolvedShellRenderMode,
  ) {
    final router = _generatedRouter;
    if (router != null) return router;

    return _generatedRouter = _createSurfaceRouter(
      context,
      resolvedShellRenderMode,
    );
  }

  double _viewportWidth(BuildContext context) {
    final mediaQueryWidth = MediaQuery.maybeOf(context)?.size.width;
    if (mediaQueryWidth != null && mediaQueryWidth > 0) return mediaQueryWidth;

    final view = View.of(context);
    if (view.devicePixelRatio <= 0) return 0;
    return view.physicalSize.width / view.devicePixelRatio;
  }
}

class _VitTradeMaterialApp extends StatelessWidget {
  const _VitTradeMaterialApp({this.routerConfig});

  final GoRouter? routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VitTrade Flutter',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _VitTradeScrollBehavior(),
      routerConfig: routerConfig,
      // I18N-2 (DEC-i18n Nhánh A — vi-VN-only): copy sản phẩm là tiếng Việt
      // inline; các widget hệ thống của Material/Cupertino (date picker,
      // tooltip, paste menu...) cũng phải nói tiếng Việt qua delegates.
      // Độc lập với I18N-1 — kể cả vi-VN-only vẫn cần khai báo này.
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // A11Y-2/3: caps OS-level font-scaling boosts at 1.3x so large system
      // text sizes cannot overflow the fixed-height chrome/card layouts
      // throughout the app. KHÔNG đặt minScaleFactor (giữ mặc định 0):
      // sàn 1.0 từng làm _ClampedTextScaler.clamp của framework gộp khoảng
      // với clamp con maxScaleFactor <= 1.0 (vd. _DatePickerHeader trong
      // showDatePicker) thành min == max và nổ assert `maxScale > minScale`
      // ở chế độ debug; chữ thu nhỏ dưới 1.0 không gây overflow nên sàn
      // không bảo vệ layout nào cả.
      builder: (context, child) =>
          MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3, child: child!),
      theme: AppTheme.dark,
    );
  }
}

class _VitTradeScrollBehavior extends MaterialScrollBehavior {
  const _VitTradeScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
