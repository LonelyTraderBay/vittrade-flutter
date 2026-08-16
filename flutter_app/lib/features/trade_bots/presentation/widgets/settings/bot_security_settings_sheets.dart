part of '../../phone/pages/settings/bot_security_settings_page.dart';

class _ApiKeySheet extends StatefulWidget {
  const _ApiKeySheet({required this.snapshot});

  final TradeBotSecuritySettingsSnapshot snapshot;

  @override
  State<_ApiKeySheet> createState() => _ApiKeySheetState();
}

class _ApiKeySheetState extends State<_ApiKeySheet> {
  bool _generated = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final keyText = widget.snapshot.generatedApiKeyPreview;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        MediaQuery.paddingOf(context).bottom + AppSpacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tạo API Key',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const _SheetInput(label: 'Tên Key', hint: 'VD: Key Bot giao dịch'),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Quyền truy cập',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          const Row(
            children: [
              Expanded(child: _PermissionChip('Chỉ đọc')),
              SizedBox(width: AppSpacing.x2),
              Expanded(child: _PermissionChip('Giao dịch + Đọc')),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          if (_generated)
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.tight,
              density: VitDensity.tool,
              borderColor: _securityGreen.withValues(alpha: .2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Đã khởi tạo API Key',
                    style: AppTextStyles.caption.copyWith(
                      color: _securityGreen,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  VitCard(
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.tight,
                    density: VitDensity.tool,
                    borderColor: AppColors.borderSolid,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _visible ? keyText : '********************',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.monoCode.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        VitIconButton(
                          icon: _visible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          tooltip: _visible ? 'Ẩn API key' : 'Hiện API key',
                          size: VitIconButtonSize.sm,
                          variant: VitIconButtonVariant.transparent,
                          onPressed: () => setState(() => _visible = !_visible),
                        ),
                        const Icon(
                          Icons.copy_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Lưu key này ngay - bạn sẽ không thể xem lại được nữa.',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            )
          else
            VitCtaButton(
              onPressed: () => setState(() => _generated = true),
              density: VitDensity.tool,
              variant: VitCtaButtonVariant.primary,
              child: const Text('Khởi tạo API Key'),
            ),
        ],
      ),
    );
  }
}

class _IpSheet extends StatelessWidget {
  const _IpSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        MediaQuery.paddingOf(context).bottom + AppSpacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thêm IP vào danh sách cho phép',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const _SheetInput(label: 'Địa chỉ IP', hint: 'VD: 192.168.1.100'),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const _SheetInput(label: 'Nhãn (Tùy chọn)', hint: 'VD: Mạng tại nhà'),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            density: VitDensity.tool,
            variant: VitCtaButtonVariant.primary,
            child: const Text('Thêm địa chỉ IP'),
          ),
        ],
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        VitCard(
          radius: VitCardRadius.tight,
          density: VitDensity.tool,
          alignment: Alignment.centerLeft,
          variant: VitCardVariant.inner,
          borderColor: AppColors.borderSolid,
          child: Text(
            hint,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
