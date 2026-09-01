import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const double _p2pComplianceVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pComplianceNativeNavClearance =
    _p2pComplianceVisualNavClearance - AppSpacing.x4;
const double _p2pComplianceVisualClearance = AppSpacing.x3;
const double _p2pComplianceNativeClearance = AppSpacing.x2;
const double _p2pComplianceIconBox = AppSpacing.x6;
const double _p2pComplianceDividerHeight = AppSpacing.dividerHairline;

class P2PComplianceOverviewPage extends ConsumerWidget {
  const P2PComplianceOverviewPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc267_p2p_compliance_hero');
  static const checklistKey = Key('sc267_p2p_compliance_checklist');

  static Key itemKey(String id) => Key('sc267_p2p_compliance_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pComplianceOverviewProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pComplianceVisualNavClearance + _p2pComplianceVisualClearance
            : _p2pComplianceNativeNavClearance +
                  _p2pComplianceNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tổng quan tuân thủ P2P',
      semanticIdentifier: 'SC-267',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pComplianceOverviewProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
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
                          P2PSpacingTokens.p2pComplianceOverviewScrollPadding(
                            scrollEndPadding,
                          ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _ComplianceHero(snapshot: snapshot),
                          _ComplianceSummary(snapshot: snapshot),
                          Text(
                            'Compliance Checklist',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          _ComplianceChecklist(items: snapshot.items),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại danh sách tuân thủ',
                            message:
                                'Trạng thái danh sách, đích lộ trình, yêu cầu chưa hoàn tất và thao tác tuân thủ tiếp theo đã được xem trước khi mở các luồng P2P.',
                            contractId: 'p2p-compliance-overview-review',
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

class _ComplianceHero extends StatelessWidget {
  const _ComplianceHero({required this.snapshot});

  final P2PComplianceOverviewSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: P2PComplianceOverviewPage.heroKey,
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
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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

class _ComplianceSummary extends StatelessWidget {
  const _ComplianceSummary({required this.snapshot});

  final P2PComplianceOverviewSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitMetricCard(
      label: 'Mục tuân thủ',
      value: '${snapshot.items.length}',
      accentColor: AppModuleAccents.p2p,
      density: VitDensity.compact,
    );
  }
}

class _ComplianceChecklist extends StatelessWidget {
  const _ComplianceChecklist({required this.items});

  final List<P2PComplianceItemDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PComplianceOverviewPage.checklistKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _ComplianceRow(item: items[index]),
            if (index != items.length - 1)
              const Divider(
                height: _p2pComplianceDividerHeight,
                color: AppColors.borderSolid,
              ),
          ],
        ],
      ),
    );
  }
}

class _ComplianceRow extends StatelessWidget {
  const _ComplianceRow({required this.item});

  final P2PComplianceItemDraft item;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PComplianceOverviewPage.itemKey(item.id),
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          context.go(item.route);
        },
        child: Padding(
          padding: P2PSpacingTokens.p2pComplianceOverviewItemPadding,
          child: Row(
            children: [
              Material(
                color: AppModuleAccents.p2p.withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                ),
                child: SizedBox(
                  width: _p2pComplianceIconBox,
                  height: _p2pComplianceIconBox,
                  child: Icon(
                    _iconFor(item.iconKey),
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
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
        ),
      ),
    );
  }
}

IconData _iconFor(String key) {
  return switch (key) {
    'file' => Icons.description_outlined,
    'trend' => Icons.trending_up_rounded,
    'money' => Icons.attach_money_rounded,
    _ => Icons.shield_outlined,
  };
}
