import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/referral_spacing_tokens.dart';

part '../../widgets/referral_rules_page_sections.dart';
part '../../widgets/referral_rules_page_common.dart';

class ReferralRulesPage extends ConsumerStatefulWidget {
  const ReferralRulesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc288_referral_rules_content');
  static const tierTableKey = Key('sc288_tier_table');
  static const rewardTypesKey = Key('sc288_reward_types');
  static const termsKey = Key('sc288_terms');
  static const faqKey = Key('sc288_faq');
  static const disclaimerKey = Key('sc288_disclaimer');

  static Key tierKey(String id) => Key('sc288_tier_$id');
  static Key rewardTypeKey(String id) => Key('sc288_reward_type_$id');
  static Key termKey(int index) => Key('sc288_term_$index');
  static Key faqToggleKey(int index) => Key('sc288_faq_toggle_$index');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralRulesPage> createState() => _ReferralRulesPageState();
}

class _ReferralRulesPageState extends ConsumerState<ReferralRulesPage> {
  int? _openFaqIndex = 0;

  @override
  Widget build(BuildContext context) {
    final rulesAsync = ref.watch(referralRulesSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quy tắc chương trình',
      semanticIdentifier: 'SC-288',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Quy tắc chương trình',
            subtitle: 'Quy tắc · Referral',
            showBack: true,
            onBack: () => context.go(
              rulesAsync.value?.backRoute ?? AppRoutePaths.referral,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ReferralRulesPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: rulesAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được quy tắc',
                            message: 'Thử lại sau hoặc quay lại trang chủ.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(referralRulesSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          const _ReferralRulesSection(
                            title: 'Hệ thống hạng',
                            subtitle: 'Mời càng nhiều, thưởng càng lớn',
                            accentColor: AppColors.warn,
                          ),
                          _TierTable(snapshot: snapshot),
                          const _ReferralRulesSection(
                            title: 'Các loại thưởng',
                            accentColor: AppModuleAccents.trade,
                          ),
                          _RewardTypes(snapshot: snapshot),
                          const _ReferralRulesSection(
                            title: 'Điều khoản chương trình',
                            accentColor: AppColors.text2,
                          ),
                          _TermsList(snapshot: snapshot),
                          const _ReferralRulesSection(
                            title: 'Câu hỏi thường gặp',
                            accentColor: AppColors.accent,
                          ),
                          _FaqList(
                            snapshot: snapshot,
                            openIndex: _openFaqIndex,
                            onToggle: (index) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() {
                                _openFaqIndex = _openFaqIndex == index
                                    ? null
                                    : index;
                              });
                            },
                          ),
                          _Disclaimer(snapshot: snapshot),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
