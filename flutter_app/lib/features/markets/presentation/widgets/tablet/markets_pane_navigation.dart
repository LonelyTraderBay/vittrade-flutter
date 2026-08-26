import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

/// Mở [route] làm detail pane của Markets terminal master-detail với ngữ
/// nghĩa back-stack đúng (hành vi Binance-iPad): pane đầu tiên mở từ tổng
/// quan được *push* lên trên nó, chuyển sang pane khác thì *replace* pane
/// hiện tại — nút back hệ thống (và back header của pane) luôn quay về
/// tổng quan, thay vì đi dọc một lịch sử dài hoặc thoát tab, điều mà
/// `context.go` sẽ gây ra trên danh sách route flat.
///
/// Cross-module destinations (Trade, DCA…) rời shell hoàn toàn nên luôn
/// phải *push* — replace sẽ đá shell khỏi stack và back không quay lại
/// được Thị trường.
void openMarketsDetailRoute(BuildContext context, String route) {
  final currentPath = GoRouterState.of(context).uri.path;
  if (currentPath == route) return;
  final inShellPane =
      currentPath != AppRoutePaths.markets && _isMarketsShellRoute(route);
  if (currentPath == AppRoutePaths.markets || !inShellPane) {
    unawaited(context.push(route));
  } else {
    context.pushReplacement(route);
  }
}

/// [route] có render bên trong Markets terminal shell hay không: tổng quan
/// `/markets`, các sub-route `/markets/...` (placeholder tools) và bộ 3
/// phân tích cặp `/pair/...`.
bool _isMarketsShellRoute(String route) {
  if (route == AppRoutePaths.markets) return true;
  if (route.startsWith('${AppRoutePaths.markets}/')) return true;
  return route.startsWith('/pair/');
}
