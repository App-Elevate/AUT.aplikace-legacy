import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height,
    this.isTransparent = true,
    this.hasIndent = true,
    this.hasEndIndent = true,
  });
  final double? height;
  final bool isTransparent;
  final bool hasIndent;
  final bool hasEndIndent;

  @override
  Widget build(BuildContext context) {
    double indent = MediaQuery.sizeOf(context).width * 0.025;
    return Divider(
      color: isTransparent ? Colors.transparent : null,
      height: height,
      indent: hasIndent ? indent : null,
      endIndent: hasEndIndent ? indent : null,
    );
  }
}
