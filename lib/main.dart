import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_wallpaper/app.dart';
import 'package:todo_wallpaper/shared/providers/hive_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:todo_wallpaper/services/background/background_task_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await Workmanager()
      .initialize(backgroundTaskDispatcher, isInDebugMode: false);
  await registerBackgroundTasks();
  runApp(const ProviderScope(child: TodoWallpaperApp()));
}
