import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_wallpaper/core/constants/hive_box_names.dart';
import 'package:todo_wallpaper/features/tasks/presentation/screens/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    await Hive.box(HiveBoxNames.appSettings).put('onboarding_done', true);
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Icon(Icons.wallpaper, size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text('Todo Wallpaper', style: theme.textTheme.displaySmall),
              const SizedBox(height: 12),
              Text(
                'Keep today visible by turning your task list into a clean home and lock screen wallpaper.',
                style: theme.textTheme.bodyLarge,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _finish(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Get started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
