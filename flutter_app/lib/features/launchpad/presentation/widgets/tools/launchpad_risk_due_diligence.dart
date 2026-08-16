part of '../../phone/pages/tools/launchpad_risk_analytics_page.dart';

class _DueDiligenceTab extends StatelessWidget {
  const _DueDiligenceTab({required this.snapshot});

  final LaunchpadRiskAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final score = snapshot.project.score;
    return KeyedSubtree(
      key: LaunchpadRiskAnalyticsPage.dueDiligenceKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Team & Governance',
            accentColor: AppColors.buy,
            children: [
              _DueDiligenceCard(
                title: 'Team Transparency',
                score: score.teamTransparency,
                rows: const [
                  _InfoRowDraft(label: 'Doxxed Team', value: 'Verified'),
                  _InfoRowDraft(
                    label: 'LinkedIn Profiles',
                    value: '5/5 verified',
                  ),
                  _InfoRowDraft(
                    label: 'Previous Projects',
                    value: '2 successful',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitPageSection(
            label: 'Security Audit',
            accentColor: AppColors.primary,
            children: [
              _DueDiligenceCard(
                title: 'Audit Score',
                score: score.auditScore,
                rows: [
                  for (final audit in snapshot.auditReports)
                    _InfoRowDraft(
                      label: audit.firm,
                      value:
                          '${audit.status} - ${audit.criticalIssues} critical issues',
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitPageSection(
            label: 'Tokenomics Analysis',
            accentColor: AppColors.warn,
            children: [
              _DueDiligenceCard(
                title: 'Tokenomics Health',
                score: score.tokenomics,
                rows: const [
                  _InfoRowDraft(label: 'Total Supply', value: '1B VIT'),
                  _InfoRowDraft(label: 'Circulating', value: '250M (25%)'),
                  _InfoRowDraft(label: 'Team Tokens', value: '15% locked'),
                  _InfoRowDraft(label: 'Top 10 Holders', value: '45%'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _InfoRowDraft {
  const _InfoRowDraft({required this.label, required this.value});

  final String label;
  final String value;
}

class _DueDiligenceCard extends StatelessWidget {
  const _DueDiligenceCard({
    required this.title,
    required this.score,
    required this.rows,
  });

  final String title;
  final int score;
  final List<_InfoRowDraft> rows;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);
    return VitCard(
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              SizedBox(
                width: LaunchpadSpacingTokens.launchpadBox58,
                child: _ScoreProgress(value: score, color: color),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '$score',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
                Text(
                  row.value,
                  style: AppTextStyles.caption.copyWith(
                    color: row.value.contains('45%')
                        ? AppColors.warn
                        : AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
            if (row != rows.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}
