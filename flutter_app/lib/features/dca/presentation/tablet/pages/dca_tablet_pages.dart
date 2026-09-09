import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

Widget _dcaError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _dcaSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _dcaRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-169: DCA tổng quan.
class DcaOverviewTabletPage extends ConsumerWidget {
  const DcaOverviewTabletPage({super.key});

  static const contentKey = Key('sc169_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaDashboardProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-169',
        semanticLabel: 'DCA tổng quan',
        title: 'DCA',
        subtitle: 'Chiến lược · Tổng quan',
        contentKey: DcaOverviewTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được DCA',
            () => ref.invalidate(dcaDashboardProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-169',
        semanticLabel: 'DCA tổng quan',
        title: 'DCA',
        subtitle: 'Chiến lược tích lũy',
        contentKey: DcaOverviewTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Tổng quan DCA',
            rows: _dcaRows([
              ('Trạng thái', 'Đang hoạt động'),
              ('Cập nhật', 'Mới nhất'),
            ]),
          ),

          _dcaSection(
            title: 'Khám phá',
            rows: [
              Wrap(
                spacing: TabletSpacingTokens.x2,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  for (final (label, path) in [
                    ('Tạo lịch DCA', AppRoutePaths.dcaScheduleConfig),
                    ('Phân tích lịch DCA', AppRoutePaths.dcaScheduleAnalytics),
                    ('Cấu hình rebalance', AppRoutePaths.dcaRebalanceConfig),
                    ('Bảng rebalance', AppRoutePaths.dcaRebalanceDashboard),
                    ('Tối ưu danh mục', AppRoutePaths.dcaPortfolioOptimizer),
                    ('Số tiền linh hoạt', AppRoutePaths.dcaDynamicAmount),
                    ('Kiểm thử lại', AppRoutePaths.dcaBacktester),
                    ('Đa tài sản', AppRoutePaths.dcaMultiAsset),
                    ('So sánh hiệu suất', AppRoutePaths.dcaPerformanceCompare),
                    ('Quy tắc thông minh', AppRoutePaths.dcaSmartRules),
                  ])
                    VitFilterChip(
                      label: label,
                      active: false,
                      color: AppColors.primary,
                      onTap: () => context.push(path),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-170: Cấu hình rebalance.
class DcaRebalanceConfigTabletPage extends ConsumerWidget {
  const DcaRebalanceConfigTabletPage({super.key});

  static const contentKey = Key('sc170_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaRebalanceConfigProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-170',
        semanticLabel: 'Cấu hình rebalance DCA',
        title: 'Cấu hình rebalance',
        subtitle: 'Phân bổ',
        contentKey: DcaRebalanceConfigTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được cấu hình rebalance',
            () => ref.invalidate(dcaRebalanceConfigProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-170',
        semanticLabel: 'Cấu hình rebalance DCA',
        title: 'Cấu hình rebalance',
        subtitle: 'Phân bổ tài sản',
        contentKey: DcaRebalanceConfigTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Trạng thái',
            rows: _dcaRows([('Trạng thái', 'Đang cấu hình')]),
          ),
        ],
      ),
    );
  }
}

/// SC-171: Dashboard rebalance.
class DcaRebalanceDashboardTabletPage extends ConsumerWidget {
  const DcaRebalanceDashboardTabletPage({super.key});

  static const contentKey = Key('sc171_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaRebalanceConfigProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-171',
        semanticLabel: 'Bảng điều khiển rebalance DCA',
        title: 'Dashboard rebalance',
        subtitle: 'Theo dõi',
        contentKey: DcaRebalanceDashboardTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được dashboard',
            () => ref.invalidate(dcaRebalanceConfigProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-171',
        semanticLabel: 'Bảng điều khiển rebalance DCA',
        title: 'Dashboard rebalance',
        subtitle: 'Theo dõi',
        contentKey: DcaRebalanceDashboardTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Dashboard',
            rows: _dcaRows([('Trạng thái', 'Đang hoạt động')]),
          ),
        ],
      ),
    );
  }
}

