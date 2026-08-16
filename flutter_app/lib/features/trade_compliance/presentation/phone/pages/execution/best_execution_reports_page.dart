import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/execution/best_execution_overview.dart';
part '../../../widgets/execution/best_execution_current.dart';
part '../../../widgets/execution/best_execution_archive_common.dart';

const _bestBackground = AppColors.bg;
const _bestPanel2 = AppColors.surface2;
const _bestBorder = AppColors.borderSolid;
const _bestGreen = AppColors.buy;
const _bestAmber = AppColors.caution;
const _bestPrimary = AppColors.primary;

class BestExecutionReportsPage extends ConsumerStatefulWidget {
  const BestExecutionReportsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc096_best_execution_content');
  static Key tabKey(String id) => Key('sc096_best_execution_tab_$id');
  static Key venueKey(int rank) => Key('sc096_best_execution_venue_$rank');
  static const analysisKey = Key('sc096_best_execution_analysis');
  static const exportKey = Key('sc096_best_execution_export');
  static const publishKey = Key('sc096_best_execution_publish');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BestExecutionReportsPage> createState() =>
      _BestExecutionReportsPageState();
}

class _BestExecutionReportsPageState
    extends ConsumerState<BestExecutionReportsPage> {
  String _tab = 'current';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeBestExecutionReportsProvider);
    return Material(
      color: _bestBackground,
      child: VitTradeHubScaffold(
        title: 'Best Execution Reports',
        subtitle: 'RTS 27 / RTS 28 Compliance',
        semanticLabel: 'Báo cáo thực thi lệnh tốt nhất theo RTS 27/28',
        semanticIdentifier: 'SC-096',
        contentKey: BestExecutionReportsPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          mode: BackNavigationMode.historyThenFallback,
        ),
        headerActions: [
          VitHeaderActionItem(
            type: VitHeaderActionType.export,
            onPressed: () => showVitNoticeSheet(
              context: context,
              title: 'Đã xếp hàng',
              message: 'PDF export đã được xếp hàng.',
              variant: VitBannerVariant.success,
              ctaVariant: VitCtaButtonVariant.success,
            ),
          ),
        ],
        children: async.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeBestExecutionReportsProvider),
            ),
          ],
          data: (snapshot) => [
            const VitTradeSection(title: 'Notice', child: _ComplianceNotice()),
            VitTradeComplianceSection(
              title: 'Execution review',
              statusPill: VitStatusPill(
                label: 'Updated ${snapshot.lastUpdatedLabel}',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Venues',
                  value: '${snapshot.venues.length} tracked',
                ),
                VitTradeComplianceItem(
                  label: 'Archive',
                  value: '${snapshot.archive.length} reports',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Reports',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryGrid(summary: snapshot.summary),
                  VitTabBar(
                    variant: VitTabBarVariant.segment,
                    activeKey: _tab,
                    onChanged: _setTab,
                    tabs: [
                      VitTabItem(
                        key: 'current',
                        label: 'Q1 2026 (Current)',
                        widgetKey: BestExecutionReportsPage.tabKey('current'),
                      ),
                      VitTabItem(
                        key: 'archive',
                        label: 'Archive',
                        widgetKey: BestExecutionReportsPage.tabKey('archive'),
                      ),
                    ],
                  ),
                  if (_tab == 'current')
                    _CurrentReport(
                      venues: snapshot.venues,
                      onAnalysis: () => context.push(
                        AppRoutePaths.tradeCopyExecutionVenueAnalysis,
                      ),
                      onExport: () => showVitNoticeSheet(
                        context: context,
                        title: 'Đã xếp hàng',
                        message: 'PDF export đã được xếp hàng.',
                        variant: VitBannerVariant.success,
                        ctaVariant: VitCtaButtonVariant.success,
                      ),
                      onPublish: () => showVitNoticeSheet(
                        context: context,
                        title: 'Đã gửi',
                        message: 'Báo cáo đã được gửi.',
                        variant: VitBannerVariant.success,
                        ctaVariant: VitCtaButtonVariant.success,
                      ),
                    )
                  else
                    _ArchiveReport(
                      reports: snapshot.archive,
                      onExport: (id) => showVitNoticeSheet(
                        context: context,
                        title: 'Đã xếp hàng',
                        message: '$id: PDF đã được xếp hàng.',
                        variant: VitBannerVariant.success,
                        ctaVariant: VitCtaButtonVariant.success,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTab(String tab) => setState(() => _tab = tab);
}
