// Tablet Gutter Flush Audit — Tablet-Spacing-Gutter-Standard, Rule S6
// ("Detail content of a master-detail shell is gutter-flush").
//
// Lỗi gốc rễ audits trước không bắt được (2026-09-16, bug 32dp mép phải
// module predictions): guardrail S6 cũ (`tablet_fullbleed_guardrail_test`)
// soi CALL-SITE `VitPageContent(` trực tiếp trong file tablet — mù với
// trang dựng qua `VitTabletSectionFrame/Body` (fullBleed:true nằm BÊN
// TRONG wrapper, trong khi wrapper tự cấp contentPad 20dp hợp lệ cho trang
// top-level). Tín hiệu đúng phải gắn NGỮ CẢNH ROUTE: trang render trong
// detail column của một master-detail shell (Markets/Profile/WalletHistory
// — đúng predicate `_isMarketSpec/_isProfileSpec/_isWalletHistorySpec`
// của tablet_route_tree) phải gutter-flush theo MỘT trong 3 idiom chuẩn:
//
//   frame   — `VitTabletSectionFrame/Body(gutterFlush: true)`
//             (body bỏ inset ngang; header horizontalPadding: zero)
//   hub     — `VitPageContent(fullBleed: true)` gọi trực tiếp trong trang
//             (trang hub /markets, /wallet/history, /wallet/transaction)
//   pane    — dựng từ `*PaneScaffold(` registry scaffold
//             (MarketsPaneScaffold/ProfilePaneScaffold… — fullBleed + header
//             zero nằm sẵn trong scaffold)
//   workspace — dựng từ `VitTabletPaneWorkspace(` registry scaffold
//             (idiom pane-workspace 2026-09-17: 2 cột trong detail pane,
//             flush bẩm sinh — scaffold không tự thêm mép ngang nào)
//
// Redirect alias (manifest `redirectTarget:`) miễn — không có trang.
// Khóa TUYỆT ĐỐI 0 vi phạm (không baseline): thêm trang vào shell mà
// quên idiom flush thì audit đỏ ngay tại CI.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_gutter_flush_audit.dart         # regen artifact
//   dart run tool/tablet_gutter_flush_audit.dart --check # CI: 0 vi phạm + artifact current
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Gutter-Flush-Audit.csv';

const _routerTreePath = 'lib/app/router/tablet/tablet_route_tree.dart';
const _manifestPath = 'lib/app/router/tablet/tablet_route_manifest.dart';
const _pathConstFiles = <String>['lib/app/router/app_route_paths.dart'];

/// Class mirror cho trang `_profileUtilityForRoute` gán ngoài switch chính.
const _utilityPaneOverrides = <String, String>{
  'settingsSecurityBiometric': 'ProfileSecurityPane',
  'settingsSecurityChangePassword': 'ProfileSecurityPane',
};

final _paneScaffoldRe = RegExp(r'[A-Z]\w*PaneScaffold\(');
final _vitPageContentRe = RegExp(r'VitPageContent\(');
final _classDeclRe = RegExp(
  r'^(?:final |base |sealed )?class (\w+)',
  multiLine: true,
);

void main(List<String> args) {
  final check = args.contains('--check');
  final rows = _audit();

  if (check) {
    final file = File(_artifactPath);
    final expected = _renderArtifact(rows);
    if (!file.existsSync()) {
      stderr.writeln('Artifact chưa tồn tại — chạy không đối số để sinh.');
      exitCode = 1;
      return;
    }
    if (file.readAsStringSync() != expected) {
      stderr.writeln(
        'Artifact stale — chạy `dart run tool/tablet_gutter_flush_audit.dart` '
        'từ flutter_app/ và commit artifact cùng code.',
      );
      exitCode = 1;
      return;
    }
  }

  final violations = rows.where((r) => r.idiom == 'VIOLATION').toList();
  stdout.writeln(
    'Gutter-flush (S6): ${rows.length} trang trong detail column của 3 shell '
    '— ${rows.length - violations.length} đạt, ${violations.length} vi phạm.',
  );
  if (violations.isNotEmpty) {
    for (final v in violations) {
      stdout.writeln('  VIOLATION  ${v.shell}  ${v.path}  ${v.reason}');
    }
    exitCode = 1;
    return;
  }
  if (!check) {
    File(_artifactPath).writeAsStringSync(_renderArtifact(rows));
    stdout.writeln('Đã ghi artifact: $_artifactPath');
  }
}

