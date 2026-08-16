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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/social/prediction_data_integration_sources.dart';
part '../../../widgets/social/prediction_data_integration_keys_webhooks.dart';
part '../../../widgets/social/prediction_data_integration_common.dart';

const _predictionPrimary = AppColors.primary;

enum _DataIntegrationTab { sources, apiKeys, webhooks }

class PredictionDataIntegrationPage extends ConsumerStatefulWidget {
  const PredictionDataIntegrationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc043_data_integration_content');
  static const sourcesTabKey = Key('sc043_tab_sources');
  static const apiKeysTabKey = Key('sc043_tab_api_keys');
  static const webhooksTabKey = Key('sc043_tab_webhooks');
  static const addSourceKey = Key('sc043_add_source');
  static const createApiKeyKey = Key('sc043_create_api_key');
  static const addWebhookKey = Key('sc043_add_webhook');

  static Key sourceKey(String id) => Key('sc043_source_$id');

  static Key revealApiKey(String id) => Key('sc043_reveal_$id');

  static Key copyApiKey(String id) => Key('sc043_copy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionDataIntegrationPage> createState() =>
      _PredictionDataIntegrationPageState();
}

class _PredictionDataIntegrationPageState
    extends ConsumerState<PredictionDataIntegrationPage> {
  _DataIntegrationTab _activeTab = _DataIntegrationTab.sources;
  final Set<String> _revealedKeys = <String>{};
  String? _copiedKeyId;

  void _toggleKey(String id) {
    setState(() {
      if (_revealedKeys.contains(id)) {
        _revealedKeys.remove(id);
      } else {
        _revealedKeys.add(id);
      }
    });
  }

  void _copyKey(PredictionApiKeyDraft apiKey) {
    unawaited(Clipboard.setData(ClipboardData(text: apiKey.key)));
    setState(() => _copiedKeyId = apiKey.id);
  }

  void _showComingSoon(String message) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataIntegrationAsync = ref.watch(
      predictionsDataIntegrationSnapshotProvider,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final footerPadding =
        footerChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Tích hợp dữ liệu dự đoán: nguồn dữ liệu, khóa API và webhook',
      semanticIdentifier: 'SC-043',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Data Integration',
            subtitle: 'Dữ liệu · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DataIntegrationTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionDataIntegrationPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionDataScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: dataIntegrationAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được tích hợp dữ liệu',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsDataIntegrationSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => switch (_activeTab) {
                          _DataIntegrationTab.sources => [
                            _SourcesOverview(snapshot: snapshot),
                            _SourceSection(sources: snapshot.sources),
                            _PrimaryBlueButton(
                              key: PredictionDataIntegrationPage.addSourceKey,
                              icon: Icons.add_rounded,
                              label: 'Add Data Source',
                              onPressed: () => _showComingSoon(
                                'Thêm nguồn dữ liệu sẽ sớm ra mắt',
                              ),
                            ),
                            const _InfoCard(
                              icon: Icons.shield_outlined,
                              message:
                                  'Oracle data sources are used for automatic event resolution. All sources are verified and monitored.',
                            ),
                          ],
                          _DataIntegrationTab.apiKeys => [
                            _ApiKeysSection(
                              apiKeys: snapshot.apiKeys,
                              revealedKeys: _revealedKeys,
                              copiedKeyId: _copiedKeyId,
                              onReveal: _toggleKey,
                              onCopy: _copyKey,
                            ),
                            _PrimaryBlueButton(
                              key:
                                  PredictionDataIntegrationPage.createApiKeyKey,
                              icon: Icons.add_rounded,
                              label: 'Create API Key',
                              onPressed: () =>
                                  _showComingSoon('Tạo API Key sẽ sớm ra mắt'),
                            ),
                            const _WarningCard(
                              message:
                                  'Keep your API keys secret. Never share them or commit to version control. Revoke immediately if compromised.',
                            ),
                          ],
                          _DataIntegrationTab.webhooks => [
                            _WebhookSection(webhooks: snapshot.webhooks),
                            _PrimaryBlueButton(
                              key: PredictionDataIntegrationPage.addWebhookKey,
                              icon: Icons.add_rounded,
                              label: 'Add Webhook',
                              onPressed: () =>
                                  _showComingSoon('Thêm Webhook sẽ sớm ra mắt'),
                            ),
                            const _InfoCard(
                              icon: Icons.info_outline_rounded,
                              message:
                                  'Webhooks allow you to receive real-time notifications when events occur. Configure your endpoint to handle POST requests.',
                            ),
                          ],
                        },
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
}
