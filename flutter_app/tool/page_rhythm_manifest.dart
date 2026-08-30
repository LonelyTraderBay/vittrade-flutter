import 'dart:io';

/// Generates ordered migration manifest for Page Rhythm rollout.
void main(List<String> args) {
  final appRoot = findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Page-Rhythm-Migration-Manifest.csv',
  );

  final rows = <_Row>[];
  for (final entity in Directory(
    '${appRoot.path}/lib',
  ).listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final normalized = _normalizePath(entity.path, appRoot.path);
    if (normalized.endsWith('shared/layout/vit_page_content.dart')) continue;

    final source = entity.readAsStringSync();
    if (!source.contains('VitPageContent(')) continue;

    final tier = _suggestTier(normalized);
    final migrated =
        source.contains('rhythm: VitPageRhythm') ||
        source.contains('rhythm: VitPageRhythm.') ||
        // Shared scaffolds pass `rhythm:` through a field defaulted to
        // `VitPageRhythm.*` (callers may override per page).
        (RegExp(r'\brhythm:\s*rhythm\b').hasMatch(source) &&
            RegExp(r'VitPageRhythm\.\w+').hasMatch(source));
    rows.add(
      _Row(
        cluster: _cluster(normalized),
        relative: normalized,
        file: 'flutter_app/lib/$normalized',
        tier: tier.name,
        status: migrated ? 'done' : 'pending',
        batch: 0,
      ),
    );
  }

  rows.sort((a, b) {
    final cluster = _clusterOrder(
      a.cluster,
    ).compareTo(_clusterOrder(b.cluster));
    if (cluster != 0) return cluster;
    return a.file.compareTo(b.file);
  });

  var batch = 1;
  var inBatch = 0;
  String? lastCluster;
  for (var i = 0; i < rows.length; i++) {
    final row = rows[i];
    if (row.status == 'done') {
      rows[i] = row.copyWith(batch: 0);
      continue;
    }
    if (lastCluster != null && row.cluster != lastCluster && inBatch > 0) {
      if (inBatch < 8) batch++;
      inBatch = 0;
    }
    rows[i] = row.copyWith(batch: batch);
    inBatch++;
    if (inBatch >= 8) {
      batch++;
      inBatch = 0;
    }
    lastCluster = row.cluster;
  }

  final csv = _renderCsv(rows);
  docsDir.createSync(recursive: true);
  csvFile.writeAsStringSync(csv);

  final planFile = File(
    '${docsDir.path}/checklists/Page-Rhythm-Migration-Execution-Plan.md',
  );
  planFile.writeAsStringSync(_renderExecutionPlan(rows, batch));

  final pending = rows.where((r) => r.status == 'pending').length;
  final done = rows.where((r) => r.status == 'done').length;
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.writeln('Wrote ${planFile.path}');
  stdout.writeln(
    'Total: ${rows.length}, done: $done, pending: $pending, batches: $batch',
  );
}

enum _Tier { compact, standard, form, relaxed, flush }

final class _Row {
  const _Row({
    required this.cluster,
    required this.relative,
    required this.file,
    required this.tier,
    required this.status,
    required this.batch,
  });

  final String cluster;
  final String relative;
  final String file;
  final String tier;
  final String status;
  final int batch;

  _Row copyWith({int? batch, String? status}) => _Row(
    cluster: cluster,
    relative: relative,
    file: file,
    tier: tier,
    status: status ?? this.status,
    batch: batch ?? this.batch,
  );
}

String _normalizePath(String absolute, String appRoot) {
  final norm = absolute.replaceAll('\\', '/');
  final root = appRoot.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');
  if (!norm.startsWith('$root/')) {
    throw StateError('Path $norm is not under app root $root');
  }
  final suffix = norm.substring(root.length + 1);
  if (!suffix.startsWith('lib/')) {
    throw StateError('Expected lib/ segment in $suffix');
  }
  return suffix.substring('lib/'.length);
}

int _clusterOrder(String cluster) {
  const order = [
    'home',
    'discovery',
    'news',
    'notifications',
    'markets',
    'predictions',
    'arena',
    'wallet',
    'trade',
    'p2p',
    'earn',
    'profile',
    'auth',
    'onboarding',
    'admin',
    'cross_module',
    'dca',
    'launchpad',
    'referral',
    'support',
    'enterprise',
    'dev',
    'shared',
  ];
  final index = order.indexOf(cluster);
  return index >= 0 ? index : order.length;
}

String _cluster(String relative) {
  final parts = relative.split('/');
  if (parts.isEmpty) return 'shared';
  if (parts[0] == 'features' && parts.length > 1) return parts[1];
  if (parts[0] == 'app') return 'shared';
  return 'shared';
}

