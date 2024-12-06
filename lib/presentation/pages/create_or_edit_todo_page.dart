import 'package:flutter/material.dart';
import 'package:inicie/presentation/pages/todo_page.dart';

import '../../setup_service_locator.dart';
import '../controllers/todo_controller.dart';
import '../controllers/todo_form_controller.dart';
import '../states/todo_form_state.dart';
import '../widget/custom_text_field_widget.dart';

class CreateOrEditTodoPage extends StatelessWidget {
  final TodoFormController controller;

  const CreateOrEditTodoPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    controller.onMessage = (message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              message.contains('sucesso') ? Colors.green : Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    };

    controller.onNavigatorBack = () => navigateToTodoPage(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<TodoFormState>(
          valueListenable: controller,
          builder: (context, state, _) {
            return Column(
              children: [
                CustomTextFieldWidget(
                  label: 'Título',
                  hint: 'Digite o título da tarefa',
                  initialValue: state.title,
                  errorText: state.titleError,
                  onChanged: controller.updateTitle,
                  prefixIcon: Icons.title,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  label: 'Descrição',
                  hint: 'Digite a descrição aqui',
                  initialValue: state.description,
                  onChanged: controller.updateDescription,
                  errorText: state.descriptionError,
                  isMultiline: true,
                  prefixIcon: Icons.description,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.blueAccent,
                        ),
                        onPressed: controller.onNavigatorBack,
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () async {
                          await controller.submit();
                        },
                        child: Text(controller.buttonSubmitText),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> navigateToTodoPage(BuildContext context) async {
  await Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return TodoPage(controller: getIt.get<TodoController>());
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}
