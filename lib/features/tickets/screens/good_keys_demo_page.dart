import 'package:flutter/material.dart';
import 'bad_keys_demo_page.dart'; // используем тот же EditableTicketItem

class GoodKeysDemoPage extends StatefulWidget {
  const GoodKeysDemoPage({super.key});

  @override
  State<GoodKeysDemoPage> createState() => _GoodKeysDemoPageState();
}

class _GoodKeysDemoPageState extends State<GoodKeysDemoPage> {
  final items = List.generate(6, (i) => 'Ticket ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Удаление c ключами — корректно')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          return EditableTicketItem(
            key: ValueKey(items[i]),
            title: items[i],
            onDelete: () => setState(() => items.removeAt(i)),
          );
        },
      ),
    );
  }
}
