import 'package:flutter/material.dart';

/// Shared hero icon skeleton for auth flow screens (OTP, 2FA setup, forgot
/// password, reset password): `SizedBox.square` -> `Material` -> `shape`
/// -> centered `Icon`/`CustomPaint`.
///
/// Consolidates the auth module's near-identical hero icon boxes; callers
/// supply size, shape, fill color, and child so each flow keeps its own
/// icon/painter and dimensions.
class AuthHeroIconBox extends StatelessWidget {
  const AuthHeroIconBox({
    super.key,
    required this.dimension,
    required this.shape,
    required this.fillColor,
    required this.child,
  });

  final double dimension;
  final ShapeBorder shape;
  final Color fillColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: Material(color: fillColor, shape: shape, child: child),
    );
  }
}
