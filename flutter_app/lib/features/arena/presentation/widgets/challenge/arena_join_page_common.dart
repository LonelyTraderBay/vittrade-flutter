part of '../../phone/pages/challenge/arena_join_page.dart';

class _AcknowledgementStack extends StatelessWidget {
  const _AcknowledgementStack({
    required this.readRules,
    required this.understandPoints,
    required this.onRules,
    required this.onPoints,
  });

  final bool readRules;
  final bool understandPoints;
  final VoidCallback onRules;
  final VoidCallback onPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AcknowledgementRow(
          key: ArenaJoinPage.rulesCheckboxKey,
          checked: readRules,
          label: 'Tôi đã đọc luật chơi và hiểu các điều kiện của challenge này',
          onTap: onRules,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _AcknowledgementRow(
          key: ArenaJoinPage.pointsCheckboxKey,
          checked: understandPoints,
          label:
              'Tôi hiểu đây là Arena Points — không phải tài sản tài chính và không thể rút ra ngoài',
          onTap: onPoints,
        ),
      ],
    );
  }
}

class _AcknowledgementRow extends StatelessWidget {
  const _AcknowledgementRow({
    super.key,
    required this.checked,
    required this.label,
    required this.onTap,
  });

  final bool checked;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: ArenaSpacingTokens.arenaJoinAcknowledgementMinHeight,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: ArenaSpacingTokens.arenaJoinCheckboxSize,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: checked ? AppColors.primary : AppColors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(
                        color: checked
                            ? AppColors.primary
                            : AppColors.borderSolid,
                        width: ArenaSpacingTokens.arenaJoinCheckboxBorderWidth,
                      ),
                    ),
                  ),
                  child: checked
                      ? const Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: ArenaSpacingTokens.arenaJoinCheckboxIcon,
                            color: AppColors.onAccent,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _joinAcknowledgementLineRatio,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.entryPoints,
    required this.canJoin,
    required this.onConfirm,
    required this.onDecline,
  });

  final int entryPoints;
  final bool canJoin;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: ArenaJoinPage.confirmKey,
          onPressed: canJoin ? onConfirm : null,
          child: Text('Xác nhận tham gia · ${_formatPoints(entryPoints)} pts'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        SizedBox(
          width: double.infinity,
          child: VitCtaButton(
            key: ArenaJoinPage.declineKey,
            onPressed: onDecline,
            variant: VitCtaButtonVariant.ghost,
            density: VitDensity.compact,
            child: Text(
              'Từ chối',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatPoints(int value) => VitFormat.compactSuffix(value);
