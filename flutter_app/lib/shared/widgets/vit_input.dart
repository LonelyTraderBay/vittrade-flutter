import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Standard text field surface: label, prefix/suffix slots, error text, and
/// accessible semantics label/hint driven by [label]/[errorText].
///
/// The field border highlights with [AppInputStates.focusInputBorder] while
/// focused (Tablet-Input-Standard I2) — a stateful border, not an overlay, so
/// the caret remains the only bright element inside the field. An error
/// border wins over the focus border.
class VitInput extends StatefulWidget {
  const VitInput({
    super.key,
    required this.controller,
    this.fieldKey,
    this.focusNode,
    this.label,
    this.semanticLabel,
    this.hintText,
    this.prefix,
    this.suffix,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final String? label;
  final String? semanticLabel;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<VitInput> createState() => _VitInputState();
}

class _VitInputState extends State<VitInput> {
  FocusNode? _internalNode;
  bool _focused = false;

  FocusNode get _effectiveNode =>
      widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(VitInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldNode = oldWidget.focusNode ?? _internalNode;
    final newNode = widget.focusNode ?? _internalNode;
    if (oldNode != newNode) {
      oldNode?.removeListener(_handleFocusChanged);
      newNode?.addListener(_handleFocusChanged);
      _handleFocusChanged();
    }
  }

  @override
  void dispose() {
    _internalNode?.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    final focused = _effectiveNode.hasFocus;
    if (focused != _focused) {
      setState(() => _focused = focused);
    }
  }

  bool get _hasError => widget.errorText != null;

  bool get _showErrorText =>
      widget.errorText != null && widget.errorText!.trim().isNotEmpty;

  String? get _resolvedSemanticLabel {
    final parts = <String>[];
    final explicit = widget.semanticLabel?.trim();
    final visual = widget.label?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      parts.add(explicit);
    } else if (visual != null && visual.isNotEmpty) {
      parts.add(visual);
    }
    if (_showErrorText) {
      parts.add('Error: ${widget.errorText!.trim()}');
    }
    return parts.isEmpty ? null : parts.join('. ');
  }

  String? get _resolvedSemanticHint {
    if (_showErrorText) return widget.errorText!.trim();
    final hint = widget.hintText?.trim();
    return hint == null || hint.isEmpty ? null : hint;
  }

  @override
  Widget build(BuildContext context) {
    final input = SizedBox(
      height: AppSpacing.inputHeight,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.surface2,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: _hasError
                  ? AppColors.sell
                  : _focused
                  ? AppInputStates.focusInputBorder
                  : AppColors.borderSolid,
              width: AppSpacing.borderWidth,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x4,
          ),
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                IconTheme(
                  data: const IconThemeData(
                    color: AppColors.text3,
                    size: AppSpacing.inputPrefixIcon,
                  ),
                  child: widget.prefix!,
                ),
                const SizedBox(width: AppSpacing.x3),
              ],
              Expanded(
                child: TextField(
                  key: widget.fieldKey,
                  controller: widget.controller,
                  focusNode: _effectiveNode,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  inputFormatters: widget.inputFormatters,
                  autofillHints: widget.autofillHints,
                  textAlign: widget.textAlign,
                  cursorColor: AppColors.primary,
                  style: widget.textStyle ?? AppTextStyles.control,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.control.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
              ),
              if (widget.suffix != null) ...[
                const SizedBox(width: AppSpacing.x3),
                widget.suffix!,
              ],
            ],
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.formFieldLabelGap),
        ],
        Semantics(
          textField: true,
          label: _resolvedSemanticLabel,
          hint: _resolvedSemanticHint,
          enabled: widget.enabled,
          child: input,
        ),
        if (_showErrorText) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            widget.errorText!,
            style: AppTextStyles.micro.copyWith(color: AppColors.sell),
          ),
        ],
      ],
    );
  }
}
