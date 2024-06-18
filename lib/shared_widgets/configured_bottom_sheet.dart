import 'package:flutter/material.dart';

void configuredBottomSheet(BuildContext context, {required Widget Function(BuildContext) builder}) {
  showModalBottomSheet(
    context: context,
    builder: builder,
    useRootNavigator: true,
    clipBehavior: Clip.hardEdge,
    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .6),
  );
}
