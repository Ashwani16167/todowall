import 'package:flutter_test/flutter_test.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/tasks/domain/entities/task_priority.dart';

void main() {
  test('TaskModel copyWith keeps existing values by default', () {
    final task = TaskModel(
      id: 'task-1',
      title: 'Write todo wallpaper',
      priority: TaskPriority.high,
      createdAt: DateTime(2026, 6, 14),
    );

    final updated = task.copyWith(completed: true);

    expect(updated.id, task.id);
    expect(updated.title, task.title);
    expect(updated.priority, TaskPriority.high);
    expect(updated.completed, isTrue);
  });
}
