import 'package:flutter/painting.dart';

class WallpaperCanvasUtils {
  WallpaperCanvasUtils._();

  static const double baseWidth = 360;
  static const double baseHeight = 780;
  static const double scale = 3;
  static const double outputWidth = baseWidth * scale;
  static const double outputHeight = baseHeight * scale;

  static TextPainter text(
    String content,
    Color color,
    double fontSize,
    String fontFamily,
    FontWeight weight, {
    TextAlign align = TextAlign.left,
    double? maxWidth,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: content,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: weight,
        ),
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
      ellipsis: maxWidth != null ? '...' : null,
      maxLines: 1,
    );
    painter.layout(maxWidth: maxWidth ?? double.infinity);
    return painter;
  }
}
