import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsRedeemPage extends ConsumerWidget {
  const SavingsRedeemPage({
    super.key,
    required this.positionId,
    this.shellRenderMode,
  });

  static const backButtonKey = Key('sc331_back_to_savings_button');

  final String positionId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(
      savingsRedeemControllerProvider(positionId),
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Rút Tiết kiệm',
      semanticIdentifier: 'SC-331',
      child: Material(
        color: AppColors.bg,
        child: controllerAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(savingsRedeemSnapshotProvider(positionId)),
            ),
          ),
          data: (controller) {
            final snapshot = controller.state.snapshot;
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    grow: true,
                    padding: VitContentPadding.compact,
                    children: [
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.standard,
                        padding: AppSpacing.zeroInsets,
                        child: _MissingPositionState(snapshot: snapshot),
                      ),
                      const Spacer(),
                    ],
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

class _MissingPositionState extends StatelessWidget {
  const _MissingPositionState({required this.snapshot});

  final SavingsRedeemSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.empty,
          title: 'Không tìm thấy vị thế tiết kiệm',
          message: snapshot.notFoundMessage,
          contractId: 'savings-redeem-empty',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Align(
          alignment: Alignment.center,
          child: VitCtaButton(
            key: SavingsRedeemPage.backButtonKey,
            fullWidth: false,
            height: EarnSpacingTokens.savingsFlowHeroHeight,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.backRoute);
            },
            child: const Text('Quay lại'),
          ),
        ),
      ],
    );
  }
}
