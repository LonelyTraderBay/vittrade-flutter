import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

class P2PFundLockHistoryPage extends ConsumerWidget {
  const P2PFundLockHistoryPage({
    super.key,
    this.walletHistoryAlias = false,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc262_p2p_fund_lock_hero');
  static const listKey = Key('sc262_p2p_fund_lock_list');

  static Key recordKey(String id) => Key('sc262_p2p_fund_lock_record_$id');

  final bool walletHistoryAlias;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      p2pFundLockHistoryProvider(walletHistoryAlias),
    );
    final screenId = walletHistoryAlias ? 'SC-263' : 'SC-262';

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Lịch sử khóa quỹ P2P',
        semanticIdentifier: screenId,
        onBack: () => context.go(AppRoutePaths.p2pWallet),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Lịch sử khóa quỹ P2P',
        semanticIdentifier: screenId,
        onBack: () => context.go(AppRoutePaths.p2pWallet),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(p2pFundLockHistoryProvider(walletHistoryAlias)),
          ),
        ],
      ),
      data: (snapshot) => VitP2PFlowScaffold(
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        semanticLabel: 'Lịch sử khóa quỹ P2P',
        semanticIdentifier: screenId,
        shellRenderMode: shellRenderMode,
        onBack: () => context.go(snapshot.parentRoute),
        children: [
          _FundLockHero(snapshot: snapshot),
          _FundLockList(records: snapshot.records),
          const VitCard(
            variant: VitCardVariant.inner,
            padding: P2PSpacingTokens.p2pFinancialSafetyInnerPadding,
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại lịch sử khóa tiền',
              message:
                  'Bản ghi khóa và giải phóng, số lượng tài sản, tham chiếu đơn, lộ trình alias và bước ví/P2P tiếp theo đã được xem trước khi thao tác.',
              contractId: 'p2p-fund-lock-history-review',
            ),
          ),
        ],
      ),
    );
  }
}

class _FundLockHero extends StatelessWidget {
  const _FundLockHero({required this.snapshot});

  final P2PFundLockHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PFundLockHistoryPage.heroKey,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.p2p,
      background: const ColoredBox(color: AppModuleAccents.p2p),
      padding: P2PSpacingTokens.p2pFinancialSafetyCardPadding,
      clip: true,
      child: Row(
        children: [
          Material(
            color: AppColors.onAccent.withValues(alpha: .20),
            borderRadius: AppRadii.smRadius,
            child: const SizedBox(
              width: P2PSpacingTokens.p2pFinancialSafetyIconBox,
              height: P2PSpacingTokens.p2pFinancialSafetyIconBox,
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${snapshot.records.length} giao dịch gần đây',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent.withValues(alpha: .88),
                    fontWeight: AppTextStyles.medium,
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

class _FundLockList extends StatelessWidget {
  const _FundLockList({required this.records});

  final List<P2PFundLockRecordDraft> records;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PFundLockHistoryPage.listKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < records.length; index++) ...[
          _FundLockRecordCard(record: records[index]),
          if (index != records.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _FundLockRecordCard extends StatelessWidget {
  const _FundLockRecordCard({required this.record});

  final P2PFundLockRecordDraft record;

  @override
  Widget build(BuildContext context) {
    final isLock = record.type == 'lock';
    final color = isLock ? AppColors.warn : AppColors.buy;

    return VitCard(
      key: P2PFundLockHistoryPage.recordKey(record.id),
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pFinancialSafetyCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: color.withValues(alpha: .14),
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              width: P2PSpacingTokens.p2pFinancialSafetyIconBox,
              height: P2PSpacingTokens.p2pFinancialSafetyIconBox,
              child: Icon(
                isLock ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${_formatFundLockAmount(record.amount, record.asset)} ${record.asset}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitAccentPill(
                      label: isLock ? 'Khóa' : 'Mở',
                      accentColor: color,
                      semanticStatus: isLock
                          ? VitStatusPillStatus.warning
                          : VitStatusPillStatus.success,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  record.reason,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: P2PSpacingTokens.p2pFinancialSafetyTinyIcon,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      record.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

String _formatFundLockAmount(double value, String asset) {
  if (asset == 'VND') {
    return _withDotThousands(value.toStringAsFixed(0));
  }
  if (asset == 'BTC') {
    return value.toStringAsFixed(8);
  }
  return _withCommaThousands(value.toStringAsFixed(2));
}

String _withDotThousands(String value) {
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _withCommaThousands(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
