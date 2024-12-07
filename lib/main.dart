import 'package:flutter/material.dart';

import 'presentation/controllers/todo_controller.dart';
import 'presentation/pages/todo_page.dart';
import 'presentation/utils/page_transition_builder_custom.dart';
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
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PageTransitionBuilderCustom(),
            TargetPlatform.iOS: PageTransitionBuilderCustom(),
          },
        ),
      ),
      home: TodoPage(controller: getIt<TodoController>()),
    );
  }
}
