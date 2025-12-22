import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const TodoCard({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              todo.isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
              todo.isCompleted ? Colors.green.shade100 : Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: todo.isCompleted ? Colors.green : Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              color: todo.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                _formatDate(todo.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (todo.updatedAt != null) ...[
                Text(
                  'Diupdate: ${_formatDate(todo.updatedAt!)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  todo.isCompleted ? Icons.undo : Icons.check_circle,
                  color: todo.isCompleted ? Colors.orange : Colors.green,
                ),
                onPressed: onToggle,
                tooltip: todo.isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}