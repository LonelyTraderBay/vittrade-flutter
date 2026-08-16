import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/phone/copy_trading_list.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_detail_hero.dart';

part '../../../widgets/phone/copy_trading_hero.dart';
part '../../../widgets/phone/copy_trading_metrics_common.dart';

CopyTradingListKeys get _copyListKeys => const CopyTradingListKeys(
  traderKey: CopyTradingPage.traderKey,
  detailKey: CopyTradingPage.detailKey,
  sortKey: CopyTradingPage.sortKey,
);

const _copyPrimary = AppColors.primary;
const _copyTextLineHeight = 1.24;

class CopyTradingPage extends ConsumerStatefulWidget {
  const CopyTradingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc063_copy_trading_scroll_content');
  static Key sortKey(String option) => Key('sc063_sort_$option');
  static Key traderKey(String id) => Key('sc063_trader_$id');
  static Key detailKey(String id) => Key('sc063_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyTradingPage> createState() => _CopyTradingPageState();
}

class _CopyTradingPageState extends ConsumerState<CopyTradingPage> {
  String _sortBy = 'Top ROI';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopyTradingProvider);

    return VitTradeHubScaffold(
      title: 'Sao chép giao dịch',
      subtitle: 'Sao chép chiến lược có kiểm soát',
      semanticLabel: 'Sao chép giao dịch – sao chép chiến lược có kiểm soát',
      semanticIdentifier: 'SC-063',
      contentKey: CopyTradingPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      activeProductId: 'copy',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được danh sách copy trading',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeCopyTradingProvider),
            ),
          ],
          data: (snapshot) {
            final traders = sortCopyTraders(snapshot.traders, _sortBy);
            return [
              VitTradeDetailHero(
                primaryLabel: 'Tổng AUM',
                primaryValue: _formatCompact(snapshot.totalAum, prefix: r'$'),
                secondaryLabel: 'Người đang copy',
                secondaryValue: _formatCompactNumber(snapshot.totalCopiers),
                secondaryColor: _copyPrimary,
                footnote: 'Cập nhật ${snapshot.lastUpdatedLabel}',
              ),
              CopyTradingRiskWarningCard(
                title: snapshot.riskWarningTitle,
                message: snapshot.riskWarningText,
              ),
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Đánh giá trước khi copy',
                message:
                    'So sánh drawdown tối đa, mức tập trung copier, phí và quy tắc dừng lỗ trước khi sao chép bất kỳ chiến lược nào.',
                contractId: snapshot.highRiskContractId,
                density: VitDensity.tool,
              ),
              VitCtaButton(
                onPressed: () => context.push(AppRoutePaths.tradeCopyEducation),
                density: VitDensity.tool,
                height: AppSpacing.inputHeight,
                leading: const Icon(Icons.menu_book_outlined),
                child: const Text('Tìm hiểu rủi ro copy trading'),
              ),
              CopyTradingSortChips(
                options: snapshot.sortOptions,
                selected: _sortBy,
                onChanged: (value) => setState(() => _sortBy = value),
                keys: _copyListKeys,
              ),
              if (traders.isEmpty)
                VitEmptyState(
                  title: 'Không có nhà cung cấp',
                  message:
                      'Không tìm thấy provider phù hợp với bộ lọc hiện tại.',
                  icon: Icons.groups_outlined,
                  actionLabel: 'Đặt lại sắp xếp',
                  onAction: () =>
                      setState(() => _sortBy = snapshot.sortOptions.first),
                )
              else
                CopyTradingTraderList(
                  traders: traders,
                  onOpen: (trader) =>
                      context.push(AppRoutePaths.tradeCopyProvider(trader.id)),
                  keys: _copyListKeys,
                ),
              _Disclaimer(text: snapshot.disclaimer),
            ];
          },
        ),
      ],
    );
  }
}
