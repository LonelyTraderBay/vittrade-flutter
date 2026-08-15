import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Web-owned composition for authentication and verification screens.
///
/// The page owns the Web form hierarchy and imports no Phone or Tablet UI.
/// Authentication policy and route contracts remain in shared application
/// layers.
class AuthWebPage extends StatelessWidget {
  const AuthWebPage({
    super.key,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.actionLabel,
    this.fields = const <AuthWebField>[],
  });

  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final String description;
  final String actionLabel;
  final List<AuthWebField> fields;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: '$title trên Web',
      semanticIdentifier: '$semanticIdentifier-WEB',
      child: Column(
        children: [
          VitHeader(title: title, subtitle: subtitle, showBack: false),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.form,
                    padding: VitContentPadding.relaxed,
                    density: VitDensity.relaxed,
                    children: [
                      VitCard(
                        variant: VitCardVariant.hero,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.primary,
                              size: AppSpacing.iconLg,
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Expanded(
                              child: Text(
                                description,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.text1,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VitCard(
                        variant: VitCardVariant.inner,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final field in fields) ...[
                              TextFormField(
                                obscureText: field.obscureText,
                                decoration: InputDecoration(
                                  labelText: field.label,
                                  hintText: field.hint,
                                ),
                              ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmFormInnerGap,
                              ),
                            ],
                            VitCtaButton(
                              leading: const Icon(Icons.arrow_forward_rounded),
                              onPressed: () => _showNotice(context),
                              child: Text(actionLabel),
                            ),
                          ],
                        ),
                      ),
                      const VitCard(
                        variant: VitCardVariant.ghost,
                        child: Text(
                          'Không chia sẻ mã xác thực hoặc mật khẩu. VitTrade không yêu cầu gửi thông tin bảo mật qua kênh không tin cậy.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showNotice(BuildContext context) {
    return showVitNoticeSheet(
      context: context,
      title: 'Đã kiểm tra thông tin',
      message:
          'Luồng xác thực Web sẽ tiếp tục sau khi hệ thống kiểm tra điều kiện bảo mật.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

class AuthWebField {
  const AuthWebField({
    required this.label,
    this.hint,
    this.obscureText = false,
  });

  final String label;
  final String? hint;
  final bool obscureText;
}
