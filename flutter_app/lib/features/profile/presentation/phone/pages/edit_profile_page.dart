import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

const _editBackground = AppColors.bg;
const _editPrimary = AppColors.primary;
const _editMuted = AppColors.text3;

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc157_edit_profile_content');
  static const cameraKey = Key('sc157_edit_profile_camera');
  static const fullNameFieldKey = Key('sc157_edit_profile_full_name');
  static const phoneFieldKey = Key('sc157_edit_profile_phone');
  static const saveKey = Key('sc157_edit_profile_save');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  bool _saving = false;
  bool _cameraSelected = false;

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileEditSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      semanticLabel: 'Chỉnh sửa hồ sơ cá nhân',
      semanticIdentifier: 'SC-157',
      background: _editBackground,
      header: VitHeader(
        title: 'Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1',
        subtitle: 'Ch\u1EC9nh s\u1EEDa \u00B7 T\u00E0i kho\u1EA3n',
        showBack: true,
        onBack: _close,
      ),
      body: SingleChildScrollView(
        key: EditProfilePage.contentKey,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.contentPad,
          AppSpacing.x3,
          AppSpacing.contentPad,
          scrollClearance,
        ),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.none,
          density: VitDensity.compact,
          fullBleed: true,
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title:
                    'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c d\u1EEF li\u1EC7u',
                message: 'Vui l\u00F2ng th\u1EED l\u1EA1i.',
                actionLabel: 'Th\u1EED l\u1EA1i',
                onAction: () => ref.invalidate(profileEditSnapshotProvider),
              ),
            ],
            data: (snapshot) {
              _nameController ??= TextEditingController(
                text: snapshot.user.fullName,
              );
              _emailController ??= TextEditingController(
                text: snapshot.user.email,
              );
              _phoneController ??= TextEditingController(
                text: snapshot.user.phone,
              );
              final nameController = _nameController!;
              final emailController = _emailController!;
              final phoneController = _phoneController!;
              return [
                VitCard(
                  density: VitDensity.compact,
                  child: _AvatarEditor(
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
                      _EditProfileField(
                        label: 'H\u1ECC V\u00C0 T\u00CAN',
                        controller: nameController,
                        keyValue: EditProfilePage.fullNameFieldKey,
                        onChanged: (_) => setState(() {}),
                      ),
                      _EditProfileField(
                        label: 'EMAIL',
                        controller: emailController,
                        readOnly: true,
                        note: 'Email kh\u00F4ng th\u1EC3 thay \u0111\u1ED5i',
                        muted: true,
                      ),
                      _EditProfileField(
                        label: 'S\u1ED0 \u0110I\u1EC6N THO\u1EA0I',
                        controller: phoneController,
                        keyValue: EditProfilePage.phoneFieldKey,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                VitCard(
                  density: VitDensity.compact,
                  padding: ProfileSpacingTokens.profileEditActionPadding,
                  child: KeyedSubtree(
                    key: EditProfilePage.saveKey,
                    child: VitCtaButton(
                      variant: VitCtaButtonVariant.auth,
                      density: VitDensity.compact,
                      loading: _saving,
                      onPressed: _canSave ? _save : null,
                      leading: const Icon(Icons.save_rounded),
                      child: Text(
                        _saving
                            ? '\u0110ang l\u01B0u...'
                            : 'L\u01B0u thay \u0111\u1ED5i',
                      ),
                    ),
                  ),
                ),
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title:
                      'X\u00E1c nh\u1EADn thay \u0111\u1ED5i h\u1ED3 s\u01A1',
                  message:
                      'Ki\u1EC3m tra h\u1ECD t\u00EAn, s\u1ED1 \u0111i\u1EC7n tho\u1EA1i v\u00E0 \u1EA3nh \u0111\u1EA1i di\u1EC7n tr\u01B0\u1EDBc khi l\u01B0u.',
                  density: VitDensity.compact,
                ),
              ];
            },
          ),
        ),
      ),
    );
  }

  bool get _canSave =>
      (_nameController?.text.trim().isNotEmpty ?? false) &&
      (_phoneController?.text.trim().isNotEmpty ?? false) &&
      !_saving;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    _close();
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
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
              accentColor: _editPrimary,
              size: AppSpacing.x7 + AppSpacing.x5,
              radius: AppRadii.cardLargeRadius,
              border: true,
            ),
            Positioned(
              right: ProfileSpacingTokens.profileEditCameraOffsetEnd,
              bottom: ProfileSpacingTokens.profileEditCameraOffsetBottom,
              child: VitIconButton(
                key: EditProfilePage.cameraKey,
                icon: selected
                    ? Icons.check_rounded
                    : Icons.photo_camera_outlined,
                tooltip: '\u0110\u1ED5i \u1EA3nh \u0111\u1EA1i di\u1EC7n',
                onPressed: onTap,
                variant: selected
                    ? VitIconButtonVariant.success
                    : VitIconButtonVariant.primary,
                size: VitIconButtonSize.sm,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'Nh\u1EA5n v\u00E0o bi\u1EC3u t\u01B0\u1EE3ng camera \u0111\u1EC3 thay \u0111\u1ED5i',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: _editMuted),
        ),
      ],
    );
  }
}

class _EditProfileField extends StatelessWidget {
  const _EditProfileField({
    required this.label,
    required this.controller,
    this.keyValue,
    this.note,
    this.readOnly = false,
    this.muted = false,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final Key? keyValue;
  final String? note;
  final bool readOnly;
  final bool muted;
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
        const SizedBox(height: AppSpacing.x1),
        VitInput(
          fieldKey: keyValue,
          controller: controller,
          semanticLabel: label,
          enabled: !readOnly,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(note!, style: AppTextStyles.micro.copyWith(color: _editMuted)),
        ],
      ],
    );
  }
}
