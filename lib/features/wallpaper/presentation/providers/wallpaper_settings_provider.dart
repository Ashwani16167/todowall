import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_wallpaper/features/wallpaper/data/models/wallpaper_settings_model.dart';
import 'package:todo_wallpaper/features/wallpaper/data/repositories/wallpaper_settings_repository_impl.dart';
import 'package:todo_wallpaper/features/wallpaper/domain/repositories/wallpaper_settings_repository.dart';
import 'package:todo_wallpaper/shared/providers/hive_provider.dart';

final wallpaperSettingsRepositoryProvider =
    Provider<WallpaperSettingsRepository>((ref) =>
        WallpaperSettingsRepositoryImpl(
            ref.watch(wallpaperSettingsBoxProvider)));

final wallpaperSettingsProvider = StreamProvider<WallpaperSettingsModel>(
    (ref) => ref.watch(wallpaperSettingsRepositoryProvider).watchSettings());

final wallpaperSettingsControllerProvider =
    Provider<WallpaperSettingsController>((ref) => WallpaperSettingsController(
        ref.watch(wallpaperSettingsRepositoryProvider)));

class WallpaperSettingsController {
  WallpaperSettingsController(this._repo);
  final WallpaperSettingsRepository _repo;
  WallpaperSettingsModel get current => _repo.getSettings();
  Future<void> update(
          WallpaperSettingsModel Function(WallpaperSettingsModel) fn) =>
      _repo.saveSettings(fn(current));
  Future<void> reset() => _repo.resetToDefaults();
}
