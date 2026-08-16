part of '../../phone/pages/staking/staking_proof_of_reserves_page.dart';

class _VerifySheet extends StatefulWidget {
  const _VerifySheet({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  State<_VerifySheet> createState() => _VerifySheetState();
}

class _VerifySheetState extends State<_VerifySheet> {
  final _userId = TextEditingController();
  final _balance = TextEditingController();
  StakingMerkleProofDraft? _proof;

  @override
  void dispose() {
    _userId.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        key: StakingProofOfReservesPage.verifySheetKey,
        padding: EarnSpacingTokens.earnContentMargin,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.cardLargeRadius,
            padding: EarnSpacingTokens.earnPaddingX5,
            child: SingleChildScrollView(
              child: _proof == null ? _form(context) : _proofView(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetTitle(title: 'Verify Your Balance'),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Text(
            widget.snapshot.verifyInfo,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _TextInput(
          fieldKey: StakingProofOfReservesPage.userIdFieldKey,
          label: 'User ID',
          controller: _userId,
          hint: 'e.g., user_12345',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _TextInput(
          fieldKey: StakingProofOfReservesPage.balanceFieldKey,
          label: 'Staked Balance (ETH)',
          controller: _balance,
          hint: 'e.g., 10.5',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          key: StakingProofOfReservesPage.verifySubmitKey,
          onPressed: _verify,
          leading: const Icon(Icons.verified_outlined),
          child: const Text('Verify Inclusion'),
        ),
      ],
    );
  }

  Widget _proofView(BuildContext context) {
    final proof = _proof!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetTitle(title: 'Verify Your Balance'),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          key: StakingProofOfReservesPage.proofResultKey,
          variant: VitCardVariant.inner,
          borderColor: AppColors.buy20,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.x7,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const Text(
                'Verification Successful',
                style: AppTextStyles.baseMedium,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Your balance of ${proof.balance.toStringAsFixed(2)} ETH is included in the Proof of Reserves Merkle tree.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const Text('Merkle Proof', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _HashCard(label: 'Leaf Hash', value: proof.leaf),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _HashCard(label: 'Merkle Root', value: proof.root),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sibling Hashes (${proof.siblings.length})',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              for (var i = 0; i < proof.siblings.length; i++)
                Text(
                  '${i + 1}. ${_shortHash(proof.siblings[i])}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          variant: VitCtaButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _verify() {
    if (_userId.text.trim().isEmpty || _balance.text.trim().isEmpty) return;
    final balance = double.tryParse(_balance.text.trim()) ?? 0;
    setState(() {
      _proof = StakingMerkleProofDraft(
        userId: _userId.text.trim(),
        balance: balance,
        leaf: '0x7a9c35cc6634c0532925a3b844bc9e7595f0beb4129dfad7890abc123',
        root:
            '0xabc123def456789012345678901234567890123456789012345678901234567890',
        siblings: const [
          '0x4df1741e6cdd9012cba8419900aa4455129dfad7890abc123',
          '0x62ab993d3d79012cba8419900aa4455129dfad7890abc123',
          '0x91cc0a18e52f012cba8419900aa4455129dfad7890abc123',
        ],
        verified: true,
      );
    });
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitInput(
          fieldKey: fieldKey,
          controller: controller,
          semanticLabel: label,
          hintText: hint,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class _HashCard extends StatelessWidget {
  const _HashCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _shortHash(value),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.content_copy_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        VitIconButton(
          icon: Icons.close_rounded,
          tooltip: 'Close',
          onPressed: () => Navigator.of(context).pop(),
          variant: VitIconButtonVariant.transparent,
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }
}

String _shortHash(String value) => maskAddress(value, head: 20, tail: 10);
