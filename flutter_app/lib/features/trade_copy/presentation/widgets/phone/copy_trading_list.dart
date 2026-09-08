import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
part 'copy_trading_list_sections.dart';

/// Visual skin for copy-trading provider lists (SC-063 classic vs SC-064 v2).
enum CopyTradingListSkin { classic, v2 }

/// Widget keys shared by copy-trading page libraries.
final class CopyTradingListKeys {
  const CopyTradingListKeys({
    required this.traderKey,
    required this.detailKey,
    required this.sortKey,
  });

  final Key Function(String id) traderKey;
  final Key Function(String id) detailKey;
  final Key Function(String option) sortKey;
}

List<TradeCopyTrader> sortCopyTraders(
  List<TradeCopyTrader> traders,
  String sortBy,
) {
  final sorted = [...traders];
  if (sortBy == 'Ổn định nhất') {
    sorted.sort((a, b) => b.sharpeRatio.compareTo(a.sharpeRatio));
  } else if (sortBy == 'Nhiều copier') {
    sorted.sort((a, b) => b.copiers.compareTo(a.copiers));
  } else if (sortBy == 'AUM cao') {
    sorted.sort((a, b) => b.aum.compareTo(a.aum));
  } else {
    sorted.sort((a, b) => b.totalPnlPct.compareTo(a.totalPnlPct));
  }
  return sorted;
}

class CopyTradingRiskWarningCard extends StatelessWidget {
  const CopyTradingRiskWarningCard({
    super.key,
    required this.title,
    required this.message,
    this.contractId = 'Copy trading provider risk disclosure',
    this.v2PreviewCopy = false,
  });

  final String title;
  final String message;
  final String contractId;
  final bool v2PreviewCopy;

  @override
  Widget build(BuildContext context) {
    final body = v2PreviewCopy
        ? '$message Preview, fees, allocation limit and confirmation are reviewed before copying.'
        : message;

    final panel = VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: title,
      message: body,
      contractId: contractId,
      density: VitDensity.tool,
    );

    if (!v2PreviewCopy) {
      return panel;
    }

    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.zeroInsets.copyWith(
        left: TradeSpacingTokens.tradePageContentGap,
        top: AppSpacing.x2,
        right: TradeSpacingTokens.tradePageContentGap,
        bottom: AppSpacing.x2,
      ),
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      child: panel,
    );
  }
}

class CopyTradingSortChips extends StatelessWidget {
  const CopyTradingSortChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.keys,
    this.skin = CopyTradingListSkin.classic,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return VitTabBar(
        activeKey: selected,
        onChanged: onChanged,
        tabs: [
          for (final option in options)
            VitTabItem(
              key: option,
              label: option,
              widgetKey: keys.sortKey(option),
            ),
        ],
      );
    }

    return VitPresetChipRow<String>(
      items: [
        for (final option in options)
          VitPresetChipItem(
            value: option,
            label: option,
            key: keys.sortKey(option),
            semanticLabel: 'Sắp xếp copy trading theo $option',
          ),
      ],
      selectedValue: selected,
      onTap: onChanged,
      height: TradeSpacingTokens.copyTradingV2SortChipHeight,
    );
  }
}

class CopyTradingTraderList extends StatelessWidget {
  const CopyTradingTraderList({
    super.key,
    required this.traders,
    required this.onOpen,
    required this.keys,
    this.skin = CopyTradingListSkin.classic,
  });

  final List<TradeCopyTrader> traders;
  final ValueChanged<TradeCopyTrader> onOpen;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return Column(
        children: [
          for (var i = 0; i < traders.length; i++) ...[
            _CopyTraderCard(
              trader: traders[i],
              onOpen: () => onOpen(traders[i]),
              keys: keys,
              skin: skin,
            ),
            if (i < traders.length - 1)
              const SizedBox(height: TradeSpacingTokens.tradePageContentGap),
          ],
        ],
      );
    }

    return VitCard(
      clip: true,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        children: [
          for (var i = 0; i < traders.length; i++) ...[
            _CopyTraderCard(
              trader: traders[i],
              onOpen: () => onOpen(traders[i]),
              keys: keys,
              skin: skin,
              grouped: true,
            ),
            if (i < traders.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _CopyTraderCard extends StatelessWidget {
  const _CopyTraderCard({
    required this.trader,
    required this.onOpen,
    required this.keys,
    required this.skin,
    this.grouped = false,
  });

  final TradeCopyTrader trader;
  final VoidCallback onOpen;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final tier = _tierFor(trader.copiers, skin);
    final cardSpace = TradeSpacingTokens.tradePageContentGap;
    final innerSpace = AppSpacing.x2;
    final risk = skin == CopyTradingListSkin.classic
        ? _riskFor(trader.riskLevel)
        : null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CopyAvatarBadge(trader: trader, tier: tier, skin: skin),
            SizedBox(
              width: skin == CopyTradingListSkin.classic
                  ? innerSpace
                  : cardSpace,
            ),
            Expanded(
              child: skin == CopyTradingListSkin.v2
                  ? Padding(
                      padding: AppSpacing.zeroInsets.copyWith(
                        top: AppSpacing.dividerHairline,
                      ),
                      child: _CopyTraderHeader(
                        trader: trader,
                        tier: tier,
                        skin: skin,
                        risk: risk,
                      ),
                    )
                  : _CopyTraderHeader(
                      trader: trader,
                      tier: tier,
                      skin: skin,
                      risk: risk,
                    ),
            ),
            SizedBox(width: innerSpace),
            _CopyRoiBlock(trader: trader, skin: skin),
          ],
        ),
        SizedBox(
          height: skin == CopyTradingListSkin.classic ? innerSpace : cardSpace,
        ),
        if (skin == CopyTradingListSkin.classic)
          _CopyProviderStats(trader: trader),
        if (skin == CopyTradingListSkin.classic) SizedBox(height: innerSpace),
        _CopyDetailsButton(
          traderId: trader.id,
          onOpen: onOpen,
          keys: keys,
          skin: skin,
        ),
      ],
    );

    if (grouped) {
      return Padding(
        key: keys.traderKey(trader.id),
        padding: AppSpacing.cardPaddingCompact,
        child: content,
      );
    }

    if (skin == CopyTradingListSkin.classic) {
      return VitCard(
        key: keys.traderKey(trader.id),
        radius: VitCardRadius.tight,
        density: VitDensity.tool,
        padding: AppSpacing.cardPaddingCompact,
        borderColor: AppColors.cardBorder,
        child: content,
      );
    }

    if (skin == CopyTradingListSkin.v2) {
      return VitCard(
        key: keys.traderKey(trader.id),
        radius: VitCardRadius.tight,
        density: VitDensity.tool,
        padding: AppSpacing.zeroInsets.copyWith(
          left: cardSpace,
          top: cardSpace,
          right: cardSpace,
          bottom: cardSpace,
        ),
        borderColor: AppColors.cardBorder,
        child: content,
      );
    }

    return VitCard(
      key: keys.traderKey(trader.id),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.cardBorder,
      child: content,
    );
  }
}
