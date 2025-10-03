import 'package:flutter/material.dart';
import '../models/ticket_repository.dart';
import '../widgets/ticket_card.dart';
import '_add_ticket_dialog.dart';

class SeparatedTicketsPage extends StatefulWidget {
  const SeparatedTicketsPage({super.key});

  @override
  State<SeparatedTicketsPage> createState() => _SeparatedTicketsPageState();
}

class _SeparatedTicketsPageState extends State<SeparatedTicketsPage> {
  final repo = TicketRepository();

  void _add() async {
    final t = await showAddTicketDialog(context);
    if (t != null) setState(() => repo.add(t));
  }

  void _remove(String id) => setState(() => repo.remove(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView.separated')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(child: Text('Список тикетов с разделителями между карточками.')),
              ],
            ),
          ),
          Expanded(
            child: repo.tickets.isEmpty
                ? const Center(child: Text('Нет тикетов'))
                : ListView.separated(
                    itemCount: repo.tickets.length,
                    separatorBuilder: (context, i) => Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.transparent, Colors.grey, Colors.transparent]),
                      ),
                    ),
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
