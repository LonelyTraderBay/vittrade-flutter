part of 'compliance_reports_tablet_pages.dart';

class RegulatoryInspectionReadyTabletPage extends ConsumerWidget {
  const RegulatoryInspectionReadyTabletPage({super.key});

  static const contentKey = Key('sc116_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeRegulatoryInspectionReadyProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-116',
        semanticLabel: 'Sẵn sàng thanh tra',
        title: 'Sẵn sàng thanh tra',
        subtitle: 'Checklist',
        contentKey: RegulatoryInspectionReadyTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được trạng thái thanh tra',
            () => ref.invalidate(tradeRegulatoryInspectionReadyProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-116',
        semanticLabel: 'Sẵn sàng thanh tra',
        title: 'Sẵn sàng thanh tra',
        subtitle: 'Checklist tuân thủ',
        contentKey: RegulatoryInspectionReadyTabletPage.contentKey,
        children: [
          _rptSection(
            title: 'Các hạng mục',
            rows: _rptBullets([
              'Chính sách phê duyệt đã ban hành',
              'Quy trình xử lý khiếu nại đã cập nhật',
              'Báo cáo giao dịch đã nộp đầy đủ',
              'Đào tạo tuân thủ đã hoàn thành',
            ]),
          ),

          _rptSection(
            title: 'Ghi chú',
            rows: [
              _rptBody(
                'Tất cả hạng mục cần được xác nhận trước kỳ thanh tra định kỳ. Hồ sơ chứng từ được lưu trữ tập trung tại phần Tài liệu.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-113/SC-416: Theo dõi khiếu nại (base + chi tiết theo mã khiếu nại).
class ComplaintTrackingTabletPage extends ConsumerWidget {
  const ComplaintTrackingTabletPage({super.key, this.complaintId});

  static const contentKey = Key('sc113_tablet_content');

  final String? complaintId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      tradeComplaintTrackingProvider(complaintId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-113',
        semanticLabel: 'Theo dõi khiếu nại',
        title: 'Theo dõi khiếu nại',
        subtitle: snapshotAsync.value?.statusLabel ?? 'Trạng thái',
        contentKey: ComplaintTrackingTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được khiếu nại',
            () => ref.invalidate(tradeComplaintTrackingProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-113',
        semanticLabel: 'Theo dõi khiếu nại',
        title: 'Theo dõi khiếu nại',
        subtitle: snapshot.statusLabel,
        contentKey: ComplaintTrackingTabletPage.contentKey,
        children: [
          _rptSection(
            title: 'Trạng thái khiếu nại',
            rows: _rptRows([
              ('Mã khiếu nại', snapshot.complaintId),
              ('Trạng thái', snapshot.statusLabel),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-114: Giới thiệu ombudsman.
class OmbudsmanReferralTabletPage extends ConsumerWidget {
  const OmbudsmanReferralTabletPage({super.key});

  static const contentKey = Key('sc114_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeOmbudsmanReferralProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-114',
        semanticLabel: 'Giới thiệu ombudsman',
        title: 'Ombudsman',
        subtitle: 'Điều kiện · Liên hệ',
        contentKey: OmbudsmanReferralTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được ombudsman',
            () => ref.invalidate(tradeOmbudsmanReferralProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-114',
        semanticLabel: 'Giới thiệu ombudsman',
        title: snapshot.infoTitle,
        subtitle: 'Điều kiện · Quy trình',
        contentKey: OmbudsmanReferralTabletPage.contentKey,
        children: [
          _rptSection(
            title: 'Thông tin',
            rows: [_rptBody(snapshot.infoDescription)],
          ),

          _rptSection(
            title: 'Điều kiện',
            rows: [
              for (final eligibility in snapshot.eligibility)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eligibility.title,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        eligibility.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _rptSection(
            title: 'Quy trình',
            rows: [
              for (final step in snapshot.processSteps)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x7,
                        child: Text(
                          '${step.step}',
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          step.title,
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

          _rptSection(
            title: 'Liên hệ',
            rows: [
              for (final contact in snapshot.contacts)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.label,
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
        ],
      ),
    );
  }
}

/// SC-100: Quản trị sản phẩm.
class ProductGovernanceTabletPage extends ConsumerWidget {
  const ProductGovernanceTabletPage({super.key});

  static const contentKey = Key('sc100_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeProductGovernanceProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-100',
        semanticLabel: 'Quản trị sản phẩm',
        title: 'Quản trị sản phẩm',
        subtitle: 'Danh mục · Đánh giá',
        contentKey: ProductGovernanceTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được quản trị sản phẩm',
            () => ref.invalidate(tradeProductGovernanceProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-100',
        semanticLabel: 'Quản trị sản phẩm',
        title: 'Quản trị sản phẩm',
        subtitle: 'Xem lại định kỳ',
        contentKey: ProductGovernanceTabletPage.contentKey,
        children: [
          for (final product in snapshot.products)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.name} (${product.type})',
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      'Rủi ro: ${product.riskLevel} · ${product.status}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Text(
            'Xem lại tiếp theo: ${snapshot.nextReviewLabel}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

/// SC-099: Phân loại khách hàng.
class ClientCategorizationTabletPage extends ConsumerWidget {
  const ClientCategorizationTabletPage({super.key});

  static const contentKey = Key('sc099_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeClientCategorizationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-099',
        semanticLabel: 'Phân loại khách hàng',
        title: 'Phân loại khách hàng',
        subtitle: 'Loại · Bảo vệ',
        contentKey: ClientCategorizationTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được phân loại',
            () => ref.invalidate(tradeClientCategorizationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-099',
        semanticLabel: 'Phân loại khách hàng',
        title: 'Phân loại khách hàng',
        subtitle: 'Bảo vệ theo loại',
        contentKey: ClientCategorizationTabletPage.contentKey,
        children: [
          for (final category in snapshot.categories)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.label,
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: snapshot.currentCategoryId == category.id
                                  ? AppColors.primary
                                  : AppColors.text1,
                            ),
                          ),
                        ),
                        if (snapshot.currentCategoryId == category.id)
                          const VitStatusPill(
                            label: 'Loại hiện tại',
                            status: VitStatusPillStatus.info,
                            size: VitStatusPillSize.sm,
                          ),
                      ],
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      category.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x2),
                    ..._rptBullets(category.protections),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
