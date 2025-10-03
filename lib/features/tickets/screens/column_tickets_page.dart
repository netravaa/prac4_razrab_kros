import 'package:flutter/material.dart';
import '../models/ticket_repository.dart';
import '../widgets/ticket_card.dart';
import '../models/ticket.dart';
import '_add_ticket_dialog.dart';

class ColumnTicketsPage extends StatefulWidget {
  const ColumnTicketsPage({super.key});

  @override
  State<ColumnTicketsPage> createState() => _ColumnTicketsPageState();
}

class _ColumnTicketsPageState extends State<ColumnTicketsPage> {
  final repo = TicketRepository();

  void _add() async {
    final t = await showAddTicketDialog(context);
    if (t != null) setState(() => repo.add(t));
  }

  void _remove(String id) => setState(() => repo.remove(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column + SingleChildScrollView')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(child: Text('Список тикетов, собранный через Column внутри прокручиваемого контейнера.')),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: repo.tickets
                    .map((t) => TicketCard(
                          key: ValueKey(t.id),
                          ticket: t,
                          onDelete: () => _remove(t.id),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
    );
  }
}
