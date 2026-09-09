import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'compliance_tablet_pages_extra.dart';

Widget _cmp2Error(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _cmp2Section({required String title, required List<Widget> rows}) {
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

List<Widget> _cmp2Rows(List<(String, String)> pairs) {
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

List<Widget> _cmp2Bullets(List<String> notes, IconData icon, Color color) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Icon(icon, size: TabletSpacingTokens.iconSm, color: color),
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

/// SC-102: Bảo vệ tiền khách hàng.
class ClientMoneyProtectionTabletPage extends ConsumerWidget {
  const ClientMoneyProtectionTabletPage({super.key});

  static const contentKey = Key('sc102_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeClientMoneyProtectionProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-102',
        semanticLabel: 'Bảo vệ tiền khách hàng',
        title: 'Bảo vệ tiền khách hàng',
        subtitle: 'Tài khoản ủy thác',
        contentKey: ClientMoneyProtectionTabletPage.contentKey,
        children: [
          _cmp2Error(
            'Không tải được bảo vệ tiền khách hàng',
            () => ref.invalidate(tradeClientMoneyProtectionProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-102',
        semanticLabel: 'Bảo vệ tiền khách hàng',
        title: 'Bảo vệ tiền khách hàng',
        subtitle: 'Tài khoản ủy thác',
        contentKey: ClientMoneyProtectionTabletPage.contentKey,
        children: [
          _cmp2Section(
            title: 'Số dư quỹ khách hàng',
            rows: _cmp2Rows([
              ('Số dư', formatTradeUsdWhole(snapshot.balance)),
              ('Tài khoản ủy thác', snapshot.trustAccount),
              ('Đối chiếu cuối', snapshot.lastReconciled),
            ]),
          ),

          _cmp2Section(
            title: 'Các cơ chế bảo vệ',
            rows: [
              for (final protection in snapshot.protections)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          Icons.shield_outlined,
                          size: TabletSpacingTokens.iconSm,
                          color: AppColors.buy,
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x2),
                      Expanded(
                        child: Text(
                          protection.title,
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

          _cmp2Section(
            title: 'Nếu công ty phá sản',
            rows: [
              Text(
                snapshot.insolvencySummary,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                snapshot.insolvencyDetail,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String formatCmp2Usd(double value) => formatTradeUsdWhole(value);

/// SC-103: Đối chiếu CASS.
class CassReconciliationTabletPage extends ConsumerWidget {
  const CassReconciliationTabletPage({super.key});

  static const contentKey = Key('sc103_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCassReconciliationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-103',
        semanticLabel: 'Đối chiếu CASS',
        title: 'Đối chiếu CASS',
        subtitle: 'Báo cáo · Ghi nhận',
        contentKey: CassReconciliationTabletPage.contentKey,
        children: [
          _cmp2Error(
            'Không tải được đối chiếu CASS',
            () => ref.invalidate(tradeCassReconciliationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-103',
        semanticLabel: 'Đối chiếu CASS',
        title: 'Đối chiếu CASS',
        subtitle: 'Chuẩn CASS',
        contentKey: CassReconciliationTabletPage.contentKey,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đã đối chiếu',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        '${snapshot.reconciledCount}',
                        style: AppTextStyles.control.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.buy,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đã xử lý',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        '${snapshot.resolvedCount}',
                        style: AppTextStyles.control.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngoại lệ',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        '${snapshot.outstandingCount}',
                        style: AppTextStyles.control.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.caution,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          for (final record in snapshot.records.take(10))
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      record.displayDate,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      record.notes ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    switch (record.status) {
                      TradeCassReconciliationStatus.matched => 'Khớp',
                      TradeCassReconciliationStatus.discrepancyResolved =>
                        'Đã xử lý lệch',
                      TradeCassReconciliationStatus.discrepancy => 'Lệch',
                    },
                    style: AppTextStyles.caption.copyWith(
                      color:
                          record.status == TradeCassReconciliationStatus.matched
                          ? AppColors.buy
                          : AppColors.caution,
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
