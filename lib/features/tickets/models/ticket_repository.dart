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
