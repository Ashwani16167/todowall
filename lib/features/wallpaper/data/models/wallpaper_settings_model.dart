import 'package:hive/hive.dart';
import 'package:todo_wallpaper/features/wallpaper/domain/entities/wallpaper_alignment.dart';
import 'package:todo_wallpaper/features/wallpaper/domain/entities/wallpaper_template.dart';
part 'wallpaper_settings_model.g.dart';

@HiveType(typeId: 1)
class WallpaperSettingsModel extends HiveObject {
  WallpaperSettingsModel({
    this.templateIndex = 0,
    this.fontSize = 16,
    this.fontFamily = 'Inter',
    this.backgroundColorValue = 0xFFF4F4F5,
    this.textColorValue = 0xFF18181B,
    this.backgroundImagePath,
    this.taskSpacing = 16,
    this.alignmentIndex = 0,
    this.showCompletedTasks = true,
    this.showDate = true,
    this.showProgress = true,
    this.maxTasksShown = 8,
  });

  @HiveField(0)
  int templateIndex;
  @HiveField(1)
  double fontSize;
  @HiveField(2)
  String fontFamily;
  @HiveField(3)
  int backgroundColorValue;
  @HiveField(4)
  int textColorValue;
  @HiveField(5)
  String? backgroundImagePath;
  @HiveField(6)
  double taskSpacing;
  @HiveField(7)
  int alignmentIndex;
  @HiveField(8)
  bool showCompletedTasks;
  @HiveField(9)
  bool showDate;
  @HiveField(10)
  bool showProgress;
  @HiveField(11)
  int maxTasksShown;

  WallpaperTemplate get template => WallpaperTemplate.values[templateIndex];
  set template(WallpaperTemplate v) => templateIndex = v.index;
  WallpaperAlignment get alignment => WallpaperAlignment.values[alignmentIndex];
  set alignment(WallpaperAlignment v) => alignmentIndex = v.index;

  WallpaperSettingsModel copyWith({
    WallpaperTemplate? template,
    double? fontSize,
    String? fontFamily,
    int? backgroundColorValue,
    int? textColorValue,
    String? backgroundImagePath,
    bool clearBackgroundImage = false,
    double? taskSpacing,
    WallpaperAlignment? alignment,
    bool? showCompletedTasks,
    bool? showDate,
    bool? showProgress,
    int? maxTasksShown,
  }) =>
      WallpaperSettingsModel(
        templateIndex: template?.index ?? templateIndex,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
        textColorValue: textColorValue ?? this.textColorValue,
        backgroundImagePath: clearBackgroundImage
            ? null
            : (backgroundImagePath ?? this.backgroundImagePath),
        taskSpacing: taskSpacing ?? this.taskSpacing,
        alignmentIndex: alignment?.index ?? alignmentIndex,
        showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
        showDate: showDate ?? this.showDate,
        showProgress: showProgress ?? this.showProgress,
        maxTasksShown: maxTasksShown ?? this.maxTasksShown,
      );
}
