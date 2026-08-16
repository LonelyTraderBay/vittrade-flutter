// Origin: 9048cda4 (2026-05-31) - feat(flutter): hoàn thiện nền tảng enterprise VitTrade
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter_test/flutter_test.dart';

import 'product_copy_guardrail_test_utils.dart';

/// SEC-S42 (A-Plus GĐ3): stem tài chính TIẾNG VIỆT đã fold ASCII — bắt copy
/// vi phạm ranh giới Arena dù viết tiếng Việt có dấu (nguồn được asciiFold
/// trước khi so). Dùng CỤM GHÉP thay vì từ đơn: 'vi' đơn lẻ đụng 'vì/với'
/// sau fold (bẫy tiếng Việt không dấu đã biết), cụm 'vi tien'/'lien ket vi'
/// thì không nhập nhằng. Mở rộng cụm mới tại một chỗ này.
const viFinancialStems =
    r'vi tien|lien ket vi|rut tien|nap tien|chuyen tien|loi nhuan|'
    r'tien mat|dat cuoc|thanh toan|thang tien|thua tien';

void main() {
  group('product copy guardrails - Arena and auth', () {
    test('Arena and RewardsHub reward surfaces stay points-only', () {
      final files = [
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
        'lib/features/rewards/presentation/phone/pages/rewards_hub_page.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      for (final path in files) {
        final source = readSource(path);
        expect(source, isNot(contains('task-wallet')), reason: path);
        expect(
          RegExp(r"rewardLabel:\s*'[^']*\bUSDT\b").allMatches(source),
          isEmpty,
          reason: path,
        );
      }

      final visibleRewardSurfaces = [
        'lib/features/rewards/presentation/phone/pages/rewards_hub_page.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      for (final path in visibleRewardSurfaces) {
        final source = readSource(path);
        expect(source, isNot(contains('USDT')), reason: path);
      }
    });

    test('Arena reward labels avoid financial payout language', () {
      final files = [
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      final unsafeRewardLabel = RegExp(
        "rewardLabel:\\s*'[^']*\\b(USDT|USD|wallet|payout|profit|cash|"
        '$viFinancialStems)\\b',
        caseSensitive: false,
      );

      for (final path in files) {
        // SEC-S42: fold dấu trước khi so — bắt cả copy tiếng Việt có dấu.
        final source = asciiFold(readSource(path));
        expect(unsafeRewardLabel.allMatches(source), isEmpty, reason: path);
      }
    });

    test('Arena user-facing pages avoid prohibited financial terms', () {
      final arenaPages = listDartFiles(
        'lib/features/arena/presentation/phone/pages',
      );
      final prohibited = RegExp(
        r'\b(wallet|profit|payout|stake|USDT|USD|cash|PnL|P/L|'
        '$viFinancialStems)\\b',
        caseSensitive: false,
      );
      // SEC-S42: câu CẤM dùng thuật ngữ tài chính là đồng minh của ranh
      // giới, không phải vi phạm — allowlist theo NỘI DUNG fold chính xác
      // (exact substring, không mở lỗ hổng theo file hay pattern).
      const negativePolicyAllowlist = {
        'Khong dung vi, gia tri tien, loi nhuan hoac cam ket hoan diem.',
      };
      final findings = <String>[];

      for (final file in arenaPages) {
        final lines = file.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          // SEC-S42: fold dấu từng dòng — copy tiếng Việt có dấu vi phạm
          // ranh giới cũng bị bắt, không chỉ thuật ngữ tiếng Anh.
          final line = asciiFold(lines[index]);
          if (!prohibited.hasMatch(line)) continue;
          if (negativePolicyAllowlist.any(line.contains)) continue;
          findings.add('${file.path}:${index + 1}: ${lines[index].trim()}');
        }
      }

      expect(
        findings,
        isEmpty,
        reason:
            'Open Arena user-facing copy must stay points-only. '
            'Prediction/financial boundary text belongs in explicit bridge '
            'documentation and safety controls, not Arena action pages.',
      );
    });

    test('Arena bridge documentation keeps Prediction and Arena separated', () {
      final source = readSource(
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
      );

      expect(source, contains('Open Arena = Points only'));
      expect(source, contains('Prediction Markets = Real positions'));
      expect(source, contains('no_wallet_link'));
      expect(source, contains('Points + PnL'));
    });

    test('Arena governance, report, and challenge state stay points-only', () {
      final source = asciiFold(
        [
          'lib/features/arena/presentation/phone/pages/governance/arena_governance_gate_page.dart',
          'lib/features/arena/presentation/phone/pages/governance/arena_governance_gate_page_tier_style.dart',
          'lib/features/arena/presentation/phone/pages/governance/arena_report_case_page.dart',
          'lib/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart',
          'lib/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page_overview_section.dart',
          'lib/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page_tabs_and_panels.dart',
          'lib/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page_actions_and_shared_widgets.dart',
          'lib/features/arena/presentation/controllers/arena_controller.dart',
          'lib/features/arena/presentation/controllers/arena_creation_controller.dart',
          'lib/features/arena/presentation/widgets/phone/arena_state_cards.dart',
        ].map(readSource).join('\n'),
      );

      final unsafe = RegExp(
        r'\b(wallet|profit|payout|stake-return|USDT|USD|cash|PnL|P/L|'
        '$viFinancialStems)\\b',
        caseSensitive: false,
      );
      expect(unsafe.allMatches(source), isEmpty);

      final roles = {
        'Arena Points': [RegExp(r'Arena Points', caseSensitive: false)],
        'Points pool': [RegExp(r'Points pool', caseSensitive: false)],
        'governance state': [
          RegExp(r'Governance state|ArenaGovernanceActionState'),
        ],
        'report review': [
          RegExp(r'Moderation review state|ArenaReportReviewState'),
        ],
        'fair play': [RegExp(r'fair-play|fair play', caseSensitive: false)],
      };

      for (final entry in roles.entries) {
        final hasRole = entry.value.any((pattern) => pattern.hasMatch(source));
        expect(hasRole, isTrue, reason: 'Arena state is missing ${entry.key}.');
      }
    });

    test('Arena release-gated surfaces avoid placeholder readiness copy', () {
      final source = asciiFold(
        [
          'lib/features/arena/data/fixtures/arena_mode_challenge_detail_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_creator_trust_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_points_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_flow_map_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_production_ecosystem_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_connected_guide_repository_methods.dart',
          'lib/features/arena/presentation/phone/pages/challenge/verified_challenges_page.dart',
          'lib/features/arena/presentation/phone/pages/hub/arena_production_ready_page_screens_states_section.dart',
          'lib/features/arena/presentation/phone/pages/hub/arena_production_ready_page_flows_registry_handoff.dart',
          'lib/features/arena/presentation/phone/pages/bridge/connected_ecosystem_production_page.dart',
          'lib/features/arena/presentation/phone/pages/bridge/connected_ecosystem_production_page_canonical_states_section.dart',
        ].map(readSource).join('\n'),
      );

      final misleading = RegExp(
        r'placeholder future-ready|placeholder only|Coming Soon|Not available in production yet|Production Ready',
        caseSensitive: false,
      );
      expect(misleading.allMatches(source), isEmpty);
      expect(source, contains('Release-gated Preview'));
      expect(source, contains('release-readiness'));
    });

    test(
      'auth reset flow does not carry OTP secrets in route query params',
      () {
        final otpPage = readSource(
          'lib/features/auth/presentation/phone/pages/otp_page.dart',
        );
        final authRoutes = readSource(
          'lib/app/router/route_groups/auth_routes.dart',
        );

        expect(otpPage, isNot(contains('otp=')));
        expect(otpPage, isNot(contains('authResetPassword}?')));
        expect(authRoutes, isNot(contains("queryParameters['otp']")));
        expect(authRoutes, isNot(contains("queryParameters['email']")));
      },
    );
  });
}
