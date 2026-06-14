import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';

class HomeWidgetService {
  static const _appGroupId = 'com.example.todo_wallpaper';
  static const _widgetName = 'TodoHomeWidgetProvider';

  Future<void> updateWidgets(
      List<TaskModel> tasks, WallpaperSettingsModel settings) async {
    await HomeWidget.setAppGroupId(_appGroupId);
    final visibleTasks = tasks
        .where((task) => settings.showCompletedTasks || !task.completed)
        .take(settings.maxTasksShown)
        .map((task) => {'title': task.title, 'completed': task.completed})
        .toList();
    final remaining = tasks.where((task) => !task.completed).length;
    final total = tasks.length;
    final completed = tasks.where((task) => task.completed).length;
    final pct = total == 0 ? 0 : ((completed / total) * 100).round();

    await HomeWidget.saveWidgetData<String>(
        'widget_tasks', jsonEncode(visibleTasks));
    await HomeWidget.saveWidgetData<String>(
        'widget_stats', '$remaining remaining - $pct% done');
    await HomeWidget.updateWidget(androidName: _widgetName);
  }
}
