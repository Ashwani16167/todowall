import 'dart:ui';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/tasks/domain/entities/task_priority.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';

abstract class WallpaperTemplatePainter {
  void paint(Canvas canvas, List<TaskModel> tasks, WallpaperSettingsModel settings);
}

Color priorityColor(TaskPriority p) {
  switch (p) {
    case TaskPriority.high: return const Color(0xFFEF4444);
    case TaskPriority.medium: return const Color(0xFFF59E0B);
    case TaskPriority.low: return const Color(0xFF10B981);
  }
}

List<TaskModel> visibleTasks(List<TaskModel> tasks, WallpaperSettingsModel s) =>
    tasks.where((t) => s.showCompletedTasks || !t.completed).take(s.maxTasksShown).toList();
