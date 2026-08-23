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
  testWidgets('VitCard supports tap and visual variants', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCard(
              padding: const EdgeInsets.all(16),
              onTap: () => taps++,
              child: const Text('standard card'),
            ),
            const SizedBox(height: 8),
            const VitCard(
              variant: VitCardVariant.hero,
              padding: EdgeInsets.all(16),
              background: ColoredBox(color: AppColors.primary08),
              child: Text('hero card'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('standard card'));
    await tester.pump();

    expect(taps, 1);
    expect(find.text('hero card'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ColoredBox && widget.color == AppColors.primary08,
      ),
      findsOneWidget,
    );

    final heroDecoratedBox = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('hero card'),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is ShapeDecoration,
            ),
          )
          .first,
    );
    final heroDecoration = heroDecoratedBox.decoration as ShapeDecoration;
    expect(heroDecoration.shadows, const [
      BoxShadow(
        color: AppColors.primary08,
        blurRadius: AppSpacing.ctaElevationBlur,
        spreadRadius: AppSpacing.ctaElevationSpread,
        offset: Offset(0, AppSpacing.ctaElevationYOffset),
      ),
    ]);
  });

  testWidgets('VitCard centers content in fixed-height tile surfaces', (
    tester,
  ) async {
    const cardHeight = 86.0;
    const contentHeight = 40.0;

    await tester.pumpWidget(
      _wrap(
        const VitCard(
          height: cardHeight,
          contentAlign: VitCardContentAlign.center,
          padding: AppSpacing.cardTilePadding,
          child: SizedBox(height: contentHeight, width: double.infinity),
        ),
      ),
    );

    final cardBox = tester.getRect(find.byType(VitCard));
    final contentBox = tester.getRect(
      find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == contentHeight,
      ),
    );

    expect(cardBox.height, cardHeight);
    expect(
      (contentBox.top - cardBox.top).round(),
      (cardBox.bottom - contentBox.bottom).round(),
    );
  });

  testWidgets('interactive VitCard carries token hover/focus overlays', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitCard(
          padding: const EdgeInsets.all(16),
          onTap: () {},
          child: const Text('tappable card'),
        ),
      ),
    );

    final inkWell = tester.widget<InkWell>(find.byType(InkWell));
    expect(inkWell.hoverColor, AppInputStates.hoverOverlay);
    expect(inkWell.focusColor, AppInputStates.focusOverlay);
  });
}
