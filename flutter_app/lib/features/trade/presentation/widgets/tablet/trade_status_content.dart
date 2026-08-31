import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

/// Skeleton phản chiếu grid terminal của SC-048 tablet (hướng Bybit
/// 2026-08-31) — cùng tầng chiều rộng như trang đã tải: đầy đủ = [chart |
/// sổ lệnh+tape | đặt lệnh], gọn = [chart | đặt lệnh] — resolving dữ liệu
/// không đổi hình trang. Terminal không cuộn trang nên không có
/// pull-to-refresh; nút Làm mới nằm trong meta strip khi dữ liệu sẵn sàng.
class TradeLoadingContent extends StatelessWidget {
  const TradeLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tier = width >= TradeSpacingTokens.tradeTerminalFullSplitMinWidth
            ? const _FullTierSkeleton()
            : const _CompactTierSkeleton();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _MetaStripSkeleton(),
            const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
            Expanded(child: tier),
          ],
        );
      },
    );
  }
}

/// Tầng đầy đủ: [chart + tab dưới | sổ lệnh + tape | đặt lệnh].
class _FullTierSkeleton extends StatelessWidget {
  const _FullTierSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _ChartColumnSkeleton()),
        SizedBox(width: TradeSpacingTokens.tradeTerminalGutter),
        SizedBox(
          width: TradeSpacingTokens.tradeTerminalBookColumnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _PanelSkeleton(labelWidth: 80)),
              SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
              Expanded(child: _PanelSkeleton(labelWidth: 96)),
            ],
          ),
        ),
        SizedBox(width: TradeSpacingTokens.tradeTerminalGutter),
        SizedBox(
          width: TradeSpacingTokens.tradeTerminalEntryColumnWidth,
          child: _PanelSkeleton(labelWidth: 110),
        ),
      ],
    );
  }
}

/// Tầng gọn: [chart + tab dưới | đặt lệnh].
class _CompactTierSkeleton extends StatelessWidget {
  const _CompactTierSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _ChartColumnSkeleton()),
        SizedBox(width: TradeSpacingTokens.tradeTerminalGutter),
        SizedBox(
          width: TradeSpacingTokens.tradeTerminalEntryColumnWidth,
          child: _PanelSkeleton(labelWidth: 110),
        ),
      ],
    );
  }
}

/// Cột chart + vùng tab dưới chart.
class _ChartColumnSkeleton extends StatelessWidget {
  const _ChartColumnSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProductTabsSkeleton(),
        SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        Expanded(child: _PanelSkeleton(labelWidth: 240)),
        SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        _BottomPanelSkeleton(),
      ],
    );
  }
}

/// Hàng meta 1 dòng: cụm symbol + giá + cụm số liệu bên phải.
class _MetaStripSkeleton extends StatelessWidget {
  const _MetaStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: AppSpacing.zeroInsets,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalMetaStripPadding,
        child: Row(
          children: [
            VitSkeleton(width: 96, height: AppSpacing.x4),
            SizedBox(width: TradeSpacingTokens.tradeTerminalMetaGap),
            VitSkeleton(width: 88, height: AppSpacing.x4),
            Spacer(),
            VitSkeleton(width: 150, height: AppSpacing.x4),
          ],
        ),
      ),
    );
  }
}

/// Hàng product tabs skeleton — cuộn ngang như hàng tabs thật ở tầng hẹp.
class _ProductTabsSkeleton extends StatelessWidget {
  const _ProductTabsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          VitSkeleton(width: 96, height: AppSpacing.buttonCompact),
          SizedBox(width: AppSpacing.x1),
          VitSkeleton(width: 72, height: AppSpacing.buttonCompact),
          SizedBox(width: AppSpacing.x1),
          VitSkeleton(width: 72, height: AppSpacing.buttonCompact),
        ],
      ),
    );
  }
}

/// Vùng tab dưới chart skeleton (chiều cao cố định).
class _BottomPanelSkeleton extends StatelessWidget {
  const _BottomPanelSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: TradeSpacingTokens.tradeTerminalBottomPanelHeight,
      child: _PanelSkeleton(labelWidth: 120),
    );
  }
}

/// Một panel phẳng skeleton: nhãn micro + vài thanh mỏng — cao độ tự nhiên
/// nhỏ, an toàn trong mọi ngữ cảnh ràng buộc (kể cả hộp cao độ cố định).
/// Không dùng `VitSkeletonList` (là VitCard lồng + hàng ~60dp, tràn hộc
/// panel mỏng).
class _PanelSkeleton extends StatelessWidget {
  const _PanelSkeleton({required this.labelWidth});

  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: AppSpacing.zeroInsets,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalPanelHeaderPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            VitSkeleton(width: labelWidth, height: AppSpacing.x3),
            const SizedBox(height: AppSpacing.x1),
            const VitSkeleton(width: double.infinity, height: AppSpacing.x3),
            const SizedBox(height: AppSpacing.x1),
            const VitSkeleton(width: double.infinity, height: AppSpacing.x3),
            const SizedBox(height: AppSpacing.x1),
            const VitSkeleton(width: 120, height: AppSpacing.x3),
          ],
        ),
      ),
    );
  }
}
