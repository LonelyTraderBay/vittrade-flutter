part of '../../phone/pages/tools/market_movers_page.dart';

class _MoverListCard extends StatelessWidget {
  const _MoverListCard({
    required this.movers,
    required this.tab,
    required this.changeFor,
    required this.onTap,
  });

  final List<MarketMover> movers;
  final String tab;
  final double Function(MarketMover mover) changeFor;
  final ValueChanged<MarketMover> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < movers.length; index++)
            _MoverRow(
              key: Key('sc010_mover_${movers[index].id}'),
              rank: index + 1,
              mover: movers[index],
              tab: tab,
              change: changeFor(movers[index]),
              last: index == movers.length - 1,
              onTap: () => onTap(movers[index]),
            ),
        ],
      ),
    );
  }
}
