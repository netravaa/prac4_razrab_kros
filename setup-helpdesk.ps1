# setup-helpdesk.ps1
# Создаёт структуру и файлы для проекта "HelpDesk Tracker"

# ---- Папки ----
$dirs = @(
  "lib",
  "lib\shared\models",
  "lib\features\home\screens",
  "lib\features\tickets\models",
  "lib\features\tickets\screens",
  "lib\features\tickets\widgets"
)

foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

# ---- lib\shared\models\user_data.dart ----
@'
class UserData {
  static String userName = 'Соколов Владимир Дмитриевич';
  static String group = 'ИКБО-12-22';
}
'@ | Set-Content -Path "lib\shared\models\user_data.dart" -Encoding UTF8

# ---- lib\features\tickets\models\ticket.dart ----
@'
class Ticket {
  final String id;
  final String title;
  final String priority; // low / normal / high
  final String assignee; // исполнитель
  final String room;     // аудитория/локация

  Ticket({
    required this.id,
    required this.title,
    required this.priority,
    required this.assignee,
    required this.room,
  });

  Ticket copyWith({
    String? id,
    String? title,
    String? priority,
    String? assignee,
    String? room,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      assignee: assignee ?? this.assignee,
      room: room ?? this.room,
    );
  }

  @override
  bool operator ==(Object other) => other is Ticket && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
'@ | Set-Content -Path "lib\features\tickets\models\ticket.dart" -Encoding UTF8

# ---- lib\features\tickets\models\ticket_repository.dart ----
@'
import 'ticket.dart';

class TicketRepository {
  static final TicketRepository _instance = TicketRepository._internal();
  factory TicketRepository() => _instance;
  TicketRepository._internal();

  final List<Ticket> _tickets = [
    Ticket(id: 't1', title: 'Не включается ПК', priority: 'high', assignee: 'Иванов И.И.', room: 'Ауд. 205'),
    Ticket(id: 't2', title: 'Не печатает принтер', priority: 'normal', assignee: 'Петров П.П.', room: 'Каб. 312'),
    Ticket(id: 't3', title: 'Сломался проектор', priority: 'high', assignee: 'Сидоров С.С.', room: 'Лекц. 1'),
    Ticket(id: 't4', title: 'Нет Wi-Fi', priority: 'low', assignee: 'Козлов К.К.', room: 'Коворкинг'),
    Ticket(id: 't5', title: 'Установка ПО', priority: 'normal', assignee: 'Орлов О.О.', room: 'Ауд. 122'),
  ];

  List<Ticket> get tickets => List.unmodifiable(_tickets);

  void add(Ticket t) => _tickets.add(t);
  void remove(String id) => _tickets.removeWhere((e) => e.id == id);

  void update(Ticket t) {
    final i = _tickets.indexWhere((e) => e.id == t.id);
    if (i != -1) _tickets[i] = t;
  }
}
'@ | Set-Content -Path "lib\features\tickets\models\ticket_repository.dart" -Encoding UTF8

# ---- lib\features\tickets\widgets\ticket_card.dart ----
@'
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
'@ | Set-Content -Path "lib\features\tickets\widgets\ticket_card.dart" -Encoding UTF8

# ---- lib\features\tickets\screens\_add_ticket_dialog.dart ----
@'
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
'@ | Set-Content -Path "lib\features\tickets\screens\_add_ticket_dialog.dart" -Encoding UTF8

# ---- lib\features\tickets\screens\column_tickets_page.dart ----
@'
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
'@ | Set-Content -Path "lib\features\tickets\screens\column_tickets_page.dart" -Encoding UTF8

# ---- lib\features\tickets\screens\listview_tickets_page.dart ----
@'
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
'@ | Set-Content -Path "lib\features\tickets\screens\listview_tickets_page.dart" -Encoding UTF8

# ---- lib\features\tickets\screens\separated_tickets_page.dart ----
@'
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
'@ | Set-Content -Path "lib\features\tickets\screens\separated_tickets_page.dart" -Encoding UTF8

# ---- lib\features\home\screens\home_screen.dart ----
@'
import 'package:flutter/material.dart';
import '../../../shared/models/user_data.dart';
import '../../tickets/screens/column_tickets_page.dart';
import '../../tickets/screens/listview_tickets_page.dart';
import '../../tickets/screens/separated_tickets_page.dart';

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
'@ | Set-Content -Path "lib\features\home\screens\home_screen.dart" -Encoding UTF8

# ---- lib\main.dart ----
@'
import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const HelpDeskApp());
}

class HelpDeskApp extends StatelessWidget {
  const HelpDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpDesk Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
'@ | Set-Content -Path "lib\main.dart" -Encoding UTF8

Write-Host "`n✅ Файлы сгенерированы. Запусти проект:" -ForegroundColor Green
Write-Host "   flutter clean; flutter pub get; flutter run" -ForegroundColor Yellow
