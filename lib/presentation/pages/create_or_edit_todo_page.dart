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
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
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
                    labelStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: 'Digite o título da tarefa',
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorText: formState.titleError,
                    errorStyle:
                        const TextStyle(color: Colors.redAccent, fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.title, color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: controller.updateDescription,
                  initialValue: formState.description,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: 'Digite a descrição aqui',
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorText: formState.descriptionError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    prefixIcon:
                        const Icon(Icons.description, color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Switch.adaptive(
                      value: formState.isDone,
                      onChanged: controller.toggleIsDone,
                      activeColor: Colors.blue,
                      activeTrackColor: Colors.blueAccent,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
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
                        onPressed: () async {
                          navigateToTodoPage(context);
                        },
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
                          if (controller.isFormValid) {
                            navigateToTodoPage(context);
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
