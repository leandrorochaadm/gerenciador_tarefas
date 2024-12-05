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
            if (state is TodoInitial) {
              return const Center(child: Text('Bem-vindo!'));
            } else if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              return _buildTodoList(context, state.todos);
            } else if (state is TodoEmpty) {
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
                controller.deleteTodo(todo);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text(
                      'Tarefa "${todo.title}" foi finalizada.',
                      style: const TextStyle(color: Colors.white),
                    ),
                    action: SnackBarAction(
                      label: 'Desfazer',
                      textColor: Colors.yellowAccent, // Contraste com o fundo
                      onPressed: () async {
                        await controller.restoreLastDeletedTodo();
                      },
                    ),
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
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
            'Você tem certeza que deseja excluir a tarefa "${todo.title}"?',
            style: const TextStyle(fontSize: 16),
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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                await controller.deleteTodo(todo);

                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarefa excluída com sucesso.'),
                    backgroundColor: Colors.green,
                  ),
                );
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
