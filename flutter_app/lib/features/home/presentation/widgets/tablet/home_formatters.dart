import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/home_action_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared quick-action tile builder used by both the home grid
/// (`HomeQuickActionsGrid`) and the "more products" sheet
/// (`HomeMoreProductsSheet`) so the icon/accent/badge mapping from
/// [HomeQuickAction] to [VitServiceTile] is defined in exactly one place.
Widget buildHomeQuickActionTile(
  HomeQuickAction action,
  VitServiceTileDensity tileDensity,
  ValueChanged<String> onNavigate,
) {
  return VitServiceTile.fromAction(
    density: tileDensity,
    icon: HomeActionTokens.icon(action.icon),
    label: action.label,
    accentColor: HomeActionTokens.accent(action.accentKey),
    badgeLabel: action.stateLabel,
    riskBadgeLabel: action.riskBadge,
    onTap: () => onNavigate(action.routePath),
  );
}

String formatUsd(double value, {bool forceTwoDecimals = false}) {
  final decimals = forceTwoDecimals || value >= 1 ? 2 : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  final whole = parts.first;
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
