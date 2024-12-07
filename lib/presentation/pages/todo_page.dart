import 'package:flutter/material.dart';
import 'package:inicie/presentation/utils/snack_helper.dart';

import '../../domain/entities/todo_item.dart';
import '../../setup_service_locator.dart';
import '../controllers/todo_controller.dart';
import '../controllers/todo_form_controller.dart';
import '../states/todo_state.dart';
import '../utils/color_helper.dart';
import '../utils/type_message_enum.dart';
import 'create_or_edit_todo_page.dart';

class TodoPage extends StatelessWidget {
  final TodoController controller;

  const TodoPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarefas',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<TodoState>(
          valueListenable: controller,
          builder: (context, state, child) {
            controller.onMessage = (message, type) {
              SnackBarHelper.show(
                context,
                message: message,
                type: type,
                onUndo: type == TypeMessage.undo
                    ? controller.restoreLastDeletedTodo
                    : null,
              );
            };

            if (state is TodoStateInitial) {
              return const Center(child: Text('Bem-vindo!'));
            } else if (state is TodoStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoStateLoaded) {
              return _buildTodoList(context, state.todos);
            } else if (state is TodoStateEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.blue[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma tarefa encontrada.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adicione novas tarefas para começar!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ocorreu um erro ao carregar as tarefas.',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchTodos,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = getIt<TodoFormController>();

          navigateToCreateOrEditTodoPage(context, controller);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void snackBarCustom(TypeMessage type, BuildContext context, String message) {
    final colorBackground = ColorHelper.getColorForType(type);

    final snackBarAction = type == TypeMessage.undo
        ? SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.yellowAccent,
            onPressed: () async => await controller.restoreLastDeletedTodo(),
          )
        : null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorBackground,
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: snackBarAction,
      ),
    );
  }

  Widget _buildTodoList(BuildContext context, List<TodoItemEntity> todos) {
    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: todo.isDone ? Colors.green : Colors.blue,
              ),
              tooltip: todo.isDone
                  ? 'Marcar como pendente'
                  : 'Marcar como concluída',
              onPressed: () {
                controller.finishTodo(todo);
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: todo.isDone ? Colors.grey : Colors.black,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              todo.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: todo.isDone ? Colors.grey : Colors.black87,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Editar tarefa',
                  onPressed: () {
                    final formController =
                        getIt<TodoFormController>(param1: todo);
                    navigateToCreateOrEditTodoPage(context, formController);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Excluir tarefa',
                  onPressed: () {
                    _showDeleteTodoModal(context, controller, todo);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showDeleteTodoModal(
  BuildContext context,
  TodoController controller,
  TodoItemEntity todo,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        ),
        child: AlertDialog(
          title: const Text(
            'Confirmar Exclusão',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Essa ação não pode ser desfeita. Tem certeza que deseja excluir a tarefa "${todo.title}"?',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await controller.deleteTodo(todo);

                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        ),
      );
    },
  );
}

void navigateToCreateOrEditTodoPage(
  BuildContext context,
  TodoFormController controller,
) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CreateOrEditTodoPage(controller: controller);
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
