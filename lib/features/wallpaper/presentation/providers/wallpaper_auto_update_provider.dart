import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_wallpaper/features/tasks/presentation/providers/task_provider.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/presentation/providers/wallpaper_settings_provider.dart';
import 'package:todo_wallpaper/features/wallpaper/services/wallpaper_apply_service.dart';
import 'package:todo_wallpaper/features/wallpaper/services/wallpaper_renderer_service.dart';
import 'package:todo_wallpaper/features/widgets_integration/services/home_widget_service.dart';

final wallpaperAutoUpdateProvider = Provider<void>((ref) {
  final renderer = WallpaperRendererService();
  final applyService = WallpaperApplyService();
  final widgetService = HomeWidgetService();
  Timer? debounce;

  Future<void> regenerate() async {
    final tasks = ref.read(taskListProvider).value;
    final settings =
        ref.read(wallpaperSettingsProvider).value ?? WallpaperSettingsModel();
    if (tasks == null) return;
    try {
      final bytes = await renderer.render(tasks, settings);
      final path = await applyService.saveWallpaperToFile(bytes);
      await applyService.applyToBoth(path);
      await widgetService.updateWidgets(tasks, settings);
    } catch (e) {
      // ignore: avoid_print
      print('Wallpaper update failed: $e');
    }
  }

  void schedule() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 600), regenerate);
  }

  ref.listen(taskListProvider, (_, next) {
    if (next.hasValue) schedule();
  });
  ref.listen(wallpaperSettingsProvider, (_, next) {
    if (next.hasValue) schedule();
  });
  ref.onDispose(() => debounce?.cancel());
});
