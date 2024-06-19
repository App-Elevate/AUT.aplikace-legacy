import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';

class ScrollViewColumn extends StatelessWidget {
  const ScrollViewColumn({
    super.key,
    this.children = const <Widget>[],
  });
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    children.add(const CustomDivider());
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }
}
