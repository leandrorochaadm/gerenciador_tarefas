import 'package:flutter/material.dart';

import '../../domain/entities/todo_item.dart';
import '../controllers/todo_controller.dart';
import '../states/todo_state.dart';
import '../widgets/create_todo_modal.dart';

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
          _showCreateTodoModal(context, controller);
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
                    _showEditTodoModal(context, controller, todo);
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

void _showModal(BuildContext context, {required Widget child}) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return child;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  ));
}

void _showCreateTodoModal(BuildContext context, TodoController controller) {
  _showModal(
    context,
    child: TodoModal(
      onSubmit: (title, description, isDone) {
        controller.createTodo(title, description: description, isDone: isDone);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarefa criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    ),
  );
}

void _showEditTodoModal(
  BuildContext context,
  TodoController controller,
  TodoItemEntity todo,
) {
  _showModal(
    context,
    child: TodoModal(
      todo: todo,
      onSubmit: (title, description, isDone) {
        final updatedTodo = TodoItemEntity(
          id: todo.id,
          title: title,
          description: description,
          isDone: isDone,
        );
        controller.updateTodo(updatedTodo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarefa atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    ),
  );
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
