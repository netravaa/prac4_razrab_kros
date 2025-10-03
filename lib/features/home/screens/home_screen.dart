import 'package:flutter/material.dart';
import '../../../shared/models/user_data.dart';
import '../../tickets/screens/column_tickets_page.dart';
import '../../tickets/screens/listview_tickets_page.dart';
import '../../tickets/screens/separated_tickets_page.dart';
import '../../tickets/screens/overflow_demo_page.dart';
import '../../tickets/screens/bad_keys_demo_page.dart';
import '../../tickets/screens/good_keys_demo_page.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cc.primaryContainer,
        title: const Text('HelpDesk Tracker — Главная'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cc.primaryContainer.withOpacity(.55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Добро пожаловать!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('${UserData.userName} • ${UserData.group}'),
                const SizedBox(height: 6),
                const Text('Демонстрация списков: Column / ListView / ListView.separated'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            context,
            title: 'Column + Scroll',
            subtitle: 'Список тикетов, собранный через Column',
            icon: Icons.view_column,
            color: Colors.blue,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ColumnTicketsPage())),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            title: 'ListView.builder',
            subtitle: 'Эффективный список с ленивым построением',
            icon: Icons.list_alt,
            color: Colors.green,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListViewTicketsPage())),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            title: 'Column (без прокрутки)',
            subtitle: 'Демонстрация overflow-ошибки',
            icon: Icons.error_outline,
            color: Colors.redAccent,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OverflowDemoPage())),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            title: 'Удаление без ключей',
            subtitle: 'Демонстрация некорректной перерисовки',
            icon: Icons.warning_amber_rounded,
            color: Colors.redAccent,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadKeysDemoPage())),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            title: 'Удаление с ключами',
            subtitle: 'Правильная работа при обновлениях',
            icon: Icons.key,
            color: Colors.teal,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoodKeysDemoPage())),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            title: 'ListView.separated',
            subtitle: 'Список с разделителями',
            icon: Icons.linear_scale,
            color: Colors.orange,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SeparatedTicketsPage())),
          ),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
                ]),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
