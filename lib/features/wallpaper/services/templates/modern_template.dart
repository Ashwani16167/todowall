import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/services/canvas_text_utils.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/wallpaper_template_painter.dart';

class ModernTemplate extends WallpaperTemplatePainter {
  @override
  void paint(
      Canvas canvas, List<TaskModel> tasks, WallpaperSettingsModel settings) {
    canvas.drawColor(const Color(0xFFF8FAFC), BlendMode.src);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(24, 48, 312, 96), const Radius.circular(20)),
      Paint()..color = const Color(0xFF2563EB),
    );
    WallpaperCanvasUtils.text('Focus list', const Color(0xFFFFFFFF), 26,
            settings.fontFamily, FontWeight.w700)
        .paint(canvas, const Offset(48, 76));

    var y = 176.0;
    for (final task in visibleTasks(tasks, settings)) {
      final card = RRect.fromRectAndRadius(
          Rect.fromLTWH(24, y - 10, 312, 48), const Radius.circular(14));
      canvas.drawRRect(card, Paint()..color = const Color(0xFFFFFFFF));
      canvas.drawCircle(
          Offset(44, y + 12), 5, Paint()..color = priorityColor(task.priority));
      WallpaperCanvasUtils.text(
        task.title,
        const Color(0xFF0F172A),
        settings.fontSize,
        settings.fontFamily,
        FontWeight.w600,
        maxWidth: 250,
      ).paint(canvas, Offset(60, y));
      y += 56;
    }
  }
}
