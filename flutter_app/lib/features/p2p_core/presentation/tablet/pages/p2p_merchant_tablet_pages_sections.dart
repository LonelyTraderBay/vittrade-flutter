part of 'p2p_merchant_tablet_pages.dart';

class P2PMerchantApplyTabletPage extends ConsumerWidget {
  const P2PMerchantApplyTabletPage({super.key});

  static const contentKey = Key('sc227_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pMerchantApplyProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đăng ký merchant P2P',
      semanticIdentifier: 'SC-227',
      child: Column(
        children: [
          VitHeader(
            title: 'Đăng ký merchant',
            subtitle: 'Điều kiện · Hồ sơ · Duyệt',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2p,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được biểu mẫu đăng ký',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pMerchantApplyProvider),
                ),
              ),
              data: (snapshot) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: SingleChildScrollView(
                    key: P2PMerchantApplyTabletPage.contentKey,
                    padding: const EdgeInsets.fromLTRB(
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x4,
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Row(
                            children: [
                              Expanded(
                                child: _MerchantStatCell(
                                  label: 'Giao dịch của bạn',
                                  value: '${snapshot.stats.totalTrades}',
                                ),
                              ),
                              Expanded(
                                child: _MerchantStatCell(
                                  label: 'Hoàn tất',
                                  value:
                                      '${snapshot.stats.completionRate.toStringAsFixed(1)}%',
                                  color: AppColors.buy,
                                ),
                              ),
                              Expanded(
                                child: _MerchantStatCell(
                                  label: 'Phản hồi TB',
                                  value: snapshot.stats.avgResponseTime,
                                ),
                              ),
                              Expanded(
                                child: _MerchantStatCell(
                                  label: 'Tuổi tài khoản',
                                  value:
                                      '${snapshot.stats.accountAgeDays} ngày',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _RequirementsCard(requirements: snapshot.requirements),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DocumentsCard(documents: snapshot.documents),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _MerchantBenefitsCard(benefits: snapshot.benefits),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quy trình duyệt',
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x2),
                              for (
                                var i = 0;
                                i < snapshot.reviewSteps.length;
                                i++
                              )
                                Padding(
                                  padding:
                                      TabletSpacingTokens.tableCellPaddingV,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: TabletSpacingTokens.x7,
                                        child: Text(
                                          '${i + 1}',
                                          style: AppTextStyles.control.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: AppTextStyles.bold,
                                            fontFeatures:
                                                AppTextStyles.tabularFigures,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          snapshot.reviewSteps[i],
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.text2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Text(
                            snapshot.securityNote,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        Text(
                          snapshot.reviewNotice,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x4),
                        VitCtaButton(
                          onPressed: () => context.go(AppRoutePaths.p2p),
                          child: const Text('Gửi hồ sơ đăng ký'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.requirements});

  final List<P2PMerchantRequirementDraft> requirements;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Điều kiện',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final requirement in requirements)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      requirement.met
                          ? Icons.check_circle_outline_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: TabletSpacingTokens.iconSm,
                      color: requirement.met ? AppColors.buy : AppColors.text3,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x2),
                  Expanded(
                    child: Text(
                      requirement.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    requirement.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
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

class _DocumentsCard extends StatelessWidget {
  const _DocumentsCard({required this.documents});

  final List<P2PMerchantDocumentDraft> documents;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hồ sơ cần tải lên',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final document in documents)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      document.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  if (document.required)
                    const VitStatusPill(
                      label: 'Bắt buộc',
                      status: VitStatusPillStatus.warning,
                      size: VitStatusPillSize.sm,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MerchantBenefitsCard extends StatelessWidget {
  const _MerchantBenefitsCard({required this.benefits});

  final List<P2PMerchantBenefitDraft> benefits;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quyền lợi merchant',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final benefit in benefits)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      benefit.title,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      benefit.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
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

/// Báo cáo merchant (SC-229): lý do + mô tả + cảnh báo duyệt — requiresConfirmation.
class P2PReportMerchantTabletPage extends ConsumerWidget {
  const P2PReportMerchantTabletPage({super.key, required this.merchantId});

  static const contentKey = Key('sc229_tablet_content');
  static const submitKey = Key('sc229_tablet_submit');

  final String merchantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pReportMerchantProvider(merchantId));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Báo cáo merchant P2P',
      semanticIdentifier: 'SC-229',
      child: Column(
        children: [
          VitHeader(
            title: 'Báo cáo merchant',
            subtitle: 'Lý do · Minh chứng · Duyệt',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2p,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được biểu mẫu báo cáo',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(p2pReportMerchantProvider(merchantId)),
                ),
              ),
              data: (snapshot) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: SingleChildScrollView(
                    key: P2PReportMerchantTabletPage.contentKey,
                    padding: const EdgeInsets.fromLTRB(
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x4,
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Merchant bị báo cáo: ${snapshot.merchant.name}',
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x1),
                              Text(
                                snapshot.detailPrompt,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lý do báo cáo',
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x2),
                              for (final reason in snapshot.reasons)
                                Padding(
                                  padding:
                                      TabletSpacingTokens.tableCellPaddingV,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          reason.label,
                                          style: AppTextStyles.caption.copyWith(
                                            fontWeight: AppTextStyles.bold,
                                            color: AppColors.text1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          reason.description,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.text2,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Text(
                            snapshot.reviewNotice,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x4),
                        VitCtaButton(
                          key: P2PReportMerchantTabletPage.submitKey,
                          variant: VitCtaButtonVariant.danger,
                          onPressed: () =>
                              context.go(snapshot.merchantProfileRoute),
                          child: const Text('Gửi báo cáo'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
