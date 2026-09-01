import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/widgets/settings/trade_bot_radio_icon.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_emergency_stop_page_sections.dart';
part '../../../widgets/settings/bot_emergency_stop_page_common.dart';

const _stopPrimary = AppColors.primary;
const _stopGreen = AppColors.buy;
const _stopRed = AppColors.sell;
const _stopOptionBorder = AppColors.borderSolid;

class BotEmergencyStopPage extends ConsumerStatefulWidget {
  const BotEmergencyStopPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc121_bot_emergency_stop_content');
  static const cancelKey = Key('sc121_bot_emergency_stop_cancel');
  static const submitKey = Key('sc121_bot_emergency_stop_submit');
  static const closePositionsKey = Key(
    'sc121_bot_emergency_stop_close_positions',
  );
  static const confirmationKey = Key('sc121_bot_emergency_stop_confirm');
  static const dialogConfirmKey = Key(
    'sc121_bot_emergency_stop_dialog_confirm',
  );

  static Key reasonKey(String reasonId) =>
      Key('sc121_bot_emergency_stop_reason_$reasonId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotEmergencyStopPage> createState() =>
      _BotEmergencyStopPageState();
}

class _BotEmergencyStopPageState extends ConsumerState<BotEmergencyStopPage> {
  String? _reasonId;
  bool _closePositions = false;
  bool _confirmed = false;
  bool _stopping = false;
  bool _supportOpen = false;

  void _goBack() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.tradeBotRiskDashboard,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeBotEmergencyStopControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    const stickyActionsHeight = AppSpacing.inputHeight + AppSpacing.x4;
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        stickyActionsHeight;

    return VitTradeDetailScaffold(
      title: 'Dừng khẩn cấp',
      subtitle: 'Dừng khẩn cấp tất cả bot đang chạy',
      semanticLabel: 'Dừng khẩn cấp toàn bộ bot giao dịch',
      semanticIdentifier: 'SC-121',
      contentKey: BotEmergencyStopPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      bottomInset: scrollEndClearance,
      activeProductId: 'bots',
      onBack: _goBack,
      footer: _StickyActions(
        bottomPadding:
            AppSpacing.contentPad + MediaQuery.paddingOf(context).bottom,
        canSubmit: _reasonId != null && _confirmed && !_stopping,
        stopping: _stopping,
        onCancel: _goBack,
        onSubmit: _submit,
      ),
      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu dừng khẩn cấp',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeBotEmergencyStopSnapshotProvider),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          final reasonLabel = snapshot.reasons
              .where((r) => r.id == _reasonId)
              .map((r) => r.label)
              .firstOrNull;
          return [
            _EmergencyOpening(
              snapshot: snapshot,
              reasonSelected: _reasonId != null,
              confirmed: _confirmed,
            ),
            VitTradeSection(
              title: 'Bot cần dừng (${snapshot.bots.length})',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < snapshot.bots.length; i++) ...[
                    _BotCard(bot: snapshot.bots[i]),
                    if (i != snapshot.bots.length - 1)
                      const SizedBox(
                        height: TradeSpacingTokens.tradeBotCardGap,
                      ),
                  ],
                ],
              ),
            ),
            VitTradeSection(
              title: 'Lý do dừng khẩn cấp',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < snapshot.reasons.length; i++) ...[
                    _ReasonOption(
                      reason: snapshot.reasons[i],
                      selected: snapshot.reasons[i].id == _reasonId,
                      onTap: () =>
                          setState(() => _reasonId = snapshot.reasons[i].id),
                    ),
                    if (i != snapshot.reasons.length - 1)
                      const SizedBox(
                        height: TradeSpacingTokens.tradeBotCardGap,
                      ),
                  ],
                ],
              ),
            ),
            VitTradeSection(
              title: 'Hành động bổ sung',
              child: _CheckActionCard(
                key: BotEmergencyStopPage.closePositionsKey,
                selected: _closePositions,
                title: snapshot.closePositionsTitle,
                description: snapshot.closePositionsDescription,
                danger: false,
                onTap: () {
                  setState(() => _closePositions = !_closePositions);
                },
              ),
            ),
            VitTradeSection(
              title: 'Xác nhận',
              child: _CheckActionCard(
                key: BotEmergencyStopPage.confirmationKey,
                selected: _confirmed,
                title: snapshot.confirmationTitle,
                description: snapshot.confirmationDescription,
                danger: true,
                onTap: () => setState(() => _confirmed = !_confirmed),
              ),
            ),
            VitTradeSection(
              title: 'Tóm tắt tác động',
              child: _ImpactSummaryCard(
                botCount: snapshot.bots.length,
                reasonLabel: reasonLabel,
                closePositions: _closePositions,
                confirmed: _confirmed,
              ),
            ),
            VitTradeSection(
              title: 'Hỗ trợ',
              child: _SupportNotice(
                snapshot: snapshot,
                expanded: _supportOpen,
                onToggle: () => setState(() => _supportOpen = !_supportOpen),
              ),
            ),
            const VitBotRiskReviewFooter(
              title: 'Xem lại yêu cầu dừng khẩn cấp',
              message:
                  'Bot đã chọn, lý do, lựa chọn đóng vị thế, xác nhận, tác động rủi ro và bước tiếp theo được xem lại trước khi gửi yêu cầu dừng.',
              contractId: 'bot-emergency-stop-review',
            ),
          ];
        },
      ),
    );
  }

  Future<void> _submit() async {
    final controller = ref.read(tradeBotEmergencyStopControllerProvider).value;
    if (controller == null ||
        !controller.canSubmit(reasonId: _reasonId, confirmed: _confirmed) ||
        _stopping) {
      return;
    }

    final snapshot = controller.state.snapshot;
    final reasonLabel = snapshot.reasons
        .where((r) => r.id == _reasonId)
        .map((r) => r.label)
        .firstOrNull;

    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận dừng khẩn cấp?',
      message:
          'Thao tác sẽ dừng ngay tất cả bot đang chạy. Không thể hoàn tác ngay lập tức.',
      rows: [
        VitConfirmDialogRow(label: 'Số bot', value: '${snapshot.bots.length}'),
        VitConfirmDialogRow(label: 'Lý do', value: reasonLabel ?? '—'),
        VitConfirmDialogRow(
          label: 'Đóng vị thế',
          value: _closePositions ? 'Có' : 'Không',
        ),
      ],
      confirmLabel: 'Dừng ngay',
      confirmVariant: VitCtaButtonVariant.destructive,
      confirmKey: BotEmergencyStopPage.dialogConfirmKey,
    );
    if (!confirmed || !mounted) return;

    setState(() => _stopping = true);
    final result = await controller.submit(
      TradeBotEmergencyStopDraft(
        reasonId: _reasonId!,
        closePositions: _closePositions,
        confirmed: _confirmed,
      ),
    );
    if (!mounted) return;
    setState(() => _stopping = false);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã dừng khẩn cấp',
      message: 'Đã dừng ${result.stoppedBotCount} bot đang chạy.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
      onPrimary: () {
        if (!mounted) return;
        context.go(result.redirectPath);
      },
    );
  }
}

String _formatSignedMoney(double value) => VitFormat.usdSigned(value);
