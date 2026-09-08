part of 'p2p_account_tablet_pages.dart';

class P2PBlacklistTabletPage extends ConsumerWidget {
  const P2PBlacklistTabletPage({super.key});

  static const contentKey = Key('sc277_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pBlacklistProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-277',
        semanticLabel: 'Danh sách chặn P2P',
        title: snapshotAsync.value?.title ?? 'Danh sách chặn',
        subtitle: 'Người dùng bị chặn',
        contentKey: P2PBlacklistTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được danh sách chặn',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pBlacklistProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-277',
        semanticLabel: 'Danh sách chặn P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PBlacklistTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              snapshot.contractNotes,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-276: Thêm vào blacklist.
class P2PBlacklistAddTabletPage extends ConsumerWidget {
  const P2PBlacklistAddTabletPage({super.key});

  static const contentKey = Key('sc276_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pBlacklistAddProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-276',
        semanticLabel: 'Thêm vào danh sách chặn P2P',
        title: 'Thêm vào danh sách chặn',
        subtitle: 'Người dùng · Lý do',
        contentKey: P2PBlacklistAddTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được biểu mẫu',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pBlacklistAddProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-276',
        semanticLabel: 'Thêm vào danh sách chặn P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PBlacklistAddTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _accSection(
              title: snapshot.heroTitle,
              rows: [
                Text(
                  snapshot.heroSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Xác nhận chặn',
                  message:
                      'Người dùng bị chặn sẽ không thấy quảng cáo của bạn và không thể giao dịch với bạn. Có thể gỡ bỏ sau.',
                  contractId: 'p2p-blacklist-add-tablet',
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _accSection(
              title: 'Lý do',
              rows: [
                Wrap(
                  spacing: TabletSpacingTokens.x3,
                  runSpacing: TabletSpacingTokens.x2,
                  children: [
                    for (final reason in snapshot.reasons)
                      VitFilterChip(
                        label: reason.label,
                        onTap: () {},
                        active: false,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              variant: VitCtaButtonVariant.danger,
              onPressed: () => context.go(AppRoutePaths.p2p),
              child: Text(snapshot.submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-259: Giải thích mã hóa E2E.
class P2PE2EInfoTabletPage extends ConsumerWidget {
  const P2PE2EInfoTabletPage({super.key});

  static const contentKey = Key('sc259_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pE2EInfoProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-259',
        semanticLabel: 'Mã hóa E2E P2P',
        title: 'Mã hóa E2E',
        subtitle: 'Bảo mật chat',
        contentKey: P2PE2EInfoTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được thông tin E2E',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pE2EInfoProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-259',
        semanticLabel: 'Mã hóa E2E P2P',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroSubtitle,
        contentKey: P2PE2EInfoTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _accSection(
              title: snapshot.diagramCaption,
              rows: [
                ..._accRows([
                  (snapshot.localLabel, 'Chỉ bạn đọc được'),
                  (snapshot.partnerLabel, 'Chỉ đối tác đọc được'),
                ]),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _accSection(
              title: 'Cách hoạt động',
              rows: [
                for (var i = 0; i < snapshot.steps.length; i++)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.control.copyWith(
                              color: AppColors.primary,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot.steps[i].step,
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
            const SizedBox(height: TabletSpacingTokens.x3),
            _accSection(
              title: 'Dấu vân tay mã hóa',
              rows: [
                ..._accRows([('Kiểm tra', snapshot.fingerprint)]),
                Text(
                  snapshot.fingerprintHint,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Text(
              snapshot.serverNote,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-260: Phòng chống lừa đảo.
class P2PFraudPreventionTabletPage extends ConsumerWidget {
  const P2PFraudPreventionTabletPage({super.key});

  static const contentKey = Key('sc260_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pFraudPreventionProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-260',
        semanticLabel: 'Phòng chống lừa đảo P2P',
        title: 'Phòng chống lừa đảo',
        subtitle: 'Kịch bản · Checklist',
        contentKey: P2PFraudPreventionTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được nội dung phòng chống lừa đảo',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pFraudPreventionProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-260',
        semanticLabel: 'Phòng chống lừa đảo P2P',
        title: 'Phòng chống lừa đảo',
        subtitle: 'Nhận diện · An toàn',
        contentKey: P2PFraudPreventionTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final pattern in snapshot.patterns)
              Padding(
                padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
                child: _accSection(
                  title: '${pattern.title} (${pattern.severity})',
                  rows: [
                    Text(
                      pattern.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
                    ),
                    ..._accBullets(
                      pattern.howItWorks,
                      Icons.arrow_forward_rounded,
                      AppColors.text3,
                    ),
                  ],
                ),
              ),
            _accSection(
              title: 'Checklist an toàn',
              rows: _accBullets(
                [for (final item in snapshot.checklist) item.label],
                Icons.check_circle_outline_rounded,
                AppColors.buy,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _accSection(
              title: 'Khẩn cấp',
              rows: _accBullets(
                [for (final action in snapshot.emergencyActions) action.label],
                Icons.emergency_outlined,
                AppColors.sell,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Text(
              snapshot.disclosure,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-275: Thành tựu P2P.
class P2PAchievementsTabletPage extends ConsumerWidget {
  const P2PAchievementsTabletPage({super.key});

  static const contentKey = Key('sc275_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pAchievementsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-275',
        semanticLabel: 'Thành tựu P2P',
        title: 'Thành tựu',
        subtitle: 'Cấp · Huy hiệu',
        contentKey: P2PAchievementsTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được thành tựu',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pAchievementsProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-275',
        semanticLabel: 'Thành tựu P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PAchievementsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _accSection(
              title: 'Cấp hiện tại: ${snapshot.currentLevel}',
              rows: [
                for (final achievement in snapshot.achievements)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            achievement.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Text(
              snapshot.contractNotes,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
