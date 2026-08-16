import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

part 'arena_universal_preset_library_page_domains_suggestions_dropdowns.dart';
part 'arena_universal_preset_library_page_titles_and_shared_widgets.dart';
part 'arena_universal_preset_library_page_demo_and_title_widgets.dart';

const _arenaAccent = AppModuleAccents.arena;
const _presetBodyLineRatio = ArenaSpacingTokens.arenaPresetBodyLineHeight;
const _presetCaptionLineRatio = ArenaSpacingTokens.arenaPresetCaptionLineHeight;
const _presetCheckLineRatio = ArenaSpacingTokens.arenaPresetCheckLineHeight;
const _presetDividerExtent = ArenaSpacingTokens.arenaPresetDividerHeight;
const _presetNoticeLineRatio = ArenaSpacingTokens.arenaPresetNoticeLineHeight;

class ArenaUniversalPresetLibraryPage extends ConsumerStatefulWidget {
  const ArenaUniversalPresetLibraryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc187_preset_content');
  static const sectionTabsKey = Key('sc187_section_tabs');
  static const selectedSuggestionKey = Key('sc187_selected_suggestion');

  static Key sectionKey(String id) => Key('sc187_section_$id');

  static Key domainKey(String id) => Key('sc187_domain_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaUniversalPresetLibraryPage> createState() =>
      _ArenaUniversalPresetLibraryPageState();
}

class _ArenaUniversalPresetLibraryPageState
    extends ConsumerState<ArenaUniversalPresetLibraryPage> {
  var _activeSection = 'domains';
  String? _expandedDomainId;
  var _suggestionDomainId = 'sports';
  String? _selectedSuggestion;
  var _activeDemoIndex = 0;
  String? _selectedTitle;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaPresetLibrarySnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thư viện preset Arena Studio cho thử thách bằng điểm',
      semanticIdentifier: 'SC-187',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Preset Library',
            subtitle: 'Preset an toàn · Points only',
            showBack: true,
            onBack: _close,
          ),
          child: snapshotAsync.when(
            loading: () => const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: VitSkeletonList())],
            ),
            error: (error, stackTrace) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: VitErrorState(
                    title: 'Không tải được Preset Library',
                    message: 'Vui lòng kiểm tra kết nối và thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () =>
                        ref.invalidate(arenaPresetLibrarySnapshotProvider),
                  ),
                ),
              ],
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionTabs(
                  sections: snapshot.sections,
                  activeId: _activeSection,
                  onChanged: _selectSection,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: ArenaUniversalPresetLibraryPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: ArenaSpacingTokens.arenaPresetScrollPadding(
                        footerPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          if (_activeSection == 'domains')
                            _DomainPacksSection(
                              packs: snapshot.domainPacks,
                              expandedId: _expandedDomainId,
                              onToggle: _toggleDomain,
                            )
                          else if (_activeSection == 'suggestions')
                            _SuggestionsSection(
                              packs: snapshot.domainPacks,
                              suggestionsByDomain: snapshot.suggestionsByDomain,
                              activeDomainId: _suggestionDomainId,
                              selectedSuggestion: _selectedSuggestion,
                              onDomainChanged: _selectSuggestionDomain,
                              onSuggestionSelected: _selectSuggestion,
                            )
                          else if (_activeSection == 'dropdowns')
                            _DropdownsSection(groups: snapshot.dropdownGroups)
                          else if (_activeSection == 'demo_flows')
                            _DemoFlowsSection(
                              flows: snapshot.demoFlows,
                              activeIndex: _activeDemoIndex,
                              onChanged: _selectDemo,
                            )
                          else
                            _TitlesSection(
                              titles: snapshot.titleSuggestions,
                              selectedTitle: _selectedTitle,
                              onSelected: _selectTitle,
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

  void _selectSection(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _activeSection = id);
  }

  void _toggleDomain(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _expandedDomainId = _expandedDomainId == id ? null : id;
    });
  }

  void _selectSuggestionDomain(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _suggestionDomainId = id;
      _selectedSuggestion = null;
    });
  }

  void _selectSuggestion(String text) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _selectedSuggestion = text);
  }

  void _selectDemo(int index) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _activeDemoIndex = index);
  }

  void _selectTitle(String title) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _selectedTitle = title);
  }

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.arenaStudio,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
