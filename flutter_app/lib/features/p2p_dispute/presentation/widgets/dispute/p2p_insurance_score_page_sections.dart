part of '../../phone/pages/dispute/p2p_insurance_score_page.dart';

class _ScoreOverviewCard extends StatelessWidget {
  const _ScoreOverviewCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceScorePage.scoreCardKey,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        children: [
          _ScoreRing(snapshot: snapshot),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            snapshot.gradeLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.gradeDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            borderColor: AppColors.buy20,
            background: const ColoredBox(color: AppColors.buy12),
            clip: true,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+${snapshot.potentialGain} điểm có thể cải thiện',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.overallScore / snapshot.maxScore;
    return SizedBox.square(
      dimension: AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: AppSpacing.x7 + AppSpacing.x5 + AppSpacing.x3,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: AppSpacing.x2 + AppSpacing.dividerHairline,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppModuleAccents.p2p,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${snapshot.overallScore}',
                style: AppTextStyles.numericDisplaySm.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '/ ${snapshot.maxScore}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                snapshot.grade,
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FactorBreakdownCard extends StatelessWidget {
  const _FactorBreakdownCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceScorePage.factorsKey,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Chi tiết điểm số',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var i = 0; i < snapshot.factors.length; i++) ...[
            _ScoreFactorRow(factor: snapshot.factors[i]),
            if (i != snapshot.factors.length - 1)
              const Divider(height: AppSpacing.x2, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _ScoreFactorRow extends StatelessWidget {
  const _ScoreFactorRow({required this.factor});

  final P2PInsuranceScoreFactorDraft factor;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(factor.toneKey);
    final progress = factor.score / factor.maxScore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
                child: Icon(
                  _iconFor(factor.iconKey),
                  color: color,
                  size: AppSpacing.iconSm,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    factor.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    factor.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${factor.score}',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/${factor.maxScore}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.x6),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: AppSpacing.x1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: AppColors.surface3),
                        FractionallySizedBox(
                          widthFactor: progress,
                          alignment: Alignment.centerLeft,
                          child: ColoredBox(color: color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              SizedBox(
                width: AppSpacing.x7,
                child: Text(
                  factor.statusLabel,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (factor.recommendation != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.x6),
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x2,
                vertical: AppSpacing.x1,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    color: color,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      factor.recommendation!,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        height: AppTextStyles.numericMicro.height,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.actions});

  final List<P2PInsuranceScoreQuickActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.north_east_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Cải thiện nhanh',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final action in actions) ...[
            _QuickActionRow(action: action),
            if (action != actions.last) const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}
