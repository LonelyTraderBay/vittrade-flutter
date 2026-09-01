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
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'arena_guide_page_guide_tab.dart';
part 'arena_guide_page_tips_safety_content.dart';
part 'arena_guide_page_faq_shared_widgets.dart';

enum _GuideTab { guide, tips, safety, faq }

enum _GuideMode { create, join }

final double _guideActionExtent = VitDensity.compact.controlHeight;
const _guideAccordionBodyLineRatio =
    ArenaSpacingTokens.arenaGuideAccordionBodyLineHeight;
const _guideChecklistLineRatio =
    ArenaSpacingTokens.arenaGuideChecklistLineHeight;
const _guideSmallBadgeLineRatio =
    ArenaSpacingTokens.arenaGuideSmallBadgeLineHeight;
const _guideStepBodyLineRatio = ArenaSpacingTokens.arenaGuideStepBodyLineHeight;
const _arenaAccent = AppModuleAccents.arena;

class ArenaGuidePage extends ConsumerStatefulWidget {
  const ArenaGuidePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc209_arena_guide_content');
  static const modeCreateKey = Key('sc209_mode_create');
  static const modeJoinKey = Key('sc209_mode_join');
  static const ctaKey = Key('sc209_primary_cta');
  static const safetyCenterKey = Key('sc209_safety_center');
  static const supportKey = Key('sc209_support');

  static Key tabKey(String id) => Key('sc209_tab_$id');
  static Key tipKey(String id) => Key('sc209_tip_$id');
  static Key faqKey(String id) => Key('sc209_faq_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaGuidePage> createState() => _ArenaGuidePageState();
}

class _ArenaGuidePageState extends ConsumerState<ArenaGuidePage> {
  _GuideTab _tab = _GuideTab.guide;
  _GuideMode _mode = _GuideMode.create;
  int? _expandedTip;
  int? _expandedFaq;
  bool _showAllTips = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaGuideSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Hướng dẫn sử dụng Arena - mẹo, an toàn và câu hỏi thường gặp',
      semanticIdentifier: 'SC-209',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Hướng dẫn Arena',
            subtitle: 'Completion · Fair play',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GuideTabs(active: _tab, onChanged: _setTab),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaGuidePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Hướng dẫn Arena',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(arenaGuideSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) => _tabChildren(context, snapshot),
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

  List<Widget> _tabChildren(BuildContext context, ArenaGuideSnapshot snapshot) {
    return switch (_tab) {
      _GuideTab.guide => [
        _GuideHero(snapshot: snapshot),
        _ModeSwitch(mode: _mode, onChanged: _setMode),
        _StepsTimeline(
          steps: _mode == _GuideMode.create
              ? snapshot.createSteps
              : snapshot.joinSteps,
        ),
        _StartCard(mode: _mode, onPressed: () => _openPrimary(context)),
        if (_mode == _GuideMode.create)
          _ExampleSection(examples: snapshot.examples),
        _ConceptSection(concepts: snapshot.keyConcepts),
        _GuideFooter(onRules: () => context.go(AppRoutePaths.arenaSafety)),
      ],
      _GuideTab.tips => [
        _TipsHeader(total: snapshot.proTips.length),
        _ImpactLegend(),
        _TipsList(
          tips: _showAllTips
              ? snapshot.proTips
              : snapshot.proTips.take(5).toList(),
          expandedIndex: _expandedTip,
          onToggle: _toggleTip,
        ),
        if (!_showAllTips && snapshot.proTips.length > 5)
          _ShowMoreTipsButton(
            remaining: snapshot.proTips.length - 5,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _showAllTips = true);
            },
          ),
        _ChecklistCard(items: snapshot.checklist),
        VitCtaButton(
          onPressed: () => context.go(AppRoutePaths.arenaStudio),
          leading: const Icon(
            Icons.auto_awesome,
            size: ArenaSpacingTokens.arenaGuideCtaIcon,
          ),
          child: const Text('Áp dụng ngay - Tạo Challenge'),
        ),
      ],
      _GuideTab.safety => [
        _SafetyHero(),
        _PointsOnlyBanner(),
        _SafetyTipList(items: snapshot.safetyTips),
        _SafetyCenterCard(
          onPressed: () => context.go(AppRoutePaths.arenaSafety),
        ),
      ],
      _GuideTab.faq => [
        _FaqHeader(total: snapshot.faqs.length),
        _FaqList(
          items: snapshot.faqs,
          expandedIndex: _expandedFaq,
          onToggle: _toggleFaq,
        ),
        _SupportCard(onPressed: () => context.go(AppRoutePaths.support)),
      ],
    };
  }

  void _setTab(_GuideTab tab) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _tab = tab);
  }

  void _setMode(_GuideMode mode) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _mode = mode);
  }

  void _toggleTip(int index) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _expandedTip = _expandedTip == index ? null : index);
  }

  void _toggleFaq(int index) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _expandedFaq = _expandedFaq == index ? null : index);
  }

  void _openPrimary(BuildContext context) {
    unawaited(HapticFeedback.mediumImpact());
    context.go(
      _mode == _GuideMode.create
          ? AppRoutePaths.arenaStudio
          : AppRoutePaths.arena,
    );
  }

  void _close() {
    unawaited(HapticFeedback.selectionClick());
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.arena,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
