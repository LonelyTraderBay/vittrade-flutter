import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

part 'staking_tablet_pages_policies.dart';
part 'staking_tablet_pages_operators.dart';
part 'staking_tablet_pages_operators2.dart';
part 'staking_tablet_pages_reports.dart';
part 'staking_tablet_pages_reports2.dart';
part 'staking_tablet_pages_community.dart';
part 'staking_tablet_pages_community2.dart';
part 'staking_tablet_pages_core2.dart';

String _stkUsd(num v) => VitFormat.usd(v.toDouble());
String _stkUsdS(num v) => VitFormat.usdSigned(v.toDouble());
String _stkPct(num v, [int d = 2]) => VitFormat.percent(v, fractionDigits: d);
String _stkDec(num v, [int d = 2]) => v.toStringAsFixed(d);

Widget _stkError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _stkSection({required String title, required List<Widget> rows}) {
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

List<Widget> _stkRows(List<(String, String)> pairs) {
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

List<Widget> _stkBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _stkBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

Widget _stkQuickLinks(BuildContext context, List<(String, String)> links) {
  return Wrap(
    spacing: TabletSpacingTokens.x2,
    runSpacing: TabletSpacingTokens.x2,
    children: [
      for (final (label, path) in links)
        VitFilterChip(
          label: label,
          active: false,
          color: AppColors.primary,
          onTap: () => context.push(path),
        ),
    ],
  );
}

List<Widget> _stkTitleBody(List<(String, String)> pairs) {
  return [
    for (final (title, body) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
            Text(
              body,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-257: Hub Staking.
class StakingEarnTabletPage extends ConsumerWidget {
  const StakingEarnTabletPage({super.key});

  static const contentKey = Key('sc257_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      stakingEarnSnapshotProvider(StakingEarnRoute.earn),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-257',
        semanticLabel: 'Bảng staking',
        title: snapshotAsync.value?.title ?? 'Staking',
        subtitle: 'Staking · Phần thưởng',
        contentKey: StakingEarnTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được staking',
            () => ref.invalidate(
              stakingEarnSnapshotProvider(StakingEarnRoute.earn),
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-257',
        semanticLabel: 'Bảng staking',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: StakingEarnTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Tổng quan',
            rows: _stkRows([
              ('Tổng đã kiếm', snapshot.totalEarnedUsd),
              ('Vị thế đang chạy', '${snapshot.activePositions}'),
              ('APY cao nhất', snapshot.maxApyLabel),
              ('Bảo vệ quỹ', snapshot.fundProtectionLabel),
            ]),
          ),

          _stkSection(
            title: 'Sản phẩm',
            rows: [
              for (final product in snapshot.products)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.name} (${product.asset})',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              '${product.lockLabel} · đã stake ${product.totalStaked}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        product.apy,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.buy,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _stkSection(
            title: 'Vị thế của bạn',
            rows: [
              for (final position in snapshot.positions)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${position.product} · ${position.asset} ${position.amount}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        'Đã kiếm ${position.earned}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _stkSection(
            title: 'Khám phá',
            rows: [
              _stkQuickLinks(context, [
                ('Bảng điều khiển', AppRoutePaths.earnDashboard),
                ('Phân tích', AppRoutePaths.earnAnalytics),
                ('Lịch sử', AppRoutePaths.earnHistory),
                ('Lịch trả thưởng', AppRoutePaths.earnCalendar),
                ('Chọn validator', AppRoutePaths.earnValidatorSelection),
                (
                  'Sức khoẻ validator',
                  AppRoutePaths.earnValidatorHealthMonitor,
                ),
                ('Tự động cộng dồn', AppRoutePaths.earnAutoCompound),
                ('Liquid staking', AppRoutePaths.earnLiquidStaking),
                ('Lệnh nâng cao', AppRoutePaths.earnAdvancedOrders),
                ('Đa chuỗi', AppRoutePaths.earnMultiChain),
                ('Bảo hiểm', AppRoutePaths.earnInsurance),
                ('Bảng rủi ro', AppRoutePaths.earnRiskDashboard),
                ('Lịch sử slashing', AppRoutePaths.earnSlashingHistory),
                ('Quản trị cộng đồng', AppRoutePaths.earnCommunityGovernance),
                ('Đề xuất', AppRoutePaths.earnProposals),
                ('Gửi tiết kiệm', AppRoutePaths.earnSavings),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
