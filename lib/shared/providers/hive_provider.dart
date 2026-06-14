import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_wallpaper/core/constants/hive_box_names.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(WallpaperSettingsModelAdapter());
  await Future.wait([
    Hive.openBox<TaskModel>(HiveBoxNames.tasks),
    Hive.openBox<WallpaperSettingsModel>(HiveBoxNames.wallpaperSettings),
    Hive.openBox(HiveBoxNames.widgetPreferences),
    Hive.openBox(HiveBoxNames.appSettings),
  ]);
}

final taskBoxProvider =
    Provider<Box<TaskModel>>((ref) => Hive.box<TaskModel>(HiveBoxNames.tasks));
final wallpaperSettingsBoxProvider = Provider<Box<WallpaperSettingsModel>>(
    (ref) => Hive.box<WallpaperSettingsModel>(HiveBoxNames.wallpaperSettings));
