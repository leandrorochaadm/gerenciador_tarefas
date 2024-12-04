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
      appBar: AppBar(title: const Text('Tarefas')),
      body: ValueListenableBuilder<TodoState>(
        valueListenable: controller,
        builder: (context, state, child) {
          if (state is TodoInitial) {
            return const Center(child: Text('Bem-vindo!'));
          } else if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          todo.isDone ? Icons.check : Icons.pending,
                          color: todo.isDone ? Colors.green : Colors.orange,
                        ),
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
                  onTap: () {
                    _showEditTodoModal(context, controller, todo);
                  },
                );
              },
            );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTodoModal(context, controller);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showCreateTodoModal(BuildContext context, TodoController controller) {
  showDialog(
    context: context,
    builder: (context) => TodoModal(
      onSubmit: (title, description, isDone) {
        controller.createTodo(title, description: description);
      },
    ),
  );
}

void _showEditTodoModal(
  BuildContext context,
  TodoController controller,
  TodoItemEntity todo,
) {
  showDialog(
    context: context,
    builder: (context) => TodoModal(
      todo: todo,
      onSubmit: (title, description, isDone) {
        final updatedTodo = TodoItemEntity(
          id: todo.id,
          title: title,
          description: description,
          isDone: isDone,
        );
        controller.updateTodo(updatedTodo);
      },
    ),
  );
}

void _showDeleteTodoModal(
    BuildContext context, TodoController controller, TodoItemEntity todo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
      );
    },
  );
}
