part of '../../phone/pages/settings/bot_api_documentation_page.dart';

class _RateLimitsCard extends StatelessWidget {
  const _RateLimitsCard({required this.items});

  final List<TradeBotRateLimit> items;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        children: [
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  item.value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            if (item != items.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            children: [
              const Icon(
                Icons.key_rounded,
                color: _apiPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Xác thực',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          Text(
            'Tất cả yêu cầu API đều cần API key. Tạo API key của bạn trong '
            'Cài đặt bảo mật. Thêm vào header:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          _CodeBlock(text: header, compact: true, dark: true),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: child,
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    required this.text,
    this.compact = false,
    this.example = false,
    this.dark = false,
  });

  final String text;
  final bool compact;
  final bool example;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: dark ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.tight,
      width: double.infinity,
      padding: compact
          ? TradeSpacingTokens.tradeBotCodeBlockCompactPadding
          : TradeSpacingTokens.tradeBotCodeBlockPadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: AppTextStyles.monoCode.copyWith(
            color: compact ? _apiPrimary : AppColors.text2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  const _MethodBadge({required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: method,
      status: switch (method) {
        'GET' => VitStatusPillStatus.success,
        'POST' => VitStatusPillStatus.info,
        _ => VitStatusPillStatus.warning,
      },
      size: VitStatusPillSize.sm,
    );
  }
}
