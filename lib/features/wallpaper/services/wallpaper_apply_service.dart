import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_wallpaper/core/constants/method_channel_constants.dart';

class WallpaperApplyService {
  static const _channel =
      MethodChannel(MethodChannelConstants.wallpaperChannel);

  Future<String> saveWallpaperToFile(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/wallpaper.png');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<bool> applyToHomeScreen(String path) async =>
      await _channel.invokeMethod<bool>(
        MethodChannelConstants.setHomeScreenWallpaper,
        {'path': path},
      ) ??
      false;

  Future<bool> applyToLockScreen(String path) async =>
      await _channel.invokeMethod<bool>(
        MethodChannelConstants.setLockScreenWallpaper,
        {'path': path},
      ) ??
      false;

  Future<bool> applyToBoth(String path) async =>
      await _channel.invokeMethod<bool>(
        MethodChannelConstants.setBothWallpapers,
        {'path': path},
      ) ??
      false;

  Future<bool> checkPermission() async =>
      await _channel.invokeMethod<bool>(
          MethodChannelConstants.checkWallpaperPermission) ??
      true;
}
