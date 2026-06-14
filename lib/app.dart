import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_wallpaper/core/constants/hive_box_names.dart';
import 'package:todo_wallpaper/core/theme/app_theme.dart';
import 'package:todo_wallpaper/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:todo_wallpaper/features/tasks/presentation/screens/home_screen.dart';
import 'package:todo_wallpaper/features/wallpaper/presentation/providers/wallpaper_auto_update_provider.dart';

class TodoWallpaperApp extends ConsumerWidget {
  const TodoWallpaperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wallpaperAutoUpdateProvider);
    final appBox = Hive.box(HiveBoxNames.appSettings);
    final onboardingDone =
        appBox.get('onboarding_done', defaultValue: false) as bool;
    return MaterialApp(
      title: 'Todo Wallpaper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: onboardingDone ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