/// SC-172: Cấu hình lịch DCA.
class DcaScheduleConfigTabletPage extends ConsumerWidget {
  const DcaScheduleConfigTabletPage({super.key});

  static const contentKey = Key('sc172_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaScheduleConfigProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-172',
        semanticLabel: 'Cấu hình lịch DCA',
        title: 'Lịch DCA',
        subtitle: 'Cấu hình',
        contentKey: DcaScheduleConfigTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được lịch DCA',
            () => ref.invalidate(dcaScheduleConfigProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-172',
        semanticLabel: 'Cấu hình lịch DCA',
        title: 'Lịch DCA',
        subtitle: 'Cấu hình',
        contentKey: DcaScheduleConfigTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Lịch',
            rows: _dcaRows([('Trạng thái', 'Đang hoạt động')]),
          ),
        ],
      ),
    );
  }
}

/// SC-173: Phân tích lịch DCA.
class DcaScheduleAnalyticsTabletPage extends ConsumerWidget {
  const DcaScheduleAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc173_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaScheduleConfigProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-173',
        semanticLabel: 'Phân tích lịch DCA',
        title: 'Phân tích lịch',
        subtitle: 'Thống kê',
        contentKey: DcaScheduleAnalyticsTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được phân tích lịch',
            () => ref.invalidate(dcaScheduleConfigProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-173',
        semanticLabel: 'Phân tích lịch DCA',
        title: 'Phân tích lịch',
        subtitle: 'Thống kê',
        contentKey: DcaScheduleAnalyticsTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Thống kê',
            rows: _dcaRows([('Trạng thái', 'Đang theo dõi')]),
          ),
        ],
      ),
    );
  }
}

/// SC-174: Portfolio optimizer.
class DcaPortfolioOptimizerTabletPage extends ConsumerWidget {
  const DcaPortfolioOptimizerTabletPage({super.key});

  static const contentKey = Key('sc174_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-174',
      semanticLabel: 'Tối ưu danh mục DCA',
      title: 'Tối ưu danh mục',
      subtitle: 'Portfolio optimizer',
      contentKey: DcaPortfolioOptimizerTabletPage.contentKey,
      children: [
        _dcaSection(
          title: 'Tối ưu hóa',
          rows: _dcaRows([('Trạng thái', 'Sẵn sàng')]),
        ),
      ],
    );
  }
}

/// SC-175: Số tiền động.
class DcaDynamicAmountTabletPage extends ConsumerWidget {
  const DcaDynamicAmountTabletPage({super.key});

  static const contentKey = Key('sc175_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaDynamicAmountProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-175',
        semanticLabel: 'DCA số tiền động',
        title: 'Số tiền động',
        subtitle: 'Chiến lược',
        contentKey: DcaDynamicAmountTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được số tiền động',
            () => ref.invalidate(dcaDynamicAmountProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-175',
        semanticLabel: 'DCA số tiền động',
        title: 'Số tiền động',
        subtitle: 'Chiến lược',
        contentKey: DcaDynamicAmountTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Chiến lược',
            rows: _dcaRows([('Trạng thái', 'Đang hoạt động')]),
          ),
        ],
      ),
    );
  }
}

/// SC-176: Backtester.
class DcaBacktesterTabletPage extends ConsumerWidget {
  const DcaBacktesterTabletPage({super.key});

  static const contentKey = Key('sc176_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaBacktesterProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-176',
        semanticLabel: 'Trình kiểm thử DCA',
        title: 'Backtester',
        subtitle: 'Kiểm tra lịch sử',
        contentKey: DcaBacktesterTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được backtester',
            () => ref.invalidate(dcaBacktesterProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-176',
        semanticLabel: 'Trình kiểm thử DCA',
        title: 'Backtester',
        subtitle: 'Kiểm tra lịch sử',
        contentKey: DcaBacktesterTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Kiểm tra',
            rows: _dcaRows([('Trạng thái', 'Sẵn sàng')]),
          ),
        ],
      ),
    );
  }
}

