import 'package:flutter/material.dart';

void configuredDialog(BuildContext context, {required Widget Function(BuildContext) builder}) {
  showDialog(
    context: context,
    builder: builder,
    useRootNavigator: true,
  );
}
