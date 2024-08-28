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
    this.transparentTitleDivider = false,
    this.transparentFooterDivider = false,
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

  /// If true, top bar will be transparent
  final bool transparentTitleDivider;

  /// If true, bottom bar will be transparent
  final bool transparentFooterDivider;

  /// The callback that is called when the button is tapped or otherwise activated.
  final void Function()? onPressed;

  /// Creates a widget that insets its child.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: smallButton ? null : onPressed,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dividerWithText(context, text: title, textAlign: titleTextAlign, transparentDivider: transparentTitleDivider),
              child ?? const SizedBox(),
              footerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget footerButton(BuildContext context) {
    Widget divider = dividerWithText(context, text: footer, textAlign: footerTextAlign, transparentDivider: transparentFooterDivider);
    if (!smallButton) return divider;

    return MaterialButton(
      visualDensity: const VisualDensity(vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: onPressed,
      child: divider,
    );
  }

  Widget dividerWithText(BuildContext context, {String? text, TextAlign? textAlign, bool transparentDivider = false}) {
    if (text == null) return CustomDivider(isTransparent: transparentDivider, hasIndent: false, hasEndIndent: false);
    return Row(
      children: [
        if (textAlign != TextAlign.start && textAlign != TextAlign.left && textAlign != TextAlign.justify)
          Flexible(child: CustomDivider(isTransparent: transparentDivider, hasIndent: false)),
        if (text == footer && footerTextAlign == TextAlign.end && onPressed != null) ...[
          Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Theme.of(context).listTileTheme.subtitleTextStyle!.color),
          const SizedBox(width: 5),
        ],
        Text(text, style: Theme.of(context).textTheme.labelLarge),
        if (textAlign != TextAlign.end && textAlign != TextAlign.right)
          Flexible(child: CustomDivider(isTransparent: transparentDivider, hasEndIndent: false)),
      ],
    );
  }
}
