part of 'onboarding_flow_page.dart';

class _OnboardingFlowPageState extends ConsumerState<OnboardingFlowPage> {
  OnboardingStepDraft _step = OnboardingStepDraft.welcome;
  int _moduleIndex = 0;
  String? _expandedBoundaryId;
  final Set<OnboardingUserGoalDraft> _selectedGoals = {};

  bool _isBlockingState(OnboardingScreenState state) {
    return switch (state) {
      OnboardingScreenState.loading ||
      OnboardingScreenState.empty ||
      OnboardingScreenState.error => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Biến thể B (GD4-Async-Playbook.md mục 6): OnboardingSnapshot đã có
    // trục screenState riêng (loading/empty/error/offline/ready/...) —
    // map AsyncValue sang screenState thay vì bọc .when() ở trang.
    final snapshot = ref
        .watch(onboardingSnapshotProvider)
        .when(
          data: (value) => value,
          loading: () => _placeholder(OnboardingScreenState.loading),
          error: (error, stackTrace) =>
              _placeholder(OnboardingScreenState.error),
        );
    final blocking = _isBlockingState(snapshot.screenState);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giới thiệu ứng dụng',
      semanticIdentifier: 'SC-397',
      child: Material(
        color: AppColors.bg,
        child: blocking
            ? _buildBlockingShell(snapshot)
            : VitAutoHideHeaderScaffold(
                header: _buildHeader(snapshot),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (snapshot.screenState == OnboardingScreenState.offline)
                      const Padding(
                        key: OnboardingFlowPage.offlineKey,
                        padding: OnboardingSpacingTokens
                            .onboardingHeaderProgressPadding,
                        child: VitOfflineBanner(
                          message:
                              'Mất kết nối. Bạn vẫn có thể hoàn thành onboarding.',
                        ),
                      ),
                    Expanded(child: _buildBody(snapshot)),
                    _buildFooter(snapshot),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBlockingShell(OnboardingSnapshot snapshot) {
    return SafeArea(
      child: switch (snapshot.screenState) {
        OnboardingScreenState.loading => LayoutBuilder(
          key: OnboardingFlowPage.loadingKey,
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsetsDirectional.only(
                start: AppSpacing.contentPad,
                end: AppSpacing.contentPad,
                top: AppSpacing.pageContentTopDefault,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VitSkeleton(
                    height: AppSpacing.buttonHero + AppSpacing.x7,
                    width: constraints.maxWidth,
                    borderRadius: AppRadii.cardLargeRadius,
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  const VitSkeletonList(rows: 3),
                ],
              ),
            );
          },
        ),
        OnboardingScreenState.empty => VitEmptyState(
          key: OnboardingFlowPage.emptyKey,
          title: 'Chưa có nội dung onboarding',
          message: 'Quay lại sau hoặc vào trang chủ để bắt đầu.',
          actionLabel: 'Về trang chủ',
          onAction: () => context.go(snapshot.homeRoute),
        ),
        OnboardingScreenState.error => VitErrorState(
          key: OnboardingFlowPage.errorKey,
          title: 'Không tải được onboarding',
          message: 'Vui lòng thử lại hoặc bỏ qua bước này.',
          actionLabel: 'Thử lại',
          onAction: () => setState(() {}),
          secondaryLabel: 'Bỏ qua',
          onSecondary: () => _skip(snapshot),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildHeader(OnboardingSnapshot snapshot) {
    if (_step == OnboardingStepDraft.complete) return const SizedBox.shrink();

    if (_step == OnboardingStepDraft.welcome) {
      return VitHeader(
        variant: VitHeaderVariant.custom,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: OnboardingSpacingTokens.onboardingHeaderWelcomePadding,
            child: Align(
              alignment: Alignment.centerRight,
              child: VitCtaButton(
                key: OnboardingFlowPage.skipButtonKey,
                onPressed: () => _skip(snapshot),
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                child: Text(
                  snapshot.welcome.skipLabel,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return VitHeader(
      variant: VitHeaderVariant.custom,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: OnboardingSpacingTokens.onboardingHeaderProgressPadding,
          child: _ProgressHeader(
            currentIndex: snapshot.steps.indexOf(_step),
            total: snapshot.steps.length,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(OnboardingSnapshot snapshot) {
    final content = switch (_step) {
      OnboardingStepDraft.welcome => _WelcomeStep(
        key: OnboardingFlowPage.welcomeKey,
        welcome: snapshot.welcome,
      ),
      OnboardingStepDraft.modules => _ModulesStep(
        key: OnboardingFlowPage.modulesKey,
        modules: snapshot.modules,
        currentIndex: _moduleIndex,
        onSelect: (index) {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _moduleIndex = index);
        },
      ),
      OnboardingStepDraft.boundaries => _BoundariesStep(
        key: OnboardingFlowPage.boundariesKey,
        boundaries: snapshot.boundaries,
        separationRules: snapshot.separationRules,
        expandedBoundaryId: _expandedBoundaryId,
        onToggle: (id) {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _expandedBoundaryId = _expandedBoundaryId == id ? null : id;
          });
        },
      ),
      OnboardingStepDraft.trust => _TrustStep(
        key: OnboardingFlowPage.trustKey,
        pillars: snapshot.trustPillars,
        commitments: snapshot.commitments,
      ),
      OnboardingStepDraft.goals => _GoalsStep(
        key: OnboardingFlowPage.goalsKey,
        goals: snapshot.goals,
        selectedGoals: _selectedGoals,
        onToggle: (goal) {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            if (_selectedGoals.contains(goal)) {
              _selectedGoals.remove(goal);
            } else {
              _selectedGoals.add(goal);
            }
          });
        },
      ),
      OnboardingStepDraft.complete => _CompleteStep(
        key: OnboardingFlowPage.completeKey,
        selectedGoals: _selectedGoals.toList(growable: false),
        recommendations: snapshot.recommendations,
        onOpenRoute: _openRoute,
      ),
    };

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: content,
    );
  }

  Widget _buildFooter(OnboardingSnapshot snapshot) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: OnboardingSpacingTokens.onboardingFooterPadding(bottomPadding),
      child: switch (_step) {
        OnboardingStepDraft.welcome => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              key: OnboardingFlowPage.startButtonKey,
              onPressed: () => _advance(snapshot),
              child: Text(snapshot.welcome.ctaLabel),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              snapshot.welcome.helperText,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        OnboardingStepDraft.complete => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              key: OnboardingFlowPage.nextButtonKey,
              onPressed: () => _finishWithPrimary(snapshot),
              trailing: const Icon(Icons.arrow_forward_rounded),
              child: const Text('Bắt đầu sử dụng'),
            ),
            VitCtaButton(
              key: OnboardingFlowPage.homeButtonKey,
              onPressed: () => _openRoute(snapshot.homeRoute),
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              child: Text(
                'Về trang chủ',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        _ => Row(
          children: [
            _BackControl(onPressed: _goBack),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: OnboardingFlowPage.nextButtonKey,
                onPressed: () => _advance(snapshot),
                trailing:
                    _step == OnboardingStepDraft.modules &&
                        _moduleIndex < snapshot.modules.length - 1
                    ? const Icon(Icons.chevron_right_rounded)
                    : null,
                child: Text(_nextLabel(snapshot)),
              ),
            ),
          ],
        ),
      },
    );
  }

  String _nextLabel(OnboardingSnapshot snapshot) {
    if (_step == OnboardingStepDraft.modules) {
      return _moduleIndex < snapshot.modules.length - 1
          ? 'Tiếp theo'
          : 'Đã hiểu';
    }
    if (_step == OnboardingStepDraft.boundaries) return 'Đã hiểu';
    if (_step == OnboardingStepDraft.goals) {
      return _selectedGoals.isEmpty ? 'Bỏ qua' : 'Hoàn tất';
    }
    return 'Tiếp theo';
  }

  void _advance(OnboardingSnapshot snapshot) {
    unawaited(HapticFeedback.selectionClick());
    if (_step == OnboardingStepDraft.modules &&
        _moduleIndex < snapshot.modules.length - 1) {
      setState(() => _moduleIndex += 1);
      return;
    }

    final currentIndex = snapshot.steps.indexOf(_step);
    if (currentIndex < snapshot.steps.length - 1) {
      setState(() => _step = snapshot.steps[currentIndex + 1]);
    }
  }

  void _goBack() {
    unawaited(HapticFeedback.selectionClick());
    final snapshot = ref.read(onboardingSnapshotProvider).value;
    if (snapshot == null) return;
    final currentIndex = snapshot.steps.indexOf(_step);
    if (currentIndex > 0) {
      setState(() => _step = snapshot.steps[currentIndex - 1]);
    }
  }

  void _skip(OnboardingSnapshot snapshot) {
    unawaited(HapticFeedback.selectionClick());
    _markOnboardingSeen();
    context.go(snapshot.homeRoute);
  }

  void _finishWithPrimary(OnboardingSnapshot snapshot) {
    _markOnboardingSeen();
    final selected = _selectedGoals.toList(growable: false);
    final recommendation = selected.isEmpty
        ? null
        : snapshot.recommendations[selected.first];
    _openRoute(recommendation?.route ?? snapshot.homeRoute);
  }

  void _openRoute(String route) {
    unawaited(HapticFeedback.selectionClick());
    _markOnboardingSeen();
    context.go(route);
  }

  /// persist GĐ4-F1: đánh dấu user đã đi qua (hoặc bỏ qua) onboarding.
  void _markOnboardingSeen() {
    unawaited(
      ref
          .read(keyValueStoreProvider)
          .setBool(KeyValueStoreKeys.onboardingSeen, true),
    );
  }
}

/// Placeholder snapshot for the loading/error branches of
/// [onboardingSnapshotProvider] (Biến thể B, GD4-Async-Playbook.md mục 6) —
/// only [OnboardingSnapshot.screenState]/backRoute/homeRoute matter here
/// since `_buildBlockingShell` never reads the other fields for these two
/// states.
OnboardingSnapshot _placeholder(OnboardingScreenState state) {
  return OnboardingSnapshot(
    endpoint: '',
    actionDraft: '',
    supportedStates: const [],
    contractNotes: '',
    backRoute: AppRoutePaths.profile,
    homeRoute: AppRoutePaths.home,
    steps: const [],
    welcome: const OnboardingWelcomeDraft(
      skipLabel: '',
      title: '',
      subtitle: '',
      features: [],
      ctaLabel: '',
      helperText: '',
    ),
    modules: const [],
    boundaries: const [],
    separationRules: const [],
    trustPillars: const [],
    commitments: const [],
    goals: const [],
    recommendations: const {},
    screenState: state,
  );
}
