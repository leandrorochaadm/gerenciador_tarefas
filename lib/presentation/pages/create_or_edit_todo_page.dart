import 'package:flutter/material.dart';

import '../controllers/todo_form_controller.dart';
import '../states/todo_form_state.dart';
import '../utils/snack_helper.dart';
import '../widget/custom_text_field_widget.dart';

class CreateOrEditTodoPage extends StatelessWidget {
  final TodoFormController controller;
  final Function onPopCallBack;

  const CreateOrEditTodoPage({
    super.key,
    required this.controller,
    required this.onPopCallBack,
  });

  @override
  Widget build(BuildContext context) {
    controller.onMessage = (message, type) {
      SnackBarHelper.show(
        context,
        message: message,
        type: type,
      );
    };

    controller.onNavigatorBack = () {
      onPopCallBack();
      Navigator.pop(context);
    };

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
