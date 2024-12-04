import 'package:flutter/material.dart';

import 'presentation/controllers/todo_controller.dart';
import 'presentation/pages/todo_page.dart';
import 'setup_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(controller: getIt<TodoController>()),
    );
  }
}
