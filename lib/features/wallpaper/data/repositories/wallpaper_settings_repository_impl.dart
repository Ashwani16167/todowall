import 'package:hive/hive.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/domain/repositories/wallpaper_settings_repository.dart';

class WallpaperSettingsRepositoryImpl implements WallpaperSettingsRepository {
  WallpaperSettingsRepositoryImpl(this._box);
  static const _key = 'wallpaper_settings';
  final Box<WallpaperSettingsModel> _box;

  @override WallpaperSettingsModel getSettings() => _box.get(_key) ?? WallpaperSettingsModel();

  @override Stream<WallpaperSettingsModel> watchSettings() async* {
    yield getSettings();
    yield* _box.watch(key: _key).map((_) => getSettings());
  }

  @override Future<void> saveSettings(WallpaperSettingsModel s) => _box.put(_key, s);
  @override Future<void> resetToDefaults() => _box.put(_key, WallpaperSettingsModel());
}
