class Task {
  String title;
  bool isDone;
  String priority; // High - Medium - Low
  DateTime? deadline;

  Task({
    required this.title,
    this.isDone = false,
    this.priority = "Medium",
    this.deadline,
  });

  // تحويل الـ Task إلى Map للتخزين
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'priority': priority,
      'deadline': deadline?.toIso8601String(),
    };
  }

  // إنشاء Task من Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      isDone: map['isDone'],
      priority: map['priority'],
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'])
          : null,
    );
  }
}
