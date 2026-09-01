import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
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
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_validator_health_monitor_page_sections.dart';
part '../../../widgets/staking/staking_validator_health_monitor_page_common.dart';

class StakingValidatorHealthMonitorPage extends ConsumerStatefulWidget {
  const StakingValidatorHealthMonitorPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc383_stats');
  static const validatorsKey = Key('sc383_validators');
  static const trendKey = Key('sc383_trend');
  static const actionKey = Key('sc383_action');
  static const footerKey = Key('sc383_footer');

  static Key validatorKey(String id) => Key('sc383_validator_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingValidatorHealthMonitorPage> createState() =>
      _StakingValidatorHealthMonitorPageState();
}

class _StakingValidatorHealthMonitorPageState
    extends ConsumerState<StakingValidatorHealthMonitorPage> {
  String? _selectedValidatorId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      stakingValidatorHealthMonitorSnapshotProvider,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giám sát sức khỏe validator staking',
      semanticIdentifier: 'SC-383',
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
                  ref.invalidate(stakingValidatorHealthMonitorSnapshotProvider),
            ),
          ),
          data: (snapshot) {
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
                subtitle: 'Theo dõi sức khỏe validator',
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
                          _SummaryStats(snapshot: snapshot),
                          VitPageSection(
                            key:
                                StakingValidatorHealthMonitorPage.validatorsKey,
                            label: 'Active Validators',
                            accentColor: AppColors.primarySoft,
                            children: [
                              for (final validator in snapshot.validators)
                                _ValidatorCard(
                                  validator: validator,
                                  selected:
                                      _selectedValidatorId == validator.id,
                                  onTap: () {
                                    setState(() {
                                      _selectedValidatorId =
                                          _selectedValidatorId == validator.id
                                          ? null
                                          : validator.id;
                                    });
                                  },
                                ),
                            ],
                          ),
                          _TrendSection(points: snapshot.uptimeHistory),
                          if (snapshot.warningCount > 0)
                            _ActionRequiredCard(snapshot: snapshot),
                          _FooterNote(note: snapshot.footerNote),
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
}
