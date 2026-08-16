import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pContributionVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pContributionNativeNavClearance =
    _p2pContributionVisualNavClearance - AppSpacing.x4;
const double _p2pContributionVisualClearance = AppSpacing.x3;
const double _p2pContributionNativeClearance = AppSpacing.x2;

class P2PContributionHistoryPage extends ConsumerStatefulWidget {
  const P2PContributionHistoryPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc242_p2p_contribution_summary');
  static const exportKey = Key('sc242_p2p_contribution_export');
  static const groupsKey = Key('sc242_p2p_contribution_groups');
  static const feedbackKey = Key('sc242_p2p_contribution_feedback');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PContributionHistoryPage> createState() =>
      _P2PContributionHistoryPageState();
}

class _P2PContributionHistoryPageState
    extends ConsumerState<P2PContributionHistoryPage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pContributionHistoryProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pContributionVisualNavClearance +
                  _p2pContributionVisualClearance
            : _p2pContributionNativeNavClearance +
                  _p2pContributionNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử đóng góp bảo hiểm P2P',
      semanticIdentifier: 'SC-242',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pContributionHistoryProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Lịch sử đóng góp',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pContributionScrollPadding(
                        scrollEndPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ContributionSummaryCard(snapshot: snapshot),
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          VitCtaButton(
                            key: P2PContributionHistoryPage.exportKey,
                            variant: VitCtaButtonVariant.secondary,
                            leading: const Icon(Icons.download_rounded),
                            onPressed: () {
                              unawaited(HapticFeedback.selectionClick());
                              setState(
                                () => _feedback =
                                    'Đã chuẩn bị báo cáo CSV lịch sử đóng góp',
                              );
                            },
                            child: const Text('Xuất CSV'),
                          ),
                          if (_feedback != null) ...[
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _FeedbackBanner(message: _feedback!),
                          ],
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          _MonthlyContributionGroups(
                            groups: snapshot.monthlyGroups,
                          ),
                          const VitPageContent(
                            rhythm: VitPageRhythm.standard,
                            padding: VitContentPadding.none,
                            fullBleed: true,
                            children: [
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Xem lại lịch sử đóng góp',
                                message:
                                    'Xuất báo cáo, nhóm theo tháng, tỷ lệ phí bảo hiểm, tổng đóng góp và phản hồi thành công được xem lại trước thao tác báo cáo P2P.',
                                contractId: 'SC-242',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContributionSummaryCard extends StatelessWidget {
  const _ContributionSummaryCard({required this.snapshot});

  final P2PContributionHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PContributionHistoryPage.summaryKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pTrustProgressHeroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Tổng quan đóng góp',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Tổng đóng góp',
                  value: '${_formatVnd(snapshot.totalContributed)} đ',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SummaryMetric(
                  label: 'Số giao dịch',
                  value: '${snapshot.totalTrades}',
                  valueColor: AppModuleAccents.p2p,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: P2PSpacingTokens.p2pMerchantCommerceDividerHeight,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SummaryLine(
            label: 'Trung bình/giao dịch',
            value: '${_formatVnd(snapshot.averagePerTrade)} đ',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SummaryLine(
            label: 'Tỷ lệ phí',
            value: snapshot.contributionRateLabel,
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PContributionHistoryPage.feedbackKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.buy20,
      padding: P2PSpacingTokens.p2pTrustProgressCardPadding,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: P2PSpacingTokens.p2pTrustProgressSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyContributionGroups extends StatelessWidget {
  const _MonthlyContributionGroups({required this.groups});

  final List<P2PContributionMonthDraft> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PContributionHistoryPage.groupsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < groups.length; i++) ...[
          _MonthGroup(group: groups[i]),
          if (i != groups.length - 1) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _MonthGroup extends StatelessWidget {
  const _MonthGroup({required this.group});

  final P2PContributionMonthDraft group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.text2,
              size: P2PSpacingTokens.p2pTrustProgressSmallIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                group.monthLabel,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${group.count} giao dịch',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '${_formatVnd(group.totalAmount)} đ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final contribution in group.contributions) ...[
          _ContributionCard(contribution: contribution),
          if (contribution != group.contributions.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _ContributionCard extends StatelessWidget {
  const _ContributionCard({required this.contribution});

  final P2PContributionDraft contribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pTrustProgressCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        contribution.orderId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _CoinPill(label: contribution.coin),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  contribution.displayDate,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'GD: ${_formatVnd(contribution.orderAmount)} đ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          SizedBox(
            width: P2PSpacingTokens.p2pTrustProgressContributionAmountWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '+${_formatVnd(contribution.contributionAmount)} đ',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${contribution.feeRate.toStringAsFixed(1)}% phí',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: AppColors.text3);
  }
}

String _formatVnd(int value) => formatP2PVnd(value);
