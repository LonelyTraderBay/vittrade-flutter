part of '../../phone/pages/orders/p2p_chat_page.dart';

class _DateSeparator extends StatelessWidget {
  const _DateSeparator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: P2PSpacingTokens.p2pChatDatePadding,
          child: Text(
            'Hôm nay',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.merchantInitial});

  final P2PChatMessageDraft message;
  final String merchantInitial;

  @override
  Widget build(BuildContext context) {
    if (message.sender == P2PChatSender.system) {
      return Padding(
        padding: P2PSpacingTokens.p2pChatMessageBottomPadding,
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: P2PSpacingTokens.p2pChatSystemMessageMaxWidth,
            ),
            child: Material(
              color: AppColors.primary08,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
                side: BorderSide(color: AppColors.primary20),
              ),
              child: Padding(
                padding: P2PSpacingTokens.p2pChatSystemMessagePadding,
                child: Column(
                  children: [
                    Text(
                      message.text,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppModuleAccents.p2p,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      message.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final isMe = message.sender == P2PChatSender.me;
    return Padding(
      padding: P2PSpacingTokens.p2pChatMessageBottomPadding,
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: P2PSpacingTokens.p2pChatMerchantAvatarRadius,
              backgroundColor: AppModuleAccents.p2p,
              child: Text(
                merchantInitial,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: P2PSpacingTokens.p2pChatMessageMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Material(
                    color: isMe ? AppModuleAccents.p2p : AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.disputeMessageBubbleRadius(
                        isUser: isMe,
                      ),
                    ),
                    child: Padding(
                      padding: P2PSpacingTokens.p2pChatMessagePadding,
                      child: Text(
                        message.text,
                        style: AppTextStyles.body.copyWith(
                          color: isMe ? AppColors.onAccent : AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.done_all_rounded,
                          size: P2PSpacingTokens.p2pChatReadIcon,
                          color: message.isRead
                              ? AppModuleAccents.p2p
                              : AppColors.text3,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
