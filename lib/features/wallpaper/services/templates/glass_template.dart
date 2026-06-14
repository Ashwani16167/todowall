import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/services/canvas_text_utils.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/wallpaper_template_painter.dart';

class GlassTemplate extends WallpaperTemplatePainter {
  @override
  void paint(
      Canvas canvas, List<TaskModel> tasks, WallpaperSettingsModel settings) {
    canvas.drawColor(const Color(0xFFE0F2FE), BlendMode.src);
    final panel = RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 54, 316, 520), const Radius.circular(24));
    canvas.drawRRect(panel, Paint()..color = const Color(0xB3FFFFFF));
    WallpaperCanvasUtils.text('Today', const Color(0xFF075985), 30,
            settings.fontFamily, FontWeight.w700)
        .paint(canvas, const Offset(48, 88));

    var y = 152.0;
    for (final task in visibleTasks(tasks, settings)) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(44, y - 8, 272, 42), const Radius.circular(12)),
        Paint()..color = const Color(0x80FFFFFF),
      );
      WallpaperCanvasUtils.text(
        task.title,
        const Color(0xFF0F172A),
        settings.fontSize,
        settings.fontFamily,
        FontWeight.w500,
        maxWidth: 240,
      ).paint(canvas, Offset(60, y));
      y += 50;
    }
  }
}
