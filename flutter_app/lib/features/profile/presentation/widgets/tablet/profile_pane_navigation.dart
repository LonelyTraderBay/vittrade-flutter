import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

/// Opens [route] as the Profile master-detail detail pane with correct
/// back-stack semantics (iPad-Settings behavior): the first pane opened
/// from the overview is *pushed* on top of it, and switching to another
/// pane *replaces* the current one — so the system back button (and the
/// pane headers' back action) always returns to the overview instead of
/// walking a growing history or exiting the tab, which is what plain
/// `context.go` would do against the flat sibling route list.
void openProfileDetailRoute(BuildContext context, String route) {
  final currentPath = GoRouterState.of(context).uri.path;
  if (currentPath == route) return;
  if (currentPath == AppRoutePaths.profile) {
    unawaited(context.push(route));
  } else {
    context.pushReplacement(route);
  }
}
