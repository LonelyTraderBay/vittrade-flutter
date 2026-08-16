// Origin: 70c67af6 (2026-07-17) - refactor: nâng cấp nền tảng VitTrade Flutter theo lộ trình enterprise A+
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Scalar/record-of-scalar key types that are safe as a `Provider.family`
/// key without `.autoDispose` — Dart records built only from these fields
/// have structural (value) equality and a naturally bounded key space, so
/// they do not leak an element per rebuild the way an object-with-identity
/// key (e.g. a mutable draft class) does.
const _safeKeyTypes = {'String', 'int', 'double', 'num', 'bool'};

/// PERF-HN2 (c): family-key autoDispose guardrail phải quét cả composition
/// root (`lib/app/providers`, không đệ quy — layout hiện tại phẳng) LẪN
/// từng feature's own `data/providers/*.dart` (STATE-S26 đã tách repository
/// providers ra khỏi `app/providers` cho một số feature — xem AGENTS.md
/// "Architecture"). Đo thực tế (2026-07-17): quét mở rộng không lộ vi phạm
/// nào (`grep -rn '\.family[<(]' lib/features/**/data/providers/*.dart` =
/// 0 kết quả) — không cần allowlist thêm, drift ghi nhận trong báo cáo
/// PERF-HN2 là "đã phủ đủ, không cần sửa gì".
Iterable<File> _providerFiles() sync* {
  yield* Directory('lib/app/providers').listSync().whereType<File>();
  for (final file in Directory(
    'lib/features',
  ).listSync(recursive: true).whereType<File>()) {
    final path = file.path.replaceAll('\\', '/');
    if (path.endsWith('.dart') && path.contains('/data/providers/')) {
      yield file;
    }
  }
}

