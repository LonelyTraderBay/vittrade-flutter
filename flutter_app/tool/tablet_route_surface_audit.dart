// Tablet-Adaptive Standard (R1) — audit scanner.
//
// Gives R1's sharpest rule its first static teeth:
//
//   R1a surface-breakpoint  — an `AppBreakpoints.` reference in tablet
//                             PRESENTATION code (features/**/presentation,
//                             shared/layout, shared/widgets). The surface is
//                             resolved once at bootstrap; a tablet page
//                             already IS tablet, so querying the global
//                             600px breakpoint means it is re-dispatching
//                             phone-vs-tablet by width at runtime — the
//                             exact anti-pattern R1 forbids. In-page layout
//                             thresholds (the 900 two-column cut) come from
//                             TabletDashboardWidths/LayoutBuilder instead.
//   R1b compat-dispatcher   — a `responsive_surface_page` /
//                             `ResponsiveSurfacePage` reference outside the
//                             sanctioned homes (app/bootstrap/ composition
//                             root, the legacy phone pages that predate
//                             surface routers). New surface code never uses
//                             the compatibility dispatcher.
//
// Out of scope on purpose (stays prose + test, documented in the standard):
// the router files' per-route `switch (surface)` arms — including their
// `null =>` compat fallback (`AppBreakpoints.isTablet(MediaQuery…)`) which
// the Invariant sanctions for the legacy `createAppRouter()` facade — and
// MediaQuery size reads for sheet sizing / pane back-button thresholds
// (legal layout concerns, not surface dispatch).
//
// The surface starts at ZERO violations — absolute lock, no baseline.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_route_surface_audit.dart            # regen
//   dart run tool/tablet_route_surface_audit.dart --check    # CI staleness
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Route-Surface-Audit.csv';

final _surfaceBreakpointRe = RegExp(r'\bAppBreakpoints\.');
final _compatDispatcherRe = RegExp(
  r'responsive_surface_page|ResponsiveSurfacePage',
);

/// Folders where the compat dispatcher is sanctioned (the composition root
/// that owns surface resolution + the legacy responsive shell itself).
const _compatAllowedPathFragments = <String>['/app/bootstrap/'];

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');

  final rows = <RouteRow>[];
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    final fileName = normalized.split('/').last;
    final isTabletSurface =
        normalized.contains('/tablet/') || fileName.contains('tablet');
    if (!isTabletSurface || !normalized.endsWith('.dart')) continue;
    // The router layer owns the sanctioned per-surface switch (incl. its
    // compat `null` arm); the theme layer owns the breakpoint definition
    // itself. R1's rule is about presentation dispatching on the surface.
    final isRouterOrTheme =
        normalized.contains('/app/router/') ||
        normalized.contains('/app/theme/');
    // The compat dispatcher check applies to every tablet file, but its
    // sanctioned homes are never tablet files — kept symmetric anyway.
    final compatSanctioned = _compatAllowedPathFragments.any(
      normalized.contains,
    );

    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      final rel = normalized.replaceFirst('lib/', '');
      if (!isRouterOrTheme && _surfaceBreakpointRe.hasMatch(line)) {
        rows.add(RouteRow(rel, i + 1, 'R1a-surface-breakpoint', line.trim()));
      }
      if (!compatSanctioned && _compatDispatcherRe.hasMatch(line)) {
        rows.add(RouteRow(rel, i + 1, 'R1b-compat-dispatcher', line.trim()));
      }
    }
  }

  rows.sort((a, b) {
    final byPath = a.path.compareTo(b.path);
    if (byPath != 0) return byPath;
    return a.line.compareTo(b.line);
  });

  final artifact = _renderArtifact(rows);
  if (checkOnly) {
    final existing = File(_artifactPath).existsSync()
        ? File(_artifactPath).readAsStringSync()
        : null;
    if (existing == null || existing != artifact) {
      stderr.writeln(
        'Tablet route-surface audit artifact is stale. '
        'Run `dart run tool/tablet_route_surface_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    stdout.writeln('Tablet route-surface audit artifact is current.');
  } else {
    File(_artifactPath).writeAsStringSync(artifact);
    stdout.writeln('Wrote $_artifactPath');
  }

  stdout.writeln(
    rows.isEmpty
        ? 'Tablet route-surface audit: 0 violations (absolute lock — no baseline).'
        : 'Tablet route-surface audit: ${rows.length} violations (absolute '
              'lock — the surface is resolved at bootstrap; presentation '
              'never re-dispatches, never baseline them).',
  );
}

/// Locks the scanner regexes against regressions — runs on every invocation.
void _selfTest() {
  void expectRule(String label, String line, String? expected) {
    String? actual;
    if (_surfaceBreakpointRe.hasMatch(line)) actual = 'R1a';
    if (_compatDispatcherRe.hasMatch(line)) {
      actual = actual == null ? 'R1b' : '$actual+R1b';
    }
    if (actual != expected) {
      stderr.writeln(
        'Route-surface self-test FAILED ($label): '
        'expected $expected, got $actual',
      );
      exit(2);
    }
  }

  expectRule(
    'breakpoint query',
    'if (AppBreakpoints.isTablet(width)) return PhonePage();',
    'R1a',
  );
  expectRule(
    'clean line',
    'const wide = width >= TabletDashboardWidths.twoColumnMinWidth;',
    null,
  );
  expectRule(
    'compat import',
    "import 'package:vit_trade_flutter/app/bootstrap/responsive_surface_page.dart';",
    'R1b',
  );
  expectRule(
    'compat reference',
    'child: ResponsiveSurfacePage(phone: A, tablet: B),',
    'R1b',
  );
}

String _renderArtifact(List<RouteRow> rows) {
  final buffer = StringBuffer()
    ..writeln('path,line,rule,source')
    ..writeln(
      '# Generated by tool/tablet_route_surface_audit.dart — regenerate after touching tablet presentation files.',
    );
  for (final row in rows) {
    buffer.writeln(
      '${row.path},${row.line},${row.rule},"${row.source.replaceAll('"', '""')}"',
    );
  }
  return buffer.toString();
}

class RouteRow {
  const RouteRow(this.path, this.line, this.rule, this.source);

  final String path;
  final int line;
  final String rule;
  final String source;
}
