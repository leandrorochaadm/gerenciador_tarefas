import 'package:flutter/material.dart';
import 'package:inicie/presentation/pages/todo_page.dart';

import '../../setup_service_locator.dart';
import '../controllers/todo_controller.dart';
import '../controllers/todo_form_controller.dart';
import '../states/todo_form_state.dart';

class CreateOrEditTodoPage extends StatelessWidget {
  final TodoFormController controller;

  const CreateOrEditTodoPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.appBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<TodoFormState>(
          valueListenable: controller,
          builder: (context, formState, _) {
            return Column(
              children: [
                TextFormField(
                  onChanged: controller.updateTitle,
                  initialValue: formState.title,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    errorText: formState.titleError,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: controller.updateDescription,
                  initialValue: formState.description,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    errorText: formState.descriptionError,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status:'),
                    Switch(
                      value: formState.isDone,
                      onChanged: controller.toggleIsDone,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await controller.submit();
                    if (controller.isFormValid) {
                      navigateToCreateOrEditTodoPage(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(formState.formErrorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(controller.buttonSubmitText),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> navigateToCreateOrEditTodoPage(BuildContext context) async {
  await Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return TodoPage(controller: getIt.get<TodoController>());
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Começa de baixo para cima
        const end = Offset.zero; // Termina na posição original
        const curve = Curves.easeInOut; // Curva de animação suave

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
