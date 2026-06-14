import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';

class HomeWidgetService {
  static const _appGroupId = 'com.example.todo_wallpaper';
  static const _widgetName = 'TodoHomeWidgetProvider';

  Future<void> updateWidgets(List<TaskModel> tasks, WallpaperSettingsModel settings) async {
    await HomeWidget.setAppGroupId(_appGroupId);
    final tasksJson = jsonEncode(
      tasks.where((t) => settings.showCompletedTasks || !t.completed)
          .take(settings.maxTasksShown)
          .map((t) => {'title': t.title, 'completed': t.completed}).toList(),
    );
    final remaining = tasks.where((t) => !t.completed).length;
    final total = tasks.length;
    final pct = total == 0 ? 0 : ((tasks.where((t) => t.completed).length / total) * 100).round();
    await HomeWidget.saveWidgetData<String>('widget_tasks', tasksJson);
    await HomeWidget.saveWidgetData<String>('widget_stats', '\$remaining remaining · \$pct% done');
    await HomeWidget.updateWidget(androidName: _widgetName);
  }
}
