import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/safety/copy_education_page_sections.dart';
part '../../../widgets/safety/copy_education_page_common.dart';

const _copyPrimary = AppColors.primary;

class CopyEducationPage extends ConsumerStatefulWidget {
  const CopyEducationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc065_copy_education_scroll_content');
  static const providerCtaKey = Key('sc065_provider_cta');
  static Key tabKey(String id) => Key('sc065_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyEducationPage> createState() => _CopyEducationPageState();
}

class _CopyEducationPageState extends ConsumerState<CopyEducationPage> {
  late String _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = 'how-it-works';
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopyEducationProvider);

    return VitTradeHubScaffold(
      title: 'Hướng dẫn Copy Trading',
      semanticLabel: 'Hướng dẫn Copy Trading',
      semanticIdentifier: 'SC-065',
      contentKey: CopyEducationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được hướng dẫn copy trading',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeCopyEducationProvider),
            ),
          ],
          data: (snapshot) => [
            VitTradeSection(
              title: 'Giới thiệu',
              child: VitTradeComplianceHero(
                title: snapshot.introTitle,
                description: snapshot.introDescription,
                icon: Icons.menu_book_outlined,
                accentColor: _copyPrimary,
              ),
            ),
            const VitTradeSection(
              title: 'Đánh giá rủi ro',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.tool,
                title: 'Review copy trading education',
                message:
                    'Understand fees, drawdown, slippage, provider risk, and copy modes before copying a provider.',
                contractId: 'Education module: copy trading',
              ),
            ),
            VitTradeSection(
              title: 'Chủ đề',
              child: _EducationTabs(
                tabs: snapshot.tabs,
                active: _activeTab,
                onChanged: (value) => setState(() => _activeTab = value),
              ),
            ),
            VitTradeSection(
              title: _activeTab == 'how-it-works'
                  ? 'Cách hoạt động'
                  : 'Nội dung',
              child: _activeTab == 'how-it-works'
                  ? _HowItWorksContent(snapshot: snapshot)
                  : _SupplementalTabContent(activeTab: _activeTab),
            ),
            VitTradeSection(
              title: 'Tiếp theo',
              child: _ProviderCta(
                onTap: () => context.push(AppRoutePaths.tradeCopyTrading),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
