import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/services/canvas_text_utils.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/wallpaper_template_painter.dart';

class AmoledTemplate extends WallpaperTemplatePainter {
  @override
  void paint(
      Canvas canvas, List<TaskModel> tasks, WallpaperSettingsModel settings) {
    canvas.drawColor(const Color(0xFF000000), BlendMode.src);
    WallpaperCanvasUtils.text('Tasks', const Color(0xFFE5E7EB), 30,
            settings.fontFamily, FontWeight.w700)
        .paint(canvas, const Offset(28, 72));
    var y = 136.0;
    for (final task in visibleTasks(tasks, settings)) {
      final color =
          task.completed ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB);
      canvas.drawCircle(
          Offset(34, y + 10), 4, Paint()..color = priorityColor(task.priority));
      WallpaperCanvasUtils.text(
        task.title,
        color,
        settings.fontSize,
        settings.fontFamily,
        FontWeight.w500,
        maxWidth: 292,
      ).paint(canvas, Offset(48, y));
      y += settings.taskSpacing + settings.fontSize;
    }
  }
}
