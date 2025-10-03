import 'package:flutter/material.dart';
import '../models/ticket.dart';

Future<Ticket?> showAddTicketDialog(BuildContext context) async {
  final title = TextEditingController();
  final assignee = TextEditingController();
  final room = TextEditingController();
  String priority = 'normal';

  final result = await showDialog<Ticket>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Новый тикет'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: title, decoration: const InputDecoration(labelText: 'Заголовок', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: priority,
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('low')),
                  DropdownMenuItem(value: 'normal', child: Text('normal')),
                  DropdownMenuItem(value: 'high', child: Text('high')),
                ],
                onChanged: (v) => priority = v ?? 'normal',
                decoration: const InputDecoration(labelText: 'Приоритет', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(controller: assignee, decoration: const InputDecoration(labelText: 'Исполнитель', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: room, decoration: const InputDecoration(labelText: 'Локация', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              if (title.text.trim().isEmpty || assignee.text.trim().isEmpty || room.text.trim().isEmpty) return;
              Navigator.pop(
                context,
                Ticket(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title.text.trim(),
                  priority: priority,
                  assignee: assignee.text.trim(),
                  room: room.text.trim(),
                ),
              );
            },
            child: const Text('Добавить'),
          ),
        ],
      );
    },
  );
  return result;
}
