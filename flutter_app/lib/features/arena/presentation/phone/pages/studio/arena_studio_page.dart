import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/features/arena/presentation/widgets/governance/arena_governance_gate_stepper_title.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/studio/arena_studio_stepper.dart';
part '../../../widgets/studio/arena_studio_fee_banner.dart';
part '../../../widgets/studio/arena_studio_steps.dart';
part '../../../widgets/studio/arena_studio_footer.dart';

const _arenaAccent = AppModuleAccents.arena;
const _studioDescriptionLineRatio =
    ArenaSpacingTokens.arenaStudioDescriptionLineHeight;
const _studioFeeBodyLineRatio = ArenaSpacingTokens.arenaStudioFeeBodyLineHeight;
const _studioTemplateLineRatio =
    ArenaSpacingTokens.arenaStudioTemplateLineHeight;

class ArenaStudioPage extends ConsumerStatefulWidget {
  const ArenaStudioPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc185_arena_studio_content');
  static const continueKey = Key('sc185_continue');
  static const saveKey = Key('sc185_save');
  static const exportKey = Key('sc185_export');
  static const importKey = Key('sc185_import');
  static const backStepKey = Key('sc185_back_step');
  static const smartRuleBuilderKey = Key('sc185_smart_rule_builder');

  static Key templateKey(String id) => Key('sc185_template_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaStudioPage> createState() => _ArenaStudioPageState();
}

class _ArenaStudioPageState extends ConsumerState<ArenaStudioPage> {
  int _step = 1;
  String? _templateId;
  String? _statusLabel;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaStudioSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tạo thử thách mới trong Arena Studio',
      semanticIdentifier: 'SC-185',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Arena Studio',
            subtitle: 'Tạo challenge · Points only',
            showBack: true,
            onBack: _close,
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
                    key: ArenaStudioPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Arena Studio',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(arenaStudioSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          _StudioStepper(steps: snapshot.steps, step: _step),
                          _PlatformFeeBanner(
                            platformFeePct: snapshot.platformFeePct,
                          ),
                          _StepBody(
                            step: _step,
                            snapshot: snapshot,
                            selectedTemplateId: _templateId,
                            onTemplateSelected: _selectTemplate,
                            onOpenSmartRules: () =>
                                context.go(AppRoutePaths.arenaStudioSmartRules),
                          ),
                          _InlineStudioActions(
                            step: _step,
                            totalSteps: snapshot.steps.length,
                            canContinue: _canContinue,
                            statusLabel: _statusLabel,
                            onBack: _step > 1 ? _backStep : null,
                            onContinue: _continue,
                            onSave: () =>
                                _markSecondaryAction('Đã lưu bản nháp'),
                            onExport: () =>
                                _markSecondaryAction('Đã chuẩn bị file xuất'),
                            onImport: () =>
                                _markSecondaryAction('Đã sẵn sàng nhập JSON'),
                          ),
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

  bool get _canContinue => _step == 1 ? _templateId != null : true;

  void _selectTemplate(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _templateId = id;
      _statusLabel = null;
    });
  }

  void _continue() {
    if (!_canContinue) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_step < 6) {
        _step += 1;
        _statusLabel = null;
      } else {
        _statusLabel = 'Đã gửi kiểm duyệt';
      }
    });
  }

  void _backStep() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_step > 1) _step -= 1;
      _statusLabel = null;
    });
  }

  void _markSecondaryAction(String label) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _statusLabel = label);
  }

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.arena,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
