part of 'referral_rewards_page.dart';

class _ReferralRewardsPageState extends ConsumerState<ReferralRewardsPage> {
  ReferralRewardFilter _filter = ReferralRewardFilter.all;
  ReferralRewardSort _sort = ReferralRewardSort.date;

  @override
  Widget build(BuildContext context) {
    final rewardsAsync = ref.watch(
      referralRewardsSnapshotProvider((filter: _filter, sort: _sort)),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phần thưởng',
      semanticIdentifier: 'SC-287',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phần thưởng',
            subtitle: 'Phần thưởng · Referral',
            showBack: true,
            onBack: () => context.go(
              rewardsAsync.value?.backRoute ?? AppRoutePaths.referral,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ReferralRewardsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(bottom: bottomInset),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: rewardsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được phần thưởng',
                            message: 'Thử lại sau hoặc quay lại trang chủ.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              referralRewardsSnapshotProvider((
                                filter: _filter,
                                sort: _sort,
                              )),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _RewardHero(
                            snapshot: snapshot,
                            onExport: () => _showExportSheet(context, snapshot),
                            onDisputes: () =>
                                _showDisputeHistorySheet(context, snapshot),
                          ),
                          _ReferralSectionHeader(
                            title: 'Hoa hồng theo tháng',
                            trailing:
                                '+${_formatUsd(snapshot.thisMonthCommission)} tháng này',
                          ),
                          _RewardChart(snapshot: snapshot),
                          _RewardTabs(
                            filters: snapshot.filters,
                            active: snapshot.filter,
                            onChanged: (value) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _filter = value);
                            },
                          ),
                          _SortRail(
                            options: snapshot.sortOptions,
                            active: snapshot.sort,
                            onChanged: (value) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _sort = value);
                            },
                          ),
                          _RewardLedger(
                            snapshot: snapshot,
                            onReport: (record) =>
                                _showReportSheet(context, snapshot, record),
                          ),
                          const _DisputeInfo(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportSheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
  ) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: ReferralSpacingTokens.referralSheetPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Xuất báo cáo hoa hồng',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    '${snapshot.records.length} bản ghi · ${_formatUsd(snapshot.totalCommission)} tổng',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  Wrap(
                    spacing: AppSpacing.x3,
                    runSpacing: AppSpacing.x3,
                    children: [
                      for (final range in snapshot.exportRanges)
                        VitAccentPill(
                          label: range.label,
                          accentColor: AppColors.text2,
                          size: VitStatusPillSize.sm,
                          semanticStatus: VitStatusPillStatus.neutral,
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    onPressed: () => Navigator.of(context).pop(),
                    leading: const Icon(Icons.download_rounded),
                    child: const Text('Tải xuống CSV'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReportSheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
    ReferralRewardRecordDraft record,
  ) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: ReferralSpacingTokens.referralSheetPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Báo lỗi hoa hồng',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  _SheetRecord(record: record),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  for (final type in snapshot.disputeTypes) ...[
                    _DisputeTypeRow(type: type),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                  ],
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    onPressed: () => Navigator.of(context).pop(),
                    variant: VitCtaButtonVariant.warning,
                    leading: const Icon(Icons.send_rounded),
                    child: const Text('Gửi báo lỗi'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDisputeHistorySheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
  ) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: ReferralSpacingTokens.referralSheetPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Lịch sử báo lỗi',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  for (final dispute in snapshot.disputes)
                    _DisputeHistoryCard(dispute: dispute),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RewardHero extends StatelessWidget {
  const _RewardHero({
    required this.snapshot,
    required this.onExport,
    required this.onDisputes,
  });

  final ReferralRewardsSnapshot snapshot;
  final VoidCallback onExport;
  final VoidCallback onDisputes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox.square(
                dimension: AppSpacing.iconLg + AppSpacing.x3,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.card_giftcard_rounded,
                      color: AppModuleAccents.referral,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng phần thưởng',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatUsd(snapshot.totalCommission),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      'USDT · Đã cộng vào ví',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              VitStatusPill(
                label: '${snapshot.tierName} (${snapshot.tierNameEn})',
                icon: Icons.workspace_premium_rounded,
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
                outline: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitBanner(
            variant: VitBannerVariant.warning,
            icon: Icons.schedule_rounded,
            message:
                '+${_formatUsd(snapshot.pendingCommission)} đang chờ xử lý',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.card_giftcard_rounded,
                  title: 'Thưởng KYC',
                  amount: snapshot.kycBonusTotal,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  icon: Icons.trending_up_rounded,
                  title: 'Hoa hồng GD',
                  amount: snapshot.tradeCommissionTotal,
                  color: AppModuleAccents.trade,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ReferralRewardsPage.exportKey,
                  onPressed: onExport,
                  variant: VitCtaButtonVariant.secondary,
                  height: VitDensity.compact.controlHeight,
                  leading: const Icon(Icons.download_rounded),
                  child: const Text('Xuất báo cáo'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: ReferralRewardsPage.disputeHistoryKey,
                  onPressed: onDisputes,
                  variant: VitCtaButtonVariant.ghost,
                  height: VitDensity.compact.controlHeight,
                  leading: const Icon(Icons.shield_outlined),
                  child: const Text('Lịch sử báo lỗi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      padding: ReferralSpacingTokens.referralInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            _formatUsd(amount),
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralSectionHeader extends StatelessWidget {
  const _ReferralSectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitModuleSectionHeader(
            title: title,
            accentColor: AppModuleAccents.referral,
            density: VitDensity.compact,
            bottomGap: AppSpacing.pageRhythmCompactInnerGap,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
      ],
    );
  }
}