class _Row {
  _Row(
    this.shell,
    this.path,
    this.pageClass,
    this.idiom,
    this.file,
    this.reason,
  );

  final String shell;
  final String path;
  final String? pageClass;
  final String idiom; // workspace | frame | hub | pane | VIOLATION
  final String file; // '' khi không tìm thấy
  final String? reason;
}

List<_Row> _audit() {
  final consts = <String, String>{};
  final methodTemplates = <String, String>{};
  final idFiles = [
    ..._pathConstFiles,
    ...Directory('lib/app/router/route_groups')
        .listSync()
        .whereType<File>()
        .map((f) => f.path)
        .where((p) => p.endsWith('_route_ids.dart'))
        .toList()
      ..sort(),
  ];
  for (final p in idFiles) {
    final src = File(p).readAsStringSync();
    for (final m in RegExp(
      r"static const String (\w+) =\s*'([^']+)'",
    ).allMatches(src)) {
      consts[m.group(1)!] = m.group(2)!;
    }
    for (final m in RegExp(
      r"static String (\w+)\(([^)]*)\) =>\s*'([^']+)'",
    ).allMatches(src)) {
      var tmpl = m.group(3)!;
      for (final raw in m.group(2)!.split(',')) {
        final param = raw.trim().split(' ').last;
        if (param.isEmpty) continue;
        tmpl = tmpl
            .replaceAll('\$$param', ':$param')
            .replaceAll('{\$$param}', ':$param');
      }
      methodTemplates[m.group(1)!] = tmpl;
    }
  }

  String? resolve(String expr) {
    expr = expr.trim();
    var m = RegExp(r'^AppRoutePaths\.(\w+)$').firstMatch(expr);
    if (m != null) return consts[m.group(1)];
    m = RegExp(r'^AppRoutePaths\.(\w+)\(').firstMatch(expr);
    if (m != null) return methodTemplates[m.group(1)];
    if (expr.startsWith("'") && expr.endsWith("'")) {
      return expr.substring(1, expr.length - 1);
    }
    return null;
  }

  // Manifest: path + redirectTarget của từng spec.
  final manifestSrc = File(_manifestPath).readAsStringSync();
  final specs = <({String path, bool redirect})>[];
  for (final m in RegExp(r'TabletRouteSpec\(').allMatches(manifestSrc)) {
    final start = m.end;
    final next = manifestSrc.indexOf('TabletRouteSpec(', start);
    final body = manifestSrc.substring(
      start,
      next > 0 ? next : manifestSrc.length,
    );
    final pm = RegExp(r'path:\s*([^,\n]+)').firstMatch(body);
    if (pm == null) continue;
    final path = resolve(pm.group(1)!);
    if (path == null) continue;
    specs.add((path: path, redirect: body.contains('redirectTarget:')));
  }

  // Switch path→class trong _buildTabletPage (giới hạn window hàm).
  final tree = File(_routerTreePath).readAsStringSync();
  final wStart = tree.indexOf('Widget _buildTabletPage(');
  final wEnd = tree.indexOf('Widget? _profileUtilityForRoute', wStart);
  if (wStart < 0 || wEnd < 0) {
    stderr.writeln('Không tìm thấy window _buildTabletPage trong route tree.');
    exit(1);
  }
  final window = tree.substring(wStart, wEnd);
  final pageOf = <String, String>{};
  for (final m in RegExp(r'if \(([^)]*path ==[^)]*)\)').allMatches(window)) {
    final cond = m.group(1)!;
    final nextIf = window.indexOf('if (path ==', m.end);
    final block = window.substring(m.end, nextIf > 0 ? nextIf : window.length);
    final ret = RegExp(r'return\s+(?:const\s+)?([A-Z]\w+)\(').firstMatch(block);
    if (ret == null) continue;
    // Điều kiện kép `path == A || path == B`: mỗi vế map cùng class.
    for (final alt in RegExp(r'path == ([^)|]+)').allMatches(cond)) {
      final path = resolve(alt.group(1)!);
      if (path != null) pageOf[path] = ret.group(1)!;
    }
  }
  for (final e in _utilityPaneOverrides.entries) {
    final p = consts[e.key];
    if (p != null) pageOf.putIfAbsent(p, () => e.value);
  }

  // Class→file (thứ tự deterministic).
  final classFile = <String, String>{};
  final dartFiles = [
    ...Directory('lib').listSync(recursive: true).whereType<File>(),
  ]..sort((a, b) => a.path.compareTo(b.path));
  for (final f in dartFiles) {
    if (!f.path.endsWith('.dart')) continue;
    final src = f.readAsStringSync();
    for (final m in _classDeclRe.allMatches(src)) {
      classFile.putIfAbsent(m.group(1)!, () => f.path.replaceAll('\\', '/'));
    }
  }

  // Phân lớp shell — mirror predicate của tablet_route_tree (giữ nguyên
  // giá trị literal; guard const đảm bảo không lệch khỏi router thật).
  void guardConst(String name, String expected) {
    final v = consts[name];
    if (v != expected) {
      stderr.writeln(
        'AppRoutePaths.$name = $v (kỳ vọng $expected) — cập nhật predicate '
        'shell trong audit này cùng router.',
      );
      exit(1);
    }
  }

  guardConst('markets', '/markets');
  guardConst('profile', '/profile');
  guardConst('walletHistory', '/wallet/history');

  String? shellOf(String path) {
    final isMarket =
        path == '/markets' ||
        path.startsWith('/markets/') ||
        path.startsWith('/pair/');
    final isProfile =
        path == '/profile' ||
        path.startsWith('/profile/') ||
        path == '/settings/security' ||
        path.startsWith('/settings/security/');
    final isWalletHistory =
        path == '/wallet/history' || path == '/wallet/transaction/:txId';
    if (isMarket) return 'markets';
    if (isProfile) return 'profile';
    if (isWalletHistory) return 'wallet-history';
    return null;
  }

  final rows = <_Row>[];
  for (final spec in specs) {
    final shell = shellOf(spec.path);
    if (shell == null) continue;
    if (spec.redirect) {
      rows.add(_Row(shell, spec.path, null, 'redirect', '', null));
      continue;
    }
    final cls = pageOf[spec.path];
    if (cls == null) {
      rows.add(
        _Row(
          shell,
          spec.path,
          null,
          'VIOLATION',
          '',
          'không map được page class trong _buildTabletPage (drift router?)',
        ),
      );
      continue;
    }
    final file = classFile[cls];
    if (file == null) {
      rows.add(
        _Row(
          shell,
          spec.path,
          cls,
          'VIOLATION',
          '',
          'không tìm thấy file class',
        ),
      );
      continue;
    }
    final src = File(file).readAsStringSync();
    // Thứ tự: workspace là tier composition mạnh nhất của trang — tin trước
    // khi frame/hub khi file dùng cả hai (vd. loading state còn SectionFrame).
    if (src.contains('VitTabletPaneWorkspace(')) {
      rows.add(_Row(shell, spec.path, cls, 'workspace', file, null));
    } else if (src.contains('gutterFlush: true')) {
      rows.add(_Row(shell, spec.path, cls, 'frame', file, null));
    } else if (_vitPageContentRe.hasMatch(src) &&
        src.contains('fullBleed: true')) {
      rows.add(_Row(shell, spec.path, cls, 'hub', file, null));
    } else if (_paneScaffoldRe.hasMatch(src)) {
      rows.add(_Row(shell, spec.path, cls, 'pane', file, null));
    } else {
      rows.add(
        _Row(
          shell,
          spec.path,
          cls,
          'VIOLATION',
          file,
          'không có idiom gutter-flush nào (frame gutterFlush:true | hub '
              'fullBleed:true | *PaneScaffold | VitTabletPaneWorkspace) — trang '
              'trong detail column của shell phải flush (S6), không stack '
              'contentPad lên outerHorizontalMargin của shell',
        ),
      );
    }
  }
  rows.sort((a, b) {
    final c = a.shell.compareTo(b.shell);
    return c != 0 ? c : a.path.compareTo(b.path);
  });
  return rows;
}

String _renderArtifact(List<_Row> rows) {
  final buf = StringBuffer('shell,path,page_class,idiom,file\n');
  for (final r in rows) {
    buf.writeln(
      '${r.shell},${r.path},${r.pageClass ?? ''},${r.idiom},${r.idiom == 'VIOLATION' ? r.reason ?? '' : r.file}',
    );
  }
  return buf.toString();
}
