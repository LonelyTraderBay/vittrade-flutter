import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const double _p2pLargeTxVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pLargeTxNativeNavClearance =
    _p2pLargeTxVisualNavClearance - AppSpacing.x4;
const double _p2pLargeTxVisualClearance = AppSpacing.x3;
const double _p2pLargeTxNativeClearance = AppSpacing.x2;

class P2PLargeTransactionJustificationPage extends ConsumerStatefulWidget {
  const P2PLargeTransactionJustificationPage({
    super.key,
    this.amount = 100000000,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc270_p2p_large_tx_hero');
  static const purposeListKey = Key('sc270_p2p_large_tx_purposes');
  static const customPurposeInputKey = Key(
    'sc270_p2p_large_tx_custom_purpose_input',
  );
  static const detailsInputKey = Key('sc270_p2p_large_tx_details_input');
  static const ctaKey = Key('sc270_p2p_large_tx_cta');
  static const confirmKey = Key('sc270_p2p_large_tx_confirm');
  static const cancelKey = Key('sc270_p2p_large_tx_cancel');

  static Key purposeKey(String purpose) =>
      Key('sc270_p2p_large_tx_purpose_${purpose.hashCode}');

  final double amount;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLargeTransactionJustificationPage> createState() =>
      _P2PLargeTransactionJustificationPageState();
}

class _P2PLargeTransactionJustificationPageState
    extends ConsumerState<P2PLargeTransactionJustificationPage> {
  final TextEditingController _customPurposeController =
      TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String? _purpose;

  @override
  void dispose() {
    _customPurposeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pLargeTransactionJustificationProvider(widget.amount),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pLargeTxVisualNavClearance + _p2pLargeTxVisualClearance
            : _p2pLargeTxNativeNavClearance + _p2pLargeTxNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    final needsCustomPurpose = _purpose == _otherPurposeLabel;
    final hasPurpose =
        _purpose != null &&
        (!needsCustomPurpose ||
            _customPurposeController.text.trim().isNotEmpty);
    final canSubmit = hasPurpose && _detailsController.text.trim().isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giải trình giao dịch lớn P2P',
      semanticIdentifier: 'SC-270',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pComplianceOverview),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pComplianceOverview),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pLargeTransactionJustificationProvider(widget.amount),
              ),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding:
                          P2PSpacingTokens.p2pLargeTransactionScrollPadding(
                            scrollEndPadding,
                          ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _LargeTransactionHero(snapshot: snapshot),
                          Text(
                            snapshot.purposeTitle,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          _PurposeList(
                            purposes: snapshot.purposes,
                            selectedPurpose: _purpose,
                            onSelected: (purpose) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _purpose = purpose);
                            },
                          ),
                          if (needsCustomPurpose)
                            VitInput(
                              controller: _customPurposeController,
                              fieldKey: P2PLargeTransactionJustificationPage
                                  .customPurposeInputKey,
                              label: snapshot.customPurposeLabel,
                              hintText: snapshot.customPurposePlaceholder,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                            ),
                          VitInput(
                            controller: _detailsController,
                            fieldKey: P2PLargeTransactionJustificationPage
                                .detailsInputKey,
                            label: snapshot.detailsLabel,
                            hintText: snapshot.detailsPlaceholder,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => setState(() {}),
                          ),
                          if (snapshot.highRiskContractId != null)
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem trước giải trình giao dịch lớn',
                              message:
                                  '${snapshot.heroTitle} cùng mục đích và giải trình chi tiết sẽ được kiểm tra theo quy định AML/CTF. Bước tiếp theo: chờ Compliance phản hồi trước khi tiếp tục giao dịch.',
                              contractId: snapshot.highRiskContractId,
                            ),
                          VitCtaButton(
                            key: P2PLargeTransactionJustificationPage.ctaKey,
                            onPressed: canSubmit
                                ? () => _confirmSubmit(snapshot)
                                : null,
                            trailing: const Icon(Icons.chevron_right_rounded),
                            child: Text(snapshot.ctaLabel),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSubmit(
    P2PLargeTransactionJustificationSnapshot snapshot,
  ) async {
    final purpose = _purpose == _otherPurposeLabel
        ? _customPurposeController.text.trim()
        : _purpose ?? 'Chưa chọn';
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận gửi giải trình giao dịch lớn',
      message:
          'Hồ sơ sẽ được Compliance rà soát theo AML/CTF. Kiểm tra số tiền, mục đích, nội dung và bước tiếp theo trước khi gửi.',
      rows: [
        VitConfirmDialogRow(label: 'Giao dịch', value: snapshot.heroTitle),
        VitConfirmDialogRow(label: 'Mục đích', value: purpose),
        const VitConfirmDialogRow(
          label: 'Nội dung giải trình',
          value: 'Đã nhập nội dung',
        ),
        const VitConfirmDialogRow(
          label: 'Bước tiếp theo',
          value: 'Chờ Compliance phản hồi',
        ),
      ],
      confirmLabel: 'Gửi giải trình',
      confirmKey: P2PLargeTransactionJustificationPage.confirmKey,
      cancelKey: P2PLargeTransactionJustificationPage.cancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.mediumImpact());
    context.go(snapshot.successRoute);
  }
}

class _LargeTransactionHero extends StatelessWidget {
  const _LargeTransactionHero({required this.snapshot});

  final P2PLargeTransactionJustificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PLargeTransactionJustificationPage.heroKey,
      color: AppColors.warn15,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardLargeRadius,
        side: BorderSide(color: AppColors.warningBorder),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pFinancialSafetyCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: AppColors.warn.withValues(alpha: .16),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
              ),
              child: const SizedBox(
                width: P2PSpacingTokens.p2pFinancialSafetyIconBox,
                height: P2PSpacingTokens.p2pFinancialSafetyIconBox,
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.heroSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: P2PSpacingTokens.p2pFinancialSafetyBodyLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurposeList extends StatelessWidget {
  const _PurposeList({
    required this.purposes,
    required this.selectedPurpose,
    required this.onSelected,
  });

  final List<String> purposes;
  final String? selectedPurpose;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PLargeTransactionJustificationPage.purposeListKey,
      children: [
        for (var index = 0; index < purposes.length; index++) ...[
          _PurposeTile(
            purpose: purposes[index],
            selected: selectedPurpose == purposes[index],
            onTap: () => onSelected(purposes[index]),
          ),
          if (index != purposes.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _PurposeTile extends StatelessWidget {
  const _PurposeTile({
    required this.purpose,
    required this.selected,
    required this.onTap,
  });

  final String purpose;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: P2PLargeTransactionJustificationPage.purposeKey(purpose),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
      background: ColoredBox(
        color: selected
            ? AppModuleAccents.p2p.withValues(alpha: .10)
            : AppColors.bg,
      ),
      clip: true,
      constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
      alignment: Alignment.centerLeft,
      padding: P2PSpacingTokens.p2pFinancialSafetyTilePadding,
      child: Text(
        purpose,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: selected ? AppModuleAccents.p2p : AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

const String _otherPurposeLabel = 'Khác (ghi rõ)';
