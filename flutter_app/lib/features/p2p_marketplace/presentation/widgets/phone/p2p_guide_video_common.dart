part of '../../phone/pages/hub/p2p_guide_page.dart';

class _VideoTab extends StatelessWidget {
  const _VideoTab({required this.snapshot});

  final P2PGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Video hướng dẫn', style: AppTextStyles.baseMedium),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${snapshot.videos.length} video',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final video in snapshot.videos) ...[
          _VideoCard(video: video),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        VitCard(
          variant: VitCardVariant.inner,
          padding: P2PSpacingTokens.p2pGuideVideoEmptyPadding,
          child: Column(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Thêm video đang được cập nhật...',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final P2PGuideVideoDraft video;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(video.toneKey);
    return VitCard(
      key: P2PGuidePage.videoKey(video.id),
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pGuideVideoCardPadding,
      onTap: HapticFeedback.selectionClick,
      child: Row(
        children: [
          SizedBox(
            width: P2PSpacingTokens.p2pGuideThumbWidth,
            height: AppSpacing.buttonCompact,
            child: Material(
              color: color.withValues(alpha: .12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    video.thumb,
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: AppSpacing.buttonCompact,
                    child: Material(
                      color: AppColors.bg,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.text1,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Meta(icon: Icons.schedule_rounded, text: video.duration),
                    _Meta(icon: Icons.visibility_outlined, text: video.views),
                    VitAccentPill(
                      label: video.level,
                      accentColor: color,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _ConceptList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const concepts = [
      (
        'Escrow',
        'Hệ thống ký quỹ tự động khóa crypto cho đến khi giao dịch hoàn tất.',
      ),
      ('Maker', 'Người tạo quảng cáo, đăng offer và được miễn phí giao dịch.'),
      ('Taker', 'Người đặt đơn theo quảng cáo có sẵn, phí 0.1%.'),
      ('KYC', 'Xác minh danh tính để tăng giới hạn giao dịch.'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thuật ngữ quan trọng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final concept in concepts) ...[
          VitCard(
            variant: VitCardVariant.inner,
            padding: P2PSpacingTokens.p2pGuideConceptPadding,
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                children: [
                  TextSpan(
                    text: '${concept.$1}: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: concept.$2),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.buttonCompact,
      child: Material(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _NumberIcon extends StatelessWidget {
  const _NumberIcon({
    required this.step,
    required this.icon,
    required this.color,
  });

  final int step;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.buttonCompact,
      child: Material(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: color),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            Positioned(
              right: AppSpacing.x1,
              bottom: AppSpacing.x1,
              child: Text(
                '$step',
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: P2PSpacingTokens.p2pGuidePillLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Text(text, style: AppTextStyles.micro.copyWith(color: AppColors.text3)),
      ],
    );
  }
}

IconData _guideIcon(String iconKey) {
  return switch (iconKey) {
    'search' => Icons.search_rounded,
    'payment' => Icons.credit_card_rounded,
    'chat' => Icons.chat_bubble_outline_rounded,
    'wallet' => Icons.account_balance_wallet_outlined,
    'file' => Icons.description_outlined,
    'lock' => Icons.lock_outline_rounded,
    'eye' => Icons.visibility_outlined,
    'check' => Icons.check_circle_outline_rounded,
    'shield' => Icons.shield_outlined,
    'alert' => Icons.report_problem_outlined,
    'users' => Icons.group_outlined,
    _ => Icons.help_outline_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppModuleAccents.p2p,
    _ => AppColors.primary,
  };
}
