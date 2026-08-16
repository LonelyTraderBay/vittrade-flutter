part of 'arena_governance_gate_page.dart';

Color _tierColor(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return AppColors.buy;
    case _EligibilityTier.amber:
      return AppColors.warn;
    case _EligibilityTier.red:
      return AppColors.sell;
  }
}

Color _tierBorder(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return AppColors.buy20;
    case _EligibilityTier.amber:
      return AppColors.warningBorder;
    case _EligibilityTier.red:
      return AppColors.sell20;
  }
}

IconData _tierIcon(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return Icons.verified_user_outlined;
    case _EligibilityTier.amber:
      return Icons.shield_outlined;
    case _EligibilityTier.red:
      return Icons.shield_outlined;
  }
}
