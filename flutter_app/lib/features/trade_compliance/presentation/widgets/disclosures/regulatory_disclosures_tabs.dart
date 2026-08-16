part of '../../phone/pages/disclosures/regulatory_disclosures_page.dart';

class _MifidTab extends StatelessWidget {
  const _MifidTab({required this.snapshot});

  final TradeRegulatoryDisclosuresSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitSectionHeader(
          title: snapshot.mifidTitle,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        for (final article in snapshot.mifidArticles)
          _DisclosureCard(block: article),
        _CommitmentCard(text: snapshot.commitmentText),
      ],
    );
  }
}

class _ProtectionTab extends StatelessWidget {
  const _ProtectionTab({required this.protection, required this.onNotice});

  final TradeRegulatoryProtection protection;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Investor Protection Scheme',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        _DisclosureCard(
          block: protection.coverage,
          color: _legalGreen,
          tint: _legalGreen.withValues(alpha: .13),
        ),
        _DisclosureCard(block: protection.covered),
        _DisclosureCard(block: protection.notCovered),
        _DisclosureCard(block: protection.claimSteps, numbered: true),
        _ActionTile(
          title: protection.contactLabel,
          icon: Icons.phone_outlined,
          color: _legalPrimary,
          onTap: () => onNotice('ICS contact details would open here.'),
        ),
      ],
    );
  }
}

class _RestrictionsTab extends StatelessWidget {
  const _RestrictionsTab({required this.restrictions});

  final TradeRegulatoryRestrictions restrictions;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Jurisdictional Restrictions',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        _WarningList(
          title: 'Copy Trading Not Available In:',
          items: restrictions.unavailableCountries,
        ),
        _LeverageRules(rules: restrictions.leverageRules),
        _DisclosureCard(block: restrictions.taxReporting),
      ],
    );
  }
}

class _LiabilityTab extends StatelessWidget {
  const _LiabilityTab({required this.liability});

  final TradeRegulatoryLiability liability;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Liability Limitations',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        _DisclosureCard(block: liability.platformRole),
        _DisclosureCard(block: liability.userResponsibility),
        _DisclosureCard(
          block: liability.indemnification,
          color: AppColors.sell,
          tint: AppColors.sell10,
          icon: Icons.warning_amber_rounded,
        ),
        _DisclosureCard(block: liability.limitation),
      ],
    );
  }
}

class _ContactTab extends StatelessWidget {
  const _ContactTab({
    required this.contacts,
    required this.whistleblower,
    required this.terms,
    required this.onNotice,
  });

  final List<TradeRegulatoryContact> contacts;
  final TradeRegulatoryDisclosureBlock whistleblower;
  final List<TradeRegulatoryDocumentLink> terms;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Regulatory Contact Information',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        for (final contact in contacts)
          _ContactTile(
            contact: contact,
            onTap: () => onNotice('${contact.title} would open externally.'),
          ),
        const VitSectionHeader(
          title: 'Whistleblower Protection',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        _DisclosureCard(
          block: whistleblower,
          color: _legalGreen,
          tint: _legalGreen.withValues(alpha: .13),
        ),
        const VitSectionHeader(
          title: 'Terms & Privacy',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _legalPrimary,
        ),
        for (final document in terms)
          _DocumentTile(
            document: document,
            onTap: () => onNotice('${document.title} would open here.'),
          ),
      ],
    );
  }
}
