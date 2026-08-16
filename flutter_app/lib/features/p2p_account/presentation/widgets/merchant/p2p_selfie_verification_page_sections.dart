part of '../../phone/pages/merchant/p2p_selfie_verification_page.dart';

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.snapshot, required this.onStart});

  final P2PSelfieVerificationSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SelfieHero(snapshot: snapshot),
        const SizedBox(height: _p2pSelfieMajorGap),
        Text(
          'Ví dụ mẫu',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pSelfieSectionGap),
        _SampleCard(snapshot: snapshot),
        const SizedBox(height: _p2pSelfieMajorGap),
        Text(
          'Hướng dẫn chụp ảnh',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pSelfieSectionGap),
        _GuidelinesCard(snapshot: snapshot),
        const SizedBox(height: _p2pSelfieMajorGap),
        _TipsCard(snapshot: snapshot),
        const SizedBox(height: _p2pSelfieMajorGap),
        VitCtaButton(
          key: P2PSelfieVerificationPage.startKey,
          onPressed: onStart,
          trailing: const Icon(Icons.photo_camera_outlined),
          child: const Text('Bắt đầu chụp ảnh'),
        ),
      ],
    );
  }
}

class _SelfieHero extends StatelessWidget {
  const _SelfieHero({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.heroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pSelfieCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: _p2pSelfieHeroIconBox,
            child: Material(
              color: AppColors.primary15,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
                side: BorderSide(color: AppColors.primary20),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: _p2pSelfieMajorGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pSelfieBodyLineHeight,
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

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.sampleKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: AppSpacing.zeroInsets,
      child: AspectRatio(
        aspectRatio: P2PSpacingTokens.p2pSelfieSampleAspectRatio,
        child: Material(
          color: AppColors.primary12,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: AppColors.text1,
                size: _p2pSelfieSampleIconSize,
              ),
              const SizedBox(height: _p2pSelfieMajorGap),
              Text(
                snapshot.sampleTitle,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                snapshot.sampleBody,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.guidelinesKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pSelfieCardPadding,
      child: Column(
        children: [
          for (final guide in snapshot.guidelines) ...[
            _ChecklistRow(text: guide, color: AppColors.buy),
            if (guide != snapshot.guidelines.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.tipsKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pSelfieCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Mẹo để thành công',
            icon: Icons.info_outline_rounded,
            iconColor: AppModuleAccents.p2p,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final tip in snapshot.tips) ...[
            _ChecklistRow(text: tip, color: AppColors.warn),
            if (tip != snapshot.tips.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _CaptureStep extends StatelessWidget {
  const _CaptureStep({required this.onCapture});

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.captureKey,
      radius: VitCardRadius.large,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pSelfieLargeCardPadding,
      onTap: onCapture,
      child: AspectRatio(
        aspectRatio: P2PSpacingTokens.p2pSelfieCaptureAspectRatio,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox.square(
              dimension: _p2pSelfieActionIconBox,
              child: Material(
                color: AppColors.primary15,
                shape: CircleBorder(),
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconLg,
                ),
              ),
            ),
            const SizedBox(height: _p2pSelfieMajorGap),
            Text(
              'Nhấn để chụp ảnh',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppModuleAccents.p2p,
              ),
            ),
            const SizedBox(height: _p2pSelfieSectionGap),
            Text(
              'Đảm bảo khuôn mặt và ID card rõ nét trong khung hình',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivenessStep extends StatelessWidget {
  const _LivenessStep({
    required this.snapshot,
    required this.currentActionIndex,
    required this.completedActions,
    required this.onConfirmAction,
  });

  final P2PSelfieVerificationSnapshot snapshot;
  final int currentActionIndex;
  final Set<String> completedActions;
  final VoidCallback onConfirmAction;

  @override
  Widget build(BuildContext context) {
    final currentAction = snapshot.livenessActions[currentActionIndex];

    return Column(
      key: P2PSelfieVerificationPage.livenessKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitProgressBar(
          label: 'Tiến độ',
          trailingLabel:
              '${completedActions.length}/${snapshot.livenessActions.length}',
          progress: snapshot.livenessActions.isEmpty
              ? 0
              : completedActions.length / snapshot.livenessActions.length,
          color: AppModuleAccents.p2p,
        ),
        const SizedBox(height: _p2pSelfieMajorGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pSelfieLargeCardPadding,
          child: Column(
            children: [
              Icon(
                _livenessIcon(currentAction.iconKey),
                color: AppModuleAccents.p2p,
                size: _p2pSelfieLivenessIconSize,
              ),
              const SizedBox(height: _p2pSelfieSectionGap),
              Text(
                currentAction.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Làm theo hướng dẫn để tiếp tục',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: _p2pSelfieMajorGap),
        GridView.count(
          crossAxisCount: P2PSpacingTokens.p2pSelfieLivenessGridColumns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: _p2pSelfieSectionGap,
          mainAxisSpacing: _p2pSelfieSectionGap,
          childAspectRatio: P2PSpacingTokens.p2pSelfieLivenessGridAspectRatio,
          children: [
            for (final action in snapshot.livenessActions)
              _LivenessActionTile(
                action: action,
                completed: completedActions.contains(action.id),
              ),
          ],
        ),
        const SizedBox(height: _p2pSelfieMajorGap),
        VitCtaButton(
          key: P2PSelfieVerificationPage.livenessActionKey,
          onPressed: onConfirmAction,
          child: const Text('Xác nhận thao tác'),
        ),
      ],
    );
  }
}
