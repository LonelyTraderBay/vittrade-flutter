// ignore_for_file: avoid_print
import 'dart:io';

/// Pre-flight mô phỏng đúng chuỗi kiểm tra tĩnh của CI "Flutter CI"
/// (`.github/workflows/flutter-ci.yml`) TRÊN MÁY LOCAL trước khi commit/push:
///
///   P1  dart format --output=none --set-exit-if-changed .
///       → bắt lớp lỗi "3 file lệch format" làm CI đỏ (run 32591422202).
///   P2  flutter analyze.
///   P3  Mọi lệnh `dart run tool/* --check` đọc trực tiếp từ workflow CI,
///       chạy trên BẢN CHECKOUT SẠCH tái tạo từ index sắp commit
///       (`git add -A` → `git write-tree` → `git archive`).
///       → bắt lớp lỗi "artifact audit được commit từ một cây có code chưa
///       commit": working tree bẩn thì audit local pass, nhưng CI checkout
///       sạch regenerate từ HEAD thuần sẽ khác kết quả (run 32592775969).
///   P4  flutter test --reporter=compact (guardrails + goldens + unit) —
///       một số vi phạm (tint viền ngoài 3 bậc, baseline ratchet…) chỉ bị
///       guardrail test bắt. Bỏ qua bằng flag `--fast`.
///
/// Chạy từ `flutter_app/`: `dart run tool/preflight_check.dart`.
///
/// Tool chỉ dùng dart:io (không dependency). P3 stage toàn bộ thay đổi
/// để tree phản ánh đúng commit sắp tạo, nhưng KHÔNG tạo commit — sau khi
/// PASS thì mọi thứ đã sẵn sàng trong index để commit ngay.
const String _workflowPath = '.github/workflows/flutter-ci.yml';

int _failures = 0;

void _report(bool ok, String label, [String? detail]) {
  stdout.writeln(ok ? '[PASS] $label' : '[FAIL] $label');
  if (!ok && detail != null && detail.isNotEmpty) {
    for (final line in detail.split('\n')) {
      stdout.writeln('       $line');
    }
  }
  if (!ok) _failures++;
}

ProcessResult _shell(
  String exe,
  List<String> args, {
  required String workingDirectory,
}) {
  // Windows: flutter/git là .bat/.cmd trong PATH — cmd /c resolve được.
  if (Platform.isWindows) {
    return Process.runSync('cmd', [
      '/c',
      exe,
      ...args,
    ], workingDirectory: workingDirectory);
  }
  return Process.runSync(exe, args, workingDirectory: workingDirectory);
}

String _git(String root, List<String> args) {
  final r = _shell('git', args, workingDirectory: root);
  if (r.exitCode != 0) {
    throw StateError(
      'git ${args.join(' ')} thất bại (exit ${r.exitCode}):\n${r.stderr}',
    );
  }
  return (r.stdout as String).trim();
}

List<String> _auditCommandsFromWorkflow(String root) {
  final yml = File('$root/$_workflowPath').readAsStringSync();
  final commands = <String>[];
  for (final raw in yml.split('\n')) {
    final line = raw.trim();
    if (!line.startsWith('run: dart run tool/')) continue;
    final cmd = line.substring('run: '.length).trim();
    if (cmd.contains('--check')) commands.add(cmd);
  }
  return commands;
}

String _tail(String out, [int maxLines = 12]) {
  final lines = out
      .split('\n')
      .map((l) => l.trimEnd())
      .where((l) => l.isNotEmpty && !l.contains('Running build hooks'))
      .toList();
  if (lines.length <= maxLines) return lines.join('\n');
  return '${lines.sublist(lines.length - maxLines).join('\n')}\n       …';
}

