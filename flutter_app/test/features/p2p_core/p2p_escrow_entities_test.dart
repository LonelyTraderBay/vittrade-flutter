// Coverage dòng 2 p3k + logic thật: assetBalance của escrow entity —
// firstWhere với orElse fallback về phần tử đầu.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';

void main() {
  P2PEscrowBalanceSnapshot snapshotWith(
    List<P2PEscrowAssetBalanceDraft> assets,
  ) {
    return P2PEscrowBalanceSnapshot(
      endpoint: '/api/mobile/p2p/escrow-balance',
      actionDraft: 'GET',
      supportedStates: const <P2PScreenState>[],
      selectedAsset: 'USDT',
      assets: assets,
      ordersByAsset: const {},
      title: 'Escrow',
      subtitle: 'Số dư · escrow',
      infoTitle: 'Escrow',
      infoBody: 'body',
      helpTitle: 'help',
      helpBullets: const [],
      parentRoute: '/p2p/wallet',
      emptyTitle: 'Trống',
      emptySubtitle: 'Không có số dư',
      contractNotes: '',
    );
  }

  test('assetBalance: trả đúng asset có trong danh sách', () {
    final draft = snapshotWith(const [
      P2PEscrowAssetBalanceDraft(
        asset: 'USDT',
        totalAmount: 1200.5,
        orderCount: 8,
      ),
      P2PEscrowAssetBalanceDraft(
        asset: 'BTC',
        totalAmount: 0.25,
        orderCount: 2,
      ),
    ]);

    final btc = draft.assetBalance('BTC');
    expect(btc.asset, 'BTC');
    expect(btc.totalAmount, 0.25);
    expect(btc.orderCount, 2);
  });

  test('assetBalance: asset lạ fallback về phần tử đầu', () {
    final draft = snapshotWith(const [
      P2PEscrowAssetBalanceDraft(
        asset: 'USDT',
        totalAmount: 1200.5,
        orderCount: 8,
      ),
    ]);

    final fallback = draft.assetBalance('ETH');
    expect(fallback.asset, 'USDT');
    expect(fallback.totalAmount, 1200.5);
  });
}
