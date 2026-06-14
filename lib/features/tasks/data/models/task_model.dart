import 'package:hive/hive.dart';
import 'package:todo_wallpaper/features/tasks/domain/entities/task_priority.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    TaskPriority priority = TaskPriority.medium,
    required this.createdAt,
    this.dueDate,
    this.sortOrder = 0,
  }) : priorityIndex = priority.index;

  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  bool completed;
  @HiveField(4)
  int priorityIndex;
  @HiveField(5)
  DateTime createdAt;
  @HiveField(6)
  DateTime? dueDate;
  @HiveField(7)
  int sortOrder;

  TaskPriority get priority => TaskPriority.values[priorityIndex];
  set priority(TaskPriority v) => priorityIndex = v.index;

  TaskModel copyWith(
      {String? title,
      String? description,
      bool? completed,
      TaskPriority? priority,
      DateTime? dueDate,
      bool clearDueDate = false,
      int? sortOrder}) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
        'priority': priorityIndex,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'sortOrder': sortOrder,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: (json['description'] as String?) ?? '',
        completed: (json['completed'] as bool?) ?? false,
        priority: TaskPriority.values[(json['priority'] as int?) ?? 1],
        createdAt: DateTime.parse(json['createdAt'] as String),
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json['dueDate'] as String)
            : null,
        sortOrder: (json['sortOrder'] as int?) ?? 0,
      );
}
