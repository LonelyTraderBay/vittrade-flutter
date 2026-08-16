import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_regulatory_framework_hero_licenses.dart';
part '../../../widgets/staking/staking_regulatory_framework_protection_complaints.dart';
part '../../../widgets/staking/staking_regulatory_framework_sheet_common.dart';

class StakingRegulatoryFrameworkPage extends ConsumerStatefulWidget {
  const StakingRegulatoryFrameworkPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc373_regulatory_hero');
  static const tabsKey = Key('sc373_regulatory_tabs');
  static const licensesKey = Key('sc373_regulatory_licenses');
  static const protectionKey = Key('sc373_regulatory_protection');
  static const complaintsKey = Key('sc373_regulatory_complaints');
  static const footerKey = Key('sc373_regulatory_footer');
  static const detailCtaKey = Key('sc373_license_detail_cta');

  static Key tabKey(String id) => Key('sc373_tab_$id');

  static Key licenseKey(String licenseNumber) =>
      Key('sc373_license_$licenseNumber');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRegulatoryFrameworkPage> createState() =>
      _StakingRegulatoryFrameworkPageState();
}

class _StakingRegulatoryFrameworkPageState
    extends ConsumerState<StakingRegulatoryFrameworkPage> {
  String? _activeTab;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingRegulatoryFrameworkSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Khung pháp lý staking — giấy phép, bảo vệ và khiếu nại',
      semanticIdentifier: 'SC-373',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingRegulatoryFrameworkSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _activeTab ??= snapshot.defaultTabId;

            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Minh bạch giấy phép và tuân thủ',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          _HeroCard(snapshot: snapshot),
                          SizedBox(
                            key: StakingRegulatoryFrameworkPage.tabsKey,
                            child: VitTabBar(
                              variant: VitTabBarVariant.underline,
                              tabs: [
                                for (final tab in snapshot.tabs)
                                  VitTabItem(key: tab.id, label: tab.label),
                              ],
                              activeKey: _activeTab!,
                              onChanged: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _activeTab = id);
                              },
                            ),
                          ),
                          if (_activeTab == 'protection')
                            _ProtectionTab(snapshot: snapshot)
                          else if (_activeTab == 'complaints')
                            _ComplaintsTab(snapshot: snapshot)
                          else
                            _LicensesTab(
                              snapshot: snapshot,
                              onLicenseTap: _openLicenseSheet,
                            ),
                          _FooterNote(text: snapshot.footerNote),
                        ],
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

  Future<void> _openLicenseSheet(StakingLicenseDraft license) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.sheetTopLargeRadius,
            padding: AppSpacing.zeroInsets,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EarnSpacingTokens.earnSheetContentPadding,
                child: _LicenseDetailSheet(license: license),
              ),
            ),
          ),
        );
      },
    );
  }
}
