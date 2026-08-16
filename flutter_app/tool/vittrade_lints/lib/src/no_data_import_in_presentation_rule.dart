import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// IDE-time port of `architecture_baseline_guardrails_test.dart`'s
/// "presentation page and widget files do not import data facades" check.
///
/// Files under `presentation/pages/` or `presentation/widgets/` must not
/// import or export anything under another feature's `data/` layer — they
/// should depend on domain/controller facades instead.
class NoDataImportInPresentationRule extends DartLintRule {
  const NoDataImportInPresentationRule() : super(code: _code);

  static const _code = LintCode(
    name: 'vittrade_no_data_import_in_presentation',
    problemMessage:
        'Pages/widgets must read domain/controller facades, not data. '
        'See architecture_baseline_guardrails_test.dart.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static final _dataImportPattern = RegExp(
    r'^package:vit_trade_flutter/features/[^/]+/data',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final path = resolver.path.replaceAll('\\', '/');
    final isPresentationPageOrWidget =
        path.contains('/presentation/pages/') ||
        path.contains('/presentation/widgets/') ||
        RegExp(
          r'/presentation/(phone|tablet|web)/(pages|widgets)/',
        ).hasMatch(path);
    if (!isPresentationPageOrWidget) return;

    void checkDirective(NamespaceDirective node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      if (_dataImportPattern.hasMatch(uri)) {
        reporter.atNode(node, code);
      }
    }

    context.registry.addImportDirective(checkDirective);
    context.registry.addExportDirective(checkDirective);
  }
}
