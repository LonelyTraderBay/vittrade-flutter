part of 'p2p_merchant_apply_page.dart';

class _BusinessInfoStep extends StatelessWidget {
  const _BusinessInfoStep({
    required this.snapshot,
    required this.nameController,
    required this.descriptionController,
    required this.businessType,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onTypeChanged,
  });

  final P2PMerchantApplySnapshot snapshot;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String businessType;
  final VoidCallback onNameChanged;
  final VoidCallback onDescriptionChanged;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: const ValueKey('sc227_step_business'),
      density: VitDensity.compact,
      children: [
        const _StepIntro(
          title: 'Thông tin doanh nghiệp',
          subtitle: 'Cung cấp thông tin để xác minh tài khoản Merchant.',
        ),
        VitCard(
          padding: VitDensity.compact.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitInput(
                controller: nameController,
                fieldKey: P2PMerchantApplyPage.businessNameFieldKey,
                label: 'Tên doanh nghiệp / Tên hiển thị *',
                hintText: 'VD: CryptoTrader VN',
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => onNameChanged(),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                'Loại hình *',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              VitPresetChipRow<String>(
                items: [
                  for (final type in snapshot.businessTypes)
                    VitPresetChipItem<String>(
                      key: P2PMerchantApplyPage.businessTypeKey(type),
                      value: type,
                      label: type,
                    ),
                ],
                selectedValue: businessType.isEmpty ? null : businessType,
                accentColor: AppModuleAccents.p2p,
                onTap: onTypeChanged,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _MultilineInput(
                controller: descriptionController,
                fieldKey: P2PMerchantApplyPage.businessDescriptionFieldKey,
                label: 'Mô tả (tùy chọn)',
                hintText: 'Giới thiệu ngắn về hoạt động giao dịch của bạn...',
                onChanged: onDescriptionChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsStep extends StatelessWidget {
  const _DocumentsStep({
    required this.documents,
    required this.uploadedDocuments,
    required this.securityNote,
    required this.onToggle,
  });

  final List<P2PMerchantDocumentDraft> documents;
  final Set<String> uploadedDocuments;
  final String securityNote;
  final ValueChanged<P2PMerchantDocumentDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: const ValueKey('sc227_step_documents'),
      density: VitDensity.compact,
      children: [
        const _StepIntro(
          title: 'Xác minh tài liệu',
          subtitle: 'Tải lên các tài liệu cần thiết để xác minh.',
        ),
        for (final document in documents) ...[
          _DocumentCard(
            document: document,
            uploaded: uploadedDocuments.contains(document.id),
            onTap: () => onToggle(document),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        VitInfoCallout(
          message: securityNote,
          icon: Icons.shield_outlined,
          accentColor: AppModuleAccents.p2p,
          padding: P2PSpacingTokens.p2pMerchantApplyInfoPadding,
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.uploaded,
    required this.onTap,
  });

  final P2PMerchantDocumentDraft document;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PMerchantApplyPage.documentKey(document.id),
      onTap: onTap,
      borderColor: uploaded ? AppColors.buy20 : null,
      padding: VitDensity.compact.cardPadding,
      child: Row(
        children: [
          _IconBadge(
            icon: uploaded
                ? Icons.check_circle_rounded
                : _iconFor(document.iconKey),
            color: uploaded ? AppColors.buy : AppColors.text3,
            large: true,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (document.required) ...[
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        '*',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  uploaded ? 'Đã tải lên (Demo)' : document.subtitle,
                  style: AppTextStyles.micro.copyWith(
                    color: uploaded ? AppColors.buy : AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Icon(
            uploaded ? Icons.check_rounded : Icons.upload_rounded,
            color: uploaded ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _HistoryStep extends StatelessWidget {
  const _HistoryStep({required this.stats});

  final P2PMerchantStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetricData(
        label: 'Tổng đơn hoàn thành',
        value: '${stats.totalTrades}',
        color: AppModuleAccents.p2p,
        icon: Icons.trending_up_rounded,
      ),
      _MetricData(
        label: 'Tỷ lệ hoàn thành',
        value: '${stats.completionRate}%',
        color: AppColors.buy,
        icon: Icons.shield_outlined,
      ),
      _MetricData(
        label: 'Thời gian phản hồi TB',
        value: stats.avgResponseTime,
        color: AppColors.warn,
        icon: Icons.access_time_rounded,
      ),
      _MetricData(
        label: 'Tuổi tài khoản',
        value: '${stats.accountAgeDays} ngày',
        color: AppColors.accent,
        icon: Icons.calendar_month_outlined,
      ),
      _MetricData(
        label: 'KL giao dịch 30 ngày',
        value: '${(stats.volume30dVnd / 1000000).toStringAsFixed(1)}M VND',
        color: AppModuleAccents.p2p,
        icon: Icons.show_chart_rounded,
      ),
      _MetricData(
        label: 'Tranh chấp',
        value: '${stats.disputes}',
        color: stats.disputes <= 2 ? AppColors.buy : AppColors.sell,
        icon: Icons.warning_amber_rounded,
      ),
    ];

    return VitPageSection(
      key: const ValueKey('sc227_step_history'),
      density: VitDensity.compact,
      children: [
        const _StepIntro(
          title: 'Đánh giá lịch sử',
          subtitle: 'Hệ thống tự động kiểm tra lịch sử giao dịch.',
        ),
        VitCard(
          padding: VitDensity.compact.cardPadding,
          child: Column(
            children: [
              for (final row in rows) ...[
                _MetricRow(data: row),
                if (row != rows.last) const Divider(color: AppColors.divider),
              ],
            ],
          ),
        ),
        const VitInfoCallout(
          message: 'Tất cả tiêu chí đánh giá đều đạt yêu cầu.',
          icon: Icons.check_circle_rounded,
          accentColor: AppColors.buy,
          padding: P2PSpacingTokens.p2pMerchantApplyInfoPadding,
        ),
      ],
    );
  }
}

class _FinalStep extends StatelessWidget {
  const _FinalStep({
    required this.stats,
    required this.businessName,
    required this.businessType,
    required this.uploadedCount,
    required this.reviewNotice,
    required this.agreementAccepted,
    required this.onToggleAgreement,
  });

  final P2PMerchantStatsDraft stats;
  final String businessName;
  final String businessType;
  final int uploadedCount;
  final String reviewNotice;
  final bool agreementAccepted;
  final VoidCallback onToggleAgreement;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _SummaryData(
        label: 'Tên',
        value: businessName.isEmpty ? '-' : businessName,
      ),
      _SummaryData(
        label: 'Loại hình',
        value: businessType.isEmpty ? '-' : businessType,
      ),
      _SummaryData(label: 'Tổng đơn', value: '${stats.totalTrades}'),
      _SummaryData(label: 'Tỷ lệ HT', value: '${stats.completionRate}%'),
      _SummaryData(label: 'KYC', value: 'Cấp ${stats.kycLevel}'),
      _SummaryData(label: 'Tài liệu', value: '$uploadedCount/3 đã tải'),
    ];

    return VitPageSection(
      key: const ValueKey('sc227_step_final'),
      density: VitDensity.compact,
      children: [
        const _StepIntro(
          title: 'Xác nhận & Gửi đơn',
          subtitle: 'Kiểm tra lại thông tin trước khi nộp đơn đăng ký.',
        ),
        VitCard(
          padding: VitDensity.compact.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tóm tắt đơn đăng ký',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              for (final row in rows) _SummaryRow(data: row),
            ],
          ),
        ),
        _AgreementCard(accepted: agreementAccepted, onTap: onToggleAgreement),
        VitInfoCallout(
          message: reviewNotice,
          icon: Icons.warning_amber_rounded,
          accentColor: AppColors.warn,
          padding: P2PSpacingTokens.p2pMerchantApplyInfoPadding,
        ),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.reviewSteps, required this.onBackToP2P});

  final List<String> reviewSteps;
  final VoidCallback onBackToP2P;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc227_success'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        const Icon(
          Icons.verified_rounded,
          color: AppColors.buy,
          size: AppSpacing.x7,
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        Text(
          'Đơn đã gửi thành công!',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          'Đội ngũ VitTrade sẽ xem xét trong vòng 1-3 ngày làm việc. Bạn sẽ nhận thông báo khi có kết quả.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCard(
          padding: VitDensity.compact.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const VitStatusPill(
                    label: 'Đang xét duyệt',
                    status: VitStatusPillStatus.warning,
                    size: VitStatusPillSize.sm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Trạng thái: Đang xét duyệt',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              for (var i = 0; i < reviewSteps.length; i++) ...[
                Row(
                  children: [
                    _TinyStatusDot(active: i == 0),
                    const SizedBox(width: AppSpacing.x3),
                    Text(
                      reviewSteps[i],
                      style: AppTextStyles.caption.copyWith(
                        color: i == 0 ? AppColors.buy : AppColors.text3,
                        fontWeight: i == 0
                            ? AppTextStyles.bold
                            : AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
                if (i != reviewSteps.length - 1)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCtaButton(
          key: P2PMerchantApplyPage.successCtaKey,
          onPressed: onBackToP2P,
          density: VitDensity.compact,
          child: const Text('Quay về P2P'),
        ),
      ],
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.step,
    required this.canProceed,
    required this.submitting,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  });

  final int step;
  final bool canProceed;
  final bool submitting;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final primary = step < 4
        ? VitCtaButton(
            key: P2PMerchantApplyPage.nextButtonKey,
            onPressed: canProceed ? onNext : null,
            density: VitDensity.compact,
            trailing: const Icon(Icons.arrow_forward_rounded),
            child: const Text('Tiếp tục'),
          )
        : VitCtaButton(
            key: P2PMerchantApplyPage.submitButtonKey,
            onPressed: canProceed && !submitting ? onSubmit : null,
            loading: submitting,
            variant: VitCtaButtonVariant.success,
            density: VitDensity.compact,
            child: Text(submitting ? 'Đang gửi...' : 'Gửi đơn đăng ký'),
          );

    if (step == 0) return primary;

    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2PMerchantApplyPage.previousButtonKey,
            onPressed: onPrevious,
            variant: VitCtaButtonVariant.secondary,
            density: VitDensity.compact,
            leading: const Icon(Icons.arrow_back_rounded),
            child: const Text('Quay lại'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(child: primary),
      ],
    );
  }
}
