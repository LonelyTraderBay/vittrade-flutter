part of 'compliance_regulatory_tablet_pages.dart';

/// SC-101/SC-415: Định nghĩa thị trường mục tiêu (chi tiết theo sản phẩm).
class TargetMarketDefinitionTabletPage extends ConsumerWidget {
  const TargetMarketDefinitionTabletPage({super.key, this.productId});

  static const contentKey = Key('sc101_tablet_content');

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedProductId = productId ?? 'default';
    final snapshotAsync = ref.watch(
      tradeTargetMarketDefinitionProvider(resolvedProductId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-101',
        semanticLabel: 'Định nghĩa thị trường mục tiêu',
        title: 'Thị trường mục tiêu',
        subtitle: 'Phù hợp · Không phù hợp',
        contentKey: TargetMarketDefinitionTabletPage.contentKey,
        children: [
          _cregError(
            'Không tải được định nghĩa thị trường',
            () => ref.invalidate(
              tradeTargetMarketDefinitionProvider(resolvedProductId),
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-101',
        semanticLabel: 'Định nghĩa thị trường mục tiêu',
        title: snapshot.product.name,
        subtitle:
            '${snapshot.product.type} · Rủi ro ${snapshot.product.riskLevel}',
        contentKey: TargetMarketDefinitionTabletPage.contentKey,
        children: [
          for (final dimension in snapshot.dimensions) ...[
            _cregSection(
              title: dimension.category,
              rows: [
                ..._cregBullets([
                  for (final suitable in dimension.suitableFor)
                    'Phù hợp: $suitable',
                  for (final notSuitable in dimension.notSuitableFor)
                    'Không phù hợp: $notSuitable',
                ]),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// SC-115: Nhật ký kiểm toán.
class AuditTrailTabletPage extends ConsumerWidget {
  const AuditTrailTabletPage({super.key});

  static const contentKey = Key('sc115_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeAuditTrailProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-115',
        semanticLabel: 'Nhật ký kiểm toán',
        title: snapshotAsync.value?.noticeTitle ?? 'Nhật ký kiểm toán',
        subtitle: 'Truy vết · Xuất dữ liệu',
        contentKey: AuditTrailTabletPage.contentKey,
        children: [
          _cregError(
            'Không tải được nhật ký',
            () => ref.invalidate(tradeAuditTrailProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-115',
        semanticLabel: 'Nhật ký kiểm toán',
        title: snapshot.noticeTitle,
        subtitle: snapshot.noticeDescription,
        contentKey: AuditTrailTabletPage.contentKey,
        children: [
          _cregSection(
            title: 'Thống kê',
            rows: _cregRows([
              for (final stat in snapshot.stats) (stat.label, stat.value),
            ]),
          ),

          _cregSection(
            title: 'Bản ghi gần đây',
            rows: [
              for (final entry in snapshot.entries.take(10))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.categoryLabel} · ${entry.action}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              entry.details,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        entry.timestampLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _cregSection(
            title: 'Định dạng xuất',
            rows: _cregBullets(snapshot.exportFormats),
          ),
        ],
      ),
    );
  }
}

/// SC-411: Yêu cầu nâng hạng khách hàng (opt-up).
class ClientOptUpRequestTabletPage extends ConsumerWidget {
  const ClientOptUpRequestTabletPage({super.key});

  static const contentKey = Key('sc411_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeClientCategorizationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-411',
        semanticLabel: 'Yêu cầu nâng hạng khách hàng',
        title: 'Nâng hạng khách hàng',
        subtitle: 'Yêu cầu · Điều kiện',
        contentKey: ClientOptUpRequestTabletPage.contentKey,
        children: [
          _cregError(
            'Không tải được thông tin phân loại',
            () => ref.invalidate(tradeClientCategorizationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-411',
        semanticLabel: 'Yêu cầu nâng hạng khách hàng',
        title: 'Nâng hạng khách hàng',
        subtitle: 'Yêu cầu · Điều kiện',
        contentKey: ClientOptUpRequestTabletPage.contentKey,
        children: [
          _cregSection(
            title: 'Các hạng hiện có',
            rows: [
              for (final category in snapshot.categories)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.label,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: snapshot.currentCategoryId == category.id
                                    ? AppColors.primary
                                    : AppColors.text1,
                              ),
                            ),
                            Text(
                              category.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (snapshot.currentCategoryId == category.id)
                        const VitStatusPill(
                          label: 'Hạng hiện tại',
                          status: VitStatusPillStatus.info,
                          size: VitStatusPillSize.sm,
                        ),
                    ],
                  ),
                ),
            ],
          ),

          _cregSection(
            title: 'Yêu cầu nâng hạng',
            rows: [
              for (final category in snapshot.categories)
                if (category.id != snapshot.currentCategoryId)
                  ..._cregBullets(category.requirements),
            ],
          ),

          _cregSection(
            title: 'Lịch sử thay đổi hạng',
            rows: [
              ...(snapshot.history.isEmpty
                  ? _cregBullets(['Chưa có thay đổi hạng nào được ghi nhận.'])
                  : <Widget>[
                      for (final change in snapshot.history)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  change.reason,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                              ),
                              Text(
                                '${change.date} · ${change.action}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ]),
            ],
          ),
        ],
      ),
    );
  }
}
