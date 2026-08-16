part of '../phone/pages/enterprise_states_page.dart';

class _StateKitSection extends StatelessWidget {
  const _StateKitSection({
    required this.snapshot,
    required this.activeState,
    required this.onStateChanged,
    required this.onMarkets,
    required this.onKyc,
  });

  final EnterpriseStatesSnapshot snapshot;
  final EnterprisePreviewState activeState;
  final ValueChanged<EnterprisePreviewState> onStateChanged;
  final VoidCallback onMarkets;
  final VoidCallback onKyc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '5 state pattern chuẩn enterprise, match 100% visual style hiện tại. Chọn state để xem preview.',
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            height:
                EnterpriseStatesSpacingTokens.enterpriseStatesLineHeightBody,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPresetChipRow<EnterprisePreviewState>(
          items: [
            for (final state in snapshot.previewStates)
              VitPresetChipItem(
                value: state.state,
                label: state.label,
                key: EnterpriseStatesPage.stateKey(state.state),
              ),
          ],
          selectedValue: activeState,
          onTap: onStateChanged,
          accentColor: AppModuleAccents.enterpriseStates,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _PreviewFrame(
          activeState: activeState,
          onMarkets: onMarkets,
          onKyc: onKyc,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Text(
          'Banner Variants',
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final banner in snapshot.banners) ...[
          _ReferenceBanner(banner: banner),
          if (banner != snapshot.banners.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ],
      ],
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({
    required this.activeState,
    required this.onMarkets,
    required this.onKyc,
  });

  final EnterprisePreviewState activeState;
  final VoidCallback onMarkets;
  final VoidCallback onKyc;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          DecoratedBox(
            decoration: const ShapeDecoration(
              shape: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Padding(
              padding: EnterpriseStatesSpacingTokens
                  .enterpriseStatesFrameHeaderPadding,
              child: Row(
                children: [
                  const VitSkeleton(
                    width: AppSpacing.x6,
                    height: AppSpacing.x6,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  Expanded(
                    child: Text(
                      'Preview — ${_previewLabel(activeState).toLowerCase()}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x6),
                ],
              ),
            ),
          ),
          if (activeState == EnterprisePreviewState.loading)
            const _SkeletonPreview()
          else if (activeState == EnterprisePreviewState.empty)
            _EmptyPreview(onMarkets: onMarkets)
          else if (activeState == EnterprisePreviewState.error)
            const _ErrorPreview()
          else if (activeState == EnterprisePreviewState.offline)
            const _OfflinePreview()
          else
            _GatePreview(onKyc: onKyc),
        ],
      ),
    );
  }
}

class _SkeletonPreview extends StatelessWidget {
  const _SkeletonPreview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EnterpriseStatesSpacingTokens.enterpriseStatesCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSkeleton(width: 150, height: AppSpacing.x4),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const Row(
            children: [
              VitSkeleton(width: 76, height: AppSpacing.x5),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 60, height: AppSpacing.x5),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 68, height: AppSpacing.x5),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 52, height: AppSpacing.x5),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (var i = 0; i < 5; i++) ...[
            const _SkeletonMarketRow(),
            if (i < 4)
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const VitSkeleton(width: double.infinity, height: AppSpacing.x6),
        ],
      ),
    );
  }
}

class _SkeletonMarketRow extends StatelessWidget {
  const _SkeletonMarketRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        VitSkeleton(
          width: AppSpacing.inputHeight,
          height: AppSpacing.inputHeight,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitSkeleton(width: 130, height: AppSpacing.x4),
              SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitSkeleton(width: 82, height: AppSpacing.x3),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.x4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VitSkeleton(width: 74, height: AppSpacing.x4),
            SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitSkeleton(width: 52, height: AppSpacing.x4),
          ],
        ),
      ],
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview({required this.onMarkets});

  final VoidCallback onMarkets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EnterpriseStatesSpacingTokens.enterpriseStatesPreviewLargePadding,
      child: VitEmptyState(
        icon: Icons.star_border_rounded,
        title: 'Bạn chưa theo dõi cặp nào',
        message:
            'Thêm cặp giao dịch vào danh sách theo dõi để không bỏ lỡ biến động giá.',
        actionLabel: 'Thêm vào Watchlist',
        actionKey: EnterpriseStatesPage.marketCtaKey,
        onAction: onMarkets,
      ),
    );
  }
}

class _ErrorPreview extends StatelessWidget {
  const _ErrorPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
          EnterpriseStatesSpacingTokens.enterpriseStatesPreviewLargePadding,
      child: VitErrorState(
        title: 'Có lỗi xảy ra',
        message: 'Vui lòng thử lại. Nếu lỗi tiếp tục, hãy kiểm tra kết nối.',
      ),
    );
  }
}

class _OfflinePreview extends StatelessWidget {
  const _OfflinePreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EnterpriseStatesSpacingTokens.enterpriseStatesPreviewPadding,
      child: Column(
        children: [
          VitOfflineBanner(message: 'Mất kết nối. Đang hiển thị dữ liệu cũ.'),
          SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Opacity(opacity: .55, child: VitSkeletonList(rows: 2)),
        ],
      ),
    );
  }
}

class _GatePreview extends StatelessWidget {
  const _GatePreview({required this.onKyc});

  final VoidCallback onKyc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EnterpriseStatesSpacingTokens.enterpriseStatesPreviewPadding,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface2,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
            side: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Padding(
          padding: EnterpriseStatesSpacingTokens.enterpriseStatesPreviewPadding,
          child: Column(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppColors.warn,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                'Cần KYC để tiếp tục',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Hoàn tất xác minh danh tính để mở khóa tính năng này.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              VitCtaButton(
                key: EnterpriseStatesPage.kycCtaKey,
                onPressed: onKyc,
                leading: const Icon(Icons.arrow_forward_rounded),
                child: const Text('Đi tới KYC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
