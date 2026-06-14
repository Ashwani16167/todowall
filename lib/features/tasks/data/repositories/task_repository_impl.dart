import 'package:hive/hive.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._box);
  final Box<TaskModel> _box;

  @override
  List<TaskModel> getAllTasks() {
    final t = _box.values.toList();
    t.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return t;
  }

  @override
  Stream<List<TaskModel>> watchTasks() =>
      _box.watch().map((_) => getAllTasks()).startWith(getAllTasks());

  @override Future<void> addTask(TaskModel task) async {
    final max = _box.values.isEmpty ? -1 : _box.values.map((t) => t.sortOrder).reduce((a, b) => a > b ? a : b);
    task.sortOrder = max + 1;
    await _box.put(task.id, task);
  }

  @override Future<void> updateTask(TaskModel task) => _box.put(task.id, task);
  @override Future<void> deleteTask(String id) => _box.delete(id);

  @override Future<void> toggleComplete(String id) async {
    final t = _box.get(id); if (t == null) return;
    t.completed = !t.completed; await t.save();
  }

  @override Future<void> reorderTasks(List<String> ids) async {
    for (var i = 0; i < ids.length; i++) {
      final t = _box.get(ids[i]); if (t == null) continue;
      t.sortOrder = i; await t.save();
    }
  }

  @override Future<void> replaceAll(List<TaskModel> tasks) async {
    await _box.clear();
    for (final t in tasks) await _box.put(t.id, t);
  }

  @override Future<void> clearAll() => _box.clear();
}

extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T v) async* { yield v; yield* this; }
}
