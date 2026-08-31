import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const _tabletTwoFaSecret = 'JBSWY3DPEHPK3PXP';
const _tabletBackupCodes = [
  '84923-13721',
  '29381-84752',
  '56743-29187',
  '93847-65432',
  '12837-49283',
];

/// Independent Tablet composition for SC-004.
class TwoFaSetupTabletPage extends ConsumerStatefulWidget {
  const TwoFaSetupTabletPage({super.key});

  static const contentKey = Key('sc004_two_fa_content');
  static const copyKey = Key('sc004_two_fa_copy');
  static const codeFieldKey = Key('sc004_two_fa_code_field');
  static const backupSavedKey = Key('sc004_two_fa_backup_saved');
  static const submitKey = Key('sc004_two_fa_submit');

  @override
  ConsumerState<TwoFaSetupTabletPage> createState() =>
      _TwoFaSetupTabletPageState();
}

class _TwoFaSetupTabletPageState extends ConsumerState<TwoFaSetupTabletPage> {
  final _codeController = TextEditingController();
  bool _copied = false;
  bool _verified = false;
  bool _backupCodesSaved = false;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 chữ số xác minh.');
      return;
    }
    await _run(() async {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: 'user@vittrade.vn',
            code: code,
            purpose: AuthOtpPurpose.twoFactor,
          );
      if (!result.success) {
        throw StateError(result.errorMessage ?? 'Mã xác minh chưa đúng.');
      }
      if (mounted) setState(() => _verified = true);
    });
  }

  Future<void> _completeSetup() async {
    if (!_verified || !_backupCodesSaved) {
      setState(
        () => _error = 'Hãy xác nhận đã lưu mã khôi phục trước khi hoàn tất.',
      );
      return;
    }
    await _run(() async {
      final result = await ref
          .read(authControllerProvider)
          .setupTwoFactor(
            secretKey: _tabletTwoFaSecret,
            code: _codeController.text.trim(),
            backupCodesSaved: _backupCodesSaved,
          );
      if (!result.success) {
        throw StateError(
          result.errorMessage ?? 'Không thể bật xác thực hai lớp.',
        );
      }
      if (mounted) context.go(AppRoutePaths.home);
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_submitting) return;
    setState(() {
      _error = '';
      _submitting = true;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = authOperationErrorMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthTabletSurface(
      semanticLabel: 'Thiết lập xác thực hai lớp tablet',
      semanticIdentifier: 'SC-004-TABLET',
      title: _verified ? 'Lưu mã khôi phục' : 'Thiết lập xác thực hai lớp',
      subtitle: _verified
          ? 'Mã khôi phục giúp bạn lấy lại quyền truy cập'
          : 'Bảo vệ tài khoản trước khi giao dịch',
      onBack: () => context.go(AppRoutePaths.authLogin),
      child: Column(
        key: TwoFaSetupTabletPage.contentKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [if (!_verified) _setupBody() else _backupBody()],
      ),
    );
  }

  Widget _setupBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(TabletSpacingTokens.x5),
          child: Column(
            children: [
              const Icon(
                Icons.qr_code_2_rounded,
                size: 72,
                color: AppColors.primary,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              const Text(
                'Quét mã QR bằng ứng dụng xác thực của bạn.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TabletSpacingTokens.pageRhythmStandardSectionGap,
              ),
              const SelectableText(
                _tabletTwoFaSecret,
                textAlign: TextAlign.center,
                style: AppTextStyles.monoCode,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitCtaButton(
                key: TwoFaSetupTabletPage.copyKey,
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: _tabletTwoFaSecret),
                  );
                  if (mounted) setState(() => _copied = true);
                },
                fullWidth: false,
                variant: VitCtaButtonVariant.ghost,
                leading: const Icon(Icons.copy_outlined),
                child: Text(_copied ? 'Đã sao chép' : 'Sao chép mã bí mật'),
              ),
            ],
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitInput(
          controller: _codeController,
          fieldKey: TwoFaSetupTabletPage.codeFieldKey,
          label: 'Mã xác minh từ ứng dụng',
          hintText: '000000',
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        _errorWidget(),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitCtaButton(
          key: TwoFaSetupTabletPage.submitKey,
          onPressed: _submitting ? null : _verifyCode,
          loading: _submitting,
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xác minh mã'),
        ),
      ],
    );
  }

  Widget _backupBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthTabletInfoBanner(
          message:
              'Lưu các mã này ở nơi an toàn. Mỗi mã chỉ dùng được một lần.',
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(TabletSpacingTokens.x4),
          child: Wrap(
            spacing: TabletSpacingTokens.x4,
            runSpacing: TabletSpacingTokens.x3,
            alignment: WrapAlignment.center,
            children: [
              for (final code in _tabletBackupCodes)
                Text(code, style: AppTextStyles.numericCode),
            ],
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        CheckboxListTile(
          key: TwoFaSetupTabletPage.backupSavedKey,
          value: _backupCodesSaved,
          onChanged: (value) =>
              setState(() => _backupCodesSaved = value ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Tôi đã lưu các mã khôi phục ở nơi an toàn.'),
        ),
        _errorWidget(),
        const SizedBox(
          height: TabletSpacingTokens.pageRhythmStandardSectionGap,
        ),
        VitCtaButton(
          key: TwoFaSetupTabletPage.submitKey,
          onPressed: _submitting ? null : _completeSetup,
          loading: _submitting,
          variant: VitCtaButtonVariant.auth,
          child: const Text('Hoàn tất bảo mật'),
        ),
      ],
    );
  }

  Widget _errorWidget() {
    if (_error.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: TabletSpacingTokens.x4),
      child: AuthTabletErrorBanner(message: _error),
    );
  }
}
