part of '../pages/otp_page.dart';

class _OtpIntro extends StatelessWidget {
  const _OtpIntro({required this.contact});

  final String contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Nhập mã xác minh',
          textAlign: TextAlign.center,
          style: AppTextStyles.pageTitle,
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX3),
        Text.rich(
          TextSpan(
            text: 'Chúng tôi đã gửi mã 6 chữ số đến ',
            children: [
              TextSpan(
                text: contact,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AuthSpacingTokens.authReadableLineHeight,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: AuthSpacingTokens.authReadableLineHeight,
          ),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX1),
        Text.rich(
          TextSpan(
            text: '(Demo: nhập ',
            children: [
              TextSpan(
                text: '123456',
                style: AppTextStyles.caption.copyWith(color: _authPrimary),
              ),
              const TextSpan(text: ')'),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