_Tier _suggestTier(String relative) {
  if (relative.contains('/dev/')) return _Tier.flush;

  if (relative.contains('/auth/presentation/pages/login_page.dart')) {
    return _Tier.flush;
  }
  if (relative.contains('/auth/') || relative.contains('/onboarding/')) {
    return _Tier.form;
  }
  if (relative.contains('kyc') ||
      relative.contains('governance_gate') ||
      relative.contains('address_add') ||
      relative.contains('withdraw') ||
      relative.contains('dispute') ||
      relative.contains('verification_page') ||
      relative.contains('register_page')) {
    return _Tier.form;
  }

  if (relative.contains('depth') ||
      relative.contains('chart') ||
      relative.contains('terminal') ||
      relative.contains('heatmap_painter') ||
      relative.contains('advanced_chart')) {
    return _Tier.flush;
  }

  if (relative.contains('/home/') ||
      relative.contains('/discovery/') ||
      relative.contains('/news/') ||
      relative.contains('/notifications/') ||
      (relative.contains('/markets/') &&
          !relative.contains('depth') &&
          !relative.contains('advanced_charts')) ||
      (relative.contains('/predictions/') &&
          (relative.contains('home') ||
              relative.contains('leaderboard') ||
              relative.contains('rewards') ||
              relative.contains('global_activity') ||
              relative.contains('breaking') ||
              relative.contains('search_page'))) ||
      (relative.contains('/arena/') &&
          (relative.contains('home') ||
              relative.contains('leaderboard') ||
              relative.contains('my_arena')))) {
    return _Tier.compact;
  }

  if (relative.contains('onboarding_flow_page') &&
      relative.contains('part_01')) {
    return _Tier.relaxed;
  }

  return _Tier.standard;
}

String _renderCsv(List<_Row> rows) {
  final buffer = StringBuffer('batch,cluster,file,tier,status\n');
  for (final row in rows) {
    buffer.writeln(
      '${row.batch},${row.cluster},${_csv(row.file)},${row.tier},${row.status}',
    );
  }
  return buffer.toString();
}

