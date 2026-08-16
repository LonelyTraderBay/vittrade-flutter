import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../../widgets/tools/launchpad_notif_sound_controls.dart';
part '../../../widgets/tools/launchpad_notif_sound_categories.dart';
part '../../../widgets/tools/launchpad_notif_sound_footer.dart';

class LaunchpadNotifSoundPage extends ConsumerStatefulWidget {
  const LaunchpadNotifSoundPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc306_launchpad_notif_sound_content');
  static const heroKey = Key('sc306_launchpad_notif_sound_hero');
  static const quickTogglesKey = Key('sc306_launchpad_notif_sound_quick');
  static const categoriesKey = Key('sc306_launchpad_notif_sound_categories');
  static const dndKey = Key('sc306_launchpad_notif_sound_dnd');
  static const infoKey = Key('sc306_launchpad_notif_sound_info');
  static const footerKey = Key('sc306_launchpad_notif_sound_footer');
  static const saveKey = Key('sc306_launchpad_notif_sound_save');

  static Key categoryKey(String id) =>
      Key('sc306_launchpad_notif_sound_category_$id');
  static Key toggleKey(String id) =>
      Key('sc306_launchpad_notif_sound_toggle_$id');
  static Key expandKey(String id) =>
      Key('sc306_launchpad_notif_sound_expand_$id');
  static Key previewKey(String id) =>
      Key('sc306_launchpad_notif_sound_preview_$id');
  static Key soundTypeKey(String id, String type) =>
      Key('sc306_launchpad_notif_sound_type_${id}_$type');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadNotifSoundPage> createState() =>
      _LaunchpadNotifSoundPageState();
}

