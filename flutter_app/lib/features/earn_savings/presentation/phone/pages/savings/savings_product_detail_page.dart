import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsProductDetailPage extends ConsumerWidget {
  const SavingsProductDetailPage({
    super.key,
    required this.productId,
    this.shellRenderMode,
  });

  static const backButtonKey = Key('sc330_back_to_savings_button');

  final String productId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      savingsProductDetailSnapshotProvider(productId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết sản phẩm tiết kiệm',
      semanticIdentifier: 'SC-330',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                savingsProductDetailSnapshotProvider(productId),
              ),
            ),
          ),
          data: (snapshot) {
            final product = snapshot.product;
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EarnSpacingTokens.earnBottomInsetPadding(bottomInset),
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (product == null)
                      _NotFoundProductState(snapshot: snapshot)
                    else ...[
                      _ProductHero(product: product),
                      const EarnInfoBanner(
                        text:
                            'APY là ước tính tham khảo và có thể thay đổi theo điều kiện thị trường.',
                      ),
                      _ProductFacts(product: product),
                      VitCtaButton(
                        height: AppSpacing.inputHeight,
                        onPressed: () => HapticFeedback.selectionClick(),
                        child: const Text('Đăng ký sản phẩm'),
                      ),
                      const EarnDisclaimerBanner(
                        text:
                            'Rút trước hạn có thể mất lãi tích lũy. Vui lòng xem quy tắc khóa và rút trước khi gửi.',
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  const _ProductHero({required this.product});

  final SavingsProductDraft product;

  @override
  Widget build(BuildContext context) {
    final lockLabel = product.type == SavingsProductType.flexible
        ? 'Linh hoạt'
        : '${product.lockDays ?? 0} ngày khóa';

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  lockLabel,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.apy,
                style: AppTextStyles.amountMd.copyWith(
                  color: AppModuleAccents.earn,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'APY ước tính',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductFacts extends StatelessWidget {
  const _ProductFacts({required this.product});

  final SavingsProductDraft product;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        children: [
          _FactRow(label: 'Tài sản', value: product.asset),
          const Divider(color: AppColors.divider, height: AppSpacing.x4),
          _FactRow(label: 'Đã ký', value: product.totalSubscribed),
          const Divider(color: AppColors.divider, height: AppSpacing.x4),
          _FactRow(label: 'Còn lại', value: product.remainingQuota),
          const Divider(color: AppColors.divider, height: AppSpacing.x4),
          _FactRow(label: 'Người tham gia', value: product.participants),
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _NotFoundProductState extends StatelessWidget {
  const _NotFoundProductState({required this.snapshot});

  final SavingsProductDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.empty,
          title: 'Sản phẩm không khả dụng',
          message: snapshot.notFoundMessage,
          contractId: 'savings-product-empty',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Align(
          alignment: Alignment.center,
          child: VitCtaButton(
            key: SavingsProductDetailPage.backButtonKey,
            fullWidth: false,
            height: EarnSpacingTokens.savingsFlowHeroHeight,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.backRoute);
            },
            child: const Text('Quay lại'),
          ),
        ),
      ],
    );
  }
}
