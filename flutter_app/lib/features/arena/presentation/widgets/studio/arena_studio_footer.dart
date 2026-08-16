part of '../../phone/pages/studio/arena_studio_page.dart';

class _InlineStudioActions extends StatelessWidget {
  const _InlineStudioActions({
    required this.step,
    required this.totalSteps,
    required this.canContinue,
    required this.onContinue,
    required this.onSave,
    required this.onExport,
    required this.onImport,
    this.onBack,
    this.statusLabel,
  });

  final int step;
  final int totalSteps;
  final bool canContinue;
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final VoidCallback onExport;
  final VoidCallback onImport;
  final VoidCallback? onBack;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    final isLastStep = step == totalSteps;
    final stateLabel =
        statusLabel ??
        (canContinue ? 'Sẵn sàng cho bước tiếp theo' : 'Chọn template trước');

    return VitCard(
      variant: VitCardVariant.inner,
      padding: ArenaSpacingTokens.arenaPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x1,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _FooterToolButton(
                      key: ArenaStudioPage.saveKey,
                      icon: Icons.save_outlined,
                      label: 'Lưu',
                      onTap: onSave,
                    ),
                    _FooterToolButton(
                      key: ArenaStudioPage.exportKey,
                      icon: Icons.download_outlined,
                      label: 'Xuất',
                      onTap: onExport,
                    ),
                    _FooterToolButton(
                      key: ArenaStudioPage.importKey,
                      icon: Icons.upload_outlined,
                      label: 'Nhập',
                      onTap: onImport,
                    ),
                  ],
                ),
              ),
              VitStatusPill(
                label: 'Bước $step / $totalSteps',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _InlineStudioStateLine(
            label: stateLabel,
            active: canContinue,
            icon: canContinue
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              if (onBack != null)
                SizedBox(
                  width: ArenaSpacingTokens.arenaStudioFooterButton,
                  height: ArenaSpacingTokens.arenaStudioFooterButton,
                  child: VitCtaButton(
                    key: ArenaStudioPage.backStepKey,
                    onPressed: onBack,
                    variant: VitCtaButtonVariant.secondary,
                    fullWidth: false,
                    height: ArenaSpacingTokens.arenaStudioFooterButton,
                    padding: AppSpacing.zeroInsets,
                    child: const Icon(Icons.chevron_left_rounded),
                  ),
                ),
              const Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: isLastStep
                    ? ArenaSpacingTokens.arenaStudioFooterSubmitWidth
                    : ArenaSpacingTokens.arenaStudioFooterContinueWidth,
                child: VitCtaButton(
                  key: ArenaStudioPage.continueKey,
                  onPressed: canContinue ? onContinue : null,
                  fullWidth: true,
                  height: ArenaSpacingTokens.arenaStudioFooterButton,
                  padding: ArenaSpacingTokens.arenaStudioFooterCtaPadding,
                  trailing: Icon(
                    isLastStep
                        ? Icons.send_outlined
                        : Icons.chevron_right_rounded,
                  ),
                  child: Text(isLastStep ? 'Mở phòng' : 'Tiếp tục'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineStudioStateLine extends StatelessWidget {
  const _InlineStudioStateLine({
    required this.label,
    required this.active,
    required this.icon,
  });

  final String label;
  final bool active;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.buy : AppColors.text3;

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: ArenaSpacingTokens.arenaStudioFooterStateIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterToolButton extends StatelessWidget {
  const _FooterToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        child: VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.standard,
          width: ArenaSpacingTokens.arenaStudioFooterToolButton,
          height: ArenaSpacingTokens.arenaStudioFooterToolButton,
          onTap: onTap,
          child: Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
        ),
      ),
    );
  }
}
