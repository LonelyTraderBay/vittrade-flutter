part of '../../phone/pages/governance/product_governance_page.dart';

class _Stats extends StatelessWidget {
  const _Stats({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    const cards = [
      ('Total Products', '3', '2 approved', _govGreen),
      ('Reviews Due', '1', 'Within 3 months', _govAmber),
      ('Channels', '3', 'Active', AppColors.text3),
    ];
    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(
            child: VitMetricCard(
              label: card.$1,
              value: card.$1 == 'Total Products'
                  ? products.length.toString()
                  : card.$2,
              accentColor: card.$4,
            ),
          ),
          if (card != cards.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}
