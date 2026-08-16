part of '../../phone/pages/staking/staking_withdrawal_policy_page.dart';

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.processTitle,
          density: VitDensity.compact,
          children: [_ProcessCard(steps: snapshot.processSteps)],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitPageSection(
          label: snapshot.timelineTitle,
          density: VitDensity.compact,
          children: [
            for (final timeline in snapshot.timelines)
              _TimelineCard(timeline: timeline),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _NoteCard(text: snapshot.timelineNote),
      ],
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({required this.steps});

  final List<StakingWithdrawalStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWithdrawalPolicyPage.processKey,
      radius: VitCardRadius.large,
      padding: _stakingWithdrawalCardPadding,
      child: Column(
        children: [
          for (final step in steps) ...[
            _ProcessStepRow(step: step),
            if (step != steps.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ProcessStepRow extends StatelessWidget {
  const _ProcessStepRow({required this.step});

  final StakingWithdrawalStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _stakingWithdrawalProcessIconBox,
          height: _stakingWithdrawalProcessIconBox,
          child: Material(
            color: _toneTint(step.tone),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
              side: BorderSide(
                color: color.withValues(alpha: .28),
                width: _stakingWithdrawalBorderWidth,
              ),
            ),
            child: Icon(
              _stepIcon(step.step),
              color: color,
              size: _stakingWithdrawalProcessIcon,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x1,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _SmallBadge(label: 'Bước ${step.step}', color: color),
                  Text(
                    step.title,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _stakingWithdrawalProcessLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final StakingWithdrawalTimelineDraft timeline;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: StakingWithdrawalPolicyPage.timelineKey(timeline.product),
      radius: VitCardRadius.large,
      constraints: BoxConstraints(
        minHeight: timeline.penalty.contains('\n')
            ? _stakingWithdrawalTimelineMinHeightTall
            : _stakingWithdrawalTimelineMinHeight,
      ),
      padding: _stakingWithdrawalCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeline.product,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineMetric(
                  label: 'Có thể rút',
                  value: timeline.initiate,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TimelineMetric(
                  label: 'Unbonding',
                  value: timeline.unbonding,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineMetric(
                  label: 'Nhận tiền',
                  value: timeline.receive,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TimelineMetric(
                  label: 'Phí rút sớm',
                  value: timeline.penalty,
                  color: timeline.penalty == 'Không'
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineMetric extends StatelessWidget {
  const _TimelineMetric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: _stakingWithdrawalTimelineValueLineHeight,
          ),
        ),
      ],
    );
  }
}

IconData _stepIcon(int step) {
  switch (step) {
    case 1:
      return Icons.account_balance_wallet_rounded;
    case 2:
      return Icons.verified_user_rounded;
    case 3:
      return Icons.schedule_rounded;
    default:
      return Icons.check_circle_rounded;
  }
}

Color _toneTint(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy10,
    StakingDisclosureRiskLevel.medium => AppColors.warn10,
    StakingDisclosureRiskLevel.high => AppColors.sell10,
  };
}
