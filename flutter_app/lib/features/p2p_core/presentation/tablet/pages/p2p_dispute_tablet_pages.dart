import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_dispute_tablet_pages_sections.dart';

Widget _disputeError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

VitStatusPillStatus _disputePillStatus(String statusLabel) {
  if (statusLabel.contains('Giải quyết') || statusLabel.contains('resolved')) {
    return VitStatusPillStatus.success;
  }
  if (statusLabel.contains('Từ chối') || statusLabel.contains('rejected')) {
    return VitStatusPillStatus.error;
  }
  return VitStatusPillStatus.warning;
}

/// SC-222: Danh sách tranh chấp.
class P2PDisputesTabletPage extends ConsumerWidget {
  const P2PDisputesTabletPage({super.key});

  static const contentKey = Key('sc222_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pDisputesProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-222',
        semanticLabel: 'Tranh chấp P2P',
        title: 'Tranh chấp',
        subtitle: 'Danh sách · Hướng dẫn',
        contentKey: P2PDisputesTabletPage.contentKey,
        children: [
          _disputeError(
            'Không tải được tranh chấp',
            () => ref.invalidate(p2pDisputesProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-222',
        semanticLabel: 'Tranh chấp P2P',
        title: 'Tranh chấp',
        subtitle: 'Danh sách · Hướng dẫn',
        contentKey: P2PDisputesTabletPage.contentKey,
        children: [
          if (snapshot.disputes.isEmpty)
            VitEmptyState(
              icon: Icons.gavel_outlined,
              title: snapshot.emptyTitle,
              message: snapshot.emptySubtitle,
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.disputes.length; i++) ...[
                    InkWell(
                      onTap: () => context.push(
                        AppRoutePaths.p2pDisputeDetail(snapshot.disputes[i].id),
                      ),
                      child: Padding(
                        padding: TabletSpacingTokens.tableCellPaddingTall,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.disputes[i].orderNumber} · ${snapshot.disputes[i].reason}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: AppTextStyles.bold,
                                      color: AppColors.text1,
                                    ),
                                  ),
                                  Text(
                                    snapshot.disputes[i].createdAt,
                                    style: AppTextStyles.micro.copyWith(
                                      color: AppColors.text3,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: VitStatusPill(
                                label: snapshot.disputes[i].statusLabel,
                                status: _disputePillStatus(
                                  snapshot.disputes[i].statusLabel,
                                ),
                                size: VitStatusPillSize.sm,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${snapshot.disputes[i].evidenceCount} minh chứng · '
                                '${snapshot.disputes[i].timelineCount} bước',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                  fontFeatures: AppTextStyles.tabularFigures,
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
                    if (i < snapshot.disputes.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),

          _sectionCard(
            title: snapshot.noticeTitle,
            rows: [
              Text(
                snapshot.notice,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ],
          ),

          _sectionCard(
            title: snapshot.guideTitle,
            rows: [
              for (var i = 0; i < snapshot.guideSteps.length; i++)
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
                          snapshot.guideSteps[i],
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

Widget _sectionCard({required String title, required List<Widget> rows}) {
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

/// SC-218 (và các biến thể detail/evidence/resolution cùng disputeId):
/// Chi tiết tranh chấp — quy trình 3 cấp + minh chứng + timeline + support.
class P2PDisputeDetailTabletPage extends ConsumerWidget {
  const P2PDisputeDetailTabletPage({super.key, required this.disputeId});

  static const contentKey = Key('sc218_tablet_content');

  final String disputeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pDisputeDetailProvider(disputeId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-218',
        semanticLabel: 'Chi tiết tranh chấp P2P',
        title: 'Chi tiết tranh chấp',
        subtitle: disputeId,
        contentKey: P2PDisputeDetailTabletPage.contentKey,
        children: [
          _disputeError(
            'Không tải được chi tiết tranh chấp',
            () => ref.invalidate(p2pDisputeDetailProvider(disputeId)),
          ),
        ],
      ),
      data: (snapshot) {
        final dispute = snapshot.dispute;
        return VitTabletSectionFrame(
          semanticIdentifier: 'SC-218',
          semanticLabel: 'Chi tiết tranh chấp P2P',
          title: 'Tranh chấp ${dispute.orderNumber}',
          subtitle: '${dispute.statusLabel} · ${dispute.reason}',
          contentKey: P2PDisputeDetailTabletPage.contentKey,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dispute.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x3),
                  for (final level in snapshot.levels)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        children: [
                          SizedBox(
                            width: TabletSpacingTokens.x7,
                            child: Text(
                              'Cấp ${level.level}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: level.level <= dispute.currentLevel
                                    ? AppColors.primary
                                    : AppColors.text3,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${level.label} · ${level.avgTime}',
                              style: AppTextStyles.caption.copyWith(
                                color: level.level <= dispute.currentLevel
                                    ? AppColors.text1
                                    : AppColors.text3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            _sectionCard(
              title: 'Minh chứng đã gửi',
              rows: [
                if (snapshot.evidence.isEmpty)
                  Text(
                    'Chưa có minh chứng nào.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  )
                else
                  for (final evidence in snapshot.evidence)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.attach_file_rounded,
                              size: TabletSpacingTokens.iconSm,
                              color: AppColors.text3,
                            ),
                          ),
                          const SizedBox(width: TabletSpacingTokens.x2),
                          Expanded(
                            child: Text(
                              evidence.fileName,
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

            _sectionCard(
              title: 'Dòng thời gian xử lý',
              rows: [
                for (final event in snapshot.timeline)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: Text(
                            event.time,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            event.event,
                            style: AppTextStyles.caption.copyWith(
                              color: event.active
                                  ? AppColors.text1
                                  : AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Tranh chấp đang xử lý',
              message:
                  'Không gửi tiền hay thông tin tài khoản ngoài hệ thống trong quá trình tranh chấp. Đội ngũ hỗ trợ sẽ liên hệ qua kênh chính thức.',
              contractId: 'p2p-dispute-detail-tablet',
            ),
          ],
        );
      },
    );
  }
}
