import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/event/prediction_order_receipt_page_sections.dart';
part '../../../widgets/event/prediction_order_receipt_page_common.dart';

const _predictionPrimary = AppColors.primary;

class PredictionOrderReceiptPage extends ConsumerWidget {
  const PredictionOrderReceiptPage({
    super.key,
    required this.receiptId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc035_prediction_receipt_content');
  static const missingReceiptKey = Key('sc035_prediction_receipt_missing');
  static const shareKey = Key('sc035_share_receipt');
  static const viewEventKey = Key('sc035_view_event');
  static const viewPortfolioKey = Key('sc035_view_portfolio');
  static const feeSummaryKey = Key('sc035_fee_summary');

  final String receiptId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptAsync = ref.watch(
      predictionsOrderReceiptSnapshotProvider(receiptId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết lệnh dự đoán: biên lai, phí và tiến trình',
      semanticIdentifier: 'SC-035',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: 'Chi tiết lệnh',
            subtitle: 'Biên lai · phí · tiến trình',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictionsPortfolio),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: receiptAsync.when(
                  loading: () => const VitSkeletonList(),
                  error: (error, stackTrace) => VitErrorState(
                    title: 'Không tải được biên lai',
                    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () => ref.invalidate(
                      predictionsOrderReceiptSnapshotProvider(receiptId),
                    ),
                  ),
                  data: (snapshot) => snapshot.found
                      ? _ReceiptContent(
                          snapshot: snapshot,
                          scrollEndPadding: scrollEndPadding,
                        )
                      : _MissingReceipt(scrollEndPadding: scrollEndPadding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
