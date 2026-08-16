part of '../../phone/pages/tools/launchpad_multisig_page.dart';

class _CreateTxCard extends StatelessWidget {
  const _CreateTxCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadMultisigPage.createKey,
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .28),
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      onTap: onTap,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.add_rounded,
            color: AppModuleAccents.launchpad,
            iconSize: LaunchpadSpacingTokens.launchpadBox40 * .45,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tạo giao dịch mới',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.launchpad,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Tạo tx cần nhiều chữ ký',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueSection extends StatelessWidget {
  const _QueueSection({
    required this.txs,
    required this.expandedTxId,
    required this.copiedField,
    required this.onToggle,
    required this.onCopy,
    required this.onSign,
    required this.onExecute,
  });

  final List<LaunchpadMultisigTxDraft> txs;
  final String? expandedTxId;
  final String? copiedField;
  final ValueChanged<String> onToggle;
  final void Function(String text, String field) onCopy;
  final ValueChanged<String> onSign;
  final ValueChanged<String> onExecute;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadMultisigPage.queueKey,
      child: VitPageSection(
        label: 'Hàng đợi giao dịch',
        accentColor: AppModuleAccents.launchpad,
        children: [
          if (txs.isEmpty)
            const VitEmptyState(
              icon: Icons.group_outlined,
              title: 'Không có giao dịch chờ xử lý',
              message: 'Tạo giao dịch mới để bắt đầu.',
            )
          else
            for (final tx in txs)
              _TxCard(
                tx: tx,
                expanded: expandedTxId == tx.id,
                copiedField: copiedField,
                onToggle: () => onToggle(tx.id),
                onCopy: onCopy,
                onSign: () => onSign(tx.id),
                onExecute: () => onExecute(tx.id),
              ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.txs,
    required this.expandedTxId,
    required this.copiedField,
    required this.onToggle,
    required this.onCopy,
  });

  final List<LaunchpadMultisigTxDraft> txs;
  final String? expandedTxId;
  final String? copiedField;
  final ValueChanged<String> onToggle;
  final void Function(String text, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadMultisigPage.historyKey,
      child: VitPageSection(
        label: 'Giao dịch đã hoàn tất',
        accentColor: AppColors.buy,
        children: [
          if (txs.isEmpty)
            const VitEmptyState(
              icon: Icons.history_rounded,
              title: 'Chưa có lịch sử',
              message: 'Giao dịch đã thực hiện sẽ hiển thị tại đây.',
            )
          else
            for (final tx in txs)
              _TxCard(
                tx: tx,
                expanded: expandedTxId == tx.id,
                copiedField: copiedField,
                onToggle: () => onToggle(tx.id),
                onCopy: onCopy,
              ),
        ],
      ),
    );
  }
}
