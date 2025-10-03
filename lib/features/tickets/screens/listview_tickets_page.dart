import 'package:flutter/material.dart';
import '../models/ticket_repository.dart';
import '../widgets/ticket_card.dart';
import '_add_ticket_dialog.dart';

class ListViewTicketsPage extends StatefulWidget {
  const ListViewTicketsPage({super.key});

  @override
  State<ListViewTicketsPage> createState() => _ListViewTicketsPageState();
}

class _ListViewTicketsPageState extends State<ListViewTicketsPage> {
  final repo = TicketRepository();

  void _add() async {
    final t = await showAddTicketDialog(context);
    if (t != null) setState(() => repo.add(t));
  }

  void _remove(String id) => setState(() => repo.remove(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView.builder')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green),
                SizedBox(width: 8),
                Expanded(child: Text('Эффективный список тикетов c ленивой подгрузкой.')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: repo.tickets.length,
              itemBuilder: (context, i) {
                final t = repo.tickets[i];
                return TicketCard(
                  key: ValueKey(t.id),
                  ticket: t,
                  onDelete: () => _remove(t.id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
    );
  }
}
