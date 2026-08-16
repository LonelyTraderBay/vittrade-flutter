import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/kyc_status_levels.dart';
part '../../widgets/kyc_details_privacy.dart';

const _kycBackground = AppColors.bg;
const _kycGreen = AppColors.buy;
const _kycPrimary = AppColors.primary;
const _kycMuted = AppColors.text3;

class KYCPage extends ConsumerStatefulWidget {
  const KYCPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc159_kyc_content');
  static const statusCardKey = Key('sc159_kyc_status_card');
  static const privacyCardKey = Key('sc159_kyc_privacy_card');
  static Key levelKey(int level) => Key('sc159_kyc_level_$level');
  static Key startKey(int level) => Key('sc159_kyc_start_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends ConsumerState<KYCPage> {
  int? _expandedLevel;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileKycSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x5 +
                  AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xác minh danh tính',
      semanticIdentifier: 'SC-159',
      child: Material(
        color: _kycBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'X\u00E1c minh danh t\u00EDnh',
            subtitle: 'KYC \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: KYCPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: ProfileSpacingTokens.kycScrollPadding(
                    scrollClearance,
                  ),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.form,
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
                          onAction: () =>
                              ref.invalidate(profileKycSnapshotProvider),
                        ),
                      ],
                      data: (snapshot) => [
                        _KycStatusCard(snapshot: snapshot),
                        VitHighRiskStatePanel(
                          state: _submitting
                              ? VitHighRiskUiState.submitting
                              : VitHighRiskUiState.riskReview,
                          title: _submitting
                              ? '\u0110ang g\u1EEDi h\u1ED3 s\u01A1 x\u00E1c minh'
                              : 'R\u00E0 so\u00E1t x\u00E1c minh danh t\u00EDnh',
                          message:
                              'Ki\u1EC3m tra c\u1EA5p KYC, gi\u1EDBi h\u1EA1n giao d\u1ECBch v\u00E0 t\u00EDnh n\u0103ng m\u1EDF kho\u00E1 tr\u01B0\u1EDBc khi n\u1ED9p.',
                          contractId:
                              'C\u1EA5p hi\u1EC7n t\u1EA1i: ${snapshot.currentLevel}',
                          density: VitDensity.compact,
                        ),
                        if (snapshot.levels.isEmpty)
                          const VitEmptyState(
                            title: 'Ch\u01B0a c\u00F3 c\u1EA5p KYC',
                            message:
                                'C\u00E1c c\u1EA5p x\u00E1c minh s\u1EBD hi\u1EC3n th\u1ECB sau khi \u0111\u1ED3ng b\u1ED9.',
                            icon: Icons.verified_user_outlined,
                          )
                        else ...[
                          for (final level in snapshot.levels)
                            _KycLevelCard(
                              level: level,
                              done: snapshot.currentLevel >= level.level,
                              expanded: _expandedLevel == level.level,
                              currentLevel: snapshot.currentLevel,
                              submitting: _submitting,
                              onTap: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(
                                  () => _expandedLevel =
                                      _expandedLevel == level.level
                                      ? null
                                      : level.level,
                                );
                              },
                              onStart: () => _startVerification(level.level),
                            ),
                        ],
                        const _PrivacyCard(),
                      ],
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

  Future<void> _startVerification(int level) async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() => _submitting = false);
  }

  void _close() {
    goBackOrFallback(context, fallbackPath: AppRoutePaths.profile);
  }
}
