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
