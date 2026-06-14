import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';

abstract class WallpaperSettingsRepository {
  WallpaperSettingsModel getSettings();
  Stream<WallpaperSettingsModel> watchSettings();
  Future<void> saveSettings(WallpaperSettingsModel settings);
  Future<void> resetToDefaults();
}
