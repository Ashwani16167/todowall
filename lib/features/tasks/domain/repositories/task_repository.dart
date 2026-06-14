import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
abstract class TaskRepository {
  List<TaskModel> getAllTasks();
  Stream<List<TaskModel>> watchTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> toggleComplete(String id);
  Future<void> reorderTasks(List<String> orderedIds);
  Future<void> replaceAll(List<TaskModel> tasks);
  Future<void> clearAll();
}
