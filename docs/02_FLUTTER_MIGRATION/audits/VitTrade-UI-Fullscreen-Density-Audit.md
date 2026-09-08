# VitTrade UI Fullscreen Density Audit

Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.

```text
total_routed_screens=409
P1_density_refactor=0
P1_fullscreen_tool_visual_qa=2
P2_visual_density_review=2
P3_followup_review=7
Pass_or_low_signal=398
```

## Priority Counts

| Priority | Count |
| --- | ---: |
| `P1_density_refactor` | 0 |
| `P1_fullscreen_tool_visual_qa` | 2 |
| `P2_visual_density_review` | 2 |
| `P3_followup_review` | 7 |
| `Pass_or_low_signal` | 398 |

## Flagged Routes

| Priority | Score | Feature | Page | Route | Reason | Page file |
| --- | ---: | --- | --- | --- | --- | --- |
| P1_fullscreen_tool_visual_qa | 16 | trade | FuturesPage | `'/trade/:pairId/futures'` | body Tool; few dense sections/cards=2 | `flutter_app/lib/features/trade/presentation/phone/pages/futures/futures_page.dart` |
| P1_fullscreen_tool_visual_qa | 14 | p2p_orders | P2PChatPage | `'/p2p/chat/:orderId'` | body Tool; few dense sections/cards=1 | `flutter_app/lib/features/p2p_orders/presentation/phone/pages/orders/p2p_chat_page.dart` |
| P2_visual_density_review | 12 | wallet | AddressAddPage | `AppRoutePaths.walletAddressBookAdd` | body B; few dense sections/cards=0 | `flutter_app/lib/features/wallet/presentation/phone/pages/address_add_page.dart` |
| P2_visual_density_review | 12 | wallet | WalletMultiManagerPage | `AppRoutePaths.walletMultiManager` | body B; few dense sections/cards=0 | `flutter_app/lib/features/wallet/presentation/phone/pages/tools/wallet_multi_manager_page.dart` |
| P3_followup_review | 8 | wallet | DepositPage | `'${AppRoutePaths.walletDeposit}/:asset'` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/deposit_page.dart` |
| P3_followup_review | 8 | wallet | DepositPage | `AppRoutePaths.walletDeposit` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/deposit_page.dart` |
| P3_followup_review | 8 | wallet | DustConverterPage | `AppRoutePaths.walletDustConverter` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/assets/dust_converter_page.dart` |
| P3_followup_review | 8 | wallet | TransactionDetailPage | `'/wallet/transaction/:txId'` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/transaction_detail_page.dart` |
| P3_followup_review | 8 | wallet | TransferPage | `AppRoutePaths.walletTransfer` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/transfer_page.dart` |
| P3_followup_review | 8 | wallet | WithdrawPage | `'${AppRoutePaths.walletWithdraw}/:asset'` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/withdraw_page.dart` |
| P3_followup_review | 8 | wallet | WithdrawPage | `AppRoutePaths.walletWithdraw` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/withdraw_page.dart` |
