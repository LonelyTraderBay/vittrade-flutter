import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pBlacklistAddVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pBlacklistAddNativeNavClearance =
    _p2pBlacklistAddVisualNavClearance - AppSpacing.x4;
const double _p2pBlacklistAddVisualClearance = AppSpacing.x3;
const double _p2pBlacklistAddNativeClearance = AppSpacing.x2;

class P2PBlacklistAddPage extends ConsumerStatefulWidget {
  const P2PBlacklistAddPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc276_p2p_blacklist_add_hero');
  static const usernameKey = Key('sc276_p2p_blacklist_add_username');
  static const noteKey = Key('sc276_p2p_blacklist_add_note');
  static const warningKey = Key('sc276_p2p_blacklist_add_warning');
  static const submitKey = Key('sc276_p2p_blacklist_add_submit');
  static const confirmKey = Key('sc276_p2p_blacklist_add_confirm');
  static const cancelKey = Key('sc276_p2p_blacklist_add_cancel');

  static Key reasonKey(String id) => Key('sc276_p2p_blacklist_add_reason_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PBlacklistAddPage> createState() =>
      _P2PBlacklistAddPageState();
}

class _P2PBlacklistAddPageState extends ConsumerState<P2PBlacklistAddPage> {
  final _usernameController = TextEditingController();
  final _noteController = TextEditingController();
  String _reasonId = 'scam';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(P2PBlacklistAddSnapshot snapshot) async {
    if (_usernameController.text.trim().isEmpty || _isSubmitting) return;

    final username = _usernameController.text.trim();
    final reason = snapshot.reasons.firstWhere(
      (item) => item.id == _reasonId,
      orElse: () => snapshot.reasons.first,
    );
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận chặn người dùng P2P',
      message:
          'Thao tác này sẽ ngăn giao dịch P2P với người dùng đã chọn. Kiểm tra lại lý do và bước tiếp theo trước khi áp dụng.',
      rows: [
        VitConfirmDialogRow(
          label: 'Người dùng',
          value: _maskUsername(username),
        ),
        VitConfirmDialogRow(label: 'Lý do', value: reason.label),
        VitConfirmDialogRow(
          label: 'Ghi chú',
          value: _noteController.text.trim().isEmpty
              ? 'Không có'
              : 'Đã nhập ghi chú',
        ),
      ],
      confirmLabel: 'Chặn người dùng',
      confirmVariant: VitCtaButtonVariant.destructive,
      confirmKey: P2PBlacklistAddPage.confirmKey,
      cancelKey: P2PBlacklistAddPage.cancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.mediumImpact());
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    context.go(snapshot.blacklistRoute);
  }

  static String _maskUsername(String value) {
    if (value.length <= 2) return '••••';
    return '${value.substring(0, 1)}•••${value.substring(value.length - 1)}';
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pBlacklistAddProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pBlacklistAddVisualNavClearance +
                  _p2pBlacklistAddVisualClearance
            : _p2pBlacklistAddNativeNavClearance +
                  _p2pBlacklistAddNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    final canSubmit =
        _usernameController.text.trim().isNotEmpty && !_isSubmitting;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thêm vào danh sách chặn P2P',
      semanticIdentifier: 'SC-276',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pBlacklist),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pBlacklist),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pBlacklistAddProvider),
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
                      padding: P2PSpacingTokens.p2pBlacklistAddScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _Hero(snapshot: snapshot),
                          VitInput(
                            key: const Key(
                              'sc276_p2p_blacklist_add_username_control',
                            ),
                            controller: _usernameController,
                            fieldKey: P2PBlacklistAddPage.usernameKey,
                            label: snapshot.usernameLabel,
                            hintText: snapshot.usernameHint,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                          ),
                          _ReasonSelector(
                            reasons: snapshot.reasons,
                            selectedReasonId: _reasonId,
                            onChanged: (id) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _reasonId = id);
                            },
                          ),
                          _NoteField(
                            controller: _noteController,
                            label: snapshot.noteLabel,
                            hint: snapshot.noteHint,
                          ),
                          _WarningCard(snapshot: snapshot),
                          VitCtaButton(
                            key: P2PBlacklistAddPage.submitKey,
                            variant: VitCtaButtonVariant.danger,
                            loading: _isSubmitting,
                            onPressed: canSubmit
                                ? () => _submit(snapshot)
                                : null,
                            leading: const Icon(Icons.block_rounded),
                            child: Text(snapshot.submitLabel),
                          ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại thao tác chặn',
                            message:
                                'Tên người dùng, lý do, ghi chú, cảnh báo, trạng thái đang gửi và bước hoàn tác/hỗ trợ tiếp theo đã được xem trước khi chặn merchant.',
                            contractId: 'p2p-blacklist-add-review',
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
}

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});

  final P2PBlacklistAddSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitNextActionCard(
      key: P2PBlacklistAddPage.heroKey,
      icon: Icons.person_remove_alt_1_outlined,
      title: snapshot.heroTitle,
      subtitle: snapshot.heroSubtitle,
      accentColor: AppColors.sell,
    );
  }
}

class _ReasonSelector extends StatelessWidget {
  const _ReasonSelector({
    required this.reasons,
    required this.selectedReasonId,
    required this.onChanged,
  });

  final List<P2PBlacklistReasonDraft> reasons;
  final String selectedReasonId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lý do chặn *',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final reason in reasons) ...[
          _ReasonTile(
            reason: reason,
            selected: reason.id == selectedReasonId,
            onTap: () => onChanged(reason.id),
          ),
          if (reason != reasons.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final P2PBlacklistReasonDraft reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason.toneKey);
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: P2PBlacklistAddPage.reasonKey(reason.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: selected
          ? color.withValues(alpha: .46)
          : AppColors.borderSolid,
      background: ColoredBox(
        color: selected ? color.withValues(alpha: .08) : AppColors.surface2,
      ),
      clip: true,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.buttonCompact + AppSpacing.x2,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          Material(
            color: color.withValues(alpha: .12),
            borderRadius: AppRadii.cardRadius,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
              child: Icon(
                _reasonIcon(reason.iconKey),
                color: color,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              reason.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? color : AppColors.text2,
                fontWeight: selected
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SizedBox(
          height: AppSpacing.ctaHeight + AppSpacing.x4,
          child: Material(
            color: AppColors.surface2,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(
                color: AppColors.borderSolid,
                width: AppSpacing.borderWidth,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
              child: TextField(
                key: P2PBlacklistAddPage.noteKey,
                controller: controller,
                minLines: null,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                cursorColor: AppColors.primary,
                style: AppTextStyles.body,
                decoration: InputDecoration.collapsed(
                  hintText: hint,
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.snapshot});

  final P2PBlacklistAddSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PBlacklistAddPage.warningKey,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              snapshot.warning,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _reasonIcon(String iconKey) {
  return switch (iconKey) {
    'alert' => Icons.report_problem_outlined,
    'clock' => Icons.schedule_rounded,
    'ban' => Icons.block_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'info' => Icons.info_outline_rounded,
    _ => Icons.block_rounded,
  };
}

Color _reasonColor(String toneKey) {
  return switch (toneKey) {
    'danger' => AppColors.sell,
    'warning' => AppColors.warn,
    'accent' => AppColors.accent,
    _ => AppColors.text3,
  };
}
