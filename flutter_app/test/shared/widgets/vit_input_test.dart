import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('VitInput renders label, affixes, errors, and password mode', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'secret');

    await tester.pumpWidget(
      _wrap(
        VitInput(
          controller: controller,
          label: 'Password',
          hintText: 'Enter password',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: const Icon(Icons.visibility_outlined),
          errorText: 'Required',
          obscureText: true,
        ),
      ),
    );

    expect(find.text('Password'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);

    final inputPadding = tester.widget<Padding>(
      find
          .ancestor(of: find.byType(TextField), matching: find.byType(Padding))
          .first,
    );
    expect(
      inputPadding.padding,
      const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x4),
    );

    final shell = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = shell.decoration as ShapeDecoration;
    final shape = decoration.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppColors.sell);
    expect(shape.side.width, AppSpacing.borderWidth);

    controller.dispose();
  });

  testWidgets('border đổi màu theo token focus khi trường được focus', (
    tester,
  ) async {
    final controller = TextEditingController();
    final node = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(node.dispose);

    await tester.pumpWidget(
      _wrap(
        VitInput(controller: controller, focusNode: node, hintText: 'Email'),
      ),
    );

    RoundedRectangleBorder borderShape() {
      final shell = tester.widget<DecoratedBox>(
        find
            .ancestor(
              of: find.byType(TextField),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      return (shell.decoration as ShapeDecoration).shape
          as RoundedRectangleBorder;
    }

    expect(borderShape().side.color, AppColors.borderSolid);

    node.requestFocus();
    await tester.pump();
    expect(borderShape().side.color, AppInputStates.focusInputBorder);

    node.unfocus();
    await tester.pump();
    expect(borderShape().side.color, AppColors.borderSolid);
  });

  testWidgets('border lỗi thắng ưu tiên so với border focus', (tester) async {
    final controller = TextEditingController();
    final node = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(node.dispose);

    await tester.pumpWidget(
      _wrap(
        VitInput(
          controller: controller,
          focusNode: node,
          errorText: 'Bắt buộc',
        ),
      ),
    );

    node.requestFocus();
    await tester.pump();

    final shell = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final shape =
        (shell.decoration as ShapeDecoration).shape as RoundedRectangleBorder;
    expect(shape.side.color, AppColors.sell);
  });
}
