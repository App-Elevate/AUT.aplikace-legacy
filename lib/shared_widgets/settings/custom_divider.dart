import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.height, this.isTransparent = true});
  final double? height;
  final bool isTransparent;

  @override
  Widget build(BuildContext context) {
    double indent = MediaQuery.sizeOf(context).width * 0.025;
    return Divider(color: isTransparent ? Colors.transparent : null, height: height, indent: indent, endIndent: indent);
  }
}

Divider divider(BuildContext context, {double? height, bool isTransparent = true}) {
  double indent = MediaQuery.sizeOf(context).width * 0.025;
  return Divider(color: isTransparent ? Colors.transparent : null, height: height, indent: indent, endIndent: indent);
}
