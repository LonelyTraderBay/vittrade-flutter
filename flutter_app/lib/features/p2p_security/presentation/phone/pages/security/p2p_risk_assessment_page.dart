import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pRiskVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pRiskNativeNavClearance =
    _p2pRiskVisualNavClearance - AppSpacing.x4;
const double _p2pRiskVisualClearance = AppSpacing.x3;
const double _p2pRiskNativeClearance = AppSpacing.x2;
const double _p2pRiskInfoLineHeight = 1.34;
const double _p2pRiskFactorIconBox = AppSpacing.buttonCompact;

class P2PRiskAssessmentPage extends ConsumerWidget {
  const P2PRiskAssessmentPage({super.key, this.shellRenderMode});

  static const scoreHeroKey = Key('sc271_p2p_risk_score_hero');
  static const infoKey = Key('sc271_p2p_risk_info');
  static const factorsKey = Key('sc271_p2p_risk_factors');

  static Key factorKey(String id) => Key('sc271_p2p_risk_factor_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pRiskAssessmentProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pRiskVisualNavClearance + _p2pRiskVisualClearance
            : _p2pRiskNativeNavClearance + _p2pRiskNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đánh giá rủi ro P2P',
      semanticIdentifier: 'SC-271',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pComplianceOverview),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pComplianceOverview),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pRiskAssessmentProvider),
            ),
          ),
          data: (snapshot) {
            final controller = P2PRiskAssessmentController(
              state: P2PRiskAssessmentViewState(snapshot: snapshot),
            );
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
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
                        padding:
                            P2PSpacingTokens.p2pRiskAssessmentScrollPadding(
                              scrollEndPadding,
                            ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _RiskScoreHero(snapshot: snapshot),
                            _RiskSummary(snapshot: snapshot),
                            _RiskInfo(snapshot: snapshot),
                            Text(
                              snapshot.factorTitle,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _RiskFactorList(
                              factors: controller.materialFactors,
                            ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại điểm rủi ro P2P',
                              message:
                                  'Điểm rủi ro, trọng số yếu tố, tín hiệu tài khoản, ảnh hưởng hạn mức và bước xem xét tiếp theo được kiểm tra trước khi mức phơi nhiễm P2P thay đổi.',
                              contractId: 'p2p-risk-assessment-review',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RiskScoreHero extends StatelessWidget {
  const _RiskScoreHero({required this.snapshot});

  final P2PRiskAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: P2PRiskAssessmentPage.scoreHeroKey,
      accentColor: AppModuleAccents.p2p,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.shield_outlined,
            color: AppModuleAccents.p2p,
            boxSize: AppSpacing.x7,
            iconSize: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${snapshot.score}',
                  style: AppTextStyles.heroNumber.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.scoreLabel,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.scoreSubtitle,
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

class _RiskSummary extends StatelessWidget {
  const _RiskSummary({required this.snapshot});

  final P2PRiskAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitMetricCard(
      label: 'Yếu tố được đánh giá',
      value: '${snapshot.factors.length}',
      accentColor: AppModuleAccents.p2p,
      density: VitDensity.compact,
    );
  }
}

class _RiskInfo extends StatelessWidget {
  const _RiskInfo({required this.snapshot});

  final P2PRiskAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PRiskAssessmentPage.infoKey,
      color: AppModuleAccents.p2p.withValues(alpha: .10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppModuleAccents.p2p.withValues(alpha: .24)),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pRiskAssessmentInnerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: P2PSpacingTokens.p2pRiskControlsInfoIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                snapshot.infoText,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _p2pRiskInfoLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskFactorList extends StatelessWidget {
  const _RiskFactorList({required this.factors});

  final List<P2PRiskFactorDraft> factors;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PRiskAssessmentPage.factorsKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < factors.length; index++) ...[
            _RiskFactorRow(factor: factors[index]),
            if (index != factors.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.borderSolid,
              ),
          ],
        ],
      ),
    );
  }
}

class _RiskFactorRow extends StatelessWidget {
  const _RiskFactorRow({required this.factor});

  final P2PRiskFactorDraft factor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: P2PRiskAssessmentPage.factorKey(factor.id),
      padding: P2PSpacingTokens.p2pRiskAssessmentCardPadding,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: _p2pRiskFactorIconBox,
            child: Material(
              color: AppColors.buy15,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
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
                  factor.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  factor.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            '+${factor.score}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
