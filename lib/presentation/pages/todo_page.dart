import 'package:flutter/material.dart';

import '../../domain/entities/todo_item.dart';
import '../../setup_service_locator.dart';
import '../controllers/todo_controller.dart';
import '../controllers/todo_form_controller.dart';
import '../states/todo_state.dart';
import '../utils/app_bar_custom_widget.dart';
import '../utils/snack_helper.dart';
import '../utils/type_message_enum.dart';
import 'create_or_edit_todo_page.dart';

class TodoPage extends StatelessWidget {
  final TodoController controller;

  const TodoPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustomWidget('Tarefas'),
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
              return const EmptyWidget();
            }

            return ErrorWidget(controller: controller);
          },
        ),
      ),
      floatingActionButton: buttonAddWidget(context),
    );
  }

  FloatingActionButton buttonAddWidget(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final todoFormController = getIt<TodoFormController>();

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return CreateOrEditTodoPage(
              controller: todoFormController,
              onPopCallBack: controller.fetchTodos,
            );
          },
        ));
      },
      child: const Icon(Icons.add),
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
                    final todoFormController =
                        getIt<TodoFormController>(param1: todo);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CreateOrEditTodoPage(
                        controller: todoFormController,
                        onPopCallBack: controller.fetchTodos,
                      );
                    }));
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

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.controller,
  });

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
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
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            'Essa ação não pode ser desfeita.\n\nTem certeza que deseja excluir a tarefa "${todo.title}"?',
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
