import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

/// Opens [route] as the Profile master-detail detail pane with correct
/// back-stack semantics (iPad-Settings behavior): the first pane opened
/// from the overview is *pushed* on top of it, and switching to another
/// pane *replaces* the current one — so the system back button (and the
/// pane headers' back action) always returns to the overview instead of
/// walking a growing history or exiting the tab, which is what plain
/// `context.go` would do against the flat sibling route list.
///
/// Cross-module rows (Referral, Hỗ trợ, product hubs…) are a different
/// story: they leave the shell entirely, so they must always be *pushed*
/// — replacing them would drop the shell from the stack and the system
/// back could not return to Tài khoản.
void openProfileDetailRoute(BuildContext context, String route) {
  final currentPath = GoRouterState.of(context).uri.path;
  if (currentPath == route) return;
  final inShellPane =
      currentPath != AppRoutePaths.profile && _isProfileShellRoute(route);
  if (currentPath == AppRoutePaths.profile || !inShellPane) {
    unawaited(context.push(route));
  } else {
    context.pushReplacement(route);
  }
}

/// Whether [route] renders inside the Profile master-detail shell (the
/// overview hub itself, its `/profile/...` sub-routes, and the security
/// settings family the menu's «Bảo mật & 2FA» row opens).
bool _isProfileShellRoute(String route) {
  if (route == AppRoutePaths.profile) return true;
  if (route.startsWith('${AppRoutePaths.profile}/')) return true;
  return route == AppRoutePaths.settingsSecurity ||
      route.startsWith('${AppRoutePaths.settingsSecurity}/');
}