void main() {
  group('state management guardrails', () {
    test('Provider.family with a non-scalar key uses autoDispose', () {
      // Baseline (2026-07-16, A-Plus roadmap STATE-S24): these already
      // key a Provider.family by a record/class that is not a bare
      // scalar and are not yet autoDispose. Fixing them is PERF-HN1 /
      // STATE-S22's job (draft-keyed leak, idiom migration) — this
      // guardrail's job is to stop the pattern from spreading further.
      // Remove an entry here only once the referenced provider is fixed.
      const allowlist = {
        // tradeOrderControllerProvider / tradeFuturesOrderControllerProvider
        // fixed by PERF-HN1 (2026-07-16): now .autoDispose.family, and
        // their draft key types (TradeOrderDraft/TradeFuturesOrderDraft)
        // gained value equality — no longer need an allowlist entry.
        // tradeLeverageControllerProvider / tradeMarginControllerProvider
        // fixed by STATE-S22 (2026-07-17): leverage thành NotifierProvider
        // family key String; margin thêm .autoDispose.
        'lib/app/providers/p2p_controller_providers.dart:p2pHomeProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pExpressConfirmProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pTaxReportingProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pWalletTransferProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeCopyConfirmationControllerProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeCopyConfigurationControllerProvider',
        'lib/app/providers/wallet_controller_providers.dart:walletDepositControllerProvider',
        'lib/app/providers/wallet_controller_providers.dart:withdrawControllerProvider',
      };

      final violations = <String>[];
      for (final file in _providerFiles()) {
        if (!file.path.endsWith('.dart')) continue;
        final source = file.readAsStringSync();
        final path = file.path.replaceAll('\\', '/');

        for (final match in RegExp(
          r'final\s+(\w+)\s*=\s*Provider(\.autoDispose)?\.family<([^,]+),\s*([^>]+(?:<[^>]*>)?[^>]*)>\(',
          dotAll: true,
        ).allMatches(source)) {
          final providerName = match.group(1)!;
          final hasAutoDispose = match.group(2) != null;
          final keyType = match.group(4)!.trim();
          if (hasAutoDispose) continue;
          if (_safeKeyTypes.contains(keyType)) continue;

          final id = '$path:$providerName';
          if (allowlist.contains(id)) continue;
          violations.add(id);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'New Provider.family declarations with a non-scalar key must '
            'use .autoDispose.family (or key by a bare scalar id instead '
            'of a record/class) to avoid leaking one cache element per '
            'rebuild: $violations',
      );
    });

    test('presentation pages do not seed a mutable local list from ref.read '
        '(dual-source state)', () {
      // Baseline gốc (2026-07-16, STATE-S24 / S2.3) từng ghim 17 trang.
      // STATE-S23 (2026-07-17) đã migrate TOÀN BỘ sang Notifier tại
      // composition root (khuôn MarketWatchlistStateController) — allowlist
      // về RỖNG và phải giữ rỗng: trang mới seed `late List` từ ref.read
      // + setState là fail ngay. otp_page.dart's `late final
      // List<TextEditingController>` là UI controller list hợp lệ, không
      // thuộc phạm vi guardrail này.
      const allowlist = <String>{};

      final violations = <String>[];
      for (final file in Directory(
        'lib/features',
      ).listSync(recursive: true).whereType<File>()) {
        final path = file.path.replaceAll('\\', '/');
        if (!path.endsWith('.dart')) continue;
        final isPage =
            path.contains('/presentation/pages/') ||
            RegExp(r'/presentation/(phone|tablet|web)/pages/').hasMatch(path);
        if (!isPage) continue;

        final source = file.readAsStringSync();
        final hasMutableLateList = RegExp(
          r'late\s+List<\w+>\s+_\w+;',
        ).hasMatch(source);
        if (!hasMutableLateList) continue;
        if (!source.contains('ref.read(')) continue;

        if (allowlist.contains(path)) continue;
        violations.add(path);
      }

      expect(
        violations,
        isEmpty,
        reason:
            'New pages seed a mutable local list from ref.read(...) '
            'instead of a Notifier, reintroducing the dual-source-of-truth '
            'pattern S2.3 migrates away from: $violations',
      );
    });

    test('write controllers are exposed via NotifierProvider, not Provider', () {
      // Baseline (2026-07-17, A-Plus roadmap STATE-S26 / ADR-001): các
      // controller CÓ đường ghi (gọi _repository.submit*/patch*/create*)
      // nhưng vẫn bọc trong `Provider` thường — migrate dần theo
      // STATE-S22/S23/TEST-HR3, xóa entry khi controller đã thành Notifier.
      // Controller read-model thuần (không match marker ghi) được phép giữ
      // Provider const theo đúng chuẩn AGENTS.md.
      const allowlist = {
        // tradeLeverageControllerProvider + tradeFuturesOrderControllerProvider
        // đã thành NotifierProvider ở STATE-S22 (2026-07-17) — xóa khỏi baseline.
        'lib/app/providers/trade_controller_providers.dart:tradeOrdersHistoryControllerProvider',
        'lib/app/providers/trade_bots_controller_providers.dart:tradeBotEmergencyStopControllerProvider',
        'lib/app/providers/trade_bots_controller_providers.dart:tradeBotSecuritySettingsControllerProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeActiveCopiesControllerProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeCopySettingsControllerProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeProviderApplicationControllerProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeCopyConfirmationControllerProvider',
        'lib/app/providers/trade_terminal_controller_providers.dart:tradeRiskManagementControllerProvider',
        'lib/app/providers/trade_terminal_controller_providers.dart:tradeAdvancedToolsControllerProvider',
      };

      // Marker "đường ghi" trong body class controller (model file).
      final writeMarker = RegExp(
        r'_repository\.(submit|patch|create|update|amend|cancel)|'
        r'\.submitOrderAction\(',
      );

      // Gom body class controller theo tên từ toàn bộ model files.
      final controllerSources = <String, String>{};
      for (final file in Directory(
        'lib/features',
      ).listSync(recursive: true).whereType<File>()) {
        final path = file.path.replaceAll('\\', '/');
        if (!path.contains('/presentation/controllers/')) continue;
        if (!path.endsWith('.dart')) continue;
        final source = file.readAsStringSync();
        for (final match in RegExp(
          r'class\s+(\w+Controller)[\s<]',
        ).allMatches(source)) {
          final name = match.group(1)!;
          final next = source.indexOf('\nfinal class ', match.start + 1);
          final end = next < 0 ? source.length : next;
          controllerSources[name] = source.substring(match.start, end);
        }
      }

      final violations = <String>[];
      for (final file in Directory(
        'lib/app/providers',
      ).listSync().whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final source = file.readAsStringSync();
        final path = file.path.replaceAll('\\', '/');

        // Anchor `= Provider` để KHÔNG match NotifierProvider/AsyncNotifier.
        for (final match in RegExp(
          r'final\s+(\w+)\s*=\s*Provider[\.<(]',
        ).allMatches(source)) {
          final providerName = match.group(1)!;
          final declEnd = source.indexOf('\nfinal ', match.start + 1);
          final body = source.substring(
            match.start,
            declEnd < 0 ? source.length : declEnd,
          );
          final ctor = RegExp(r'return\s+(\w+Controller)\(').firstMatch(body);
          if (ctor == null) continue;
          final controllerBody = controllerSources[ctor.group(1)!];
          if (controllerBody == null) continue;
          if (!writeMarker.hasMatch(controllerBody)) continue;

          final id = '$path:$providerName';
          if (allowlist.contains(id)) continue;
          violations.add(id);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Controller có đường ghi (submit/patch/...) phải là '
            'NotifierProvider theo ADR-001/AGENTS.md — Provider const chỉ '
            'dành cho read-model thuần: $violations',
      );
    });
  });
}
