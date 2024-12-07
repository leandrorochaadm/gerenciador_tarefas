import 'package:flutter/material.dart';

class AppBarCustomWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const AppBarCustomWidget(this.title, {super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 4,
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    );
  }
}
