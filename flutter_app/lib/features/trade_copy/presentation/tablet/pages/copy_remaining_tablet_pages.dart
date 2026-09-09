import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

Widget _crError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _crSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _crRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

List<Widget> _crBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

/// SC-075: Phân tích hiệu suất chi tiết (attribution, drawdown, dự báo).
class PerformanceAttributionTabletPage extends ConsumerWidget {
  const PerformanceAttributionTabletPage({super.key, required this.copyId});

  static const contentKey = Key('sc075_tablet_content');

  final String copyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      tradePerformanceAttributionProvider(copyId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-075',
        semanticLabel: 'Phân tích hiệu suất chi tiết',
        title: 'Phân tích hiệu suất',
        subtitle: copyId,
        contentKey: PerformanceAttributionTabletPage.contentKey,
        children: [
          _crError(
            'Không tải được phân tích hiệu suất',
            () => ref.invalidate(tradePerformanceAttributionProvider(copyId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-075',
        semanticLabel: 'Phân tích hiệu suất chi tiết',
        title: 'Phân tích hiệu suất',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: PerformanceAttributionTabletPage.contentKey,
        children: [
          _crSection(
            title: 'Chỉ số chính',
            rows: _crRows([
              (
                'Tổng lợi suất',
                VitFormat.percent(snapshot.totalReturnPct, fractionDigits: 2),
              ),
              (
                'Alpha',
                VitFormat.percent(snapshot.alphaPct, fractionDigits: 2),
              ),
              ('Beta', snapshot.beta.toStringAsFixed(2)),
              ('R²', snapshot.rSquared.toStringAsFixed(2)),
              (
                'Đóng góp thị trường',
                VitFormat.percent(
                  snapshot.marketContributionPct,
                  fractionDigits: 1,
                ),
              ),
              (
                'Đóng góp kỹ năng',
                VitFormat.percent(
                  snapshot.skillContributionPct,
                  fractionDigits: 1,
                ),
              ),
            ]),
          ),

          _crSection(
            title: 'Rủi ro và dự báo',
            rows: _crRows([
              (
                'Sụt giảm tối đa',
                VitFormat.percent(snapshot.maxDrawdownPct, fractionDigits: 2),
              ),
              (
                'Sụt giảm trung bình',
                VitFormat.percent(snapshot.avgDrawdownPct, fractionDigits: 2),
              ),
              ('Dự báo trung vị', snapshot.medianProjection.toStringAsFixed(2)),
              (
                'Kịch bản xấu nhất',
                snapshot.worstProjection.toStringAsFixed(2),
              ),
              ('Kịch bản tốt nhất', snapshot.bestProjection.toStringAsFixed(2)),
            ]),
          ),

          _crSection(
            title: 'Lợi suất theo ngày (thị trường / kỹ năng)',
            rows: [
              for (final point in snapshot.returns.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x7,
                        child: Text(
                          'N${point.day}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Thị trường ${VitFormat.percent(point.market)} · '
                          'Kỹ năng ${VitFormat.percent(point.alpha)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Text(
                        VitFormat.percent(point.total),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: point.total >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-080: Giáo dục an toàn sao chép (lừa đảo, dấu hiệu cảnh báo, phân cấp
/// xác minh).
class SafetyEducationTabletPage extends ConsumerWidget {
  const SafetyEducationTabletPage({super.key});

  static const contentKey = Key('sc080_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeSafetyEducationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-080',
        semanticLabel: 'Giáo dục an toàn sao chép',
        title: 'Giáo dục an toàn',
        subtitle: 'Trung tâm an toàn sao chép',
        contentKey: SafetyEducationTabletPage.contentKey,
        children: [
          _crError(
            'Không tải được giáo dục an toàn',
            () => ref.invalidate(tradeSafetyEducationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-080',
        semanticLabel: 'Giáo dục an toàn sao chép',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroDescription,
        contentKey: SafetyEducationTabletPage.contentKey,
        children: [
          _crSection(
            title: 'Chủ đề',
            rows: _crRows([
              for (final tab in snapshot.tabs)
                (
                  '• ${tab.label}',
                  tab.id == snapshot.defaultTabId ? 'Đang xem' : 'Sẵn sàng',
                ),
            ]),
          ),

          for (final scam in snapshot.scams) ...[
            _crSection(
              title: scam.title,
              rows: [
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    scam.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ),
                ..._crBullets(scam.howToAvoid),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],

          _crSection(
            title: 'Dấu hiệu cảnh báo',
            rows: [
              for (final flag in snapshot.redFlags)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flag.flag,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              flag.explanation,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        flag.severity,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          for (final tier in snapshot.verificationTiers) ...[
            _crSection(
              title: 'Cấp xác minh: ${tier.tier}',
              rows: _crBullets(tier.requirements),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],

          _crSection(
            title: 'Lý do báo cáo',
            rows: _crBullets(snapshot.reportReasons),
          ),
        ],
      ),
    );
  }
}
