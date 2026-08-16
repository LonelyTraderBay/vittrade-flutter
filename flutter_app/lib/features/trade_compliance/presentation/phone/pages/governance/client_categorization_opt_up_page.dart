part of 'client_categorization_page.dart';

class ClientOptUpRequestPage extends ConsumerStatefulWidget {
  const ClientOptUpRequestPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc411_client_opt_up_content');
  static const criteriaKey = Key('sc411_client_opt_up_criteria');
  static const waiverKey = Key('sc411_client_opt_up_waiver');
  static const submitKey = Key('sc411_client_opt_up_submit');
  static const successKey = Key('sc411_client_opt_up_success');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientOptUpRequestPage> createState() =>
      _ClientOptUpRequestPageState();
}

class _ClientOptUpRequestPageState
    extends ConsumerState<ClientOptUpRequestPage> {
  bool _criteriaConfirmed = false;
  bool _waiverAcknowledged = false;
  bool _submitted = false;

  bool get _canSubmit =>
      _criteriaConfirmed && _waiverAcknowledged && !_submitted;

  Future<void> _submitForReview() async {
    setState(() => _submitted = true);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã lưu yêu cầu rà soát',
      message:
          'Bộ phận tuân thủ phải rà soát trước khi thay đổi phân loại có hiệu lực.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeClientCategorizationProvider);
    return VitTradeDetailScaffold(
      title: 'Yêu cầu nâng hạng khách hàng',
      subtitle: 'Phân loại MiFID II',
      semanticLabel:
          'Yêu cầu nâng hạng lên khách hàng chuyên nghiệp (MiFID II)',
      semanticIdentifier: 'SC-411',
      contentKey: ClientOptUpRequestPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyClientCategorization,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeClientCategorizationProvider),
          ),
        ],
        data: (snapshot) {
          final professional = snapshot.categories.firstWhere(
            (item) => item.id == 'professional',
          );
          return [
            VitTradeComplianceSection(
              title: 'Rà soát nâng hạng',
              statusPill: const VitStatusPill(
                label: 'Không đổi hạng ngay',
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Mục tiêu',
                  value: professional.label,
                ),
                VitTradeComplianceItem(
                  label: 'Tiêu chí',
                  value: '${professional.requirements.length} yêu cầu',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Yêu cầu',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VitCard(
                    density: VitDensity.tool,
                    radius: VitCardRadius.tight,
                    child: VitPageSection(
                      label: 'Tiêu chí khách hàng chuyên nghiệp',
                      density: VitDensity.tool,
                      children: [
                        for (final requirement in professional.requirements)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.track_changes_outlined,
                                color: _clientPrimary,
                                size: 14,
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              Expanded(
                                child: Text(
                                  requirement,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  VitPageSection(
                    density: VitDensity.tool,
                    children: [
                      _OptUpChecklistTile(
                        key: ClientOptUpRequestPage.criteriaKey,
                        value: _criteriaConfirmed,
                        title: 'Tôi đáp ứng tiêu chí khách hàng chuyên nghiệp',
                        subtitle:
                            'Hồ sơ phải được rà soát trước khi hạng có thể thay đổi.',
                        onChanged: (value) =>
                            setState(() => _criteriaConfirmed = value),
                      ),
                      _OptUpChecklistTile(
                        key: ClientOptUpRequestPage.waiverKey,
                        value: _waiverAcknowledged,
                        title: 'Tôi hiểu bảo vệ nhà đầu tư sẽ thay đổi',
                        subtitle:
                            'Nâng hạng có thể làm giảm bảo vệ dành cho khách hàng bán lẻ.',
                        onChanged: (value) =>
                            setState(() => _waiverAcknowledged = value),
                      ),
                    ],
                  ),
                  VitCtaButton(
                    key: ClientOptUpRequestPage.submitKey,
                    onPressed: _canSubmit ? _submitForReview : null,
                    density: VitDensity.tool,
                    child: const Text('Gửi để rà soát'),
                  ),
                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    density: VitDensity.tool,
                    title: 'Rà soát yêu cầu nâng hạng',
                    message:
                        'Xác nhận tiêu chí, miễn trừ bảo vệ, biên lai tuân thủ và bước tiếp theo có hiệu lực chậm được rà soát trước khi đổi hạng.',
                    contractId: 'client-opt-up-review',
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}

class _OptUpChecklistTile extends StatelessWidget {
  const _OptUpChecklistTile({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: _clientPrimary,
        title: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}
