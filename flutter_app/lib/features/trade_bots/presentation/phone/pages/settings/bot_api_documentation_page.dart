import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_api_documentation_intro_tabs.dart';
part '../../../widgets/settings/bot_api_documentation_endpoints.dart';
part '../../../widgets/settings/bot_api_documentation_websocket_examples.dart';
part '../../../widgets/settings/bot_api_documentation_support_common.dart';

const _apiPrimary = AppColors.primary;
const _apiRed = AppColors.sell;

class BotApiDocumentationPage extends ConsumerStatefulWidget {
  const BotApiDocumentationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc134_bot_api_documentation_content');
  static Key tabKey(String id) => Key('sc134_bot_api_tab_$id');
  static Key languageKey(String id) => Key('sc134_bot_api_language_$id');
  static Key endpointKey(String method, String path) =>
      Key('sc134_bot_api_endpoint_${method}_$path');
  static const copyKey = Key('sc134_bot_api_copy');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotApiDocumentationPage> createState() =>
      _BotApiDocumentationPageState();
}

class _BotApiDocumentationPageState
    extends ConsumerState<BotApiDocumentationPage> {
  String? _view;
  String? _language;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotApiDocumentationProvider);
    return VitTradeHubScaffold(
      title: 'Tài liệu API',
      subtitle: 'Tài liệu API bot cho nhà phát triển',
      semanticLabel: 'Tài liệu API bot dành cho nhà phát triển',
      semanticIdentifier: 'SC-134',
      contentKey: BotApiDocumentationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được tài liệu API',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotApiDocumentationProvider),
          ),
        ],
        data: (snapshot) {
          _view ??= snapshot.defaultView;
          _language ??= snapshot.defaultLanguage;
          final view = _view!;
          final language = _language!;
          return [
            VitBotSubpageHero(
              primaryLabel: 'Endpoint',
              primaryValue: '${snapshot.endpoints.length}',
              secondaryLabel: 'Sự kiện WS',
              secondaryValue: '${snapshot.websocketEvents.length}',
            ),
            const VitTradeSection(title: 'Tổng quan', child: _IntroCard()),
            VitTradeSection(
              title: 'Tài liệu',
              child: VitTabBar(
                variant: VitTabBarVariant.segment,
                activeKey: view,
                onChanged: (view) => setState(() => _view = view),
                tabs: [
                  for (final tab in snapshot.tabs)
                    VitTabItem(
                      key: tab.id,
                      label: tab.label,
                      widgetKey: BotApiDocumentationPage.tabKey(tab.id),
                    ),
                ],
              ),
            ),
            VitTradeSection(
              title: view == 'endpoints'
                  ? 'Endpoints'
                  : view == 'websocket'
                  ? 'WebSocket'
                  : 'Examples',
              child: view == 'endpoints'
                  ? _EndpointsView(endpoints: snapshot.endpoints)
                  : view == 'websocket'
                  ? _WebSocketView(
                      url: snapshot.websocketUrl,
                      events: snapshot.websocketEvents,
                    )
                  : _ExamplesView(
                      examples: snapshot.codeExamples,
                      language: language,
                      copied: _copied,
                      onLanguageChanged: (language) {
                        setState(() {
                          _language = language;
                          _copied = false;
                        });
                      },
                      onCopy: _copy,
                    ),
            ),
            VitTradeSection(
              title: 'Giới hạn tần suất',
              child: _RateLimitsCard(items: snapshot.rateLimits),
            ),
            VitTradeSection(
              title: 'Xác thực',
              child: _AuthCard(header: snapshot.authenticationHeader),
            ),
            const VitBotRiskReviewFooter(
              title: 'Xem lại vận hành API Bot',
              message:
                  'Endpoint, xác thực, giới hạn tần suất, sự kiện websocket và kênh hỗ trợ được xem lại trước khi tích hợp bot.',
              contractId: 'bot-api-documentation-review',
              statusLabel: 'Tài liệu chỉ đọc',
            ),
          ];
        },
      ),
    );
  }

  void _copy(String text) {
    unawaited(Clipboard.setData(ClipboardData(text: text)));
    setState(() => _copied = true);
  }
}
