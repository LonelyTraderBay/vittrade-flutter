part of '../../phone/pages/orders/p2p_order_proof_page.dart';

class _OrderProofSummary extends StatelessWidget {
  const _OrderProofSummary({required this.order});

  final P2POrderProofDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pFinancialSafetyInnerPadding,
      child: Column(
        children: [
          _SummaryLine(label: 'Đơn hàng', value: order.orderNumber),
          const SizedBox(height: AppSpacing.x1),
          _SummaryLine(
            label: 'Số tiền',
            value: '${_formatVnd(order.totalVnd)} ${order.currency}',
            valueColor: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadSection extends StatelessWidget {
  const _UploadSection({
    required this.title,
    required this.subtitle,
    required this.isUploading,
    required this.onCamera,
    required this.onGallery,
  });

  final String title;
  final String subtitle;
  final bool isUploading;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          subtitle,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            Expanded(
              child: _UploadSourceCard(
                key: P2POrderProofPage.cameraKey,
                icon: Icons.photo_camera_outlined,
                label: 'Chụp ảnh',
                caption: 'Mở camera',
                color: AppColors.primary,
                enabled: !isUploading,
                onPressed: onCamera,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _UploadSourceCard(
                key: P2POrderProofPage.galleryKey,
                icon: Icons.image_outlined,
                label: 'Thư viện',
                caption: 'Chọn từ ảnh',
                color: AppColors.accent,
                enabled: !isUploading,
                onPressed: onGallery,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UploadSourceCard extends StatelessWidget {
  const _UploadSourceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.caption,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      height: AppSpacing.buttonHero + AppSpacing.x4,
      padding: P2PSpacingTokens.p2pFinancialSafetyCardPadding,
      borderColor: color.withValues(alpha: .45),
      onTap: enabled ? onPressed : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _UploadedProofs extends StatelessWidget {
  const _UploadedProofs({required this.proofs, required this.onRemove});

  final List<String> proofs;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đã tải (${proofs.length}/3)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (var index = 0; index < proofs.length; index++)
              _ProofThumb(index: index, onRemove: () => onRemove(index)),
          ],
        ),
      ],
    );
  }
}

class _ProofThumb extends StatelessWidget {
  const _ProofThumb({required this.index, required this.onRemove});

  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        VitCard(
          width: P2PSpacingTokens.p2pFinancialSafetyProofThumb,
          height: P2PSpacingTokens.p2pFinancialSafetyProofThumb,
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.standard,
          borderColor: AppColors.buy20,
          background: const ColoredBox(color: AppColors.buy10),
          clip: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Ảnh ${index + 1}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -AppSpacing.x2,
          right: -AppSpacing.x2,
          child: SizedBox.square(
            dimension: AppSpacing.x6,
            child: Center(
              child: VitIconButton(
                key: P2POrderProofPage.removeKey(index),
                icon: Icons.delete_outline,
                tooltip: 'Remove proof ${index + 1}',
                onPressed: onRemove,
                variant: VitIconButtonVariant.danger,
                size: VitIconButtonSize.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.title, required this.tips});

  final String title;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pFinancialSafetyInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final tip in tips) P2PHelpBullet(text: tip),
        ],
      ),
    );
  }
}

class _ProofWarning extends StatelessWidget {
  const _ProofWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      icon: Icons.warning_amber_rounded,
      message: message,
      iconColor: AppColors.warn,
      messageColor: AppColors.warn,
      borderColor: AppColors.warningBorder,
      variant: VitCardVariant.ghost,
      padding: P2PSpacingTokens.p2pFinancialSafetyInnerPadding,
    );
  }
}

String _formatVnd(int value) => formatP2PVnd(value);
