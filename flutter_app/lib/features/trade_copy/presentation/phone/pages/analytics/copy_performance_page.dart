import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/trade_copy_header_body_card.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/analytics/copy_performance_summary_tabs.dart';
part '../../../widgets/analytics/copy_performance_details.dart';
part '../../../widgets/analytics/copy_performance_common.dart';

const _performancePrimary = AppColors.primary;
const _performancePurple = AppColors.accent;
const _performanceGreen = AppColors.buy;
const _performanceRed = AppColors.sell;
const _performanceSpace = AppSpacing.x2;
const _performanceCardSpace = AppSpacing.x3;
const _performanceInfoLineHeight = 1.18;

class CopyPerformancePage extends ConsumerStatefulWidget {
  const CopyPerformancePage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc074_copy_performance_content');

  static Key tabKey(String id) => Key('sc074_copy_performance_tab_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyPerformancePage> createState() =>
      _CopyPerformancePageState();
}

class _CopyPerformancePageState extends ConsumerState<CopyPerformancePage> {
  String _activeTab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradeCopyPerformanceProvider(widget.copyId),
    );

    return VitTradeDetailScaffold(
      title: 'Phân tích hiệu suất',
      semanticLabel: 'Phân tích hiệu suất',
      semanticIdentifier: 'SC-074',
      contentKey: CopyPerformancePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
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
              title: 'Không tải được hiệu suất copy',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(tradeCopyPerformanceProvider(widget.copyId)),
            ),
          ],
          data: (snapshot) => [
            VitTradeSection(
              title: 'Đánh giá rủi ro',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại hiệu suất copy',
                message:
                    'PnL, phí, drawdown, lịch sử lệnh và chỉ số rủi ro được xem lại trước khi thay đổi phân bổ copy.',
                contractId: 'copy-performance-${widget.copyId}',
                density: VitDensity.tool,
              ),
            ),
            VitTradeSection(
              title: 'Tổng quan',
              child: _PerformanceSummary(snapshot: snapshot),
            ),
            VitTradeSection(
              title: 'Phân tích',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PerformanceTabs(
                    activeTab: _activeTab,
                    onChanged: (value) => setState(() => _activeTab = value),
                  ),
                  if (_activeTab == 'overview')
                    _OverviewTab(snapshot: snapshot)
                  else if (_activeTab == 'trades')
                    _TradesTab(snapshot: snapshot)
                  else if (_activeTab == 'costs')
                    _CostsTab(snapshot: snapshot)
                  else
                    _MetricsTab(snapshot: snapshot),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x2,
              ),
              child: Text(
                'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Chênh lệch so với provider là bình thường.',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: _performanceInfoLineHeight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
