import 'package:flutter/material.dart';

class AccountAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AccountAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AccountAppBar> createState() => _AccountAppBarState();
}

class _AccountAppBarState extends State<AccountAppBar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
