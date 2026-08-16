part of '../../phone/pages/governance/arena_governance_gate_page.dart';

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: AppColors.surface2,
    contentPadding: ArenaSpacingTokens.arenaGovernanceInputPadding,
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(
        color: AppColors.borderSolid,
        width: ArenaSpacingTokens.arenaGovernanceInputBorderWidth,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(
        color: AppColors.accent,
        width: ArenaSpacingTokens.arenaGovernanceInputBorderWidth,
      ),
    ),
  );
}

IconData _privacyIcon(String id) {
  switch (id) {
    case 'public':
      return Icons.public_rounded;
    case 'private':
      return Icons.lock_outline_rounded;
    default:
      return Icons.link_rounded;
  }
}

IconData _domainIcon(String id) {
  switch (id) {
    case 'sports':
      return Icons.sports_soccer_rounded;
    case 'esports':
      return Icons.sports_esports_rounded;
    case 'crypto':
      return Icons.show_chart_rounded;
    case 'tech':
      return Icons.smart_toy_outlined;
    case 'science':
      return Icons.science_outlined;
    case 'health':
      return Icons.fitness_center_rounded;
    case 'entertainment':
      return Icons.movie_outlined;
    case 'work':
      return Icons.business_center_outlined;
    case 'community':
      return Icons.groups_2_outlined;
    default:
      return Icons.category_outlined;
  }
}

IconData _challengeIcon(String id) {
  switch (id) {
    case 'multi_choice':
      return Icons.format_list_bulleted_rounded;
    case 'closest_guess':
      return Icons.adjust_rounded;
    case 'highest_wins':
      return Icons.bar_chart_rounded;
    case 'lowest_wins':
      return Icons.trending_down_rounded;
    case 'first_to_finish':
      return Icons.flag_outlined;
    case 'team_score':
      return Icons.groups_rounded;
    case 'referee_decision':
      return Icons.gavel_rounded;
    case 'community_vote':
      return Icons.how_to_vote_outlined;
    case 'proof_challenge':
      return Icons.verified_outlined;
    default:
      return Icons.check_box_outlined;
  }
}

String _tierLabel(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return 'Public-ready';
    case _EligibilityTier.amber:
      return 'Private only';
    case _EligibilityTier.red:
      return 'Chưa đủ điều kiện';
  }
}
