import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';

/// Creates a card with a horizontal bar at the top and bottom
class LinedCard extends StatelessWidget {
  const LinedCard({
    super.key,
    this.title,
    this.footer,
    this.titleTextAlign = TextAlign.start,
    this.footerTextAlign = TextAlign.center,
    this.smallButton = true,
    this.onPressed,
    this.child,
  });

  /// Card title, aligned with the top bar
  final String? title;

  /// Card title, aligned with the bottom bar
  final String? footer;

  /// How to align the title text
  final TextAlign titleTextAlign;

  /// How to align the footer text
  final TextAlign footerTextAlign;

  /// If true, the whole card will be pressable, else only the bottom bar
  final bool smallButton;

  /// The callback that is called when the button is tapped or otherwise activated.
  final void Function()? onPressed;

  /// Creates a widget that insets its child.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: smallButton ? null : onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: Spacing.s16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.s16, vertical: Spacing.s4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dividerWithText(context, text: title, textAlign: titleTextAlign),
              child ?? const SizedBox(),
              footerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget footerButton(BuildContext context) {
    if (!smallButton) return dividerWithText(context, text: footer, textAlign: footerTextAlign);

    return MaterialButton(
      visualDensity: const VisualDensity(vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: onPressed,
      child: dividerWithText(context, text: footer, textAlign: footerTextAlign),
    );
  }

  Widget dividerWithText(BuildContext context, {String? text, TextAlign? textAlign}) {
    if (text == null) return const CustomDivider(isTransparent: false, hasIndent: false);

    return Row(
      children: [
        if (textAlign != TextAlign.start && textAlign != TextAlign.left && textAlign != TextAlign.justify)
          const Flexible(child: CustomDivider(isTransparent: false, hasIndent: false)),
        Text(text, style: Theme.of(context).textTheme.labelLarge),
        if (textAlign != TextAlign.end && textAlign != TextAlign.right)
          const Flexible(child: CustomDivider(isTransparent: false, hasEndIndent: false)),
      ],
    );
  }
}
