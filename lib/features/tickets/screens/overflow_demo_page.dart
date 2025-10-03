import 'package:flutter/material.dart';
import '../models/ticket_repository.dart';
import '../widgets/ticket_card.dart';

/// Демонстрация ОШИБКИ переполнения:
/// много элементов в Column без скролла -> RenderFlex overflow.
class OverflowDemoPage extends StatelessWidget {
  OverflowDemoPage({super.key});

  final repo = TicketRepository();

  @override
  Widget build(BuildContext context) {
    // при желании можно "искусственно" размножить элементы:
    final items = [
      ...repo.tickets,
      ...repo.tickets,
      ...repo.tickets,
      ...repo.tickets,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Column (без прокрутки) — overflow')),
      body: Column(
        children: items
            .map((t) => TicketCard(
          ticket: t,
        ))
            .toList(),
      ),
    );
  }
}
