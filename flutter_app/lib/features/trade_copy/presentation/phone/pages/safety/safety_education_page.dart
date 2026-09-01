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
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/safety/safety_education_page_sections.dart';
part '../../../widgets/safety/safety_education_page_common.dart';

const _safetyPrimary = AppColors.primary;

class SafetyEducationPage extends ConsumerStatefulWidget {
  const SafetyEducationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc080_safety_education_content');
  static Key tabKey(String id) => Key('sc080_tab_$id');
  static Key scamKey(String id) => Key('sc080_scam_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SafetyEducationPage> createState() =>
      _SafetyEducationPageState();
}

class _SafetyEducationPageState extends ConsumerState<SafetyEducationPage> {
  late String _activeTabId;
  String? _expandedScamId;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeSafetyEducationProvider);

    return VitTradeHubScaffold(
      title: 'An toàn & Bảo mật',
      semanticLabel: 'An toàn & Bảo mật',
      semanticIdentifier: 'SC-080',
      contentKey: SafetyEducationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được nội dung an toàn',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeSafetyEducationProvider),
            ),
          ],
          data: (snapshot) {
            if (!_initialized) {
              _activeTabId = snapshot.defaultTabId;
              _initialized = true;
            }
            return [
              const VitTradeSection(
                title: 'Đánh giá rủi ro',
                child: VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  density: VitDensity.tool,
                  title: 'Xem lại tín hiệu an toàn copy trading',
                  message:
                      'Xác nhận dấu hiệu lừa đảo, xác minh provider, giới hạn báo cáo và bước tiếp theo trước khi copy.',
                ),
              ),
              VitTradeComplianceSection(
                title: 'An toàn copy trading',
                density: VitDensity.tool,
                statusPill: const VitStatusPill(
                  label: 'Đọc trước khi copy',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Lừa đảo theo dõi',
                    value: '${snapshot.scams.length}',
                  ),
                  VitTradeComplianceItem(
                    label: 'Cảnh báo đỏ',
                    value: '${snapshot.redFlags.length}',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Giáo dục',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VitTradeComplianceHero(
                      title: snapshot.heroTitle,
                      description: snapshot.heroDescription,
                      icon: Icons.shield_outlined,
                      accentColor: _safetyPrimary,
                    ),
                    _SafetyTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTabId,
                      onChanged: (id) {
                        setState(() {
                          _activeTabId = id;
                          _expandedScamId = null;
                        });
                      },
                    ),
                    if (_activeTabId == 'scams')
                      _ScamsTab(
                        scams: snapshot.scams,
                        expandedId: _expandedScamId,
                        onToggle: (id) => setState(
                          () => _expandedScamId = _expandedScamId == id
                              ? null
                              : id,
                        ),
                      )
                    else if (_activeTabId == 'redflags')
                      _RedFlagsTab(flags: snapshot.redFlags)
                    else if (_activeTabId == 'verification')
                      _VerificationTab(tiers: snapshot.verificationTiers)
                    else
                      _ReportTab(reasons: snapshot.reportReasons),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}
