import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'prediction_order_receipt_tablet_sections.dart';

/// SC-225: Biên lai lệnh dự đoán trên tablet — tái composition đầy đủ theo
/// trang phone SC-035 (hero, tổng quan lệnh + tiến trình khớp, timeline,
/// dấu thời gian, chia sẻ, công bố, hành động), khoảng cách token tablet.
/// Là điểm đến của luồng đặt lệnh SC-211.
class PredictionOrderReceiptTabletPage extends ConsumerWidget {
  const PredictionOrderReceiptTabletPage({super.key, required this.receiptId});

  static const contentKey = Key('sc225_tablet_content');
  static const missingReceiptKey = Key('sc225_tablet_missing');
  static const shareKey = Key('sc225_share_receipt');
  static const viewEventKey = Key('sc225_view_event');
  static const viewPortfolioKey = Key('sc225_view_portfolio');
  static const feeSummaryKey = Key('sc225_fee_summary');

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptAsync = ref.watch(
      predictionsOrderReceiptSnapshotProvider(receiptId),
    );

    return receiptAsync.when(
      loading: () => const VitTabletSectionFrame(
        gutterFlush: true,
        semanticIdentifier: 'SC-225',
        semanticLabel: 'Biên lai lệnh prediction',
        title: 'Chi tiết lệnh',
        subtitle: 'Biên lai · phí · tiến trình',
        contentKey: PredictionOrderReceiptTabletPage.contentKey,
        children: [VitSkeletonList(rows: 6)],
      ),
      error: (error, stackTrace) => VitTabletSectionFrame(
        gutterFlush: true,
        semanticIdentifier: 'SC-225',
        semanticLabel: 'Biên lai lệnh prediction',
        title: 'Chi tiết lệnh',
        subtitle: 'Biên lai · phí · tiến trình',
        contentKey: PredictionOrderReceiptTabletPage.contentKey,
        backFallback: AppRoutePaths.marketsPredictionsPortfolio,
        children: [
          VitErrorState(
            title: 'Không tải được biên lai',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              predictionsOrderReceiptSnapshotProvider(receiptId),
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        gutterFlush: true,
        semanticIdentifier: 'SC-225',
        semanticLabel: 'Biên lai lệnh prediction',
        title: 'Chi tiết lệnh',
        subtitle: 'Biên lai · phí · tiến trình',
        contentKey: PredictionOrderReceiptTabletPage.contentKey,
        backFallback: AppRoutePaths.marketsPredictionsPortfolio,
        children: snapshot.found
            ? [
                _Sc225ReceiptHero(receipt: snapshot.receipt!),
                _Sc225OrderSummary(receipt: snapshot.receipt!),
                if (snapshot.highRiskContractId != null)
                  VitHighRiskStatePanel(
                    state: VitHighRiskUiState.success,
                    title: 'Trạng thái biên lai lệnh',
                    message:
                        'Trạng thái gửi, chi tiết biên lai, lịch sử danh mục '
                        'và khôi phục hỗ trợ được gắn với hợp đồng prediction '
                        'dùng chung.',
                    contractId: snapshot.highRiskContractId,
                    density: VitDensity.compact,
                  ),
                _Sc225TimelineCard(receipt: snapshot.receipt!),
                _Sc225TimestampCard(receipt: snapshot.receipt!),
                _Sc225ShareReceiptButton(receipt: snapshot.receipt!),
                const _Sc225DisclosureCard(),
                _Sc225ReceiptActions(receipt: snapshot.receipt!),
              ]
            : [
                const VitEmptyState(
                  key: PredictionOrderReceiptTabletPage.missingReceiptKey,
                  title: 'Không tìm thấy',
                  message: 'Lệnh không tồn tại hoặc đã bị xoá',
                  icon: Icons.warning_amber_rounded,
                ),
              ],
      ),
    );
  }
}