class _LaunchpadNotifSoundPageState
    extends ConsumerState<LaunchpadNotifSoundPage> {
  var _initialized = false;
  var _masterEnabled = true;
  var _masterVolume = 80.0;
  var _vibrate = true;
  var _doNotDisturb = false;
  var _dndStartHour = 22;
  var _dndEndHour = 7;
  var _hasChanges = false;
  var _saved = false;
  String? _expandedCategoryId;
  String? _playingPreviewId;
  final Map<String, _CategoryState> _categories = {};

  @override
  Widget build(BuildContext context) {
    final notifSoundAsync = ref.watch(launchpadNotifSoundSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollTailReserve =
        navInset + MediaQuery.paddingOf(context).bottom + AppSpacing.x3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cài đặt âm thanh và thông báo Launchpad',
      semanticIdentifier: 'SC-306',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: scrollTailReserve,
          semanticLabel: 'Cài đặt âm thanh và thông báo Launchpad',
          semanticIdentifier: 'SC-306',
          header: VitHeader(
            title: 'Âm thanh thông báo',
            subtitle: 'Cài đặt thông báo · Không ảnh hưởng tham gia IDO',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.launchpad),
          ),
          child: SingleChildScrollView(
            key: LaunchpadNotifSoundPage.contentKey,
            physics: const ClampingScrollPhysics(),
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              gap: VitContentGap.tight,
              children: [
                ...notifSoundAsync.when(
                  loading: () => const [VitSkeletonList()],
                  error: (error, stackTrace) => [
                    VitErrorState(
                      title: 'Không tải được cài đặt âm thanh',
                      message: 'Vui lòng kiểm tra kết nối và thử lại.',
                      actionLabel: 'Thử lại',
                      onAction: () =>
                          ref.invalidate(launchpadNotifSoundSnapshotProvider),
                    ),
                  ],
                  data: (snapshot) {
                    _ensureState(snapshot);
                    return [
                      _MasterSoundHero(
                        masterEnabled: _masterEnabled,
                        volume: _masterVolume,
                        onToggle: () => _markChanged(() {
                          _masterEnabled = !_masterEnabled;
                        }),
                        onVolumeChanged: (value) => _markChanged(() {
                          _masterVolume = value;
                        }),
                      ),
                      VitHighRiskStatePanel(
                        state: _saved
                            ? VitHighRiskUiState.success
                            : VitHighRiskUiState.riskReview,
                        title: _saved
                            ? 'Notification settings saved'
                            : 'Notification settings review',
                        message:
                            'Sound, vibration, do-not-disturb, alert categories and delivery preferences are reviewed before saving.',
                        contractId: 'launchpad-notification-sound',
                      ),
                      _QuickTogglesCard(
                        vibrate: _vibrate,
                        doNotDisturb: _doNotDisturb,
                        dndStartHour: _dndStartHour,
                        dndEndHour: _dndEndHour,
                        onVibrate: () => _markChanged(() {
                          _vibrate = !_vibrate;
                        }),
                        onDoNotDisturb: () => _markChanged(() {
                          _doNotDisturb = !_doNotDisturb;
                        }),
                      ),
                      if (_doNotDisturb)
                        _DndScheduleCard(
                          startHour: _dndStartHour,
                          endHour: _dndEndHour,
                          onStartChanged: (value) => _markChanged(() {
                            _dndStartHour = value;
                          }),
                          onEndChanged: (value) => _markChanged(() {
                            _dndEndHour = value;
                          }),
                        ),
                      _CategorySoundSection(
                        snapshot: snapshot,
                        masterEnabled: _masterEnabled,
                        categories: _categories,
                        expandedCategoryId: _expandedCategoryId,
                        playingPreviewId: _playingPreviewId,
                        onToggleCategory: _toggleCategory,
                        onExpandCategory: (id) => setState(() {
                          _expandedCategoryId = _expandedCategoryId == id
                              ? null
                              : id;
                        }),
                        onSoundType: _setSoundType,
                        onVolume: _setCategoryVolume,
                        onPreview: _previewSound,
                      ),
                      const VitInfoCallout(
                        key: LaunchpadNotifSoundPage.infoKey,
                        message:
                            'Âm thanh chỉ phát khi ứng dụng đang hoạt động. Thông báo push ngoài app sử dụng cài đặt hệ thống thiết bị.',
                        accentColor: AppModuleAccents.launchpad,
                        padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                      ),
                      _InlineSaveActions(
                        saved: _saved,
                        hasChanges: _hasChanges,
                        onSave: _hasChanges || _saved ? _save : null,
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _ensureState(LaunchpadNotifSoundSnapshot snapshot) {
    if (_initialized) return;
    _masterEnabled = snapshot.masterEnabled;
    _masterVolume = snapshot.masterVolume.toDouble();
    _vibrate = snapshot.vibrate;
    _doNotDisturb = snapshot.doNotDisturb;
    _dndStartHour = snapshot.dndStartHour;
    _dndEndHour = snapshot.dndEndHour;
    for (final category in snapshot.categories) {
      _categories[category.id] = _CategoryState(
        enabled: category.enabled,
        soundType: category.soundType,
        volume: category.volume.toDouble(),
      );
    }
    _initialized = true;
  }

  void _markChanged(VoidCallback update) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      update();
      _hasChanges = true;
      _saved = false;
    });
  }

  void _toggleCategory(String id) {
    _markChanged(() {
      final state = _categories[id];
      if (state == null) return;
      _categories[id] = state.copyWith(enabled: !state.enabled);
    });
  }

  void _setSoundType(String id, String soundType) {
    _markChanged(() {
      final state = _categories[id];
      if (state == null) return;
      _categories[id] = state.copyWith(soundType: soundType);
    });
  }

  void _setCategoryVolume(String id, double volume) {
    _markChanged(() {
      final state = _categories[id];
      if (state == null) return;
      _categories[id] = state.copyWith(volume: volume);
    });
  }

  void _previewSound(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _playingPreviewId = id);
  }

  void _save() {
    unawaited(HapticFeedback.mediumImpact());
    setState(() {
      _hasChanges = false;
      _saved = true;
    });
  }
}
