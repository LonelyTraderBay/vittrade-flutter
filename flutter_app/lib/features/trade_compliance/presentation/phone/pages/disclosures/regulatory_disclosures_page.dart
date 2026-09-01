import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/disclosures/regulatory_disclosures_hero_tabs.dart';
part '../../../widgets/disclosures/regulatory_disclosures_tabs.dart';
part '../../../widgets/disclosures/regulatory_disclosures_common.dart';
part '../../../widgets/disclosures/regulatory_disclosures_cards.dart';
part '../../../widgets/disclosures/regulatory_disclosures_actions.dart';

const _legalPrimary = AppColors.primary;
const _legalGreen = AppColors.buy;
const _legalAmber = AppColors.caution;

class RegulatoryDisclosuresPage extends ConsumerStatefulWidget {
  const RegulatoryDisclosuresPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc084_regulatory_disclosures_content');
  static Key tabKey(String id) => Key('sc084_tab_$id');
  static Key contactKey(String title) => Key('sc084_contact_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryDisclosuresPage> createState() =>
      _RegulatoryDisclosuresPageState();
}

class _RegulatoryDisclosuresPageState
    extends ConsumerState<RegulatoryDisclosuresPage> {
  String? _activeTabId;
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeRegulatoryDisclosuresProvider);

    return VitTradeHubScaffold(
      title: 'Regulatory Disclosures',
      semanticLabel: 'Công bố thông tin quy định pháp lý',
      semanticIdentifier: 'SC-084',
      contentKey: RegulatoryDisclosuresPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeRegulatoryDisclosuresProvider),
          ),
        ],
        data: (snapshot) {
          _activeTabId ??= snapshot.defaultTabId;
          final activeTabLabel = snapshot.tabs
              .firstWhere(
                (tab) => tab.id == _activeTabId,
                orElse: () => snapshot.tabs.first,
              )
              .label;

          return [
            VitTradeSection(
              title: 'Overview',
              child: VitTradeComplianceHero(
                title: snapshot.heroTitle,
                description: snapshot.heroDescription,
              ),
            ),
            VitTradeComplianceSection(
              title: 'Disclosure review',
              statusPill: const VitStatusPill(
                label: 'Disclosure route visible',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Viewing section',
                  value: activeTabLabel,
                ),
                VitTradeComplianceItem(
                  label: 'Support contacts',
                  value: '${snapshot.contacts.length} regulatory contacts',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Disclosures',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LegalTabs(
                    tabs: snapshot.tabs,
                    activeId: _activeTabId!,
                    onChanged: (id) => setState(() => _activeTabId = id),
                  ),
                  _LegalTabBody(
                    snapshot: snapshot,
                    activeTabId: _activeTabId!,
                    onNotice: (notice) => setState(() => _notice = notice),
                  ),
                  if (_notice != null) ...[
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    _RegulatoryNoticePanel(
                      text: _notice!,
                      onClose: () => setState(() => _notice = null),
                    ),
                  ],
                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    density: VitDensity.tool,
                    title: 'Disclosure review state',
                    message:
                        'Legal tabs, product disclosures, contact routes, notice result and investor next step are reviewed before regulated action.',
                    contractId: 'regulatory-disclosures-review',
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
