import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/services/canvas_text_utils.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/wallpaper_template_painter.dart';

class MinimalTemplate extends WallpaperTemplatePainter {
  @override
  void paint(
      Canvas canvas, List<TaskModel> tasks, WallpaperSettingsModel settings) {
    canvas.drawColor(Color(settings.backgroundColorValue), BlendMode.src);
    final textColor = Color(settings.textColorValue);
    WallpaperCanvasUtils.text(
            'Today', textColor, 28, settings.fontFamily, FontWeight.w700)
        .paint(canvas, const Offset(28, 64));
    paintSimpleTasks(canvas, tasks, settings, textColor, const Offset(28, 124));
  }
}

void paintSimpleTasks(
  Canvas canvas,
  List<TaskModel> tasks,
  WallpaperSettingsModel settings,
  Color textColor,
  Offset start,
) {
  var y = start.dy;
  for (final task in visibleTasks(tasks, settings)) {
    final marker = task.completed ? '[x]' : '[ ]';
    final painter = WallpaperCanvasUtils.text(
      '$marker ${task.title}',
      task.completed ? textColor.withValues(alpha: 0.55) : textColor,
      settings.fontSize,
      settings.fontFamily,
      FontWeight.w500,
      maxWidth: 300,
    );
    painter.paint(canvas, Offset(start.dx, y));
    y += settings.taskSpacing + settings.fontSize;
  }
}
