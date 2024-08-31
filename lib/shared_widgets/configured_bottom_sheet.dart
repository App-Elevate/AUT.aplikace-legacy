import 'package:flutter/material.dart';

void configuredBottomSheet(BuildContext context, {required Widget Function(BuildContext) builder}) {
  showModalBottomSheet(
    context: context,
    builder: builder,
    useRootNavigator: true,
    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .6),
  );
}
