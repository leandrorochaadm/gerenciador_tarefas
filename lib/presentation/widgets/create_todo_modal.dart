import 'package:flutter/material.dart';

import '../../domain/entities/todo_item.dart';

class TodoModal extends StatefulWidget {
  final TodoItemEntity? todo;
  final void Function(String title, String description, bool isDone) onSubmit;

  const TodoModal({
    super.key,
    this.todo,
    required this.onSubmit,
  });

  @override
  State<TodoModal> createState() => _TodoModalState();
}

class _TodoModalState extends State<TodoModal> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    _isDone = widget.todo?.isDone ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Editar Tarefa' : 'Criar Nova Tarefa',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status da Tarefa:'),
                  DropdownButton<bool>(
                    value: _isDone,
                    onChanged: (value) {
                      setState(() {
                        _isDone = value!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: false,
                        child: Text('Pendente'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('Concluída'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('O título é obrigatório.'),
                          ),
                        );
                        return;
                      }

                      widget.onSubmit(
                        _titleController.text,
                        _descriptionController.text,
                        _isDone,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(isEditing ? 'Atualizar' : 'Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
