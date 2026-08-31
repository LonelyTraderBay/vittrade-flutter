import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/common/profile_icon_registry.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet account-settings detail pane (SC-160) for the Profile
/// master-detail shell — a public port of the phone `SettingsPage`'s content
/// (currency chip row, language list, trade-security and notification toggle
/// lists, app info card) into [ProfilePaneScaffold], per R2: the phone page
/// and its `part` family stay untouched. Same [profileSettingsSnapshotProvider]
/// data and the same [KeyValueStore] persistence as the phone page.
class ProfileSettingsPane extends ConsumerStatefulWidget {
  const ProfileSettingsPane({super.key});

  @override
  ConsumerState<ProfileSettingsPane> createState() =>
      _ProfileSettingsPaneState();
}

class _ProfileSettingsPaneState extends ConsumerState<ProfileSettingsPane> {
  bool _initialized = false;
  String _selectedCurrency = 'USD';
  String _selectedLanguageId = 'vi';
  Map<String, bool> _toggles = const {};

  Future<void> _refresh() async {
    ref.invalidate(profileSettingsSnapshotProvider);
    await ref.read(profileSettingsSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSettingsSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Cài đặt',
      subtitle: 'Cài đặt · thông báo · giao diện',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.settingsPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.settingsPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) {
          _initializeFrom(snapshot);
          return [
            VitPageSection(
              label: 'GIAO DIỆN',
              accentColor: AppColors.primary,
              headerVariant: VitSectionHeaderVariant.accentBar,
              headerDensity: VitDensity.compact,
              innerGap: TabletSpacingTokens.x4,
              children: [
                _CurrencyCard(
                  currencies: snapshot.currencyOptions,
                  selectedCurrency: _selectedCurrency,
                  onChanged: _setCurrency,
                ),
              ],
            ),
            VitPageSection(
              label: 'NGÔN NGỮ',
              accentColor: AppColors.primary,
              headerVariant: VitSectionHeaderVariant.accentBar,
              headerDensity: VitDensity.compact,
              innerGap: TabletSpacingTokens.x4,
              children: [
                _LanguageCard(
                  languages: snapshot.languages,
                  selectedId: _selectedLanguageId,
                  onChanged: _setLanguage,
                ),
              ],
            ),
            VitPageSection(
              label: 'BẢO MẬT GIAO DỊCH',
              accentColor: AppColors.primary,
              headerVariant: VitSectionHeaderVariant.accentBar,
              headerDensity: VitDensity.compact,
              innerGap: TabletSpacingTokens.x4,
              children: [
                if (snapshot.tradeSecurity.isEmpty)
                  const VitEmptyState(
                    title: 'Chưa có cài đặt giao dịch',
                    message: 'Các tùy chọn bảo mật sẽ hiển thị khi khả dụng.',
                    icon: Icons.shield_outlined,
                  )
                else
                  _SettingsListCard(
                    rows: snapshot.tradeSecurity,
                    toggles: _toggles,
                    onToggle: _setToggle,
                  ),
              ],
            ),
            VitPageSection(
              label: 'THÔNG BÁO',
              accentColor: AppColors.primary,
              headerVariant: VitSectionHeaderVariant.accentBar,
              headerDensity: VitDensity.compact,
              innerGap: TabletSpacingTokens.x4,
              children: [
                if (snapshot.notifications.isEmpty)
                  const VitEmptyState(
                    title: 'Chưa có thông báo',
                    message: 'Cài đặt thông báo sẽ hiển thị sau khi tải xong.',
                    icon: Icons.notifications_none_rounded,
                  )
                else
                  _SettingsListCard(
                    rows: snapshot.notifications,
                    toggles: _toggles,
                    onToggle: _setToggle,
                  ),
              ],
            ),
            _AppInfoCard(rows: snapshot.appInfo),
          ];
        },
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
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
  });

  final List<String> currencies;
  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          const Icon(
            Icons.language_rounded,
            color: AppColors.primary,
            size: ProfileSpacingTokens.settingsCurrencyIcon,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn vị tiền tệ hiển thị',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                VitPresetChipRow<String>(
                  gap: ProfileSpacingTokens.settingsCurrencyChipGap,
                  selectedValue: selectedCurrency,
                  onTap: onChanged,
                  items: [
                    for (final currency in currencies)
                      VitPresetChipItem<String>(
                        key: ProfileTabletKeys.settingsCurrency(currency),
                        value: currency,
                        label: currency,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.languages,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ProfileLanguageOption> languages;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          for (final language in languages) ...[
            _LanguageRow(
              language: language,
              selected: language.id == selectedId,
              onTap: () => onChanged(language.id),
            ),
            if (language != languages.last)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final ProfileLanguageOption language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.settingsLanguage(language.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      child: Material(
        color: selected ? AppColors.surface2 : AppColors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                VitDensity.compact.controlHeight + TabletSpacingTokens.x2,
          ),
          child: Padding(
            padding: ProfileSpacingTokens.settingsLanguageRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    language.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                if (selected)
                  const SizedBox(
                    width: ProfileSpacingTokens.settingsLanguageSelectedDot,
                    height: ProfileSpacingTokens.settingsLanguageSelectedDot,
                    child: Material(
                      color: AppColors.primary,
                      shape: CircleBorder(),
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

class _SettingsListCard extends StatelessWidget {
  const _SettingsListCard({
    required this.rows,
    required this.toggles,
    required this.onToggle,
  });

  final List<ProfileSettingsItem> rows;
  final Map<String, bool> toggles;
  final void Function(String id, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          for (final row in rows) ...[
            _SettingsToggleRow(
              row: row,
              enabled: toggles[row.id] ?? false,
              onToggle: (value) => onToggle(row.id, value),
            ),
            if (row != rows.last)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.row,
    required this.enabled,
    required this.onToggle,
  });

  final ProfileSettingsItem row;
  final bool enabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final hasIcon = row.iconKey != 'none';

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: VitDensity.compact.controlHeight + TabletSpacingTokens.x5,
      ),
      child: Padding(
        padding: hasIcon
            ? ProfileSpacingTokens.settingsRowPaddingWithIcon
            : ProfileSpacingTokens.settingsRowPaddingNoIcon,
        child: Row(
          children: [
            if (hasIcon) ...[
              Icon(
                profileIconFor(row.iconKey),
                color: AppColors.primary,
                size: ProfileSpacingTokens.settingsRowIcon,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Text(
                    row.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ),
            if (row.canToggle && row.enabled != null) ...[
              const SizedBox(width: TabletSpacingTokens.x4),
              VitTogglePill(
                key: ProfileTabletKeys.settingsToggle(row.id),
                enabled: enabled,
                onChanged: onToggle,
                semanticLabel: row.title,
                width: ProfileSpacingTokens.settingsSwitchWidth,
                height: ProfileSpacingTokens.settingsSwitchHeight,
                knobSize: ProfileSpacingTokens.settingsSwitchKnob,
                knobMargin: ProfileSpacingTokens.settingsSwitchKnobMargin,
                activeColor: AppColors.buy,
                inactiveColor: AppColors.toggleTrackOff,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.settingsAppInfo,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'THÔNG TIN ỨNG DỤNG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x4),
                Text(
                  row.value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
            if (row != rows.last)
              const SizedBox(height: TabletSpacingTokens.x4),
          ],
        ],
      ),
    );
  }
}
