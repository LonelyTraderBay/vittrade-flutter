part of 'p2p_claim_detail_page.dart';

class _ReasonShareRow extends StatelessWidget {
  const _ReasonShareRow({required this.row});

  final P2PClaimReasonShareDraft row;

  @override
  Widget build(BuildContext context) {
    final color = row.highlight ? AppModuleAccents.p2p : AppColors.text3;
    return Row(
      children: [
        SizedBox(
          width: P2PSpacingTokens.p2pClaimReasonLabelWidth,
          child: Text(
            row.label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: row.highlight
                  ? AppTextStyles.bold
                  : AppTextStyles.normal,
            ),
          ),
        ),
        Expanded(
          child: VitProgressBar(
            progress: row.percent / 100,
            color: row.highlight ? AppModuleAccents.p2p : AppColors.text3,
            height: _p2pClaimProgressLineExtent,
            trackColor: AppColors.surface3,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '${row.percent}%',
          style: AppTextStyles.micro.copyWith(
            color: row.highlight ? AppModuleAccents.p2p : AppColors.text3,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MiniStatTile extends StatelessWidget {
  const _MiniStatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.descriptionKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Mô tả',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: _p2pClaimDescriptionLine,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimSectionTabs extends StatelessWidget {
  const _ClaimSectionTabs({
    required this.active,
    required this.claim,
    required this.onChanged,
  });

  final _ClaimDetailSection active;
  final P2PClaimDetailDraft claim;
  final ValueChanged<_ClaimDetailSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: P2PClaimDetailPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (value) => onChanged(_ClaimDetailSection.values.byName(value)),
      tabs: [
        VitTabItem(
          key: _ClaimDetailSection.timeline.name,
          label: 'Lịch sử  ${claim.timeline.length}',
        ),
        VitTabItem(
          key: _ClaimDetailSection.evidence.name,
          label: 'Bằng chứng  ${claim.evidence.length}',
        ),
        VitTabItem(
          key: _ClaimDetailSection.notes.name,
          label: 'Ghi chú  ${claim.reviewerNotes.length}',
        ),
      ],
    );
  }
}

class _ClaimSectionBody extends StatelessWidget {
  const _ClaimSectionBody({required this.section, required this.claim});

  final _ClaimDetailSection section;
  final P2PClaimDetailDraft claim;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _ClaimDetailSection.timeline => _TimelineSection(events: claim.timeline),
      _ClaimDetailSection.evidence => _EvidenceSection(files: claim.evidence),
      _ClaimDetailSection.notes => _NotesSection(notes: claim.reviewerNotes),
    };
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.events});

  final List<P2PClaimTimelineEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PClaimDetailPage.timelineKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < events.length; i++)
          _TimelineEventRow(event: events[i], isLast: i == events.length - 1),
      ],
    );
  }
}

class _TimelineEventRow extends StatelessWidget {
  const _TimelineEventRow({required this.event, required this.isLast});

  final P2PClaimTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _timelineColor(event.statusKey);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.x7,
          child: Column(
            children: [
              SizedBox(
                width: P2PSpacingTokens.p2pClaimTimelineNodeSize,
                height: _p2pClaimTimelineNodeExtent,
                child: Material(
                  color: _statusBackground(color),
                  shape: CircleBorder(side: BorderSide(color: color)),
                  child: Icon(
                    _timelineIcon(event.statusKey),
                    color: color,
                    size: P2PSpacingTokens.p2pClaimTimelineNodeIcon,
                  ),
                ),
              ),
              if (!isLast)
                const SizedBox(
                  width: P2PSpacingTokens.p2pClaimTimelineConnectorWidth,
                  height: _p2pClaimTimelineConnectorExtent,
                  child: ColoredBox(color: AppColors.divider),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Padding(
            padding: P2PSpacingTokens.p2pClaimTimelineRowPadding(isLast),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pClaimBodyLine,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.actor == null
                      ? event.timestamp
                      : '${event.timestamp} · ${event.actor}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EvidenceSection extends StatelessWidget {
  const _EvidenceSection({required this.files});

  final List<P2PClaimEvidenceDraft> files;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PClaimDetailPage.evidenceKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UploadEvidenceCard(count: files.length),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final file in files) ...[
          _EvidenceFileCard(file: file),
          if (file != files.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _UploadEvidenceCard extends StatelessWidget {
  const _UploadEvidenceCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.borderSolid,
      padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
      child: Column(
        children: [
          const SizedBox(
            width: _p2pClaimIconBoxExtent,
            height: _p2pClaimIconBoxExtent,
            child: Material(
              color: AppColors.primary12,
              borderRadius: AppRadii.lgRadius,
              child: Icon(
                Icons.upload_file_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Tải lên bằng chứng',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Đã có $count tệp. Hỗ trợ PNG, JPG, PDF, DOC',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _EvidenceFileCard extends StatelessWidget {
  const _EvidenceFileCard({required this.file});

  final P2PClaimEvidenceDraft file;

  @override
  Widget build(BuildContext context) {
    final isImage = file.type == 'image' || file.type == 'screenshot';
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
      child: Row(
        children: [
          SizedBox(
            width: _p2pClaimIconBoxExtent,
            height: _p2pClaimIconBoxExtent,
            child: Material(
              color: isImage ? AppColors.accent12 : AppColors.primary12,
              borderRadius: AppRadii.smRadius,
              child: Icon(
                isImage ? Icons.image_outlined : Icons.description_outlined,
                color: isImage ? AppColors.accent : AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${file.size} · ${file.uploadedAt}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.visibility_outlined,
            color: AppColors.text2,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final List<P2PClaimReviewerNoteDraft> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PClaimDetailPage.notesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final note in notes) ...[
          _ReviewerNoteCard(note: note),
          if (note != notes.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
          child: Row(
            children: [
              const Icon(
                Icons.send_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Gửi tin nhắn cho reviewer...',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
