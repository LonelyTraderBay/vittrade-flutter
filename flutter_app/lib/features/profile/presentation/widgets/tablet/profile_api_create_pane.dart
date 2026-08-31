import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'profile_api_create_pane_sections.dart';

/// Tablet create-API-key detail pane (SC-162) for the Profile master-detail
/// shell — a public port of the phone `ApiKeyCreatePage`'s three-step flow
/// (form → confirm → one-time result) into [ProfilePaneScaffold], per R2:
/// the phone page and its `part` family stay untouched. Same
/// [profileApiKeyCreateSnapshotProvider] data. Opened from the API pane's
/// header "+" action; the result CTA returns to the API list pane in place.
class ProfileApiCreatePane extends ConsumerStatefulWidget {
  const ProfileApiCreatePane({super.key});

  @override
  ConsumerState<ProfileApiCreatePane> createState() =>
      _ProfileApiCreatePaneState();
}

enum _ApiCreateStep { form, confirm, result }

class _ProfileApiCreatePaneState extends ConsumerState<ProfileApiCreatePane> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  Set<String> _permissions = const {'read'};
  final List<String> _ips = [];
  String _expiry = 'none';
  _ApiCreateStep _step = _ApiCreateStep.form;

  bool get _canProceed => _nameController.text.trim().length >= 3;

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileApiKeyCreateSnapshotProvider);

    return ProfilePaneScaffold(
      title: switch (_step) {
        _ApiCreateStep.confirm => 'Xác nhận tạo API Key',
        _ApiCreateStep.result => 'API Key đã tạo',
        _ => 'Tạo API Key mới',
      },
      subtitle: 'API · quyền · an toàn',
      onBack: _onBack,
      scrollKey: ProfileTabletKeys.apiCreatePane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.apiCreatePaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(profileApiKeyCreateSnapshotProvider),
          ),
        ],
        data: (snapshot) => switch (_step) {
          _ApiCreateStep.confirm => _confirmChildren(snapshot),
          _ApiCreateStep.result => _resultChildren,
          _ => _formChildren(snapshot),
        },
      ),
    );
  }

  void _onBack() {
    if (_step == _ApiCreateStep.confirm) {
      setState(() => _step = _ApiCreateStep.form);
      return;
    }
    context.go(AppRoutePaths.profile);
  }

  List<Widget> _formChildren(ProfileApiKeyCreateSnapshot snapshot) {
    return [
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Rà soát phạm vi API key',
        message:
            'Chỉ cấp quyền tối thiểu, thiết lập IP whitelist, chọn thời hạn '
            'và xác nhận cách lưu secret trước khi tạo.',
        density: VitDensity.compact,
      ),
      _CreateFieldSection(
        label: 'Tên API Key',
        required: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitInput(
              fieldKey: ProfileTabletKeys.apiCreateNameField,
              controller: _nameController,
              semanticLabel: 'Tên API Key',
              hintText: 'VD: Trading Bot Alpha, Portfolio Tracker...',
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Text(
                  'Tối thiểu 3 ký tự',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: AppSpacing.x4),
                const Expanded(child: SizedBox.shrink()),
                Text(
                  '${_nameController.text.length}/30',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
      _CreateFieldSection(
        label: 'Quyền truy cập',
        required: true,
        child: Column(
          children: [
            for (final permission in snapshot.permissions) ...[
              _PermissionCard(
                permission: permission,
                selected: _permissions.contains(permission.id),
                onTap: () => _togglePermission(permission.id),
              ),
              if (permission != snapshot.permissions.last)
                const SizedBox(height: AppSpacing.x4),
            ],
          ],
        ),
      ),
      _CreateFieldSection(
        label: 'IP Whitelist',
        optional: 'khuyến nghị',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: VitInput(
                    fieldKey: ProfileTabletKeys.apiCreateIpField,
                    controller: _ipController,
                    semanticLabel: 'Danh sách IP được phép',
                    hintText: 'VD: 192.168.1.100',
                    onSubmitted: (_) => _addIp(),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                SizedBox(
                  width: ProfileSpacingTokens.profileApiCreateIpAddWidth,
                  child: VitIconButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Thêm IP whitelist',
                    onPressed: _addIp,
                    variant: VitIconButtonVariant.primary,
                    size: VitIconButtonSize.lg,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            if (_ips.isEmpty)
              Text(
                'Không có IP whitelist — key có thể được dùng từ bất kỳ đâu',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              Wrap(
                spacing: ProfileSpacingTokens.profileApiCreateIpChipGap,
                runSpacing: ProfileSpacingTokens.profileApiCreateIpChipGap,
                children: [
                  for (final ip in _ips)
                    VitChoicePill(
                      label: ip,
                      selected: true,
                      onTap: () => setState(() => _ips.remove(ip)),
                      tone: VitChoicePillTone.success,
                      height: AppSpacing.buttonCompact,
                      padding:
                          ProfileSpacingTokens.profileApiCreateIpChipPadding,
                    ),
                ],
              ),
          ],
        ),
      ),
      _CreateFieldSection(
        label: 'Thời hạn',
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                ProfileSpacingTokens.profileApiCreateExpiryCrossAxisCount,
            mainAxisSpacing: ProfileSpacingTokens.profileApiCreateExpirySpacing,
            crossAxisSpacing:
                ProfileSpacingTokens.profileApiCreateExpirySpacing,
            mainAxisExtent:
                ProfileSpacingTokens.profileApiCreateTabletExpiryExtent,
          ),
          itemCount: snapshot.expiryOptions.length,
          itemBuilder: (context, index) {
            final option = snapshot.expiryOptions[index];
            final isSelected = option.id == _expiry;
            return VitCard(
              key: ProfileTabletKeys.apiCreateExpiry(option.id),
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _expiry = option.id);
              },
              density: VitDensity.compact,
              variant: isSelected
                  ? VitCardVariant.standard
                  : VitCardVariant.inner,
              borderColor: isSelected
                  ? AppColors.primary.withValues(alpha: .34)
                  : AppColors.cardBorder,
              padding: ProfileSpacingTokens.profileApiCreateExpiryPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.text2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    option.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      _SecurityTipsCard(tips: snapshot.securityTips),
      VitCtaButton(
        key: ProfileTabletKeys.apiCreateContinue,
        onPressed: _canProceed
            ? () => setState(() => _step = _ApiCreateStep.confirm)
            : null,
        variant: VitCtaButtonVariant.auth,
        density: VitDensity.compact,
        child: const Text('Tiếp tục'),
      ),
    ];
  }

  List<Widget> _confirmChildren(ProfileApiKeyCreateSnapshot snapshot) {
    final permissionLabels = snapshot.permissions
        .where((permission) => _permissions.contains(permission.id))
        .map((permission) => permission.label)
        .join(', ');
    final expiry = snapshot.expiryOptions.firstWhere(
      (option) => option.id == _expiry,
      orElse: () => snapshot.expiryOptions.first,
    );

    return [
      _CreateSummaryCard(
        rows: [
          ProfileInfoRow(
            label: 'Tên API Key',
            value: _nameController.text.trim(),
          ),
          ProfileInfoRow(label: 'Quyền truy cập', value: permissionLabels),
          ProfileInfoRow(
            label: 'IP Whitelist',
            value: _ips.isEmpty ? 'Không giới hạn' : _ips.join(', '),
          ),
          ProfileInfoRow(label: 'Thời hạn', value: expiry.label),
        ],
      ),
      if (_ips.isEmpty)
        const _CreateWarningCard(
          text: 'Key không giới hạn IP. Khuyến nghị thêm IP whitelist.',
        ),
      VitCtaButton(
        key: ProfileTabletKeys.apiCreateConfirm,
        onPressed: () => setState(() => _step = _ApiCreateStep.result),
        variant: VitCtaButtonVariant.auth,
        density: VitDensity.compact,
        child: const Text('Tạo API Key'),
      ),
    ];
  }

  List<Widget> get _resultChildren => [
    const _CreateWarningCard(
      text: 'Secret Key chỉ hiển thị một lần duy nhất. Hãy lưu ngay.',
      tone: _CreateWarningTone.danger,
    ),
    const _KeyResultCard(label: 'API Key', value: 'vt_live_demo_7h3k9m2p4x8q'),
    const _KeyResultCard(label: 'Secret Key', value: 'sk_live_demo_only_once'),
    const _ApiCreateDoneButton(),
  ];

  void _togglePermission(String id) {
    if (id == 'read') return;
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      final next = {..._permissions};
      if (next.contains(id)) {
        next.remove(id);
      } else {
        next.add(id);
      }
      _permissions = next;
    });
  }

  void _addIp() {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) return;
    if (!_ips.contains(ip)) {
      unawaited(HapticFeedback.selectionClick());
      setState(() => _ips.add(ip));
    }
    _ipController.clear();
  }
}

/// Wraps the "Đã lưu, quay lại" CTA with the in-shell navigation — kept out
/// of the static children list because it needs the route helper.
