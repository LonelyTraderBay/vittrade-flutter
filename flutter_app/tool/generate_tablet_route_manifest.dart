import 'dart:io';

const _outputPath = 'lib/app/router/tablet/tablet_route_manifest.dart';
const _truthTablePath =
    '../docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md';

void main() {
  final truthTable = File(_truthTablePath);
  if (!truthTable.existsSync()) {
    throw StateError('Missing route truth table: ${truthTable.path}');
  }

  final rows = truthTable
      .readAsLinesSync()
      .where((line) => line.startsWith('| `lib/app/router/'))
      .map(_parseRow)
      .toList(growable: false);
  if (rows.isEmpty) throw StateError('Route truth table contains no routes.');

  final output = StringBuffer('''// GENERATED FILE - do not edit by hand.
//
// Source: docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md
// Regenerate from flutter_app/ with:
//   dart run tool/generate_tablet_route_manifest.dart

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

/// Surface-neutral route declarations consumed by the Tablet composition.
///
/// The manifest keeps path/name/redirect parity with the audited route tree;
/// the Tablet router decides independently which page or utility composition
/// renders each declaration.
final class TabletRouteSpec {
  const TabletRouteSpec({
    required this.path,
    this.name,
    this.redirectTarget,
  });

  final String path;
  final String? name;
  final String? redirectTarget;

  bool get isRedirectAlias => redirectTarget != null;
}

const List<TabletRouteSpec> tabletRouteManifest = [
''');

  for (final row in rows) {
    output.writeln('  TabletRouteSpec(');
    output.writeln('    path: ${row.path},');
    if (row.name != null) output.writeln('    name: ${row.name},');
    if (row.redirectTarget != null) {
      output.writeln('    redirectTarget: ${row.redirectTarget},');
    }
    output.writeln('  ),');
  }
  output.writeln('];');

  File(_outputPath).writeAsStringSync(output.toString());
  stdout.writeln('Wrote $_outputPath (${rows.length} routes).');
}

_RouteRow _parseRow(String line) {
  final cells = line.split('|').map((cell) => cell.trim()).toList();
  if (cells.length < 7) throw FormatException('Malformed route row: $line');

  String unquote(String value) {
    if (!value.startsWith('`') || !value.endsWith('`')) {
      throw FormatException('Expected a Dart expression: $value');
    }
    return value.substring(1, value.length - 1);
  }

  final path = unquote(cells[3]);
  final nameValue = unquote(cells[4]);
  final classification = unquote(cells[5]);
  final evidence = unquote(cells[6]);
  return _RouteRow(
    path: path,
    name: nameValue == '-' ? null : nameValue,
    redirectTarget: classification == 'redirect_alias' && evidence != 'redirect'
        ? evidence
        : null,
  );
}

final class _RouteRow {
  const _RouteRow({required this.path, this.name, this.redirectTarget});

  final String path;
  final String? name;
  final String? redirectTarget;
}
