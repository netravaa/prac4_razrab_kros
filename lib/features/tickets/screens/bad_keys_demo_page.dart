import 'package:flutter/material.dart';

class EditableTicketItem extends StatefulWidget {
  final String title;
  final VoidCallback onDelete;

  const EditableTicketItem({
    super.key, // КЛЮЧ НЕ ПЕРЕДАЁМ в bad-версии
    required this.title,
    required this.onDelete,
  });

  @override
  State<EditableTicketItem> createState() => _EditableTicketItemState();
}

class _EditableTicketItemState extends State<EditableTicketItem> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: TextField(
          controller: _c,
          decoration: const InputDecoration(hintText: 'Напишите что-нибудь…'),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: widget.onDelete,
        ),
      ),
    );
  }
}

class BadKeysDemoPage extends StatefulWidget {
  const BadKeysDemoPage({super.key});

  @override
  State<BadKeysDemoPage> createState() => _BadKeysDemoPageState();
}

class _BadKeysDemoPageState extends State<BadKeysDemoPage> {
  final items = List.generate(6, (i) => 'Ticket ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Удаление без ключей — проблема')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          return EditableTicketItem(
            title: items[i],
            onDelete: () => setState(() => items.removeAt(i)),
          );
        },
      ),
    );
  }
}
