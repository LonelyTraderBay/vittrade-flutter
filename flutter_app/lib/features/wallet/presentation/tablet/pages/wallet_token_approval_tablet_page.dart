import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for token approvals SC-150.
class WalletTokenApprovalTabletPage extends ConsumerStatefulWidget {
  const WalletTokenApprovalTabletPage({super.key});

  static const contentKey = Key('sc150_token_approval_tablet_content');
  static const revokeAllKey = Key('sc150_token_approval_revoke_all_tablet');
  static const revokeSheetCancelKey = Key(
    'sc150_token_approval_sheet_cancel_tablet',
  );
  static const revokeSheetConfirmKey = Key(
    'sc150_token_approval_sheet_confirm_tablet',
  );

  static Key tabKey(String label) =>
      Key('sc150_token_approval_tab_tablet_$label');
  static Key approvalKey(String id) => Key('sc150_token_approval_tablet_$id');
  static Key revokeKey(String id) =>
      Key('sc150_token_approval_revoke_tablet_$id');

  @override
  ConsumerState<WalletTokenApprovalTabletPage> createState() =>
      _WalletTokenApprovalTabletPageState();
}

class _WalletTokenApprovalTabletPageState
    extends ConsumerState<WalletTokenApprovalTabletPage> {
  static const _active = 'active';
  static const _history = 'history';
  static const _settings = 'settings';

  String _tab = _active;
  bool _autoRevokeUnused = true;
  bool _warnUnlimited = true;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tokenApprovalControllerProvider);
    return controllerAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được phê duyệt token',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(tokenApprovalControllerProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (controller) => _frame(
        primary: _buildPrimary(controller),
        secondary: _buildSecondary(controller),
      ),
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Phê duyệt token trên tablet',
      semanticIdentifier: 'SC-150-TABLET',
      title: 'Phê duyệt token',
      subtitle: 'Kiểm tra quyền truy cập trước khi thu hồi',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(TokenApprovalController controller) {
    final snapshot = controller.state.snapshot;
    return Column(
      key: WalletTokenApprovalTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _securityOverview(snapshot),
        VitPageSection(
          label: 'Danh mục quyền truy cập',
          headerIcon: Icons.shield_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitTabBar(
              tabs: const [
                VitTabItem(key: _active, label: 'Hoạt động'),
                VitTabItem(key: _history, label: 'Lịch sử'),
                VitTabItem(key: _settings, label: 'Cài đặt'),
              ],
              activeKey: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
              variant: VitTabBarVariant.pill,
            ),
          ],
        ),
        switch (_tab) {
          _history => _historyContent(snapshot),
          _settings => _settingsContent(),
          _ => _activeContent(controller),
        },
      ],
    );
  }

  Widget _securityOverview(WalletTokenApprovalSnapshot snapshot) {
    return VitCard(
      variant: VitCardVariant.hero,
      child: Row(
        children: [
          const Icon(
            Icons.security_outlined,
            color: AppColors.accent,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng quan phê duyệt token'),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${snapshot.approvals.length} quyền đang hoạt động',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${snapshot.criticalCount}',
                style: AppTextStyles.amountSm.copyWith(color: AppColors.sell),
              ),
              Text(
                'Rủi ro nghiêm trọng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeContent(TokenApprovalController controller) {
    final snapshot = controller.state.snapshot;
    final approvals = snapshot.riskSortedApprovals;
    return VitPageSection(
      label: 'Quyền đang hoạt động',
      headerIcon: Icons.lock_open_outlined,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.form,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Rà soát rủi ro trước khi thu hồi',
          message:
              'Xem trước bên chi tiêu, token, hạn mức, phí gas và tác động. Không thể hoàn tác sau khi xác nhận trên chuỗi.',
          contractId: 'Phê duyệt token',
          density: VitDensity.compact,
        ),
        for (final approval in approvals) _approvalCard(controller, approval),
        VitCtaButton(
          key: WalletTokenApprovalTabletPage.revokeAllKey,
          onPressed: approvals.isEmpty
              ? null
              : () => _showRevokeSheet(controller, null),
          variant: VitCtaButtonVariant.danger,
          leading: const Icon(Icons.delete_outline_rounded),
          child: const Text('Thu hồi tất cả quyền rủi ro cao'),
        ),
        const VitCard(
          variant: VitCardVariant.ghost,
          child: Text(
            'Hợp đồng thông minh có thể sử dụng quyền đã cấp. Thu hồi các quyền không còn cần thiết để giảm rủi ro tài sản.',
          ),
        ),
      ],
    );
  }

  Widget _approvalCard(
    TokenApprovalController controller,
    WalletTokenApproval approval,
  ) {
    return VitCard(
      key: WalletTokenApprovalTabletPage.approvalKey(approval.id),
      variant: VitCardVariant.inner,
      onTap: () => _showRevokeSheet(controller, approval),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _riskIcon(approval.riskLevel),
            color: _riskColor(approval.riskLevel),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(approval.token)),
                    VitStatusPill(
                      label: _riskLabel(approval.riskLevel),
                      status: _riskStatus(approval.riskLevel),
                      icon: _riskIcon(approval.riskLevel),
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${approval.spenderName} · ${approval.maskedSpender}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Hạn mức: ${approval.amountLabel} · Dùng lần cuối: ${approval.lastUsedLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          IconButton(
            key: WalletTokenApprovalTabletPage.revokeKey(approval.id),
            tooltip: 'Xem trước thu hồi ${approval.token}',
            onPressed: () => _showRevokeSheet(controller, approval),
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  Widget _historyContent(WalletTokenApprovalSnapshot snapshot) {
    return VitPageSection(
      label: 'Lịch sử thu hồi',
      headerIcon: Icons.history_rounded,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.form,
      children: [
        for (final item in snapshot.revokedApprovals)
          VitCard(
            variant: VitCardVariant.inner,
            child: VitInfoRow(
              label: '${item.token} · ${item.spenderName}',
              value: item.revokedAtLabel,
              leading: const Icon(Icons.verified_user_outlined),
              density: VitDensity.compact,
              showDivider: false,
            ),
          ),
      ],
    );
  }

  Widget _settingsContent() {
    return VitPageSection(
      label: 'Cài đặt bảo mật',
      headerIcon: Icons.settings_outlined,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.form,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          child: Column(
            children: [
              SwitchListTile.adaptive(
                value: _autoRevokeUnused,
                onChanged: (value) => setState(() => _autoRevokeUnused = value),
                title: const Text('Tự thu hồi quyền không sử dụng'),
                subtitle: const Text('Yêu cầu xem trước trước khi thực hiện.'),
              ),
              SwitchListTile.adaptive(
                value: _warnUnlimited,
                onChanged: (value) => setState(() => _warnUnlimited = value),
                title: const Text('Cảnh báo quyền không giới hạn'),
                subtitle: const Text(
                  'Hiển thị cảnh báo trong danh sách rủi ro.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondary(TokenApprovalController controller) {
    final snapshot = controller.state.snapshot;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          child: Column(
            children: [
              VitInfoRow(
                label: 'Quyền rủi ro cao',
                value: '${snapshot.highRiskCount}',
                leading: const Icon(Icons.warning_amber_rounded),
                valueColor: AppColors.caution,
                density: VitDensity.compact,
                showDivider: true,
              ),
              VitInfoRow(
                label: 'Quyền không giới hạn',
                value: '${snapshot.unlimitedCount}',
                leading: const Icon(Icons.all_inclusive_rounded),
                valueColor: AppColors.sell,
                density: VitDensity.compact,
                showDivider: true,
              ),
              VitInfoRow(
                label: 'Quyền chưa sử dụng',
                value: '${snapshot.unusedCount}',
                leading: const Icon(Icons.hourglass_empty_rounded),
                valueColor: AppColors.primary,
                density: VitDensity.compact,
                showDivider: false,
              ),
            ],
          ),
        ),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Không xác nhận vội',
          message:
              'Mỗi lần thu hồi cần xem lại tác động và phí mạng. Chỉ tiếp tục khi bạn hiểu rõ quyền sẽ bị gỡ.',
          contractId: 'SC-150',
          density: VitDensity.compact,
        ),
      ],
    );
  }

  void _showRevokeSheet(
    TokenApprovalController controller,
    WalletTokenApproval? approval,
  ) {
    final preview = controller.revokePreview(approval);
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        builder: (sheetContext) => _revokeSheet(sheetContext, preview),
      ),
    );
  }

  Widget _revokeSheet(BuildContext sheetContext, TokenRevokePreview preview) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(preview.title, style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(preview.body),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Bước xem trước bắt buộc',
              message:
                  'Kiểm tra đúng bên chi tiêu, token, hạn mức, phí gas và tác động trước khi ký.',
              contractId: 'Thu hồi quyền token',
              density: VitDensity.compact,
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    key: WalletTokenApprovalTabletPage.revokeSheetCancelKey,
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    variant: VitCtaButtonVariant.secondary,
                    child: const Text('Xem lại sau'),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: VitCtaButton(
                    key: WalletTokenApprovalTabletPage.revokeSheetConfirmKey,
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      unawaited(
                        showVitNoticeSheet(
                          context: context,
                          title: 'Đã ghi nhận yêu cầu thu hồi',
                          message:
                              'Yêu cầu cần được ký và phát sóng sau khi kiểm tra phí mạng.',
                        ),
                      );
                    },
                    variant: VitCtaButtonVariant.danger,
                    child: Text(preview.confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _riskColor(String risk) => switch (risk) {
    'critical' => AppColors.sell,
    'high' => AppColors.riskHigh,
    'medium' => AppColors.caution,
    'low' => AppColors.buy,
    _ => AppColors.text3,
  };

  IconData _riskIcon(String risk) => switch (risk) {
    'critical' => Icons.report_gmailerrorred_rounded,
    'high' => Icons.warning_amber_rounded,
    'medium' => Icons.info_outline_rounded,
    'low' => Icons.verified_user_outlined,
    _ => Icons.shield_outlined,
  };

  VitStatusPillStatus _riskStatus(String risk) => switch (risk) {
    'critical' => VitStatusPillStatus.error,
    'high' => VitStatusPillStatus.orange,
    'medium' => VitStatusPillStatus.warning,
    'low' => VitStatusPillStatus.success,
    _ => VitStatusPillStatus.neutral,
  };

  String _riskLabel(String risk) => switch (risk) {
    'critical' => 'Nghiêm trọng',
    'high' => 'Cao',
    'medium' => 'Trung bình',
    'low' => 'Thấp',
    _ => 'Chưa phân loại',
  };
}
