import 'package:flutter/material.dart';

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
                    if (formState.formErrorMessage != null) {
                      Navigator.pop(context);
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
