part of '../../phone/pages/studio/arena_studio_page.dart';

class _StudioStepper extends StatelessWidget {
  const _StudioStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return ArenaWizardStepper(
      steps: steps,
      activeStep: step,
      style: ArenaWizardStepperStyle.studio,
      accentColor: _arenaAccent,
    );
  }
}
