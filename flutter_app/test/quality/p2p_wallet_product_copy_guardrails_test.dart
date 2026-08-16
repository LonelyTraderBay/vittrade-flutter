// Origin: 573c8664 (2026-06-01) - refactor: hoàn thiện tái cấu trúc Flutter enterprise hậu E900
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter_test/flutter_test.dart';

import 'product_copy_guardrail_test_utils.dart';

void main() {
  group('product copy guardrails - P2P and wallet', () {
    test('P2P order, escrow, and wallet surfaces stay boundary-safe', () {
      final targets = [
        HighRiskCopyTarget(
          path:
              'lib/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart',
          paths: [
            'lib/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_order_page_state.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_order_content_cards.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_order_page_common.dart',
          ],
          roles: {
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'payment': [RegExp(r'payment|thanh toan', caseSensitive: false)],
            'fee': [RegExp(r'fee|feeLabel|phi', caseSensitive: false)],
            'confirm': [RegExp(r'confirm|xac nhan', caseSensitive: false)],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_balance_page.dart',
          paths: [
            'lib/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_balance_page.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_balance_page_sections.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_balance_page_common.dart',
          ],
          roles: {
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'payment': [RegExp(r'payment', caseSensitive: false)],
            'release': [RegExp(r'release|giai phong', caseSensitive: false)],
            'dispute': [RegExp(r'dispute|tranh chap', caseSensitive: false)],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_detail_page.dart',
          paths: [
            'lib/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_detail_page.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_detail_status_address.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_detail_multisig_order.dart',
            'lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_detail_timeline_actions.dart',
          ],
          roles: {
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'release': [RegExp(r'release|giai phong', caseSensitive: false)],
            'security': [RegExp(r'security|bao ve', caseSensitive: false)],
            'signature': [
              RegExp(r'signer|signed|chu ky', caseSensitive: false),
            ],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_page.dart',
          paths: [
            'lib/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_page.dart',
            'lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_hero.dart',
            'lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_balances.dart',
            'lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_actions_history.dart',
          ],
          roles: {
            'wallet': [RegExp(r'wallet', caseSensitive: false)],
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'transfer': [RegExp(r'transfer|chuyen', caseSensitive: false)],
            'locked': [RegExp(r'locked|khoa', caseSensitive: false)],
          },
        ),
      ];

      final arenaBoundaryLeak = RegExp(
        r'Arena\s+Points|points-only|points pool|rewardLabel',
        caseSensitive: false,
      );

      for (final target in targets) {
        final source = asciiFold(target.sourcePaths.map(readSource).join('\n'));
        expect(
          arenaBoundaryLeak.allMatches(source),
          isEmpty,
          reason: '${target.path} must not borrow Arena points language.',
        );
        for (final entry in target.roles.entries) {
          final hasRole = entry.value.any(
            (pattern) => pattern.hasMatch(source),
          );
          expect(
            hasRole,
            isTrue,
            reason: '${target.path} is missing ${entry.key} safety copy.',
          );
        }
      }
    });

    test('high-risk wallet and P2P flows keep confirmation safety roles', () {
      final targets = [
        HighRiskCopyTarget(
          path:
              'lib/features/wallet/presentation/phone/pages/withdraw_page.dart',
          paths: [
            'lib/features/wallet/presentation/phone/pages/withdraw_page.dart',
            'lib/features/wallet/presentation/widgets/transfer/withdraw_common.dart',
            'lib/features/wallet/presentation/widgets/transfer/withdraw_form_sections.dart',
            'lib/features/wallet/presentation/widgets/transfer/withdraw_network_picker.dart',
            'lib/features/wallet/presentation/widgets/transfer/withdraw_preview_sheet.dart',
            'lib/features/wallet/presentation/controllers/wallet_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'\bpreview\b|_PreviewRow')],
            'confirm': [RegExp(r'\bconfirm\b|xac nhan', caseSensitive: false)],
            'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
            'limit': [
              RegExp(r'minWithdraw|limit|toi thieu', caseSensitive: false),
            ],
            'risk': [
              RegExp(
                r'high-risk|\brisk\b|audit|maskedAddress',
                caseSensitive: false,
              ),
            ],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/wallet/presentation/phone/pages/address_add_page.dart',
          paths: [
            'lib/features/wallet/presentation/phone/pages/address_add_page.dart',
            'lib/features/wallet/presentation/tablet/pages/address_add_tablet_page.dart',
            'lib/features/wallet/presentation/widgets/address/wallet_address_add_sections.dart',
            'lib/features/wallet/presentation/controllers/wallet_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'\bpreview\b|_PreviewPanel')],
            'confirm': [RegExp(r'\bconfirm\b|xac nhan', caseSensitive: false)],
            'destination': [
              RegExp(r'maskedAddress|address|dia chi', caseSensitive: false),
            ],
            'risk': [
              RegExp(
                r'auditTrailNote|khong the|kiem tra|\brisk\b',
                caseSensitive: false,
              ),
            ],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart',
          paths: [
            'lib/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart',
            'lib/features/wallet/presentation/widgets/tools/wallet_token_revoke_sheet.dart',
            'lib/features/wallet/presentation/controllers/wallet_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'revokePreview|\bpreview\b')],
            'confirm': [
              RegExp(r'confirmLabel|\bconfirm\b', caseSensitive: false),
            ],
            'risk': [
              RegExp(r'\brisk\b|unlimited|protect', caseSensitive: false),
            ],
            'spender/token': [
              RegExp(r'spender|token|approval', caseSensitive: false),
            ],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_add_page.dart',
          roles: {
            'preview': [RegExp(r'\bpreview\b|_PaymentPreview')],
            'confirm': [RegExp(r'confirmMessage|confirmTitle|\bconfirm\b')],
            'account owner': [
              RegExp(r'ownerName|owner|chu tai khoan', caseSensitive: false),
            ],
            'security': [
              RegExp(
                r'securityNote|confirmMessage|ownership',
                caseSensitive: false,
              ),
            ],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/p2p_marketplace/presentation/phone/pages/ads/p2p_create_ad_page.dart',
          paths: [
            'lib/features/p2p_marketplace/presentation/phone/pages/ads/p2p_create_ad_page.dart',
            'lib/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_sections.dart',
            'lib/features/p2p_core/presentation/controllers/p2p_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'\bpreview\b|_LivePreviewCard')],
            'confirm': [
              RegExp(r'confirmPublish|\bconfirm\b', caseSensitive: false),
            ],
            'limit': [
              RegExp(
                r'minField|maxField|toi thieu|toi da',
                caseSensitive: false,
              ),
            ],
            'risk': [
              RegExp(
                r'warningNote|_WarningCard|terms|dieu khoan',
                caseSensitive: false,
              ),
            ],
            'payment': [RegExp(r'payment|thanh toan', caseSensitive: false)],
          },
        ),
      ];

      for (final target in targets) {
        final source = asciiFold(target.sourcePaths.map(readSource).join('\n'));
        for (final entry in target.roles.entries) {
          final hasRole = entry.value.any(
            (pattern) => pattern.hasMatch(source),
          );
          expect(
            hasRole,
            isTrue,
            reason: '${target.path} is missing ${entry.key} safety copy.',
          );
        }
      }
    });
  });
}
