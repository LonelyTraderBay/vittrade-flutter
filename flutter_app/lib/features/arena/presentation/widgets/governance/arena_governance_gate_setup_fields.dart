part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _TitleField extends StatelessWidget {
  const _TitleField({required this.title, required this.onChanged});

  final String title;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Tên challenge',
      required: true,
      child: TextFormField(
        key: ArenaGovernanceGatePage.titleKey,
        initialValue: title,
        onChanged: onChanged,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration('VD: BTC Weekly Predict — Tuần 10'),
      ),
    );
  }
}

class _DomainGrid extends StatelessWidget {
  const _DomainGrid({
    required this.domains,
    required this.selectedId,
    required this.publicRoom,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> domains;
  final String selectedId;
  final bool publicRoom;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Lĩnh vực',
      required: publicRoom,
      child: Wrap(
        spacing: AppSpacing.x2,
        runSpacing: AppSpacing.x3,
        children: [
          for (final domain in domains)
            _MiniOptionChip(
              key: ArenaGovernanceGatePage.domainKey(domain.id),
              icon: _domainIcon(domain.id),
              label: domain.label,
              selected: selectedId == domain.id,
              onTap: () => onSelected(domain.id),
            ),
        ],
      ),
    );
  }
}

class _ChallengeTypeGrid extends StatelessWidget {
  const _ChallengeTypeGrid({
    required this.types,
    required this.selectedId,
    required this.publicRoom,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> types;
  final String selectedId;
  final bool publicRoom;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Loại challenge',
      required: publicRoom,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: types.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ArenaSpacingTokens.arenaGovernanceGridColumns,
          childAspectRatio: ArenaSpacingTokens.arenaGovernanceDomainGridAspect,
          crossAxisSpacing: AppSpacing.x2,
          mainAxisSpacing: AppSpacing.x2,
        ),
        itemBuilder: (context, index) {
          final type = types[index];
          return _MiniOptionChip(
            key: ArenaGovernanceGatePage.challengeTypeKey(type.id),
            icon: _challengeIcon(type.id),
            label: type.label,
            selected: selectedId == type.id,
            onTap: () => onSelected(type.id),
          );
        },
      ),
    );
  }
}

class _WinConditionCard extends StatelessWidget {
  const _WinConditionCard({
    required this.snapshot,
    required this.subject,
    required this.action,
    required this.metric,
    required this.winType,
    required this.deadlineContext,
    required this.customWinCondition,
    required this.publicRoom,
    required this.onSubject,
    required this.onAction,
    required this.onMetric,
    required this.onWinType,
    required this.onDeadlineContext,
    required this.onCustomWinChanged,
  });

  final ArenaGovernanceSnapshot snapshot;
  final String subject;
  final String action;
  final String metric;
  final String winType;
  final String deadlineContext;
  final String customWinCondition;
  final bool publicRoom;
  final VoidCallback onSubject;
  final VoidCallback onAction;
  final VoidCallback onMetric;
  final VoidCallback onWinType;
  final VoidCallback onDeadlineContext;
  final ValueChanged<String> onCustomWinChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.adjust_rounded,
                color: AppColors.accent,
                size: ArenaSpacingTokens.arenaGovernanceIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Điều kiện thắng',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (publicRoom) const _RequiredPill(text: 'BẮT BUỘC'),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          GridView.count(
            crossAxisCount: ArenaSpacingTokens.arenaGovernanceGridColumns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.x2,
            mainAxisSpacing: AppSpacing.x2,
            childAspectRatio: ArenaSpacingTokens.arenaGovernanceWinGridAspect,
            children: [
              _BuilderField(
                label: 'A. Chủ thể',
                value: subject,
                onTap: onSubject,
              ),
              _BuilderField(
                label: 'B. Hành động',
                value: action,
                onTap: onAction,
              ),
              _BuilderField(label: 'C. Chỉ số', value: metric, onTap: onMetric),
              _BuilderField(
                label: 'D. Kiểu thắng',
                value: winType,
                onTap: onWinType,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _BuilderField(
            label: 'E. Thời điểm',
            value: deadlineContext,
            onTap: onDeadlineContext,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          TextFormField(
            initialValue: customWinCondition,
            onChanged: onCustomWinChanged,
            maxLines: 2,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            decoration: _inputDecoration(
              'VD: Người đoán gần nhất với giá ETH vào 25/03 lúc 10:00 sẽ thắng.',
            ),
          ),
        ],
      ),
    );
  }
}