/// SC-177: Multi-asset DCA.
class DcaMultiAssetTabletPage extends ConsumerWidget {
  const DcaMultiAssetTabletPage({super.key});

  static const contentKey = Key('sc177_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaMultiAssetProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-177',
        semanticLabel: 'DCA đa tài sản',
        title: 'Multi-asset DCA',
        subtitle: 'Đa tài sản',
        contentKey: DcaMultiAssetTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được multi-asset DCA',
            () => ref.invalidate(dcaMultiAssetProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-177',
        semanticLabel: 'DCA đa tài sản',
        title: 'Multi-asset DCA',
        subtitle: 'Đa tài sản',
        contentKey: DcaMultiAssetTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Danh sách tài sản',
            rows: _dcaRows([('Trạng thái', 'Đang hoạt động')]),
          ),
        ],
      ),
    );
  }
}

/// SC-178: So sánh hiệu suất DCA.
class DcaPerformanceCompareTabletPage extends ConsumerWidget {
  const DcaPerformanceCompareTabletPage({super.key});

  static const contentKey = Key('sc178_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-178',
      semanticLabel: 'So sánh hiệu suất DCA',
      title: 'So sánh hiệu suất',
      subtitle: 'DCA · So sánh',
      contentKey: DcaPerformanceCompareTabletPage.contentKey,
      children: [
        _dcaSection(
          title: 'So sánh',
          rows: _dcaRows([('Trạng thái', 'Sẵn sàng')]),
        ),
      ],
    );
  }
}

/// SC-179: Smart rules DCA.
class DcaSmartRulesTabletPage extends ConsumerWidget {
  const DcaSmartRulesTabletPage({super.key});

  static const contentKey = Key('sc179_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(dcaSmartRulesProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-179',
        semanticLabel: 'Quy tắc thông minh DCA',
        title: 'Smart Rules',
        subtitle: 'Quy tắc thông minh',
        contentKey: DcaSmartRulesTabletPage.contentKey,
        children: [
          _dcaError(
            'Không tải được smart rules',
            () => ref.invalidate(dcaSmartRulesProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-179',
        semanticLabel: 'Quy tắc thông minh DCA',
        title: 'Smart Rules',
        subtitle: 'Quy tắc thông minh',
        contentKey: DcaSmartRulesTabletPage.contentKey,
        children: [
          _dcaSection(
            title: 'Quy tắc',
            rows: _dcaRows([('Trạng thái', 'Đang hoạt động')]),
          ),
        ],
      ),
    );
  }
}

/// SC-408: Sửa rebalance.
class DcaRebalanceEditTabletPage extends ConsumerWidget {
  const DcaRebalanceEditTabletPage({super.key, required this.configId});

  static const contentKey = Key('sc408_tablet_content');

  final String configId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-408',
      semanticLabel: 'Sửa rebalance DCA',
      title: 'Sửa rebalance',
      subtitle: configId,
      contentKey: DcaRebalanceEditTabletPage.contentKey,
      children: [
        _dcaSection(
          title: 'Sửa cấu hình',
          rows: _dcaRows([('Config ID', configId)]),
        ),
      ],
    );
  }
}

/// SC-409: Lịch sử rebalance.
class DcaRebalanceHistoryTabletPage extends ConsumerWidget {
  const DcaRebalanceHistoryTabletPage({super.key, required this.configId});

  static const contentKey = Key('sc409_tablet_content');

  final String configId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-409',
      semanticLabel: 'Lịch sử rebalance DCA',
      title: 'Lịch sử rebalance',
      subtitle: configId,
      contentKey: DcaRebalanceHistoryTabletPage.contentKey,
      children: [
        _dcaSection(
          title: 'Lịch sử',
          rows: _dcaRows([('Config ID', configId)]),
        ),
      ],
    );
  }
}
