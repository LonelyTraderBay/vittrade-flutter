import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

const _ombudsmanBorder = AppColors.borderSolid;
const _ombudsmanPrimary = AppColors.primary;
const _ombudsmanGreen = AppColors.buy;
const _ombudsmanAmber = AppColors.caution;
const double _ombudsmanContactIconExtent =
    AppSpacing.buttonCompact + AppSpacing.x1;
const double _ombudsmanStepMarkerExtent = AppSpacing.buttonCompact;

class OmbudsmanReferralPage extends ConsumerWidget {
  const OmbudsmanReferralPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc114_ombudsman_content');
  static const ctaKey = Key('sc114_ombudsman_cta');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tradeOmbudsmanReferralProvider);
    return VitTradeHubScaffold(
      title: 'Financial Ombudsman',
      subtitle: 'Independent Dispute Resolution',
      semanticLabel: 'Chuyển khiếu nại đến Cơ quan Thanh tra Tài chính độc lập',
      semanticIdentifier: 'SC-114',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyComplaintsHandling,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeOmbudsmanReferralProvider),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Review ombudsman referral route',
              message:
                  'Confirm complaint deadline, eligibility, evidence, and next steps before external escalation.',
            ),
          ),
          VitTradeComplianceSection(
            title: 'Referral status',
            statusPill: const VitStatusPill(
              label: 'External referral',
              status: VitStatusPillStatus.warning,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Eligibility',
                value: '${snapshot.eligibility.length} criteria',
              ),
              VitTradeComplianceItem(
                label: 'Contacts',
                value: '${snapshot.contacts.length} routes',
              ),
            ],
          ),
          VitTradeSection(
            title: 'Overview',
            child: VitTradeComplianceHero(
              title: snapshot.infoTitle,
              description: snapshot.infoDescription,
              icon: Icons.shield_outlined,
              accentColor: _ombudsmanGreen,
            ),
          ),
          VitTradeSection(
            title: 'When Can You Refer?',
            child: _EligibilityCard(items: snapshot.eligibility),
          ),
          VitTradeSection(
            title: 'Contact Information',
            child: _ContactCard(contacts: snapshot.contacts),
          ),
          VitTradeSection(
            title: 'How It Works',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final step in snapshot.processSteps)
                  _ProcessStepCard(step: step),
                _VisitButton(snapshot: snapshot),
                const TradeBodyReviewSection(
                  title: 'Đánh giá nội dung chuyển khiếu nại đến Thanh tra',
                  message:
                      'Nội dung chuyển khiếu nại đến Thanh tra đã được xem xét',
                  detail:
                      'Trạng thái điều kiện chuyển khiếu nại, liên hệ, quy trình, nút truy cập, trống và kết quả luôn hiển thị rõ ràng.',
                  primary:
                      'Điều kiện chuyển khiếu nại luôn hiển thị phía trên các hành động chuyển khiếu nại ra bên ngoài.',
                  secondary:
                      'Thông tin liên hệ và các bước quy trình luôn được tách riêng để phục vụ việc chuyển khiếu nại theo quy định.',
                  tertiary:
                      'Nút truy cập luôn được thể hiện là bước giải quyết tranh chấp bên ngoài.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EligibilityCard extends StatelessWidget {
  const _EligibilityCard({required this.items});

  final List<TradeOmbudsmanEligibility> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.ombudsmanEligibilityPadding,
      radius: VitCardRadius.tight,
      borderColor: _ombudsmanBorder.withValues(alpha: .76),
      child: Column(
        children: [
          for (final item in items) ...[
            _EligibilityRow(item: item),
            if (item != items.last) const SizedBox(height: AppSpacing.rowPy),
          ],
        ],
      ),
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  const _EligibilityRow({required this.item});

  final TradeOmbudsmanEligibility item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: TradeSpacingTokens.complaintCaseIconNudgePadding,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: _ombudsmanGreen,
            size: AppSpacing.inputPrefixIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contacts});

  final List<TradeOmbudsmanContact> contacts;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.complaintCaseCardPadding,
      radius: VitCardRadius.tight,
      borderColor: _ombudsmanBorder.withValues(alpha: .76),
      child: Column(
        children: [
          for (final contact in contacts) ...[
            _ContactRow(contact: contact),
            if (contact != contacts.last)
              const SizedBox(height: AppSpacing.sectionGapCompact),
          ],
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});

  final TradeOmbudsmanContact contact;

  @override
  Widget build(BuildContext context) {
    final color = switch (contact.icon) {
      TradeOmbudsmanContactIcon.phone => _ombudsmanPrimary,
      TradeOmbudsmanContactIcon.website => _ombudsmanGreen,
      TradeOmbudsmanContactIcon.address => _ombudsmanAmber,
    };
    final icon = switch (contact.icon) {
      TradeOmbudsmanContactIcon.phone => Icons.phone_outlined,
      TradeOmbudsmanContactIcon.website => Icons.open_in_new_rounded,
      TradeOmbudsmanContactIcon.address => Icons.description_outlined,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        VitCard(
          width: _ombudsmanContactIconExtent,
          height: _ombudsmanContactIconExtent,
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.tight,
          borderColor: color.withValues(alpha: .24),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: AppSpacing.inputPrefixIcon),
        ),
        const SizedBox(width: AppSpacing.rowPy),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                contact.value,
                style:
                    (contact.icon == TradeOmbudsmanContactIcon.address
                            ? AppTextStyles.monoCode
                            : AppTextStyles.base)
                        .copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
              ),
              if (contact.detail != null) ...[
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  contact.detail!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProcessStepCard extends StatelessWidget {
  const _ProcessStepCard({required this.step});

  final TradeOmbudsmanProcessStep step;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.ombudsmanProcessPadding,
      radius: VitCardRadius.tight,
      borderColor: _ombudsmanBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: _ombudsmanStepMarkerExtent,
            height: _ombudsmanStepMarkerExtent,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            alignment: Alignment.center,
            child: Text(
              '${step.step}',
              style: AppTextStyles.caption.copyWith(
                color: _ombudsmanPrimary,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Padding(
              padding: TradeSpacingTokens.complaintCaseIconNudgePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    step.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitButton extends StatelessWidget {
  const _VisitButton({required this.snapshot});

  final TradeOmbudsmanReferralSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: OmbudsmanReferralPage.ctaKey,
      density: VitDensity.tool,
      onPressed: () {
        unawaited(HapticFeedback.selectionClick());
        unawaited(
          showVitNoticeSheet(
            context: context,
            title: 'Sắp ra mắt',
            message: 'Trang khiếu nại sẽ sớm ra mắt',
            variant: VitBannerVariant.info,
          ),
        );
      },
      leading: const Icon(
        Icons.open_in_new_rounded,
        size: TradeSpacingTokens.complaintCaseTrailingIcon,
      ),
      child: Text(
        snapshot.ctaLabel,
        style: AppTextStyles.control.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
