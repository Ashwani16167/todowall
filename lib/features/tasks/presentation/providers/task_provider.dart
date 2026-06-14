import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:todo_wallpaper/features/tasks/domain/entities/task_priority.dart';
import 'package:todo_wallpaper/features/tasks/domain/repositories/task_repository.dart';
import 'package:todo_wallpaper/shared/providers/hive_provider.dart';

const _uuid = Uuid();

final taskRepositoryProvider = Provider<TaskRepository>(
    (ref) => TaskRepositoryImpl(ref.watch(taskBoxProvider)));
final taskListProvider = StreamProvider<List<TaskModel>>(
    (ref) => ref.watch(taskRepositoryProvider).watchTasks());

final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(taskListProvider).value ?? [];
  final total = tasks.length,
      completed = tasks.where((t) => t.completed).length;
  return TaskStats(
      total: total,
      completed: completed,
      remaining: total - completed,
      percentComplete: total == 0 ? 0 : ((completed / total) * 100).round());
});

class TaskStats {
  const TaskStats(
      {required this.total,
      required this.completed,
      required this.remaining,
      required this.percentComplete});
  final int total, completed, remaining, percentComplete;
}

final taskListControllerProvider = Provider<TaskListController>(
    (ref) => TaskListController(ref.watch(taskRepositoryProvider)));

class TaskListController {
  TaskListController(this._repo);
  final TaskRepository _repo;

  Future<void> addTask(
          {required String title,
          String description = '',
          TaskPriority priority = TaskPriority.medium,
          DateTime? dueDate}) =>
      _repo.addTask(TaskModel(
          id: _uuid.v4(),
          title: title,
          description: description,
          priority: priority,
          createdAt: DateTime.now(),
          dueDate: dueDate));

  Future<void> updateTask(TaskModel t) => _repo.updateTask(t);
  Future<void> deleteTask(String id) => _repo.deleteTask(id);
  Future<void> toggleComplete(String id) => _repo.toggleComplete(id);
  Future<void> reorder(List<String> ids) => _repo.reorderTasks(ids);
  Future<void> clearAll() => _repo.clearAll();
  Future<void> replaceAll(List<TaskModel> tasks) => _repo.replaceAll(tasks);
}
