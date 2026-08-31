import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet edit-profile detail pane (SC-157) for the Profile master-detail
/// shell — a public port of the phone `EditProfilePage`'s content (avatar
/// editor with camera toggle, name/email/phone fields with the email locked
/// to read-only, save CTA gated on valid input, risk-review panel) into
/// [ProfilePaneScaffold], per R2: the phone page and its `part` family stay
/// untouched. Same [profileEditSnapshotProvider] data; saving returns to the
/// overview pane like the phone page pops back to the profile.
class ProfileEditPane extends ConsumerStatefulWidget {
  const ProfileEditPane({super.key});

  @override
  ConsumerState<ProfileEditPane> createState() => _ProfileEditPaneState();
}

class _ProfileEditPaneState extends ConsumerState<ProfileEditPane> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  bool _cameraSelected = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  bool get _canSave =>
      (_nameController?.text.trim().isNotEmpty ?? false) &&
      (_phoneController?.text.trim().isNotEmpty ?? false) &&
      !_saving;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileEditSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Chỉnh sửa hồ sơ',
      subtitle: 'Thông tin cá nhân · liên hệ',
      onBack: () => context.go(AppRoutePaths.profile),
      scrollKey: ProfileTabletKeys.editPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 4)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.editPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(profileEditSnapshotProvider),
          ),
        ],
        data: (snapshot) {
          _nameController ??= TextEditingController(
            text: snapshot.user.fullName,
          );
          _emailController ??= TextEditingController(text: snapshot.user.email);
          _phoneController ??= TextEditingController(text: snapshot.user.phone);
          return [
            VitCard(
              density: VitDensity.compact,
              child: _PaneAvatarEditor(
                initial: snapshot.user.fullName.substring(0, 1),
                selected: _cameraSelected,
                onTap: () {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _cameraSelected = !_cameraSelected);
                },
              ),
            ),
            VitCard(
              density: VitDensity.compact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PaneEditField(
                    label: 'HỌ VÀ TÊN',
                    controller: _nameController!,
                    keyValue: ProfileTabletKeys.editNameField,
                    onChanged: (_) => setState(() {}),
                  ),
                  _PaneEditField(
                    label: 'EMAIL',
                    controller: _emailController!,
                    readOnly: true,
                    note: 'Email không thể thay đổi',
                  ),
                  _PaneEditField(
                    label: 'SỐ ĐIỆN THOẠI',
                    controller: _phoneController!,
                    keyValue: ProfileTabletKeys.editPhoneField,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            VitCard(
              density: VitDensity.compact,
              padding: ProfileSpacingTokens.profileEditActionPadding,
              child: VitCtaButton(
                key: ProfileTabletKeys.editSave,
                variant: VitCtaButtonVariant.auth,
                density: VitDensity.compact,
                loading: _saving,
                onPressed: _canSave ? _save : null,
                leading: const Icon(Icons.save_rounded),
                child: Text(_saving ? 'Đang lưu...' : 'Lưu thay đổi'),
              ),
            ),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xác nhận thay đổi hồ sơ',
              message:
                  'Kiểm tra họ tên, số điện thoại và ảnh đại diện trước khi lưu.',
              density: VitDensity.compact,
            ),
          ];
        },
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    // Phone parity: saving pops back to the profile — on tablet that means
    // returning to the overview pane inside the shell.
    context.go(AppRoutePaths.profile);
  }
}

class _PaneAvatarEditor extends StatelessWidget {
  const _PaneAvatarEditor({
    required this.initial,
    required this.selected,
    required this.onTap,
  });

  final String initial;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            VitAssetAvatar(
              label: initial,
              accentColor: AppColors.primary,
              size: AppSpacing.x7 + AppSpacing.x5,
              radius: AppRadii.cardLargeRadius,
              border: true,
            ),
            Positioned(
              right: ProfileSpacingTokens.profileEditCameraOffsetEnd,
              bottom: ProfileSpacingTokens.profileEditCameraOffsetBottom,
              child: VitIconButton(
                key: ProfileTabletKeys.editCamera,
                icon: selected
                    ? Icons.check_rounded
                    : Icons.photo_camera_outlined,
                tooltip: 'Đổi ảnh đại diện',
                onPressed: onTap,
                variant: selected
                    ? VitIconButtonVariant.success
                    : VitIconButtonVariant.primary,
                size: VitIconButtonSize.sm,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Nhấn vào biểu tượng camera để thay đổi',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PaneEditField extends StatelessWidget {
  const _PaneEditField({
    required this.label,
    required this.controller,
    this.keyValue,
    this.note,
    this.readOnly = false,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final Key? keyValue;
  final String? note;
  final bool readOnly;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.heavy,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitInput(
          fieldKey: keyValue,
          controller: controller,
          semanticLabel: label,
          enabled: !readOnly,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.x4),
          Text(
            note!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
