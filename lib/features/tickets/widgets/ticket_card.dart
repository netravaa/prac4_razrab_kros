import 'package:flutter/material.dart';
import '../models/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onDelete;

  const TicketCard({super.key, required this.ticket, this.onDelete});

  Color _priorityColor(BuildContext context) {
    switch (ticket.priority) {
      case 'high': return Colors.redAccent;
      case 'low':  return Colors.green;
      default:     return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pc = _priorityColor(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: pc,
          child: Text(
            ticket.title.substring(0,1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(ticket.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Приоритет: ${ticket.priority} • Исп.: ${ticket.assignee}\nЛокация: ${ticket.room}'),
        trailing: onDelete == null
            ? null
            : IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
      ),
    );
  }
}
