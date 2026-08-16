import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

const double _p2pPaymentHistoryVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pPaymentHistoryNativeNavClearance =
    _p2pPaymentHistoryVisualNavClearance - AppSpacing.x4;
const double _p2pPaymentHistoryVisualClearance = AppSpacing.x3;
const double _p2pPaymentHistoryNativeClearance = AppSpacing.x2;

class P2PPaymentMethodHistoryPage extends ConsumerWidget {
  const P2PPaymentMethodHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc236_payment_history_content');
  static Key txKey(String id) => Key('sc236_payment_history_tx_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pPaymentMethodHistoryProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pPaymentHistoryVisualNavClearance +
                  _p2pPaymentHistoryVisualClearance
            : _p2pPaymentHistoryNativeNavClearance +
                  _p2pPaymentHistoryNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'Lịch sử thanh toán P2P',
      semanticIdentifier: 'SC-236',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sử thanh toán',
            subtitle: 'Thanh toán · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pPaymentMethodHistoryProvider),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PPaymentMethodHistoryPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pPaymentHistoryScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _StatsCard(snapshot: snapshot),
                          if (snapshot.transactions.isEmpty)
                            VitEmptyState(title: snapshot.emptyTitle)
                          else
                            VitPageSection(
                              gap: VitContentGap.tight,
                              children: [
                                for (final transaction in snapshot.transactions)
                                  _TransactionCard(transaction: transaction),
                              ],
                            ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại lịch sử phương thức thanh toán',
                            message:
                                'Lịch sử thanh toán P2P giữ hướng lệnh, trạng thái đã hủy, tổng khối lượng, tỷ lệ thành công và ngữ cảnh xem lại tiếp theo hiển thị trước khi người dùng tái sử dụng hoặc đổi phương thức.',
                            contractId: 'SC-236',
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final P2PPaymentMethodHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pPaymentCompactCardPadding,
      child: Row(
        children: [
          Expanded(
            child: _StatBlock(
              value: '${snapshot.totalTransactions}',
              label: 'Giao dịch',
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: _StatBlock(
              value: _formatMillionVnd(snapshot.totalVolume),
              label: 'Tổng khối lượng',
              color: AppColors.buy,
            ),
          ),
          Expanded(
            child: _StatBlock(
              value: '${snapshot.successRate.toStringAsFixed(1)}%',
              label: 'Thành công',
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final P2PPaymentHistoryTransactionDraft transaction;

  bool get _isBuy => transaction.type == P2PTradeType.buy;
  bool get _isCompleted => transaction.status == 'completed';

  Color get _tone {
    if (!_isCompleted) return AppColors.text3;
    return _isBuy ? AppColors.buy : AppColors.sell;
  }

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodHistoryPage.txKey(transaction.id),
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentCompactCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TrendIcon(isBuy: _isBuy, tone: _tone),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      transaction.orderId,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitStatusPill(
                      label: _isBuy ? 'MUA' : 'BÁN',
                      status: _isCompleted
                          ? (_isBuy
                                ? VitStatusPillStatus.success
                                : VitStatusPillStatus.error)
                          : VitStatusPillStatus.neutral,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _formatVnd(transaction.amount),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: AppColors.text3,
                      size: P2PSpacingTokens.p2pPaymentMetaIcon,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Flexible(
                      child: Text(
                        transaction.timestamp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                    if (!_isCompleted) ...[
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        '·',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        'Đã hủy',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _TrendIcon extends StatelessWidget {
  const _TrendIcon({required this.isBuy, required this.tone});

  final bool isBuy;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tone == AppColors.buy
          ? AppColors.buy15
          : tone == AppColors.sell
          ? AppColors.sell15
          : AppColors.surface2,
      shape: const CircleBorder(),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(
          isBuy ? Icons.trending_up_rounded : Icons.trending_down_rounded,
          color: tone,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

String _formatVnd(int value) => formatP2PVnd(value);

String _formatMillionVnd(int value) {
  final millions = value ~/ 1000000;
  return '${_formatGroupedNumber(millions)}M';
}

String _formatGroupedNumber(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