void main(List<String> arguments) {
  final appDir = Directory.current.path;
  final stdout_ = stdout;
  final root = _git(appDir, ['rev-parse', '--show-toplevel']);
  stdout_.writeln('== PRE-FLIGHT (mô phỏng CI local) — repo: $root ==');

  // P0 — tổng quan thay đổi chưa commit (đối chiếu bằng mắt trước khi push).
  final status = _git(root, ['status', '--porcelain=v1', '-uall']);
  final changed = status.isEmpty
      ? const <String>[]
      : status.split('\n').toList();
  stdout_.writeln('Thay đổi chưa commit: ${changed.length} file');
  for (final line in changed) {
    stdout_.writeln('  $line');
  }

  // P1 — format (đúng lệnh CI "Check formatting").
  final fmt = _shell('dart', [
    'format',
    '--output=none',
    '--set-exit-if-changed',
    '.',
  ], workingDirectory: appDir);
  _report(
    fmt.exitCode == 0,
    'P1 dart format --set-exit-if-changed .',
    _tail('${fmt.stdout}${fmt.stderr}'),
  );

  // P2 — analyze.
  final ana = _shell('flutter', ['analyze'], workingDirectory: appDir);
  _report(
    ana.exitCode == 0,
    'P2 flutter analyze',
    _tail('${ana.stdout}${ana.stderr}'),
  );

  // P3 — mọi audit --check của CI trên bản sạch tái tạo từ index.
  final commands = _auditCommandsFromWorkflow(root);
  if (commands.isEmpty) {
    _report(
      false,
      'P3 đọc danh sách audit từ $_workflowPath',
      'Không tìm thấy lệnh `dart run tool/ ... --check` nào trong workflow.',
    );
  } else {
    stdout_.writeln(
      'P3 ${commands.length} lệnh audit --check của CI — chạy trên bản '
      'checkout sạch tái tạo từ index sắp commit:',
    );
    _git(root, ['add', '-A']);
    final treeSha = _git(root, ['write-tree']);
    final tmp = Directory.systemTemp.createTempSync('vt-preflight-');
    try {
      final tarPath = '${tmp.path}${Platform.pathSeparator}preflight-tree.tar';
      _git(root, ['archive', '--format=tar', '--output=$tarPath', treeSha]);
      // bsdtar trên Windows hiểu "C:\..." là host remote — dùng tên file
      // tương đối với cwd = thư mục tạm để tránh dấu ":".
      final extract = _shell('tar', [
        '-x',
        '-f',
        'preflight-tree.tar',
        '-C',
        '.',
      ], workingDirectory: tmp.path);
      if (extract.exitCode != 0) {
        _report(
          false,
          'P3 giải nén git archive',
          _tail('${extract.stdout}${extract.stderr}'),
        );
      } else {
        final cleanApp = '${tmp.path}${Platform.pathSeparator}flutter_app';
        // Audit tool hiện thuần dart:io nên chạy được ngay; pub get offline
        // im lặng cho tương lai nếu tool có dependency package.
        _shell('dart', ['pub', 'get', '--offline'], workingDirectory: cleanApp);
        for (final cmd in commands) {
          final parts = cmd.split(RegExp(r'\s+'));
          final r = _shell(
            parts.first,
            parts.sublist(1),
            workingDirectory: cleanApp,
          );
          _report(r.exitCode == 0, 'P3 $cmd', _tail('${r.stdout}${r.stderr}'));
        }
      }
    } finally {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    }
  }

  // P4 — full test suite (guardrails + goldens + unit) như job test của CI.
  // Một số vi phạm (ví dụ tint viền ngoài 3 bậc) chỉ bị guardrail test bắt,
  // không thuộc 20 lệnh audit tĩnh ở P3. Bỏ qua bằng flag --fast.
  if (arguments.contains('--fast')) {
    stdout_.writeln('P4 flutter test — BỎ QUA (--fast)');
  } else {
    final test = _shell('flutter', [
      'test',
      '--reporter=compact',
    ], workingDirectory: appDir);
    final out = '${test.stdout}${test.stderr}';
    final summary = RegExp(
      r'\d+:\d+ \+\d+(?: ~\d+)?(?: -\d+)?: (All tests passed|Some tests failed)',
    ).allMatches(out).map((m) => m.group(0)).join('\n');
    _report(
      test.exitCode == 0,
      'P4 flutter test --reporter=compact',
      summary.isNotEmpty ? summary : _tail(out),
    );
  }

  stdout_.writeln(
    _failures == 0
        ? '== PRE-FLIGHT PASS — sẵn sàng commit + push (thay đổi đã được stage) =='
        : '== PRE-FLIGHT THẤT BẠI ($_failures mục) — sửa hết trước khi commit ==',
  );
  exitCode = _failures == 0 ? 0 : 1;
}

extension on String {
  String trimEnd() => replaceFirst(RegExp(r'\s+$'), '');
}
