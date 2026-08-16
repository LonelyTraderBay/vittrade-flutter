part of '../../phone/pages/orders/p2p_chat_page.dart';

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.snapshot});

  final P2PChatSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Padding(
        padding: P2PSpacingTokens.p2pChatHeaderPadding(
          MediaQuery.paddingOf(context).top,
        ),
        child: Row(
          children: [
            _RoundIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Quay lại chi tiết đơn P2P',
              onPressed: () =>
                  context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
            ),
            const SizedBox(width: AppSpacing.x3),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: P2PSpacingTokens.p2pChatHeaderAvatarRadius,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    snapshot.merchantInitial,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Positioned(
                  right: P2PSpacingTokens.p2pChatOnlineBadgeOffset,
                  bottom: P2PSpacingTokens.p2pChatOnlineBadgeOffset,
                  child: SizedBox.square(
                    dimension: P2PSpacingTokens.p2pChatOnlineBadgeSize,
                    child: Material(
                      color: AppColors.buy,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: AppColors.surface,
                          width: P2PSpacingTokens.p2pChatOnlineBadgeBorder,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.merchant,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    snapshot.activeLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                  ),
                ],
              ),
            ),
            _SmallHeaderButton(
              key: P2PChatPage.detailKey,
              tooltip: 'Mở chi tiết đơn P2P',
              label: 'Chi tiết',
              onPressed: () =>
                  context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
            ),
            const SizedBox(width: AppSpacing.x2),
            _RoundIconButton(
              key: P2PChatPage.e2eKey,
              icon: Icons.lock_outline_rounded,
              tooltip: 'Mở thông tin mã hóa E2E',
              color: AppColors.buy,
              onPressed: () => context.go(AppRoutePaths.p2pE2EInfo),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskBanner extends StatelessWidget {
  const _RiskBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pChatRiskBannerPadding,
      child: P2PNoticeCard(
        icon: Icons.warning_amber_rounded,
        message: message,
        iconColor: AppColors.sell,
        messageColor: AppColors.sell,
        borderColor: AppColors.sell20,
        variant: VitCardVariant.standard,
        padding: P2PSpacingTokens.p2pDisputeCardPadding,
        messageStyle: AppTextStyles.micro.copyWith(
          color: AppColors.sell,
          height: 1.4,
        ),
      ),
    );
  }
}

class _E2EBanner extends StatelessWidget {
  const _E2EBanner({
    required this.title,
    required this.subtitle,
    required this.onOpen,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      background: const ColoredBox(color: AppColors.buy10),
      padding: P2PSpacingTokens.p2pChatBannerPadding,
      onTap: onOpen,
      clip: true,
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.buy,
                size: P2PSpacingTokens.p2pChatTinyIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'AES-256',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          VitInlineIconAction(
            icon: Icons.close_rounded,
            tooltip: 'Close E2E encryption banner',
            onPressed: onClose,
            color: AppColors.buy,
            size: P2PSpacingTokens.p2pChatCloseIcon,
            padding: AppSpacing.x1,
            borderRadius: AppRadii.pillRadius,
          ),
        ],
      ),
    );
  }
}