String _csv(String value) {
  if (value.contains(',') || value.contains('"')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

String _renderExecutionPlan(List<_Row> rows, int lastBatch) {
  final now = DateTime.now().toIso8601String().split('T').first;
  final done = rows.where((r) => r.status == 'done').length;
  final pending = rows.where((r) => r.status == 'pending').length;
  final nextBatch = rows
      .where((r) => r.status == 'pending')
      .map((r) => r.batch)
      .fold<int?>(null, (a, b) => a == null || b < a ? b : a);

  final buffer = StringBuffer('''
# Page Rhythm — Kế hoạch thực thi tự động (AI)

> **Mục tiêu:** Migrate toàn bộ `VitPageContent` sang `rhythm: VitPageRhythm.*` theo thứ tự batch, **không dừng giữa chừng** cho đến khi `pending = 0`.
>
> **Manifest nguồn:** `VitTrade-Page-Rhythm-Migration-Manifest.csv` (regenerate sau mỗi batch).
> **Checklist ngắn:** [Page-Rhythm-Migration-Checklist.md](./Page-Rhythm-Migration-Checklist.md)
> **Cập nhật manifest:** `cd flutter_app && dart run tool/page_rhythm_manifest.dart`

---

## Trạng thái hiện tại

| Metric | Giá trị |
| --- | --- |
| Tổng file `VitPageContent` | ${rows.length} |
| Đã migrate (`done`) | $done |
| Còn lại (`pending`) | $pending |
| Batch cuối | ${lastBatch.toString().padLeft(2, '0')} |
| **Batch tiếp theo** | **${(nextBatch ?? 0).toString().padLeft(2, '0')}** |
| Ngày generate | $now |

---

## Quy trình AI (bắt buộc — chạy tuần tự đến hết)

### Vòng lặp chính

```
WHILE manifest có status=pending:
  1. Đọc batch nhỏ nhất còn pending (mục Batch dưới đây)
  2. Với TỪNG file trong batch (theo thứ tự):
     a. import app_page_rhythm.dart
     b. VitPageContent(rhythm: VitPageRhythm.<tier>, ...) — tier theo manifest
     c. Xóa SizedBox orphan giữa sibling top-level (parent owns gap)
     d. Inner gap: pageRhythm*InnerGap hoặc VitSectionHeader.bottomGap
  3. Gate xác minh batch (bắt buộc trước khi sang batch kế):
     cd flutter_app
     flutter analyze lib/features/<cluster_của_batch>/
     flutter test test/features/<cluster>/ --reporter=compact  # nếu có
     dart run tool/page_rhythm_manifest.dart   # cập nhật done/pending
     dart run tool/page_rhythm_audit.dart
  4. Đánh dấu batch DONE trong checkpoint (cuối file)
  5. TIẾP TỤC batch kế — KHÔNG hỏi user, KHÔNG dừng giữa program
UNTIL pending == 0
```

### Quy tắc tier (manifest `tier` column)

| tier | VitPageRhythm | Khi nào |
| --- | --- | --- |
| compact | `.compact` | Feed/tab root: Home, Markets list, Predictions feed, Arena feed |
| standard | `.standard` | Scroll: Wallet, Trade, P2P list, Profile, Earn, Admin |
| form | `.form` | Auth wizard, KYC, withdraw, dispute, governance gate |
| relaxed | `.relaxed` | Onboarding hero |
| flush | `.flush` | Chart, depth, terminal, login hero, `/dev/*` |

**Login đặc biệt:** `rhythm: VitPageRhythm.flush` + `customGap: AppSpacing.zero` nếu cần.

### Anti-pattern (sửa trong cùng batch)

- `SizedBox(height: AppSpacing.sectionGap)` giữa children của `VitPageContent`
- Nested `VitPageContent` chỉ để chèn gap
- Module `*SectionGap` khi đã có `pageRhythm*SectionGap`

### Exception (đánh dấu done, không refactor sâu)

- `/dev/*` — chỉ wire `rhythm: flush`
- CustomPainter / bottom sheet nội bộ — không bọc thêm VitPageContent

---

## Prompt khởi động AI (copy vào chat Agent)

```
Thực thi Page Rhythm migration theo:
docs/02_FLUTTER_MIGRATION/checklists/Page-Rhythm-Migration-Execution-Plan.md

Quy tắc:
1. Đọc mục "Checkpoint AI" và "Batch tiếp theo"
2. Migrate đủ 8 file (hoặc ít hơn nếu batch cuối) — thêm rhythm + dọn orphan gap
3. Chạy gate verify của batch
4. dart run tool/page_rhythm_manifest.dart (cập nhật done/pending)
5. Sang batch kế TIẾP — không dừng, không hỏi user — đến pending=0

Tham chiếu code mẫu: features/home/presentation/phone/pages/home_page_state.dart
```

### Checklist từng file (4 bước)

1. `import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';`
2. `VitPageContent(rhythm: VitPageRhythm.<tier>, ...)` — giữ `padding`/`density` hiện có
3. Xóa `SizedBox` orphan giữa children top-level của `VitPageContent`
4. Section con: `AppSpacing.pageRhythm<Tier>InnerGap` hoặc `VitSectionHeader(bottomGap: ...)`

---

## Checkpoint AI

Sau mỗi batch, cập nhật block này:

```yaml
last_completed_batch: ${(nextBatch ?? 1) - 1}
next_batch: ${nextBatch ?? 'COMPLETE'}
pending_files: $pending
last_verify: <flutter analyze OK | date>
```

---

## Danh sách batch

''');

  for (var b = 1; b <= lastBatch; b++) {
    final batchRows = rows.where((r) => r.batch == b).toList();
    if (batchRows.isEmpty) continue;

    final batchDone = batchRows.every((r) => r.status == 'done');
    final clusters = batchRows.map((r) => r.cluster).toSet().toList()
      ..sort((a, b) => _clusterOrder(a).compareTo(_clusterOrder(b)));
    buffer.writeln(
      '### Batch ${b.toString().padLeft(2, '0')} — ${clusters.join(', ')}',
    );
    buffer.writeln('');
    buffer.writeln('Trạng thái: ${batchDone ? '✅ DONE' : '⏳ PENDING'}');
    buffer.writeln('');
    buffer.writeln('| # | File | Tier | Status |');
    buffer.writeln('| --- | --- | --- | --- |');

    for (var i = 0; i < batchRows.length; i++) {
      final row = batchRows[i];
      final mark = row.status == 'done' ? 'done' : 'pending';
      buffer.writeln('| ${i + 1} | `${row.relative}` | ${row.tier} | $mark |');
    }
    buffer.writeln('');
    final gateCluster = batchRows
        .map((r) => r.cluster)
        .firstWhere((c) => c != 'shared', orElse: () => 'shared');
    if (gateCluster == 'shared') {
      buffer.writeln('**Gate:** `flutter analyze lib/app/ lib/shared/`');
    } else {
      buffer.writeln('**Gate:** `flutter analyze lib/features/$gateCluster/`');
    }
    buffer.writeln('');
  }

  buffer.writeln('---');
  buffer.writeln('');
  buffer.writeln('## File đã migrate trước manifest (batch 0)');
  buffer.writeln('');
  final doneRows = rows.where((r) => r.status == 'done').toList();
  for (final row in doneRows) {
    buffer.writeln('- [x] `${row.relative}` — ${row.tier}');
  }

  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('');
  buffer.writeln('## Phase 5 (sau khi pending = 0)');
  buffer.writeln('');
  buffer.writeln(
    '1. `dart run tool/page_rhythm_audit.dart --check` bật fail CI',
  );
  buffer.writeln('2. Deprecate module `*SectionGap` tokens trùng global');
  buffer.writeln(
    '3. (Tuỳ chọn) VitDensity.standard.pageContentGap 16→13 khi ≥80% pass audit',
  );

  return buffer.toString();
}

Directory findAppRoot() {
  final current = Directory.current;
  if (Directory('${current.path}/lib/app/router/route_groups').existsSync()) {
    return current;
  }
  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/router/route_groups').existsSync()) {
    return nested;
  }
  throw StateError('Run from repo root or flutter_app/.');
}
