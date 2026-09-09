part of 'copy_trading_extended_tablet_pages.dart';

/// SC-082: Giải quyết tranh chấp sao chép.
class CopyDisputeResolutionTabletPage extends ConsumerWidget {
  const CopyDisputeResolutionTabletPage({super.key});

  static const contentKey = Key('sc082_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeDisputeResolutionProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-082',
        semanticLabel: 'Giải quyết tranh chấp sao chép',
        title: 'Giải quyết tranh chấp',
        subtitle: 'Quy trình · Cases',
        contentKey: CopyDisputeResolutionTabletPage.contentKey,
        children: [
          _extError(
            'Không tải được giải quyết tranh chấp',
            () => ref.invalidate(tradeDisputeResolutionProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-082',
        semanticLabel: 'Giải quyết tranh chấp sao chép',
        title: snapshot.noticeTitle,
        subtitle: snapshot.noticeBody,
        contentKey: CopyDisputeResolutionTabletPage.contentKey,
        children: [
          _extSection(
            title: 'Cases đang xử lý',
            rows: [
              if (snapshot.activeCases.isEmpty)
                Text(
                  'Không có case nào đang xử lý.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                )
              else
                for (final disputeCase in snapshot.activeCases)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            disputeCase.complaintType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          disputeCase.status,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.caution,
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),

          _extSection(
            title: 'Cases đã giải quyết',
            rows: [
              if (snapshot.resolvedCases.isEmpty)
                Text(
                  'Chưa có case nào hoàn tất.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                )
              else
                for (final disputeCase in snapshot.resolvedCases.take(6))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            disputeCase.complaintType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Text(
                          disputeCase.status,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.buy,
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

/// SC-077: Nhật ký kiểm toán bản sao.
class CopyAuditLogTabletPage extends ConsumerStatefulWidget {
  const CopyAuditLogTabletPage({super.key, required this.copyId});

  static const contentKey = Key('sc077_tablet_content');

  final String copyId;

  @override
  ConsumerState<CopyAuditLogTabletPage> createState() =>
      _CopyAuditLogTabletPageState();
}

class _CopyAuditLogTabletPageState
    extends ConsumerState<CopyAuditLogTabletPage> {
  String? _selectedFormat;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopyAuditLogProvider(widget.copyId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-077',
        semanticLabel: 'Nhật ký kiểm toán P2P',
        title: 'Nhật ký kiểm toán',
        subtitle: widget.copyId,
        contentKey: CopyAuditLogTabletPage.contentKey,
        children: [
          _extError(
            'Không tải được nhật ký',
            () => ref.invalidate(tradeCopyAuditLogProvider(widget.copyId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-077',
        semanticLabel: 'Nhật ký kiểm toán sao chép',
        title: snapshot.complianceTitle,
        subtitle: snapshot.complianceDescription,
        contentKey: CopyAuditLogTabletPage.contentKey,
        children: [
          for (final event in snapshot.events.take(20))
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      event.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      event.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          _extSection(
            title: 'Xuất dữ liệu',
            rows: [
              Wrap(
                spacing: TabletSpacingTokens.x3,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  for (final format in snapshot.exportFormats)
                    VitFilterChip(
                      label: format.label,
                      onTap: () =>
                          setState(() => _selectedFormat = format.label),
                      active: format.label == _selectedFormat,
                      color: AppColors.primary,
                    ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x2),
              Text(
                'Dữ liệu lưu trữ ${snapshot.retentionYears} năm theo quy định.',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-069: Đơn đăng ký làm provider.
class ProviderApplyTabletPage extends ConsumerWidget {
  const ProviderApplyTabletPage({super.key});

  static const contentKey = Key('sc069_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(
      tradeProviderApplicationControllerProvider,
    );

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-069',
        semanticLabel: 'Đăng ký làm provider',
        title: 'Đăng ký provider',
        subtitle: 'Điều kiện · Quyền lợi',
        contentKey: ProviderApplyTabletPage.contentKey,
        children: [
          _extError(
            'Không tải được đơn đăng ký',
            () => ref.invalidate(tradeProviderApplicationControllerProvider),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        return VitTabletSectionFrame(
          semanticIdentifier: 'SC-069',
          semanticLabel: 'Đăng ký làm provider',
          title: 'Đăng ký làm provider',
          subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
          contentKey: ProviderApplyTabletPage.contentKey,
          children: [
            _extSection(
              title: 'Các bước đăng ký',
              rows: [
                for (final step in snapshot.steps)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.name,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          step.name,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            _extSection(
              title: 'Quyền lợi',
              rows: [
                for (final benefit in snapshot.benefits)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            benefit.title,
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

            _extSection(
              title: 'Yêu cầu',
              rows: [
                for (final requirement in snapshot.requirements)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            requirement.label,
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

            _extSection(
              title: 'Trách nhiệm',
              rows: _bulletCopy2(snapshot.responsibilities),
            ),
          ],
        );
      },
    );
  }
}

List<Widget> _bulletCopy2(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: TabletSpacingTokens.iconSm,
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}
