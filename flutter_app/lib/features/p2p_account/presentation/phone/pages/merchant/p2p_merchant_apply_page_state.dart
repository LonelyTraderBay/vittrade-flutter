part of 'p2p_merchant_apply_page.dart';

class _P2PMerchantApplyPageState extends ConsumerState<P2PMerchantApplyPage> {
  static const List<String> _steps = [
    'Yêu cầu',
    'Thông tin',
    'Xác minh',
    'Lịch sử',
    'Hoàn tất',
  ];

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();

  int _step = 0;
  String _businessType = '';
  bool _agreementAccepted = false;
  bool _submitting = false;
  bool _submitted = false;
  final Set<String> _uploadedDocuments = {};

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pMerchantApplyProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pMerchantApplyVisualNavClearance +
                  P2PSpacingTokens.p2pMerchantApplyBottomInsetVisual
            : _p2pMerchantApplyNativeNavClearance +
                  P2PSpacingTokens.p2pMerchantApplyBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đăng ký Merchant P2P',
      semanticIdentifier: 'SC-227',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Đăng ký Merchant',
            subtitle: 'Merchant · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pMerchantApplyProvider),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_submitted)
                  _ProgressHeader(steps: _steps, currentStep: _step),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PMerchantApplyPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pMerchantApplyScrollPadding(
                        scrollEndPadding,
                      ),
                      child: _submitted
                          ? _SuccessState(
                              reviewSteps: snapshot.reviewSteps,
                              onBackToP2P: () => context.go(AppRoutePaths.p2p),
                            )
                          : VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.none,
                              fullBleed: true,
                              density: VitDensity.compact,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: _stepContent(snapshot),
                                ),
                                _NavigationButtons(
                                  step: _step,
                                  canProceed: _canProceed(snapshot),
                                  submitting: _submitting,
                                  onPrevious: _previous,
                                  onNext: _next,
                                  onSubmit: () => _submit(snapshot),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent(P2PMerchantApplySnapshot snapshot) {
    return switch (_step) {
      0 => _RequirementsStep(snapshot: snapshot),
      1 => _BusinessInfoStep(
        snapshot: snapshot,
        nameController: _businessNameController,
        descriptionController: _businessDescriptionController,
        businessType: _businessType,
        onNameChanged: () => setState(() {}),
        onDescriptionChanged: () => setState(() {}),
        onTypeChanged: (value) {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _businessType = value);
        },
      ),
      2 => _DocumentsStep(
        documents: snapshot.documents,
        uploadedDocuments: _uploadedDocuments,
        securityNote: snapshot.securityNote,
        onToggle: _toggleDocument,
      ),
      3 => _HistoryStep(stats: snapshot.stats),
      _ => _FinalStep(
        stats: snapshot.stats,
        businessName: _businessNameController.text.trim(),
        businessType: _businessType,
        uploadedCount: _uploadedDocuments.length,
        reviewNotice: snapshot.reviewNotice,
        agreementAccepted: _agreementAccepted,
        onToggleAgreement: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _agreementAccepted = !_agreementAccepted);
        },
      ),
    };
  }

  bool _canProceed(P2PMerchantApplySnapshot snapshot) {
    return switch (_step) {
      0 => snapshot.allRequirementsMet,
      1 =>
        _businessNameController.text.trim().isNotEmpty &&
            _businessType.isNotEmpty,
      2 =>
        snapshot.documents
            .where((document) => document.required)
            .every((document) => _uploadedDocuments.contains(document.id)),
      3 => true,
      _ => _agreementAccepted,
    };
  }

  void _next() {
    if (_step >= _steps.length - 1) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _step += 1);
  }

  void _previous() {
    if (_step <= 0) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _step -= 1);
  }

  void _toggleDocument(P2PMerchantDocumentDraft document) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_uploadedDocuments.contains(document.id)) {
        _uploadedDocuments.remove(document.id);
      } else {
        _uploadedDocuments.add(document.id);
      }
    });
  }

  Future<void> _submit(P2PMerchantApplySnapshot snapshot) async {
    if (!_canProceed(snapshot) || _submitting) return;
    unawaited(HapticFeedback.lightImpact());
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.steps, required this.currentStep});

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: P2PSpacingTokens.p2pMerchantApplyProgressPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < steps.length; i++)
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StepConnector(
                                active: i > 0 && i <= currentStep,
                              ),
                            ),
                            _StepDot(index: i, activeIndex: currentStep),
                            Expanded(
                              child: _StepConnector(active: i < currentStep),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          steps[i],
                          key: P2PMerchantApplyPage.stepKey(i),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.micro.copyWith(
                            color: i <= currentStep
                                ? AppColors.text1
                                : AppColors.text3,
                            fontWeight: i <= currentStep
                                ? AppTextStyles.bold
                                : AppTextStyles.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pMerchantApplyConnectorPadding,
      child: SizedBox(
        height: _p2pMerchantApplyConnectorHeight,
        child: Material(
          color: active ? AppColors.buy : AppColors.surface3,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.activeIndex});

  final int index;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final completed = index < activeIndex;
    final active = index == activeIndex;
    final color = completed
        ? AppColors.buy
        : active
        ? AppModuleAccents.p2p
        : AppColors.surface3;
    return SizedBox.square(
      dimension: P2PSpacingTokens.p2pMerchantApplyStepDotSize,
      child: Material(
        color: color,
        shape: CircleBorder(
          side: BorderSide(
            color: completed || active ? color : AppColors.borderSolid,
          ),
        ),
        child: Center(
          child: completed
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconSm,
                )
              : Text(
                  '${index + 1}',
                  style: AppTextStyles.micro.copyWith(
                    color: active ? AppColors.onAccent : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                    height: _p2pMerchantApplyTightLineHeight,
                  ),
                ),
        ),
      ),
    );
  }
}

class _RequirementsStep extends StatelessWidget {
  const _RequirementsStep({required this.snapshot});

  final P2PMerchantApplySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: const ValueKey('sc227_step_requirements'),
      density: VitDensity.compact,
      children: [
        const _StepIntro(
          title: 'Trở thành Merchant',
          subtitle:
              'Nâng cấp tài khoản để nhận ưu đãi độc quyền và tăng uy tín.',
        ),
        _BenefitGrid(benefits: snapshot.benefits),
        _RequirementChecklist(requirements: snapshot.requirements),
      ],
    );
  }
}

class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid({required this.benefits});

  final List<P2PMerchantBenefitDraft> benefits;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: benefits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: P2PSpacingTokens.p2pMerchantApplyBenefitCrossAxisCount,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        mainAxisExtent: _p2pMerchantApplyBenefitExtent,
      ),
      itemBuilder: (context, index) => _BenefitCard(benefit: benefits[index]),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final P2PMerchantBenefitDraft benefit;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(benefit.toneKey);
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: _iconFor(benefit.iconKey), color: tone),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            benefit.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            benefit.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _p2pMerchantApplyCompactLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementChecklist extends StatelessWidget {
  const _RequirementChecklist({required this.requirements});

  final List<P2PMerchantRequirementDraft> requirements;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Yêu cầu tối thiểu',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final requirement in requirements) ...[
            _RequirementRow(requirement: requirement),
            if (requirement != requirements.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.requirement});

  final P2PMerchantRequirementDraft requirement;

  @override
  Widget build(BuildContext context) {
    final color = requirement.met ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        _CircleStatusIcon(met: requirement.met),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            requirement.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: requirement.met ? AppColors.text1 : AppColors.sell,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          requirement.value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
