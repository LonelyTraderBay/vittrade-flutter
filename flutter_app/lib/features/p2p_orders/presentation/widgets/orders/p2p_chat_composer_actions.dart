part of '../../phone/pages/orders/p2p_chat_page.dart';

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.bottomInset,
    required this.quickReplies,
    required this.controller,
    required this.onShareProof,
    required this.onQuickReply,
    required this.onChanged,
    required this.onSend,
  });

  final double bottomInset;
  final List<String> quickReplies;
  final TextEditingController controller;
  final VoidCallback onShareProof;
  final ValueChanged<String> onQuickReply;
  final VoidCallback onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final canSend = controller.text.trim().isNotEmpty;
    return Material(
      color: AppColors.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
          Padding(
            padding: P2PSpacingTokens.p2pChatComposerBottomPadding(bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: AppSpacing.buttonStandard,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: P2PSpacingTokens.p2pChatQuickReplyRailPadding,
                    children: [
                      _ReplyChip(
                        key: P2PChatPage.shareProofKey,
                        label: 'Chia sẻ bằng chứng',
                        icon: Icons.shield_outlined,
                        onTap: onShareProof,
                      ),
                      for (final reply in quickReplies)
                        _ReplyChip(
                          key: P2PChatPage.quickReplyKey(reply),
                          label: reply,
                          icon: null,
                          onTap: () => onQuickReply(reply),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: P2PSpacingTokens.p2pChatComposerInputPadding,
                  child: Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.image_outlined,
                        tooltip: 'Attach payment proof image',
                        onPressed: () {
                          unawaited(HapticFeedback.selectionClick());
                          unawaited(
                            showVitNoticeSheet(
                              context: context,
                              title: 'Sắp ra mắt',
                              message:
                                  'Đính kèm ảnh bằng chứng thanh toán sẽ sớm ra mắt',
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  P2PSpacingTokens.p2pChatComposerLabelPadding,
                              child: Text(
                                'E2E Encrypted',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.buy,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x1),
                            VitInput(
                              fieldKey: P2PChatPage.inputKey,
                              controller: controller,
                              onChanged: (_) => onChanged(),
                              semanticLabel: 'Tin nhắn mã hóa đầu cuối P2P',
                              hintText: 'Nhập tin nhắn...',
                              textStyle: AppTextStyles.body.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      _RoundIconButton(
                        key: P2PChatPage.sendKey,
                        icon: Icons.send_rounded,
                        tooltip: 'Send encrypted P2P message',
                        color: canSend ? AppModuleAccents.p2p : AppColors.text3,
                        onPressed: canSend ? onSend : () {},
                      ),
                    ],
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

class _ReplyChip extends StatelessWidget {
  const _ReplyChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pChatReplyChipOuterPadding,
      child: VitStatusPill(
        label: label,
        status: icon == null
            ? VitStatusPillStatus.neutral
            : VitStatusPillStatus.success,
        icon: icon,
        size: VitStatusPillSize.sm,
        onTap: onTap,
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.text2,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: P2PSpacingTokens.p2pChatRoundIconButtonSize,
      child: Center(
        child: VitInlineIconAction(
          icon: icon,
          tooltip: tooltip,
          onPressed: onPressed,
          color: color,
          size: AppSpacing.iconMd,
          padding: AppSpacing.x2,
          borderRadius: AppRadii.pillRadius,
        ),
      ),
    );
  }
}

class _SmallHeaderButton extends StatelessWidget {
  const _SmallHeaderButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: Icons.chevron_right_rounded,
      tooltip: tooltip,
      label: label,
      onPressed: onPressed,
      variant: VitIconButtonVariant.primary,
      size: VitIconButtonSize.sm,
    );
  }
}
