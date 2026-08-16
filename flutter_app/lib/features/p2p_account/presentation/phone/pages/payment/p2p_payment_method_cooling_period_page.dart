import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pPaymentCoolingVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pPaymentCoolingNativeNavClearance =
    _p2pPaymentCoolingVisualNavClearance - AppSpacing.x4;
const double _p2pPaymentCoolingVisualClearance = AppSpacing.x3;
const double _p2pPaymentCoolingNativeClearance = AppSpacing.x2;

class P2PPaymentMethodCoolingPeriodPage extends ConsumerWidget {
  const P2PPaymentMethodCoolingPeriodPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc235_payment_cooling_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(
      p2pPaymentMethodCoolingPeriodControllerProvider,
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pPaymentCoolingVisualNavClearance +
                  _p2pPaymentCoolingVisualClearance
            : _p2pPaymentCoolingNativeNavClearance +
                  _p2pPaymentCoolingNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'Thời gian chờ thanh toán P2P',
      semanticIdentifier: 'SC-235',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Thời gian chờ',
            subtitle: 'Thanh toán · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
          ),
          child: controllerAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pPaymentMethodCoolingPeriodControllerProvider,
              ),
            ),
            data: (controller) {
              final snapshot = controller.state.snapshot;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2PPaymentMethodCoolingPeriodPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding:
                            P2PSpacingTokens.p2pPaymentCoolingScrollPadding(
                              scrollEndPadding,
                            ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.form,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _CoolingHero(
                                  daysLeft: controller.daysLeft,
                                  hoursLeft: controller.hoursLeft,
                                ),
                                _TimelineCard(snapshot: snapshot),
                                _ReasonCard(reasons: snapshot.reasons),
                                _WaitingNote(
                                  title: snapshot.waitTitle,
                                  message: snapshot.waitMessage,
                                ),
                              ],
                            ),
                            if (snapshot.highRiskContractId != null)
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Đang hạn chế phương thức mới',
                                message:
                                    'Phương thức thanh toán mới bị hạn chế đến hết thời gian chờ. '
                                    'Hạn mức lệnh P2P, ký quỹ escrow và tranh chấp vẫn áp dụng. '
                                    'Bước tiếp theo: dùng phương thức đã xác minh khác hoặc chờ hết hạn.',
                                contractId: snapshot.highRiskContractId,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CoolingHero extends StatelessWidget {
  const _CoolingHero({required this.daysLeft, required this.hoursLeft});

  final int daysLeft;
  final int hoursLeft;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pPaymentCardPadding,
      borderColor: AppColors.warningBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Material(
                color: AppColors.warn15,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
                child: SizedBox(
                  width: AppSpacing.x7,
                  height: AppSpacing.x7,
                  child: Icon(
                    Icons.schedule_rounded,
                    color: AppColors.warn,
                    size: P2PSpacingTokens.p2pPaymentHeroIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đang trong thời gian chờ',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppModuleAccents.p2p,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Phương thức thanh toán mới cần chờ 7 ngày',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Material(
            color: AppColors.warn15,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
            ),
            child: Padding(
              padding: P2PSpacingTokens.p2pPaymentCoolingHeroCountdownPadding,
              child: Column(
                children: [
                  Text(
                    '${daysLeft}d ${hoursLeft}h',
                    style: AppTextStyles.heroNumber.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Còn lại',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.snapshot});

  final P2PPaymentMethodCoolingPeriodSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentCardPadding,
      child: Row(
        children: [
          Expanded(
            child: _TimeBlock(label: 'Thêm lúc', value: snapshot.addedAt),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _TimeBlock(
              label: 'Sẵn sàng lúc',
              value: snapshot.availableAt,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.reasons});

  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tại sao có thời gian chờ?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (var index = 0; index < reasons.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    reasons[index],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (index != reasons.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _WaitingNote extends StatelessWidget {
  const _WaitingNote({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentCardPadding,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  message,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
