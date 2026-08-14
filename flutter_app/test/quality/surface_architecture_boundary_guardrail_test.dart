import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _surfacePathRe = RegExp(
  r'/presentation/(?:pages/|widgets/)?(phone|tablet|web)(?:/|$)',
);

String _normalize(String path) => path.replaceAll('\\', '/');

String? _surfaceFor(String path) =>
    _surfacePathRe.firstMatch(_normalize(path))?.group(1);

Iterable<File> _presentationFiles() sync* {
  final root = Directory('lib/features');
  if (!root.existsSync()) return;
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (_surfaceFor(entity.path) != null) yield entity;
  }
}

void main() {
  test('surface presentation không import chéo Phone/Tablet/Web', () {
    final violations = <String>[];

    for (final file in _presentationFiles()) {
      final path = _normalize(file.path);
      final surface = _surfaceFor(path)!;
      final forbidden = switch (surface) {
        'phone' => const [
          'presentation/pages/tablet/',
          'presentation/widgets/tablet/',
          'presentation/tablet/',
          'presentation/pages/web/',
          'presentation/widgets/web/',
          'presentation/web/',
        ],
        'tablet' => const [
          'presentation/pages/phone/',
          'presentation/widgets/phone/',
          'presentation/phone/',
          'presentation/pages/web/',
          'presentation/widgets/web/',
          'presentation/web/',
          'presentation/pages/hub/',
          'presentation/widgets/hub/',
        ],
        'web' => const [
          'presentation/pages/phone/',
          'presentation/widgets/phone/',
          'presentation/phone/',
          'presentation/pages/tablet/',
          'presentation/widgets/tablet/',
          'presentation/tablet/',
        ],
        _ => const <String>[],
      };

      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trimLeft();
        if (!trimmed.startsWith('import ') && !trimmed.startsWith('export ')) {
          continue;
        }
        for (final token in forbidden) {
          if (line.contains(token)) {
            violations.add('$path imports $token');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Surface UI must not import another surface or legacy hub UI: '
          '$violations',
    );
  });
}
