import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _normalize(String path) => path.replaceAll('\\', '/');

bool _isPhoneBaselinePage(File file) {
  final path = _normalize(file.path);
  if (!path.contains('/lib/features/')) return false;
  if (!path.contains('/presentation/pages/')) return false;

  final relative = path.split('/presentation/pages/').last;
  return !relative.startsWith('tablet/') && !relative.startsWith('web/');
}

Iterable<File> _phoneBaselinePages() sync* {
  final root = Directory('lib/features');
  if (!root.existsSync()) return;

  for (final entity in root.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (_isPhoneBaselinePage(entity)) yield entity;
    }
  }
}

void main() {
  test('Phone baseline pages không import UI Tablet hoặc Web', () {
    const forbiddenTokens = <String>[
      '/presentation/tablet/',
      '/presentation/web/',
      '/presentation/pages/tablet/',
      '/presentation/pages/web/',
      '/presentation/widgets/tablet/',
      '/presentation/widgets/web/',
    ];
    final violations = <String>[];

    for (final file in _phoneBaselinePages()) {
      final path = _normalize(file.path);
      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trimLeft();
        if (!trimmed.startsWith('import ') && !trimmed.startsWith('export ')) {
          continue;
        }
        for (final token in forbiddenTokens) {
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
          'Phone baseline must remain independent from Tablet/Web presentation: '
          '$violations',
    );
  });
}
