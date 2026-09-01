import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';

const addressAddBackground = AppColors.bg;
const addressAddPanel = AppColors.surface;
const addressAddPanel2 = AppColors.surface2;
const addressAddPrimary = AppColors.primary;
const addressAddGreen = AppColors.buy;
const addressAddAmber = AppColors.caution;
const addressAddRed = AppColors.sell;

class AddressFieldSection extends StatelessWidget {
  const AddressFieldSection({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.optionalText,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddressFieldLabel(
          label: label,
          required: required,
          optionalText: optionalText,
        ),
        SizedBox(height: AppSurfaceSpacing.formFieldLabelGap),
        child,
      ],
    );
  }
}

class AddressFieldLabel extends StatelessWidget {
  const AddressFieldLabel({
    super.key,
    required this.label,
    this.required = false,
    this.optionalText,
  });

  final String label;
  final bool required;
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            TextSpan(
              text: ' *',
              style: AppTextStyles.caption.copyWith(color: addressAddRed),
            ),
          if (optionalText != null)
            TextSpan(
              text: ' $optionalText',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.normal,
              ),
            ),
        ],
      ),
    );
  }
}

class AddressTextInput extends StatelessWidget {
  const AddressTextInput({
    super.key,
    this.fieldKey,
    required this.semanticLabel,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLength,
  });

  final Key? fieldKey;
  final String semanticLabel;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: fieldKey,
      semanticLabel: semanticLabel,
      controller: controller,
      hintText: hintText,
      inputFormatters: maxLength == null
          ? null
          : [LengthLimitingTextInputFormatter(maxLength!)],
      textInputAction: TextInputAction.next,
      onChanged: (_) => onChanged(),
    );
  }
}

class AddressWalletInput extends StatelessWidget {
  const AddressWalletInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: const Key('sc143_address_address_field'),
      semanticLabel: 'Địa chỉ ví',
      controller: controller,
      hintText: 'Nhập hoặc dán địa chỉ...',
      textInputAction: TextInputAction.next,
      onChanged: (_) => onChanged(),
      suffix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddressIconCircleButton(
            semanticLabel: 'Dán địa chỉ ví',
            icon: Icons.content_paste_rounded,
            onTap: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              final text = data?.text;
              if (text == null || text.isEmpty) return;
              controller.text = text;
              onChanged();
            },
          ),
          SizedBox(width: AppSurfaceSpacing.x2),
          AddressIconCircleButton(
            semanticLabel: 'Quét mã QR địa chỉ ví',
            icon: Icons.qr_code_scanner_rounded,
            onTap: () => unawaited(
              showVitNoticeSheet(
                context: context,
                title: 'Sắp ra mắt',
                message: 'Quét QR sẽ mở khi trình quét ví được kết nối',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressIconCircleButton extends StatelessWidget {
  const AddressIconCircleButton({
    super.key,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  final String semanticLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: icon,
      tooltip: semanticLabel,
      onPressed: onTap,
      size: VitIconButtonSize.sm,
      variant: VitIconButtonVariant.transparent,
    );
  }
}

class AddressPrimaryActionButton extends StatelessWidget {
  const AddressPrimaryActionButton({
    super.key,
    required this.enabled,
    required this.label,
    this.semanticLabel,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final String? semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: VitCtaButton(
        onPressed: enabled ? onTap : null,
        height: AppSurfaceSpacing.inputHeight,
        child: Text(label),
      ),
    );
  }
}

String maskWalletAddress(String address) =>
    maskAddress(address, head: 16, tail: 8);
