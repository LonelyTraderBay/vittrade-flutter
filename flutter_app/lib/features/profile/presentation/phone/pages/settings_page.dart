import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/common/profile_icon_registry.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/settings_page_sections.dart';
part '../../widgets/settings_page_common.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc160_settings_content');
  static const appInfoKey = Key('sc160_settings_app_info');
  static Key currencyKey(String currency) =>
      Key('sc160_settings_currency_$currency');
  static Key languageKey(String id) => Key('sc160_settings_language_$id');
  static Key toggleKey(String id) => Key('sc160_settings_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _initialized = false;
  String _selectedCurrency = 'USD';
  String _selectedLanguageId = 'vi';
  Map<String, bool> _toggles = const {};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSettingsSnapshotProvider);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      semanticLabel: 'Cài đặt tài khoản',
      semanticIdentifier: 'SC-160',
      header: VitHeader(
        title: 'C\u00E0i \u0111\u1EB7t',
        subtitle: 'C\u00E0i \u0111\u1EB7t \u00B7 Profile',
        showBack: true,
        onBack: _close,
      ),
      body: SingleChildScrollView(
        key: SettingsPage.contentKey,
        physics: const ClampingScrollPhysics(),
        padding: ProfileSpacingTokens.settingsScrollPadding(scrollClearance),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.none,
          density: VitDensity.compact,
          fullBleed: true,
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title:
                    'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c d\u1EEF li\u1EC7u',
                message: 'Vui l\u00F2ng th\u1EED l\u1EA1i.',
                actionLabel: 'Th\u1EED l\u1EA1i',
                onAction: () => ref.invalidate(profileSettingsSnapshotProvider),
              ),
            ],
            data: (snapshot) {
              _initializeFrom(snapshot);
              return [
                const VitSectionHeader(
                  title: 'GIAO DI\u1EC6N',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: AppColors.primary,
                  density: VitDensity.compact,
                ),
                _CurrencyCard(
                  currencies: snapshot.currencyOptions,
                  selectedCurrency: _selectedCurrency,
                  onChanged: _setCurrency,
                ),
                const VitSectionHeader(
                  title: 'NG\u00D4N NG\u1EEE',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: AppColors.primary,
                  density: VitDensity.compact,
                ),
                _LanguageCard(
                  languages: snapshot.languages,
                  selectedId: _selectedLanguageId,
                  onChanged: _setLanguage,
                ),
                const VitSectionHeader(
                  title: 'B\u1EA2O M\u1EACT GIAO D\u1ECACH',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: AppColors.primary,
                  density: VitDensity.compact,
                ),
                if (snapshot.tradeSecurity.isEmpty)
                  const VitEmptyState(
                    title:
                        'Ch\u01B0a c\u00F3 c\u00E0i \u0111\u1EB7t giao d\u1ECBch',
                    message:
                        'C\u00E1c tu\u1EF3 ch\u1ECDn b\u1EA3o m\u1EADt s\u1EBD hi\u1EC3n th\u1ECB khi kh\u1EA3 d\u1EE5ng.',
                    icon: Icons.shield_outlined,
                  )
                else
                  _SettingsListCard(
                    rows: snapshot.tradeSecurity,
                    toggles: _toggles,
                    onToggle: _setToggle,
                  ),
                const VitSectionHeader(
                  title: 'TH\u00D4NG B\u00C1O',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: AppColors.primary,
                  density: VitDensity.compact,
                ),
                if (snapshot.notifications.isEmpty)
                  const VitEmptyState(
                    title: 'Ch\u01B0a c\u00F3 th\u00F4ng b\u00E1o',
                    message:
                        'C\u00E0i \u0111\u1EB7t th\u00F4ng b\u00E1o s\u1EBD hi\u1EC3n th\u1ECB sau khi t\u1EA3i xong.',
                    icon: Icons.notifications_none_rounded,
                  )
                else
                  _SettingsListCard(
                    rows: snapshot.notifications,
                    toggles: _toggles,
                    onToggle: _setToggle,
                  ),
                _AppInfoCard(rows: snapshot.appInfo),
              ];
            },
          ),
        ),
      ),
    );
  }

  void _initializeFrom(ProfileSettingsSnapshot snapshot) {
    if (_initialized) return;
    final store = ref.read(keyValueStoreProvider);
    _selectedCurrency =
        store.getString(KeyValueStoreKeys.settingsCurrency) ??
        snapshot.selectedCurrency;
    _selectedLanguageId =
        store.getString(KeyValueStoreKeys.settingsLanguage) ??
        snapshot.selectedLanguageId;
    _toggles = {
      for (final item in [...snapshot.tradeSecurity, ...snapshot.notifications])
        if (item.enabled != null)
          item.id:
              store.getBool(KeyValueStoreKeys.settingsTogglePrefix + item.id) ??
              item.enabled!,
    };
    _initialized = true;
  }

  void _setCurrency(String currency) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _selectedCurrency = currency);
    // persist GĐ4-F1: giữ đơn vị tiền hiển thị qua phiên.
    unawaited(
      ref
          .read(keyValueStoreProvider)
          .setString(KeyValueStoreKeys.settingsCurrency, currency),
    );
  }

  void _setLanguage(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _selectedLanguageId = id);
    // persist GĐ4-F1: giữ ngôn ngữ đã chọn qua phiên.
    unawaited(
      ref
          .read(keyValueStoreProvider)
          .setString(KeyValueStoreKeys.settingsLanguage, id),
    );
  }

  void _setToggle(String id, bool value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _toggles = {..._toggles, id: value});
    // persist GĐ4-F1: giữ trạng thái toggle qua phiên.
    unawaited(
      ref
          .read(keyValueStoreProvider)
          .setBool(KeyValueStoreKeys.settingsTogglePrefix + id, value),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}
