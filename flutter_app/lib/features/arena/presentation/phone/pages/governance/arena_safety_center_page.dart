import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/governance/arena_safety_center_page_sections.dart';
part '../../../widgets/governance/arena_safety_center_page_common.dart';

const double _safetyVisualScrollClearance = 108;
const double _safetyNativeScrollClearance = 72;
const double _safetyBodyLineHeight = 1.28;
const double _safetyNoticeLineHeight = 1.3;
const double _safetyCheckLineHeight = 1.25;
const double _safetySectionTitleLineHeight = 1.2;
const double _safetyMarkerWidth = AppSpacing.pageSectionAccentWidth;
const double _safetyMarkerHeight = AppSpacing.rowPy + AppSpacing.x1;
const double _safetyIconBox = AppSpacing.buttonCompact;
const double _safetyIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _safetySmallIcon = AppSpacing.iconSm + AppSpacing.hairlineStroke;
const double _safetyProcessColumnWidth = AppSpacing.buttonCompact;
const double _safetyProcessStepBox = AppSpacing.iconMd + AppSpacing.x2;
const double _safetyProcessLineWidth = AppSpacing.dividerHairline;
const double _safetyProcessLineHeight = AppSpacing.x5;
const double _safetyInfoIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _safetyDividerHeight = AppSpacing.dividerHairline;

class ArenaSafetyCenterPage extends ConsumerWidget {
  const ArenaSafetyCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc198_safety_content');
  static const firstCommunityRuleKey = Key('sc198_first_community_rule');
  static const blockedLinkKey = Key('sc198_blocked_link');
  static const reportsLinkKey = Key('sc198_reports_link');
  static const acknowledgeKey = Key('sc198_acknowledge');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaSafetyCenterSnapshotProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _safetyVisualScrollClearance
            : _safetyNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'An toàn và quy tắc Arena - trung tâm an toàn Open Arena',
      semanticIdentifier: 'SC-198',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'An toàn & Quy tắc Arena',
            subtitle: 'Trung tâm an toàn · Open Arena',
            showBack: true,
            onBack: () => _close(context),
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
                    key: contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      gap: VitContentGap.tight,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Trung tâm an toàn',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaSafetyCenterSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _SafetyHero(snapshot: snapshot),
                          _SafetySection(
                            title: 'Quy tắc cộng đồng',
                            accentColor: AppColors.primary,
                            children: [
                              for (final entry
                                  in snapshot.communityRules.asMap().entries)
                                _RuleCard(
                                  key: entry.key == 0
                                      ? firstCommunityRuleKey
                                      : null,
                                  rule: entry.value,
                                ),
                            ],
                          ),
                          _SafetySection(
                            title: 'Nội dung bị cấm',
                            accentColor: AppColors.sell,
                            children: [
                              _BannedContentCard(items: snapshot.bannedContent),
                            ],
                          ),
                          _SafetySection(
                            title: 'Cách báo cáo và chặn',
                            accentColor: AppColors.warn,
                            children: [
                              for (final action in snapshot.reportActions)
                                _RuleCard(rule: action),
                            ],
                          ),
                          _SafetySection(
                            title: 'Quy trình xử lý vi phạm',
                            accentColor: AppColors.buy,
                            children: [
                              _ViolationProcessCard(
                                items: snapshot.violationProcess,
                              ),
                            ],
                          ),
                          _SafetySection(
                            title: 'Cách chốt kết quả',
                            accentColor: AppColors.primary,
                            children: [_InfoCard(info: snapshot.resolution)],
                          ),
                          _SafetySection(
                            title: 'Không giao dịch ngoài nền tảng',
                            accentColor: AppColors.sell,
                            children: [_InfoCard(info: snapshot.offPlatform)],
                          ),
                          _SafetySection(
                            title: 'Về Arena Points',
                            accentColor: AppColors.accent,
                            children: [
                              _InfoCard(info: snapshot.pointsDisclaimer),
                            ],
                          ),
                          _QuickLinks(links: snapshot.quickLinks),
                          VitCtaButton(
                            key: acknowledgeKey,
                            onPressed: () => _acknowledge(context),
                            child: Text(snapshot.ctaLabel),
                          ),
                          VitCommunityRulesLink(label: snapshot.footerLabel),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }

  static void _acknowledge(BuildContext context) {
    unawaited(HapticFeedback.mediumImpact());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}
