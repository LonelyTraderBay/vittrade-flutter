import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_entities.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';

final class MockOnboardingRepository implements OnboardingRepository {
  const MockOnboardingRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('onboarding_mock_fetch_failed');
  }

  @override
  Future<OnboardingSnapshot> getFlow() async {
    await _simulateNetwork();
    return const OnboardingSnapshot(
      endpoint: '/api/mobile/onboarding/onboarding',
      screenState: OnboardingScreenState.ready,
      actionDraft:
          'read-only reference data plus local navigation actions for step, '
          'goal selection, skip, complete, and recommended route handoff',
      supportedStates: [
        OnboardingScreenState.loading,
        OnboardingScreenState.empty,
        OnboardingScreenState.error,
        OnboardingScreenState.offline,
        OnboardingScreenState.ready,
        OnboardingScreenState.submitting,
        OnboardingScreenState.success,
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Response owns '
          'onboardingReferenceData and screenState while runtime step progress '
          'remains local until account persistence is introduced.',
      backRoute: AppRoutePaths.profile,
      homeRoute: AppRoutePaths.home,
      steps: [
        OnboardingStepDraft.welcome,
        OnboardingStepDraft.modules,
        OnboardingStepDraft.boundaries,
        OnboardingStepDraft.trust,
        OnboardingStepDraft.goals,
        OnboardingStepDraft.complete,
      ],
      welcome: OnboardingWelcomeDraft(
        skipLabel: 'Bỏ qua',
        title: 'Chào mừng đến với\nTrading App',
        subtitle:
            'Nền tảng toàn diện cho Trading, P2P, Prediction Markets và Arena Challenges',
        ctaLabel: 'Bắt đầu',
        helperText: 'Chỉ mất 1 phút để hoàn thành',
        features: [
          OnboardingFeatureDraft(
            id: 'trading',
            title: 'Giao dịch đa dạng',
            description: 'Spot, P2P, Prediction Markets - tất cả trong một',
          ),
          OnboardingFeatureDraft(
            id: 'security',
            title: 'An toàn & Minh bạch',
            description: 'Bảo mật tối đa, rõ ràng từng giao dịch',
          ),
          OnboardingFeatureDraft(
            id: 'smart',
            title: 'Tính năng thông minh',
            description: 'DCA tự động, Rebalance, Smart Scheduling',
          ),
        ],
      ),
      modules: [
        OnboardingModuleDraft(
          id: 'trading',
          name: 'Trading',
          description: 'Giao dịch Crypto Spot',
          features: [
            'Mua/bán crypto nhanh chóng',
            'Biểu đồ giá realtime',
            'DCA tự động',
            'Portfolio tracking',
          ],
        ),
        OnboardingModuleDraft(
          id: 'wallet',
          name: 'Wallet',
          description: 'Quản lý tài sản',
          features: [
            'Nạp/rút crypto & fiat',
            'Lịch sử giao dịch',
            'Bảo mật đa lớp',
            'Hỗ trợ đa loại tài sản',
          ],
        ),
        OnboardingModuleDraft(
          id: 'p2p',
          name: 'P2P',
          description: 'Giao dịch ngang hàng',
          features: [
            'Mua/bán trực tiếp',
            'Escrow tự động',
            'Nhiều phương thức thanh toán',
            'Rating & review',
          ],
        ),
        OnboardingModuleDraft(
          id: 'prediction',
          name: 'Prediction Markets',
          description: 'Dự đoán sự kiện',
          features: [
            'Thị trường dự đoán',
            'Xác suất realtime',
            'Portfolio & P/L',
            'Leaderboard',
          ],
        ),
        OnboardingModuleDraft(
          id: 'arena',
          name: 'Open Arena',
          description: 'Thử thách cộng đồng',
          features: [
            'Tạo/tham gia challenges',
            'Arena Points (không phải tiền)',
            'Creator tools',
            'Community-driven',
          ],
        ),
      ],
      boundaries: [
        OnboardingBoundaryDraft(
          id: 'value',
          title: 'Trading & P2P',
          subtitle: 'Giá trị thực - Wallet liên kết',
          nature: 'Market / Value-based',
          examples: [
            'Giao dịch Spot, P2P - dùng crypto/fiat thật',
            'Prediction Markets - positions có giá trị',
            'Wallet balance, PnL, lịch sử giao dịch',
          ],
        ),
        OnboardingBoundaryDraft(
          id: 'points',
          title: 'Open Arena',
          subtitle: 'Arena Points - Không liên quan wallet',
          nature: 'Social / Points-only',
          examples: [
            'Thử thách cộng đồng dùng Arena Points',
            'Không ảnh hưởng số dư wallet',
            'Không phải tài sản tài chính',
          ],
        ),
      ],
      separationRules: [
        'Wallet và Arena Points tách biệt hoàn toàn',
        'PnL Trading không gộp với điểm Arena',
        'Leaderboard Trading và Arena riêng biệt',
        'Không có chuyển đổi điểm sang tiền',
      ],
      trustPillars: [
        OnboardingTrustDraft(
          id: 'safety',
          title: 'An toàn theo thiết kế',
          description:
              'Mọi giao dịch có preview, confirm, và trạng thái rõ ràng trước khi thực hiện.',
        ),
        OnboardingTrustDraft(
          id: 'transparency',
          title: 'Minh bạch tuyệt đối',
          description:
              'Phí, slippage, network - tất cả hiển thị đầy đủ trước khi bạn xác nhận.',
        ),
        OnboardingTrustDraft(
          id: 'security',
          title: 'Bảo mật đa lớp',
          description:
              '2FA, biometrics, anti-phishing code, quản lý thiết bị & phiên đăng nhập.',
        ),
        OnboardingTrustDraft(
          id: 'no_dark_patterns',
          title: 'Không dark patterns',
          description:
              'Không FOMO, không hype, không che giấu rủi ro. Thông tin trung thực, rõ ràng.',
        ),
      ],
      commitments: [
        'Preview đầy đủ trước mọi giao dịch',
        'Escrow tự động bảo vệ P2P',
        'Dispute resolution rõ quy trình',
        'Arena có governance & moderation',
        'Không hứa hẹn lợi nhuận',
      ],
      goals: [
        OnboardingGoalDraft(
          id: OnboardingUserGoalDraft.tradeCrypto,
          label: 'Giao dịch Crypto',
          description: 'Mua/bán, Spot trading',
        ),
        OnboardingGoalDraft(
          id: OnboardingUserGoalDraft.saveRegularly,
          label: 'Tiết kiệm định kỳ',
          description: 'DCA, đầu tư tự động',
        ),
        OnboardingGoalDraft(
          id: OnboardingUserGoalDraft.p2pExchange,
          label: 'Giao dịch P2P',
          description: 'Mua/bán trực tiếp',
        ),
        OnboardingGoalDraft(
          id: OnboardingUserGoalDraft.predictEvents,
          label: 'Prediction Markets',
          description: 'Dự đoán sự kiện',
        ),
        OnboardingGoalDraft(
          id: OnboardingUserGoalDraft.arenaChallenges,
          label: 'Arena Challenges',
          description: 'Thử thách cộng đồng',
          disclosure: 'Arena Points only',
        ),
        OnboardingGoalDraft(
          id: OnboardingUserGoalDraft.earnRewards,
          label: 'Kiếm thưởng',
          description: 'Staking, referral',
        ),
      ],
      recommendations: {
        OnboardingUserGoalDraft.tradeCrypto: OnboardingRecommendationDraft(
          title: 'Giao dịch đầu tiên',
          description: 'Mua hoặc bán crypto nhanh chóng',
          route: '/trade/BTCUSDT',
        ),
        OnboardingUserGoalDraft.saveRegularly: OnboardingRecommendationDraft(
          title: 'Tạo kế hoạch DCA',
          description: 'Thiết lập đầu tư định kỳ tự động',
          route: AppRoutePaths.dca,
        ),
        OnboardingUserGoalDraft.p2pExchange: OnboardingRecommendationDraft(
          title: 'Khám phá P2P',
          description: 'Tìm offer tốt nhất từ cộng đồng',
          route: AppRoutePaths.p2p,
        ),
        OnboardingUserGoalDraft.predictEvents: OnboardingRecommendationDraft(
          title: 'Xem Prediction Markets',
          description: 'Khám phá các sự kiện dự đoán',
          route: AppRoutePaths.markets,
        ),
        OnboardingUserGoalDraft.arenaChallenges: OnboardingRecommendationDraft(
          title: 'Tham gia Arena',
          description: 'Khám phá thử thách cộng đồng',
          route: AppRoutePaths.home,
        ),
        OnboardingUserGoalDraft.earnRewards: OnboardingRecommendationDraft(
          title: 'Kiếm thưởng ngay',
          description: 'Staking và referral programs',
          route: AppRoutePaths.home,
        ),
      },
    );
  }
}
