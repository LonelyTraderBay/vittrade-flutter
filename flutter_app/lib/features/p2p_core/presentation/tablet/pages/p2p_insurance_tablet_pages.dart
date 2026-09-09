import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_insurance_tablet_pages_extra.dart';

Widget _insError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _insSection({required String title, required List<Widget> rows}) {
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

List<Widget> _insRows(List<(String, String)> pairs) {
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

/// SC-238: Quỹ bảo hiểm P2P — dashboard số dư quỹ + claims + coverage tiers.
class P2PInsuranceFundTabletPage extends ConsumerWidget {
  const P2PInsuranceFundTabletPage({super.key});

  static const contentKey = Key('sc238_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pInsuranceFundProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quỹ bảo hiểm P2P',
      semanticIdentifier: 'SC-238',
      child: Column(
        children: [
          VitHeader(
            title: 'Quỹ bảo hiểm',
            subtitle: 'Số dư · Claims · Độ bao phủ',
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
                child: _insError(
                  'Không tải được quỹ bảo hiểm',
                  () => ref.invalidate(p2pInsuranceFundProvider),
                ),
              ),
              data: (snapshot) => VitTwoColumnTabletDashboard(
                onRefresh: () async {
                  ref.invalidate(p2pInsuranceFundProvider);
                  await ref.read(p2pInsuranceFundProvider.future);
                },
                banner: VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Row(
                    children: [
                      Expanded(
                        child: _InsStat(
                          label: 'Tổng quỹ',
                          value: formatP2PVnd(snapshot.totalFund),
                        ),
                      ),
                      Expanded(
                        child: _InsStat(
                          label: 'Đang xử lý',
                          value: '${snapshot.activeClaims} claims',
                        ),
                      ),
                      Expanded(
                        child: _InsStat(
                          label: 'Độ lành mạnh',
                          value: snapshot.healthStatus,
                          color: AppColors.buy,
                        ),
                      ),
                      Expanded(
                        child: _InsStat(
                          label: 'Bao phủ của bạn',
                          value: '${snapshot.userCoveragePct}%',
                        ),
                      ),
                    ],
                  ),
                ),
                primaryChildren: [
                  _insSection(
                    title: 'Claims gần đây',
                    rows: [
                      if (snapshot.claims.isEmpty)
                        Text(
                          snapshot.emptyTitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        )
                      else
                        for (final claim in snapshot.claims.take(6))
                          Padding(
                            padding: TabletSpacingTokens.tableCellPaddingV,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    claim.claimCode,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text1,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    claim.reason,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    formatP2PVnd(claim.amount),
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text1,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ),
                                VitStatusPill(
                                  label: switch (claim.status) {
                                    P2PInsuranceClaimStatus.pending =>
                                      'Chờ duyệt',
                                    P2PInsuranceClaimStatus.reviewing =>
                                      'Đang duyệt',
                                    P2PInsuranceClaimStatus.approved =>
                                      'Đã duyệt',
                                    P2PInsuranceClaimStatus.rejected =>
                                      'Từ chối',
                                    P2PInsuranceClaimStatus.paid =>
                                      'Đã chi trả',
                                  },
                                  status:
                                      claim.status ==
                                          P2PInsuranceClaimStatus.paid
                                      ? VitStatusPillStatus.success
                                      : claim.status ==
                                            P2PInsuranceClaimStatus.rejected
                                      ? VitStatusPillStatus.error
                                      : VitStatusPillStatus.warning,
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                  _insSection(
                    title: 'Coverage theo hạng',
                    rows: [
                      for (final coverage in snapshot.coverageTiers)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  coverage.name,
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: coverage.highlight
                                        ? AppTextStyles.bold
                                        : AppTextStyles.normal,
                                    color: coverage.highlight
                                        ? AppColors.primary
                                        : AppColors.text2,
                                  ),
                                ),
                              ),
                              Text(
                                '${coverage.coveragePct} bao phủ',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
                secondaryChildren: [
                  _insSection(
                    title: 'Kiểm toán',
                    rows: _insRows([
                      ('Đơn vị kiểm toán', snapshot.auditorName),
                      ('Kiểm toán gần nhất', snapshot.lastAuditDate),
                      ('Kiểm toán kế tiếp', snapshot.nextAuditDate),
                      (
                        'Tỷ lệ thanh toán',
                        '${snapshot.approvalRate.toStringAsFixed(1)}%',
                      ),
                      ('Giải quyết TB', '${snapshot.avgResolutionHours} giờ'),
                    ]),
                  ),
                  _insSection(
                    title: 'Liên kết',
                    rows: [
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingV,
                        child: InkWell(
                          onTap: () => context.push(snapshot.certificateRoute),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Chứng chỉ bảo hiểm',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: TabletSpacingTokens.iconMd,
                                color: AppColors.text3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsStat extends StatelessWidget {
  const _InsStat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.control.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

/// SC-239: Chứng chỉ bảo hiểm.
class P2PInsuranceCertificateTabletPage extends ConsumerWidget {
  const P2PInsuranceCertificateTabletPage({super.key});

  static const contentKey = Key('sc239_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pInsuranceCertificateProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chứng chỉ bảo hiểm P2P',
      semanticIdentifier: 'SC-239',
      child: Column(
        children: [
          VitHeader(
            title: 'Chứng chỉ bảo hiểm',
            subtitle: 'Phạm vi · Điều khoản',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pInsurance,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: _insError(
                  'Không tải được chứng chỉ',
                  () => ref.invalidate(p2pInsuranceCertificateProvider),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                contentKey: P2PInsuranceCertificateTabletPage.contentKey,
                children: [
                  _insSection(
                    title: 'Chứng chỉ ${snapshot.certId}',
                    rows: _insRows([
                      ('Người giữ', snapshot.holderName),
                      ('Mã danh tính', snapshot.holderId),
                      ('Hạng', snapshot.tierName),
                      ('Bao phủ', '${snapshot.coveragePct}%'),
                      (
                        'Tối đa/claim',
                        formatP2PVnd(snapshot.maxCoveragePerClaim),
                      ),
                      (
                        'Tối đa/30 ngày',
                        formatP2PVnd(snapshot.maxCoveragePer30Days),
                      ),
                      ('Tỷ lệ đóng góp', snapshot.contributionRate),
                      ('Cấp ngày', snapshot.issueDate),
                      ('Có hiệu lực đến', snapshot.validUntil),
                    ]),
                  ),

                  _insSection(
                    title: 'Trường hợp được bao phủ',
                    rows: _bulletIns(snapshot.coveredCases),
                  ),

                  _insSection(
                    title: 'Loại trừ',
                    rows: _bulletIns(snapshot.exclusions),
                  ),

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
          ),
        ],
      ),
    );
  }
}

List<Widget> _bulletIns(List<String> notes) {
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
