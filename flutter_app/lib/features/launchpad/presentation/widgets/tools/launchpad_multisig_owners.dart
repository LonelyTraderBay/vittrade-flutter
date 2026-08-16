part of '../../phone/pages/tools/launchpad_multisig_page.dart';

class _OwnersSection extends StatelessWidget {
  const _OwnersSection({
    required this.safe,
    required this.copiedField,
    required this.onCopy,
  });

  final LaunchpadMultisigSafeDraft safe;
  final String? copiedField;
  final void Function(String text, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadMultisigPage.ownersKey,
      child: VitPageSection(
        label: 'Owners & Signers',
        accentColor: AppModuleAccents.launchpad,
        children: [
          for (final owner in safe.owners)
            VitCard(
              padding: LaunchpadSpacingTokens.launchpadPaddingX3,
              child: Row(
                children: [
                  VitAccentIconBox(
                    icon: owner.role == LaunchpadMultisigSignerRole.owner
                        ? Icons.verified_user_outlined
                        : Icons.group_outlined,
                    color: owner.role == LaunchpadMultisigSignerRole.owner
                        ? AppModuleAccents.launchpad
                        : AppColors.primary,
                    iconSize: LaunchpadSpacingTokens.launchpadBox36 * .45,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              owner.label,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            VitAccentPill(
                              label: owner.role.name,
                              accentColor:
                                  owner.role ==
                                      LaunchpadMultisigSignerRole.owner
                                  ? AppModuleAccents.launchpad
                                  : AppColors.primary,
                            ),
                          ],
                        ),
                        Text(
                          owner.address,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VitIconButton(
                    key: LaunchpadMultisigPage.copyKey('owner', owner.label),
                    onPressed: () => onCopy(owner.address, owner.label),
                    icon: copiedField == owner.label
                        ? Icons.check_rounded
                        : Icons.copy_rounded,
                    tooltip: 'Copy dia chi ${owner.label}',
                    variant: copiedField == owner.label
                        ? VitIconButtonVariant.success
                        : VitIconButtonVariant.transparent,
                    size: VitIconButtonSize.sm,
                  ),
                ],
              ),
            ),
          _SafeInfoCard(safe: safe),
        ],
      ),
    );
  }
}

class _SafeInfoCard extends StatelessWidget {
  const _SafeInfoCard({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.accent,
                size: LaunchpadSpacingTokens.launchpadIconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thông tin Safe',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _DetailRow(label: 'Address', value: safe.address),
          _DetailRow(label: 'Chain', value: safe.chain),
          _DetailRow(
            label: 'Threshold',
            value: '${safe.threshold} of ${safe.owners.length}',
          ),
          _DetailRow(label: 'Balance', value: safe.balance),
          _DetailRow(label: 'Total Tx', value: '${safe.txCount}'),
        ],
      ),
    );
  }
}
