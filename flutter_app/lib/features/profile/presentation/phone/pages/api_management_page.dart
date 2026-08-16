import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/api_management_keys.dart';
part '../../widgets/api_management_key_controls.dart';
part '../../widgets/api_management_docs.dart';

const _apiBackground = AppColors.bg;
const _apiBorder = AppColors.cardBorder;
const _apiPrimary = AppColors.primary;
const _apiGreen = AppColors.buy;
const _apiAmber = AppColors.warn;
const _apiRed = AppColors.sell;
const _apiMuted = AppColors.text3;

class ApiManagementPage extends ConsumerStatefulWidget {
  const ApiManagementPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc163_api_content');
  static const createKey = Key('sc163_api_create');
  static Key cardKey(String id) => Key('sc163_api_card_$id');
  static Key toggleKey(String id) => Key('sc163_api_toggle_$id');
  static Key revealKey(String id) => Key('sc163_api_reveal_$id');
  static Key deleteKey(String id) => Key('sc163_api_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ApiManagementPage> createState() => _ApiManagementPageState();
}

class _ApiManagementPageState extends ConsumerState<ApiManagementPage> {
  bool _initialized = false;
  List<ProfileApiKey> _keys = const [];
  String? _showSecretId;
  String? _copiedId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileApiManagementSnapshotProvider);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý API',
      semanticIdentifier: 'SC-163',
      child: Material(
        color: _apiBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Qu\u1EA3n l\u00FD API',
            subtitle: 'API \u00B7 Profile',
            showBack: true,
            onBack: _close,
            actions: [
              VitHeaderActionItem(
                key: ApiManagementPage.createKey,
                type: VitHeaderActionType.add,
                tooltip: 'Tạo API key',
                onPressed: _createApiKey,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ApiManagementPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: ProfileSpacingTokens.profileApiScrollPadding(
                    scrollClearance,
                  ),
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
                          onAction: () => ref.invalidate(
                            profileApiManagementSnapshotProvider,
                          ),
                        ),
                      ],
                      data: (snapshot) {
                        _initializeFrom(snapshot);
                        return [
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title:
                                'R\u00E0 so\u00E1t quy\u1EC1n truy c\u1EADp API',
                            message:
                                'Ki\u1EC3m tra quy\u1EC1n giao d\u1ECBch, IP whitelist, secret v\u00E0 key \u0111ang b\u1EADt tr\u01B0\u1EDBc khi ti\u1EBFp t\u1EE5c.',
                            contractId:
                                'Key \u0111ang b\u1EADt: ${_keys.where((key) => key.isActive).length}/${_keys.length}',
                            density: VitDensity.compact,
                          ),
                          if (_keys.isEmpty)
                            const VitEmptyState(
                              title: 'Ch\u01B0a c\u00F3 API key',
                              message:
                                  'T\u1EA1o key m\u1EDBi v\u00E0 ch\u1EC9 c\u1EA5p quy\u1EC1n th\u1EADt s\u1EF1 c\u1EA7n.',
                              icon: Icons.key_off_outlined,
                            )
                          else
                            for (final apiKey in _keys)
                              _ApiKeyCard(
                                apiKey: apiKey,
                                showSecret: _showSecretId == apiKey.id,
                                copiedId: _copiedId,
                                onToggle: () => _toggleKey(apiKey.id),
                                onReveal: () => _toggleSecret(apiKey.id),
                                onCopy: _copyText,
                                onDelete: () => _confirmDelete(apiKey),
                              ),
                          const _ApiDocsCard(),
                        ];
                      },
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

  void _initializeFrom(ProfileApiManagementSnapshot snapshot) {
    if (_initialized) return;
    _keys = List<ProfileApiKey>.of(snapshot.keys);
    _initialized = true;
  }

  void _createApiKey() {
    unawaited(HapticFeedback.selectionClick());
    context.go(AppRoutePaths.profileApiCreate);
  }

  void _toggleKey(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _keys = [
        for (final apiKey in _keys)
          if (apiKey.id == id)
            apiKey.copyWith(isActive: !apiKey.isActive)
          else
            apiKey,
      ];
    });
  }

  void _toggleSecret(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showSecretId = _showSecretId == id ? null : id);
  }

  Future<void> _copyText(String id, String value) async {
    unawaited(HapticFeedback.selectionClick());
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    setState(() => _copiedId = id);
  }

  Future<void> _confirmDelete(ProfileApiKey apiKey) async {
    unawaited(HapticFeedback.selectionClick());
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xo\u00E1 API Key?',
      message:
          'Thao t\u00E1c n\u00E0y kh\u00F4ng th\u1EC3 ho\u00E0n t\u00E1c. T\u1EA5t c\u1EA3 k\u1EBFt n\u1ED1i s\u1EED d\u1EE5ng key n\u00E0y '
          's\u1EBD ng\u1EEBng ho\u1EA1t \u0111\u1ED9ng.',
      confirmLabel: 'Xo\u00E1',
      confirmVariant: VitCtaButtonVariant.destructive,
    );
    if (!confirmed || !mounted) return;
    setState(() => _keys = _keys.where((key) => key.id != apiKey.id).toList());
    await showVitNoticeSheet(
      context: context,
      title: '\u0110\u00E3 xo\u00E1 API key',
      message:
          'Key "${apiKey.name}" \u0111\u00E3 b\u1ECB xo\u00E1 v\u00E0 ng\u1EEBng ho\u1EA1t \u0111\u1ED9ng.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  void _close() {
    goBackOrFallback(context, fallbackPath: AppRoutePaths.profile);
  }
}
