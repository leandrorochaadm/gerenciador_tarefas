import 'package:flutter/material.dart';
import 'package:inicie/setup_service_locator.dart';

import '../../domain/entities/todo_item.dart';
import '../controllers/todo_controller.dart';
import '../controllers/todo_form_controller.dart';
import '../states/todo_state.dart';
import 'create_or_edit_todo_page.dart';

class TodoPage extends StatelessWidget {
  final TodoController controller;

  const TodoPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<TodoState>(
          valueListenable: controller,
          builder: (context, state, child) {
            if (state is TodoInitial) {
              return const Center(child: Text('Bem-vindo!'));
            } else if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              return _buildTodoList(context, state.todos);
            } else if (state is TodoEmpty) {
              return const Center(child: Text('Nenhuma tarefa encontrada.'));
            } else if (state is TodoError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
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

            return const SizedBox();
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

  Widget _buildTodoList(BuildContext context, List<TodoItemEntity> todos) {
    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Icon(
              todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: todo.isDone ? Colors.green : Colors.orange,
            ),
            title: Text(todo.title),
            subtitle: Text(todo.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    final controller = getIt<TodoFormController>(param1: todo);

                    navigateToCreateOrEditTodoPage(context, controller);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
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
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text(
                  'Você tem certeza que deseja excluir a tarefa "${todo.title}"?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.deleteTodo(todo.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ),
        );
      },
    ),
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
