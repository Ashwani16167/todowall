import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/domain/entities/wallpaper_template.dart';
import 'package:todo_wallpaper/features/wallpaper/services/canvas_text_utils.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/amoled_template.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/glass_template.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/minimal_template.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/modern_template.dart';
import 'package:todo_wallpaper/features/wallpaper/services/templates/wallpaper_template_painter.dart';

class WallpaperRendererService {
  Future<Uint8List> render(List<TaskModel> tasks, WallpaperSettingsModel settings) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const ui.Rect.fromLTWH(0, 0, WallpaperCanvasUtils.outputWidth, WallpaperCanvasUtils.outputHeight));
    canvas.scale(WallpaperCanvasUtils.scale);
    _resolvePainter(settings.template).paint(canvas, tasks, settings);
    final picture = recorder.endRecording();
    final image = await picture.toImage(WallpaperCanvasUtils.outputWidth.round(), WallpaperCanvasUtils.outputHeight.round());
    try {
      final bd = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bd == null) throw StateError('PNG encode failed');
      return bd.buffer.asUint8List();
    } finally { image.dispose(); picture.dispose(); }
  }

  WallpaperTemplatePainter _resolvePainter(WallpaperTemplate t) {
    switch (t) {
      case WallpaperTemplate.minimal: return MinimalTemplate();
      case WallpaperTemplate.modern: return ModernTemplate();
      case WallpaperTemplate.amoled: return AmoledTemplate();
      case WallpaperTemplate.glass: return GlassTemplate();
    }
  }
}
