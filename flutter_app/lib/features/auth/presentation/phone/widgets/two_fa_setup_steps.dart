part of '../pages/two_fa_setup_page.dart';

class _TwoFaStepper extends StatelessWidget {
  const _TwoFaStepper({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AuthSpacingTokens.authTwoFaStepperPadding,
      child: Row(
        children: [
          for (var index = 1; index <= 3; index++) ...[
            _StepDot(index: index, activeStep: step),
            if (index < 3)
              Expanded(
                child: Padding(
                  padding: AuthSpacingTokens.authTwoFaProgressMargin,
                  child: ClipRRect(
                    borderRadius: AppRadii.pillRadius,
                    child: ColoredBox(
                      color: index < step ? _authPrimary : _authPrimary30,
                      child: const SizedBox(
                        height: AuthSpacingTokens.authOtpProgressHeight,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.activeStep});

  final int index;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeStep;
    final isComplete = index < activeStep;
    final color = isActive || isComplete ? _authPrimary : _authStepInactive;

    return SizedBox.square(
      dimension: AuthSpacingTokens.authTwoFaStepDotSize,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: Center(
          child: isComplete
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.onAccent,
                  size: AuthSpacingTokens.authTwoFaStepIcon,
                )
              : Text(
                  '$index',
                  style: AppTextStyles.caption.copyWith(
                    color: isActive ? AppColors.onAccent : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
