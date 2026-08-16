import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_color_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_cta_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_footer.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_hero.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_input_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_playground.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_section_header_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_tokens_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/dev_state_bar.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

class DesignSystemPage extends ConsumerStatefulWidget {
  const DesignSystemPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc399_design_system_content');
  static const statesKey = Key('sc399_design_system_states');
  static const heroKey = Key('sc399_design_system_hero');
  static const tokensKey = Key('sc399_design_system_tokens');
  static const colorsKey = Key('sc399_design_system_colors');
  static const ctaKey = Key('sc399_design_system_cta');
  static const inputKey = Key('sc399_design_system_input');
  static const sectionsKey = Key('sc399_design_system_sections');
  static const playgroundKey = Key('sc399_design_system_playground');
  static Key swatchKey(String id) => Key('sc399_swatch_$id');
  static Key ctaDemoKey(String id) => Key('sc399_cta_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DesignSystemPage> createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends ConsumerState<DesignSystemPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'password');
  final _searchController = TextEditingController();
  final _errorController = TextEditingController(text: 'abc');
  final _playgroundInputController = TextEditingController();
  final _playgroundLabelController = TextEditingController(text: 'Mua BTC');
  final _playgroundErrorController = TextEditingController();

  String _playgroundVariant = 'primary';
  String _playgroundLabel = 'Mua BTC';
  bool _playgroundDisabled = false;
  bool _playgroundLoading = false;
  bool _playgroundFullWidth = true;
  bool _inputPrefix = true;
  bool _inputSuffix = false;
  String _inputError = '';
  DevUiMode _uiMode = DevUiMode.live;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    _errorController.dispose();
    _playgroundInputController.dispose();
    _playgroundLabelController.dispose();
    _playgroundErrorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(designSystemSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => _DesignSystemScaffold(
        title: 'Design System',
        subtitle: 'Dev · Design System',
        bottomInset: bottomInset,
        body: const _DesignSystemLoading(),
      ),
      error: (error, stackTrace) => _DesignSystemScaffold(
        title: 'Design System',
        subtitle: 'Dev · Design System',
        bottomInset: bottomInset,
        body: VitErrorState(
          title: 'Design system unavailable',
          message: 'Could not load token catalog. Retry when back online.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(designSystemSnapshotProvider),
        ),
      ),
      data: (snapshot) => _DesignSystemScaffold(
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        bottomInset: bottomInset,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DevStateBar(
              key: DesignSystemPage.statesKey,
              supportedStates: snapshot.supportedStates,
              active: _uiMode,
              onChanged: (mode) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _uiMode = mode);
              },
            ),
            switch (_uiMode) {
              DevUiMode.loading => const _DesignSystemLoading(),
              DevUiMode.empty => const VitEmptyState(
                title: 'Design tokens unavailable',
                message:
                    'Token registry is empty. Reload when the dev catalog syncs.',
              ),
              DevUiMode.error => VitErrorState(
                title: 'Design system unavailable',
                message:
                    'Could not load token catalog. Retry when back online.',
                onAction: () => setState(() => _uiMode = DevUiMode.live),
              ),
              DevUiMode.offline => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitOfflineBanner(
                    detail: 'Showing cached token reference.',
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  ..._liveSections(snapshot),
                ],
              ),
              DevUiMode.live => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _liveSections(snapshot),
              ),
            },
          ],
        ),
      ),
    );
  }

  List<Widget> _liveSections(DesignSystemSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Foundation',
        children: [
          VitCard(
            radius: VitCardRadius.large,
            padding: AppSpacing.zeroInsets,
            clip: true,
            child: DesignSystemHero(
              key: DesignSystemPage.heroKey,
              snapshot: snapshot,
            ),
          ),
          VitCard(
            radius: VitCardRadius.large,
            padding: AppSpacing.zeroInsets,
            clip: true,
            child: DesignSystemTokensSection(
              sectionKey: DesignSystemPage.tokensKey,
              tokens: snapshot.tokens,
            ),
          ),
          VitCard(
            radius: VitCardRadius.large,
            padding: AppSpacing.zeroInsets,
            clip: true,
            child: DesignSystemColorSection(
              sectionKey: DesignSystemPage.colorsKey,
              swatchKey: DesignSystemPage.swatchKey,
              swatches: snapshot.swatches,
            ),
          ),
        ],
      ),
      VitPageSection(
        label: 'Components',
        children: [
          DesignSystemCtaSection(
            sectionKey: DesignSystemPage.ctaKey,
            ctaDemoKey: DesignSystemPage.ctaDemoKey,
            demos: snapshot.ctaDemos,
          ),
          DesignSystemInputSection(
            sectionKey: DesignSystemPage.inputKey,
            demos: snapshot.inputDemos,
            emailController: _emailController,
            passwordController: _passwordController,
            searchController: _searchController,
            errorController: _errorController,
          ),
          DesignSystemSectionHeaderSection(
            sectionKey: DesignSystemPage.sectionsKey,
            demos: snapshot.sectionDemos,
          ),
        ],
      ),
      VitPageSection(
        label: 'Playground',
        children: [
          DesignSystemPlayground(
            sectionKey: DesignSystemPage.playgroundKey,
            label: _playgroundLabel,
            variant: _playgroundVariant,
            disabled: _playgroundDisabled,
            loading: _playgroundLoading,
            fullWidth: _playgroundFullWidth,
            inputPrefix: _inputPrefix,
            inputSuffix: _inputSuffix,
            inputError: _inputError,
            inputController: _playgroundInputController,
            labelController: _playgroundLabelController,
            errorController: _playgroundErrorController,
            onVariantChanged: (variant) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _playgroundVariant = variant);
            },
            onLabelChanged: (label) {
              setState(() => _playgroundLabel = label);
            },
            onToggleDisabled: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _playgroundDisabled = !_playgroundDisabled);
            },
            onToggleLoading: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _playgroundLoading = !_playgroundLoading);
            },
            onToggleFullWidth: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _playgroundFullWidth = !_playgroundFullWidth);
            },
            onTogglePrefix: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _inputPrefix = !_inputPrefix);
            },
            onToggleSuffix: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _inputSuffix = !_inputSuffix);
            },
            onErrorChanged: (value) => setState(() => _inputError = value),
          ),
        ],
      ),
      DesignSystemFooter(snapshot: snapshot),
    ];
  }
}

class _DesignSystemLoading extends StatelessWidget {
  const _DesignSystemLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 6);
  }
}

class _DesignSystemScaffold extends StatelessWidget {
  const _DesignSystemScaffold({
    required this.title,
    required this.subtitle,
    required this.bottomInset,
    required this.body,
  });

  final String title;
  final String subtitle;
  final double bottomInset;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hệ thống thiết kế (công cụ nội bộ)',
      semanticIdentifier: 'SC-399',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: DesignSystemPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AdminSpacingTokens.devScrollPadding(bottomInset),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.flush,
                    gap: VitContentGap.loose,
                    children: [body],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
