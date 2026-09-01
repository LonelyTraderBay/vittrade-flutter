import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
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

const double _p2pSourceFundsVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pSourceFundsNativeNavClearance =
    _p2pSourceFundsVisualNavClearance - AppSpacing.x4;
const double _p2pSourceFundsVisualClearance = AppSpacing.x3;
const double _p2pSourceFundsNativeClearance = AppSpacing.x2;

class P2PSourceOfFundsPage extends ConsumerStatefulWidget {
  const P2PSourceOfFundsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc269_p2p_sof_hero');
  static const sourceListKey = Key('sc269_p2p_sof_sources');
  static const inputKey = Key('sc269_p2p_sof_input');
  static const ctaKey = Key('sc269_p2p_sof_cta');
  static const confirmKey = Key('sc269_p2p_sof_confirm');
  static const cancelKey = Key('sc269_p2p_sof_cancel');

  static Key sourceKey(String id) => Key('sc269_p2p_sof_source_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSourceOfFundsPage> createState() =>
      _P2PSourceOfFundsPageState();
}

class _P2PSourceOfFundsPageState extends ConsumerState<P2PSourceOfFundsPage> {
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedSource;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pSourceOfFundsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pSourceFundsVisualNavClearance + _p2pSourceFundsVisualClearance
            : _p2pSourceFundsNativeNavClearance +
                  _p2pSourceFundsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    final canSubmit =
        _selectedSource != null && _detailsController.text.trim().isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Khai báo nguồn vốn P2P',
      semanticIdentifier: 'SC-269',
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
              onAction: () => ref.invalidate(p2pSourceOfFundsProvider),
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
                      padding: P2PSpacingTokens.p2pSourceOfFundsScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _SourceHero(snapshot: snapshot),
                          Text(
                            snapshot.sourceTitle,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          _FundSourceList(
                            sources: snapshot.sources,
                            selectedSource: _selectedSource,
                            onSelected: (source) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _selectedSource = source.id);
                            },
                          ),
                          VitInput(
                            controller: _detailsController,
                            fieldKey: P2PSourceOfFundsPage.inputKey,
                            label: snapshot.inputLabel,
                            hintText: snapshot.inputPlaceholder,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => setState(() {}),
                          ),
                          if (snapshot.highRiskContractId != null)
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem trước khai báo nguồn vốn',
                              message:
                                  'Nguồn tiền, chi tiết bổ sung và bước rà soát KYC được kiểm tra trước khi gửi khai báo. Bước tiếp theo: chờ Compliance phản hồi trước khi tiếp tục giao dịch.',
                              contractId: snapshot.highRiskContractId,
                            ),
                          VitCtaButton(
                            key: P2PSourceOfFundsPage.ctaKey,
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

  Future<void> _confirmSubmit(P2PSourceOfFundsSnapshot snapshot) async {
    final selected = snapshot.sources.firstWhere(
      (source) => source.id == _selectedSource,
      orElse: () => snapshot.sources.first,
    );
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận gửi khai báo nguồn vốn',
      message:
          'Khai báo sẽ được chuyển đến Compliance để rà soát. Kiểm tra nguồn vốn, nội dung bổ sung và bước tiếp theo trước khi gửi.',
      rows: [
        VitConfirmDialogRow(label: 'Nguồn vốn', value: selected.label),
        const VitConfirmDialogRow(
          label: 'Chi tiết bổ sung',
          value: 'Đã nhập nội dung',
        ),
        const VitConfirmDialogRow(
          label: 'Bước tiếp theo',
          value: 'Chờ Compliance phản hồi',
        ),
      ],
      confirmLabel: 'Gửi khai báo',
      confirmKey: P2PSourceOfFundsPage.confirmKey,
      cancelKey: P2PSourceOfFundsPage.cancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.mediumImpact());
    context.go(snapshot.successRoute);
  }
}

class _SourceHero extends StatelessWidget {
  const _SourceHero({required this.snapshot});

  final P2PSourceOfFundsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PSourceOfFundsPage.heroKey,
      color: AppModuleAccents.p2p,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardLargeRadius,
        side: BorderSide(color: AppModuleAccents.p2p),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pFinancialSafetyCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: AppColors.onAccent.withValues(alpha: .20),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
              ),
              child: const SizedBox(
                width: P2PSpacingTokens.p2pFinancialSafetyIconBox,
                height: P2PSpacingTokens.p2pFinancialSafetyIconBox,
                child: Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.onAccent,
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
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.heroSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .90),
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

class _FundSourceList extends StatelessWidget {
  const _FundSourceList({
    required this.sources,
    required this.selectedSource,
    required this.onSelected,
  });

  final List<P2PFundSourceDraft> sources;
  final String? selectedSource;
  final ValueChanged<P2PFundSourceDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSourceOfFundsPage.sourceListKey,
      children: [
        for (var index = 0; index < sources.length; index++) ...[
          _FundSourceTile(
            source: sources[index],
            selected: selectedSource == sources[index].id,
            onTap: () => onSelected(sources[index]),
          ),
          if (index != sources.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _FundSourceTile extends StatelessWidget {
  const _FundSourceTile({
    required this.source,
    required this.selected,
    required this.onTap,
  });

  final P2PFundSourceDraft source;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppModuleAccents.p2p : AppColors.text3;

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: P2PSourceOfFundsPage.sourceKey(source.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
      background: ColoredBox(
        color: selected
            ? AppModuleAccents.p2p.withValues(alpha: .10)
            : AppColors.bg,
      ),
      clip: true,
      constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
      padding: P2PSpacingTokens.p2pFinancialSafetyCardPadding,
      child: Row(
        children: [
          Material(
            color: selected
                ? AppModuleAccents.p2p.withValues(alpha: .16)
                : AppColors.surface2,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: P2PSpacingTokens.p2pFinancialSafetyCompactIconBox,
              height: P2PSpacingTokens.p2pFinancialSafetyCompactIconBox,
              child: Icon(
                _fundIcon(source.iconKey),
                color: color,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              source.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                color: selected ? AppModuleAccents.p2p : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          if (selected) ...[
            const SizedBox(width: AppSpacing.x3),
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconMd,
            ),
          ],
        ],
      ),
    );
  }
}

IconData _fundIcon(String key) {
  return switch (key) {
    'briefcase' => Icons.business_center_outlined,
    'trend' => Icons.trending_up_rounded,
    'home' => Icons.home_outlined,
    'gift' => Icons.card_giftcard_rounded,
    _ => Icons.attach_money_rounded,
  };
}
