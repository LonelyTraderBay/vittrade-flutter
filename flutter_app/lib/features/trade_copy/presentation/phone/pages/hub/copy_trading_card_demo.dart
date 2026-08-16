import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/phone/copy_trading_card_demo_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/phone/copy_trading_card_demo_sections.dart';
part '../../../widgets/phone/copy_trading_card_demo_common.dart';

class CopyTradingCardDemo extends ConsumerWidget {
  const CopyTradingCardDemo({super.key, this.shellRenderMode});

  static const contentKey = Key('sc401_copy_card_content');
  static const analysisKey = Key('sc401_copy_card_analysis');
  static const matrixKey = Key('sc401_copy_card_matrix');
  static const issuesKey = Key('sc401_copy_card_issues');
  static const recommendationKey = Key('sc401_copy_card_recommendation');
  static const guidelinesKey = Key('sc401_copy_card_guidelines');

  static Key variantKey(String id) => Key('sc401_variant_$id');
  static Key cardKey(String id) => CopyTradingCardDemoUiKeys.cardKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCopyCardDemoProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();

    return snapshotAsync.when(
      loading: () => VitTradeHubScaffold(
        title: 'Phân tích thẻ sao chép',
        semanticLabel: 'Phân tích thẻ sao chép giao dịch (bản demo nội bộ)',
        semanticIdentifier: 'SC-401',
        contentKey: CopyTradingCardDemo.contentKey,
        shellRenderMode: mode,
        showProductTabs: false,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.home,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitTradeHubScaffold(
        title: 'Phân tích thẻ sao chép',
        semanticLabel: 'Phân tích thẻ sao chép giao dịch (bản demo nội bộ)',
        semanticIdentifier: 'SC-401',
        contentKey: CopyTradingCardDemo.contentKey,
        shellRenderMode: mode,
        showProductTabs: false,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.home,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          VitErrorState(
            title: 'Không tải được dữ liệu demo',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeCopyCardDemoProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTradeHubScaffold(
        title: snapshot.title,
        semanticLabel: 'Phân tích thẻ sao chép giao dịch (bản demo nội bộ)',
        semanticIdentifier: 'SC-401',
        contentKey: CopyTradingCardDemo.contentKey,
        shellRenderMode: mode,
        showProductTabs: false,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: snapshot.backRoute,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          _AnalysisHeader(snapshot: snapshot),
          for (final variant in snapshot.variants)
            CopyTradingVariantSection(
              key: CopyTradingCardDemo.variantKey(variant.id),
              variant: variant,
              metrics: snapshot.metrics,
            ),
          _ComparisonMatrix(issues: snapshot.issues),
          _OriginalIssues(issues: snapshot.originalIssues),
          _Recommendation(snapshot: snapshot),
          _Guidelines(guidelines: snapshot.guidelines),
        ],
      ),
    );
  }
}
