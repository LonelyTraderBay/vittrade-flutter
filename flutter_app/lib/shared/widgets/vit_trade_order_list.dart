import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Descriptor for a trade order row in dense list views.
final class VitTradeOrderRecord {
  const VitTradeOrderRecord({
    required this.id,
    required this.symbol,
    required this.sideLabel,
    required this.detail,
    this.sideColor = AppColors.text1,
    this.onTap,
  });

  final String id;
  final String symbol;
  final String sideLabel;
  final String detail;
  final Color sideColor;
  final VoidCallback? onTap;
}

/// One row rendering a [VitTradeOrderRecord] (symbol/detail + side label).
class VitTradeOrderRow extends StatelessWidget {
  const VitTradeOrderRow({super.key, required this.record});

  final VitTradeOrderRecord record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: SharedSpacingTokens.tradeOrderRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.symbol,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                SizedBox(height: AppSurfaceSpacing.x1),
                Text(
                  record.detail,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          Text(
            record.sideLabel,
            style: AppTextStyles.caption.copyWith(
              color: record.sideColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card-wrapped, divider-separated list of [VitTradeOrderRow]s, or an
/// [emptyLabel] message when [records] is empty.
class VitTradeOrderList extends StatelessWidget {
  const VitTradeOrderList({
    super.key,
    required this.records,
    this.emptyLabel = 'Chưa có lệnh',
  });

  final List<VitTradeOrderRecord> records;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Padding(
        padding: SharedSpacingTokens.tradeOrderRowPadding,
        child: Text(
          emptyLabel,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      );
    }

    return VitCard(
      clip: true,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (var i = 0; i < records.length; i++) ...[
            InkWell(
              onTap: records[i].onTap,
              child: VitTradeOrderRow(record: records[i]),
            ),
            if (i < records.length - 1)
              Divider(
                height: AppSurfaceSpacing.dividerHairline,
                thickness: AppSurfaceSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}
