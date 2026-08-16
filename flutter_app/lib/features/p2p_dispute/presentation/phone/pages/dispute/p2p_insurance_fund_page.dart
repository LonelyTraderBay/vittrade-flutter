import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'p2p_insurance_fund_overview_cards.dart';
part 'p2p_insurance_fund_claims_tour.dart';
part 'p2p_insurance_fund_page_common.dart';

enum _InsuranceTab { overview, claims }

const double _p2pInsuranceIconBox = AppSpacing.buttonCompact;
const double _p2pInsuranceChartHeight =
    P2PSpacingTokens.p2pTrustProgressChartHeight;
const double _p2pInsuranceInputHeight =
    P2PSpacingTokens.p2pTrustProgressInputHeight;
const double _p2pInsuranceTourMaxHeight =
    P2PSpacingTokens.p2pTrustProgressTourMaxHeight;
const double _p2pInsuranceTourStepHeight =
    P2PSpacingTokens.p2pTrustProgressTourStepHeight;
const double _p2pInsuranceTourIconBox = AppSpacing.x7;
const double _p2pInsuranceBodyLineHeight =
    P2PSpacingTokens.p2pTrustProgressBodyLineHeight;
const double _p2pInsuranceCaptionLineHeight =
    P2PSpacingTokens.p2pTrustProgressCaptionLineHeight;

class P2PInsuranceFundPage extends ConsumerStatefulWidget {
  const P2PInsuranceFundPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc238_p2p_insurance_content');
  static const overviewTabKey = Key('sc238_p2p_insurance_overview_tab');
  static const claimsTabKey = Key('sc238_p2p_insurance_claims_tab');
  static const tourKey = Key('sc238_p2p_insurance_tour');
  static const tourContinueKey = Key('sc238_p2p_insurance_tour_continue');
  static const certificateKey = Key('sc238_p2p_insurance_certificate');
  static const submitClaimKey = Key('sc238_p2p_insurance_submit_claim');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PInsuranceFundPage> createState() =>
      _P2PInsuranceFundPageState();
}

class _P2PInsuranceFundPageState extends ConsumerState<P2PInsuranceFundPage> {
  _InsuranceTab _tab = _InsuranceTab.overview;
  bool _showTour = true;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pInsuranceFundProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Quỹ bảo hiểm P2P',
        semanticIdentifier: 'SC-238',
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Đang tải…',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: const VitSkeletonList(),
        ),
      ),
      error: (error, stackTrace) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Quỹ bảo hiểm P2P',
        semanticIdentifier: 'SC-238',
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Không tải được',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pInsuranceFundProvider),
          ),
        ),
      ),
      data: (snapshot) => Stack(
        children: [
          VitPageLayout(
            variant: VitPageVariant.flush,
            semanticLabel: 'Quỹ bảo hiểm P2P',
            semanticIdentifier: 'SC-238',
            child: Material(
              type: MaterialType.transparency,
              child: VitAutoHideHeaderScaffold(
                header: VitHeader(
                  title: 'Quỹ bảo hiểm',
                  subtitle: 'Bảo hiểm · P2P',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.p2p),
                  actions: [
                    VitHeaderActionItem(
                      type: VitHeaderActionType.help,
                      tooltip: 'Hướng dẫn sử dụng',
                      tone: VitHeaderActionTone.primary,
                      onPressed: () {
                        unawaited(HapticFeedback.selectionClick());
                        setState(() => _showTour = true);
                      },
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: P2PSpacingTokens.p2pTrustProgressTabPadding,
                      child: VitTabBar(
                        variant: VitTabBarVariant.segment,
                        activeKey: _tab.name,
                        onChanged: (key) {
                          unawaited(HapticFeedback.selectionClick());
                          setState(() {
                            _tab = key == _InsuranceTab.claims.name
                                ? _InsuranceTab.claims
                                : _InsuranceTab.overview;
                          });
                        },
                        tabs: const [
                          VitTabItem(
                            key: 'overview',
                            label: 'Tổng quan',
                            icon: Icons.shield_outlined,
                          ),
                          VitTabItem(
                            key: 'claims',
                            label: 'Yêu cầu của tôi',
                            icon: Icons.receipt_long_rounded,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          key: P2PInsuranceFundPage.contentKey,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.contentPad,
                            AppSpacing.x3,
                            AppSpacing.contentPad,
                            scrollEndPadding,
                          ),
                          child: VitPageContent(
                            rhythm: VitPageRhythm.standard,
                            padding: VitContentPadding.none,
                            fullBleed: true,
                            density: VitDensity.compact,
                            children: [
                              VitPageSection(
                                density: VitDensity.compact,
                                children: [
                                  _tab == _InsuranceTab.overview
                                      ? _OverviewContent(snapshot: snapshot)
                                      : _ClaimsContent(snapshot: snapshot),
                                ],
                              ),
                              const VitHighRiskStatePanel(
                                density: VitDensity.compact,
                                state: VitHighRiskUiState.riskReview,
                                title: 'Xem lại quỹ bảo hiểm',
                                message:
                                    'Sức khỏe quỹ, điều kiện, mức bảo hiểm, danh sách yêu cầu, chứng nhận và bước tiếp theo được xem lại trước khi gửi yêu cầu.',
                                contractId: 'p2p-insurance-fund-review',
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
          if (_showTour)
            _InsuranceTourOverlay(
              snapshot: snapshot,
              onClose: () {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _showTour = false);
              },
              onContinue: () {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _showTour = false);
              },
            ),
        ],
      ),
    );
  }
}
