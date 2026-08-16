part of '../../phone/pages/safety/dispute_resolution_page.dart';

class _FileComplaintTab extends StatelessWidget {
  const _FileComplaintTab({
    required this.snapshot,
    required this.selectedType,
    required this.selectedProviderId,
    required this.subjectController,
    required this.descriptionController,
    required this.evidenceAttached,
    required this.canSubmit,
    required this.onTypeChanged,
    required this.onProviderChanged,
    required this.onUpload,
    required this.onSubmit,
  });

  final TradeDisputeResolutionSnapshot snapshot;
  final String? selectedType;
  final String? selectedProviderId;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final bool evidenceAttached;
  final bool canSubmit;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String?> onProviderChanged;
  final VoidCallback onUpload;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _NoticeCard(title: snapshot.noticeTitle, body: snapshot.noticeBody),
        VitPageSection(
          key: DisputeResolutionPage.complaintTypeSectionKey,
          label: 'Complaint Type',
          density: VitDensity.tool,
          children: [
            for (final type in snapshot.complaintTypes)
              _ComplaintTypeCard(
                option: type,
                selected: selectedType == type.value,
                onPressed: () => onTypeChanged(type.value),
              ),
          ],
        ),
        VitPageSection(
          label: 'Provider',
          density: VitDensity.tool,
          children: [
            _ProviderSelect(
              providers: snapshot.providers,
              selectedProviderId: selectedProviderId,
              onChanged: onProviderChanged,
            ),
          ],
        ),
        VitPageSection(
          label: 'Details',
          density: VitDensity.tool,
          children: [
            const _FieldLabel('Subject'),
            _TextFieldShell(
              key: DisputeResolutionPage.subjectKey,
              controller: subjectController,
              hint: 'Brief summary of the issue',
            ),
            const _FieldLabel('Description'),
            _TextFieldShell(
              key: DisputeResolutionPage.descriptionKey,
              controller: descriptionController,
              hint:
                  'Describe the issue in detail. Include dates, trade IDs, amounts, etc.',
              minLines: 3,
              maxLines: 5,
            ),
          ],
        ),
        VitPageSection(
          label: 'Evidence',
          density: VitDensity.tool,
          children: [
            _UploadEvidenceButton(
              attached: evidenceAttached,
              onPressed: onUpload,
            ),
            _SubmitButton(enabled: canSubmit, onPressed: onSubmit),
          ],
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _disputePrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _disputePrimary,
            size: TradeSpacingTokens.tradeBotSmallIcon,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputePrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(color: _disputePrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintTypeCard extends StatelessWidget {
  const _ComplaintTypeCard({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final TradeComplaintTypeOption option;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: DisputeResolutionPage.complaintTypeKey(option.value),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      constraints: const BoxConstraints(
        minHeight: TradeSpacingTokens.tradeBotOptionMinHeight,
      ),
      density: VitDensity.tool,
      borderColor: selected ? _disputePrimary : _disputeFieldBorder,
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: selected ? _disputePrimary : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: selected ? _disputePrimary : AppColors.text3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderSelect extends StatelessWidget {
  const _ProviderSelect({
    required this.providers,
    required this.selectedProviderId,
    required this.onChanged,
  });

  final List<TradeDisputeProviderOption> providers;
  final String? selectedProviderId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: DisputeResolutionPage.providerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: _disputeFieldBorder,
      constraints: const BoxConstraints(
        minHeight: TradeSpacingTokens.tradeBotControlCompact,
      ),
      padding: TradeSpacingTokens.tradeBotDisputeProviderPadding,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProviderId,
          dropdownColor: _disputeField,
          borderRadius: AppRadii.cardRadius,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
            size: TradeSpacingTokens.tradeBotDisputeDropdownIcon,
          ),
          hint: Text(
            'Select provider...',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          style: AppTextStyles.caption.copyWith(color: AppColors.text1),
          items: [
            for (final provider in providers)
              DropdownMenuItem<String>(
                value: provider.id,
                child: Text(provider.name),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TextFieldShell extends StatelessWidget {
  const _TextFieldShell({
    super.key,
    required this.controller,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    if (minLines == 1 && maxLines == 1) {
      return VitInput(
        controller: controller,
        hintText: hint,
        textInputAction: TextInputAction.next,
      );
    }

    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: _disputePrimary,
      style: AppTextStyles.caption.copyWith(color: AppColors.text1),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
        filled: true,
        fillColor: _disputeField,
        contentPadding: TradeSpacingTokens.tradeBotDisputeTextFieldPadding,
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.cardRadius,
          borderSide: BorderSide(color: _disputeFieldBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.cardRadius,
          borderSide: BorderSide(color: _disputePrimary, width: 1.5),
        ),
      ),
    );
  }
}

class _UploadEvidenceButton extends StatelessWidget {
  const _UploadEvidenceButton({
    required this.attached,
    required this.onPressed,
  });

  final bool attached;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DisputeResolutionPage.uploadKey,
      onPressed: onPressed,
      variant: attached
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.secondary,
      density: VitDensity.tool,
      leading: Icon(
        attached ? Icons.check_circle_outline_rounded : Icons.upload_rounded,
      ),
      child: Text(
        attached ? 'Evidence attached' : 'Upload Evidence (Optional)',
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DisputeResolutionPage.submitKey,
      onPressed: enabled ? onPressed : null,
      density: VitDensity.tool,
      leading: const Icon(Icons.send_outlined),
      child: const Text('Submit Complaint'),
    );
  }
}
