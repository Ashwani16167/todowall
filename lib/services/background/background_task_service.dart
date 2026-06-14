import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:todo_wallpaper/core/constants/hive_box_names.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/repositories/wallpaper_settings_repository_impl.dart';
import 'package:todo_wallpaper/features/wallpaper/services/wallpaper_apply_service.dart';
import 'package:todo_wallpaper/features/wallpaper/services/wallpaper_renderer_service.dart';
import 'package:todo_wallpaper/features/widgets_integration/services/home_widget_service.dart';

Future<void> registerBackgroundTasks() async {
  await Workmanager().registerPeriodicTask(
    'midnight_wallpaper_refresh',
    'midnight_wallpaper_refresh',
    frequency: const Duration(hours: 1),
    existingWorkPolicy: ExistingWorkPolicy.keep,
  );
}

@pragma('vm:entry-point')
void backgroundTaskDispatcher() {
  Workmanager().executeTask((task, data) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(WallpaperSettingsModelAdapter());
      }
      if (!Hive.isBoxOpen(HiveBoxNames.tasks)) {
        await Hive.openBox<TaskModel>(HiveBoxNames.tasks);
      }
      if (!Hive.isBoxOpen(HiveBoxNames.wallpaperSettings)) {
        await Hive.openBox<WallpaperSettingsModel>(
            HiveBoxNames.wallpaperSettings);
      }
      final tasks = TaskRepositoryImpl(Hive.box<TaskModel>(HiveBoxNames.tasks))
          .getAllTasks();
      final settings = WallpaperSettingsRepositoryImpl(
              Hive.box<WallpaperSettingsModel>(HiveBoxNames.wallpaperSettings))
          .getSettings();
      final bytes = await WallpaperRendererService().render(tasks, settings);
      final path = await WallpaperApplyService().saveWallpaperToFile(bytes);
      await WallpaperApplyService().applyToBoth(path);
      await HomeWidgetService().updateWidgets(tasks, settings);
      return true;
    } catch (_) {
      return false;
    }
  });
}
