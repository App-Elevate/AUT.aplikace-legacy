import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';

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
  final String? title;
  final String? footer;
  final TextAlign titleTextAlign;
  final TextAlign footerTextAlign;
  final bool smallButton;
  final void Function()? onPressed;
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
              dividerWithText(title, titleTextAlign),
              child ?? const SizedBox(),
              footerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget footerButton(BuildContext context) {
    if (!smallButton) return dividerWithText(footer, footerTextAlign);
    return MaterialButton(
      visualDensity: const VisualDensity(vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: onPressed,
      child: dividerWithText(footer, footerTextAlign),
    );
  }

  Widget dividerWithText(String? text, TextAlign textAlign) {
    if (text == null) {
      return const CustomDivider(isTransparent: false, hasIndent: false);
    }
    return Row(
      children: [
        if (textAlign != TextAlign.start && textAlign != TextAlign.left && textAlign != TextAlign.justify)
          const Flexible(child: CustomDivider(isTransparent: false, hasIndent: false)),
        Text(text, style: const TextStyle(color: Colors.white54)),
        if (textAlign != TextAlign.end && textAlign != TextAlign.right)
          const Flexible(child: CustomDivider(isTransparent: false, hasEndIndent: false)),
      ],
    );
  }
}
