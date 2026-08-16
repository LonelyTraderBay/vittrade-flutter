part of '../../phone/pages/tools/launchpad_webhooks_page.dart';

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    super.key,
    required this.active,
    required this.onTap,
    this.size = _launchpadWebhooksCopyButtonExtent,
  });

  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      onPressed: onTap,
      icon: active ? Icons.check_rounded : Icons.copy_rounded,
      tooltip: active ? 'Da copy' : 'Copy',
      variant: active
          ? VitIconButtonVariant.success
          : VitIconButtonVariant.transparent,
      size: size <= _launchpadWebhooksIcon2xl
          ? VitIconButtonSize.sm
          : VitIconButtonSize.md,
    );
  }
}

class _EmptySubscriptions extends StatelessWidget {
  const _EmptySubscriptions();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _launchpadWebhooksCardPadding,
      child: Column(
        children: [
          const Icon(
            Icons.hub_outlined,
            color: AppColors.text3,
            size: _launchpadWebhooksEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Chua co webhook nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tao webhook de nhan thong bao event tu contract',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
