part of '../../phone/pages/governance/arena_governance_gate_page.dart';

enum _EligibilityTier { green, amber, red }

final class _GovernanceCheck {
  const _GovernanceCheck(this.label, this.passed);

  final String label;
  final bool passed;
}

final class _GovernanceResult {
  const _GovernanceResult({
    required this.clarity,
    required this.level,
    required this.tier,
    required this.checks,
    required this.warnings,
    required this.risk,
    required this.nextAction,
    required this.canProceed,
  });

  final int clarity;
  final String level;
  final _EligibilityTier tier;
  final List<_GovernanceCheck> checks;
  final List<String> warnings;
  final String risk;
  final String nextAction;
  final bool canProceed;
}
