part of '../../phone/pages/tools/launchpad_multisig_page.dart';

class _CreateTxSheet extends StatefulWidget {
  const _CreateTxSheet({
    required this.safe,
    required this.onClose,
    required this.onCreate,
  });

  final LaunchpadMultisigSafeDraft safe;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadMultisigTxDraft> onCreate;

  @override
  State<_CreateTxSheet> createState() => _CreateTxSheetState();
}

class _CreateTxSheetState extends State<_CreateTxSheet> {
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contractController = TextEditingController();
  final _functionController = TextEditingController();
  final _valueController = TextEditingController(text: '0');

  @override
  void dispose() {
    _labelController.dispose();
    _descriptionController.dispose();
    _contractController.dispose();
    _functionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _labelController.text.trim().isNotEmpty &&
        _contractController.text.trim().isNotEmpty &&
        _functionController.text.trim().isNotEmpty;
    return Material(
      key: LaunchpadMultisigPage.createSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .64),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DeviceMetrics.width,
              maxHeight: 760,
            ),
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.sheetTopLargeRadius,
                ),
              ),
              child: SingleChildScrollView(
                padding: LaunchpadSpacingTokens.launchpadCreateSheetPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: LaunchpadSpacingTokens.launchpadBox40,
                        height: AppSpacing.x1,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tạo giao dịch Multi-sig',
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        VitIconButton(
                          key: LaunchpadMultisigPage.cancelCreateKey,
                          onPressed: widget.onClose,
                          icon: Icons.close_rounded,
                          tooltip: 'Dong tao giao dich Multi-sig',
                          variant: VitIconButtonVariant.transparent,
                          size: VitIconButtonSize.md,
                        ),
                      ],
                    ),
                    _SafeSheetBadge(safe: widget.safe),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    VitInput(
                      label: 'Tên giao dịch',
                      hintText: 'VD: Withdraw rewards',
                      controller: _labelController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    VitInput(
                      label: 'Mô tả',
                      hintText: 'Chi tiết giao dịch...',
                      controller: _descriptionController,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    VitInput(
                      label: 'Contract Address',
                      hintText: '0x...',
                      controller: _contractController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    VitInput(
                      label: 'Function Name',
                      hintText: 'VD: transfer, approve, claimRewards',
                      controller: _functionController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    VitInput(
                      label: 'Value (native token)',
                      hintText: '0',
                      controller: _valueController,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    _CreateWarning(safe: widget.safe),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      key: LaunchpadMultisigPage.submitCreateKey,
                      onPressed: canSubmit ? _submit : null,
                      child: const Text('Tạo giao dịch'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    widget.onCreate(
      LaunchpadMultisigTxDraft(
        id: 'mtx_new',
        label: _labelController.text.trim(),
        description: _descriptionController.text.trim(),
        contractAddress: _contractController.text.trim(),
        chain: widget.safe.chain,
        accent: widget.safe.accent,
        functionName: _functionController.text.trim(),
        params: const {},
        value: _valueController.text.trim().isEmpty
            ? '0'
            : _valueController.text.trim(),
        estimatedGas: r'$0.10',
        status: LaunchpadMultisigTxStatus.pendingSignatures,
        threshold: widget.safe.threshold,
        signers: widget.safe.owners,
        signedCount: 0,
        createdAt: '07/03/2026 10:00',
        expiresAt: '14/03/2026 10:00',
        nonce: widget.safe.txCount + 1,
        safeAddress: widget.safe.address,
      ),
    );
  }
}

class _SafeSheetBadge extends StatelessWidget {
  const _SafeSheetBadge({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppModuleAccents.launchpad.withValues(alpha: .08),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX2,
        child: Row(
          children: [
            Icon(
              Icons.shield_outlined,
              color: safe.accent.resolve(),
              size: LaunchpadSpacingTokens.launchpadIconLg,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                safe.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '${safe.threshold}/${safe.owners.length}',
              style: AppTextStyles.micro.copyWith(color: safe.accent.resolve()),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateWarning extends StatelessWidget {
  const _CreateWarning({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.warn15),
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: LaunchpadSpacingTokens.launchpadIconMd,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Cần ${safe.threshold} chữ ký từ ${safe.owners.length} signers. Giao dịch hết hạn sau 7 ngày.',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
