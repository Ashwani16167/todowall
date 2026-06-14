import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_wallpaper/features/tasks/data/models/task_model.dart';
import 'package:todo_wallpaper/features/tasks/domain/entities/task_priority.dart';
import 'package:todo_wallpaper/features/tasks/presentation/providers/task_provider.dart';
import 'package:todo_wallpaper/features/wallpaper/domain/entities/wallpaper_template.dart';
import 'package:todo_wallpaper/features/wallpaper/presentation/providers/wallpaper_settings_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _taskController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final title = _taskController.text.trim();
    if (title.isEmpty) {
      return;
    }
    await ref
        .read(taskListControllerProvider)
        .addTask(title: title, priority: _priority);
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final stats = ref.watch(taskStatsProvider);
    final settings = ref.watch(wallpaperSettingsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Wallpaper'),
        actions: [
          IconButton(
            tooltip: 'Clear completed',
            onPressed: () async {
              final current =
                  ref.read(taskListProvider).value ?? const <TaskModel>[];
              await ref.read(taskListControllerProvider).replaceAll(
                    current.where((task) => !task.completed).toList(),
                  );
            },
            icon: const Icon(Icons.cleaning_services_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('${stats.remaining} remaining',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            LinearProgressIndicator(
                value: stats.total == 0 ? 0 : stats.completed / stats.total),
            const SizedBox(height: 16),
            _AddTaskBar(
              controller: _taskController,
              priority: _priority,
              onPriorityChanged: (value) => setState(() => _priority = value),
              onSubmitted: _addTask,
            ),
            const SizedBox(height: 16),
            if (settings != null) _TemplatePicker(template: settings.template),
            const SizedBox(height: 16),
            tasks.when(
              data: (items) => items.isEmpty
                  ? const _EmptyTasks()
                  : Column(
                      children:
                          items.map((task) => _TaskTile(task: task)).toList()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Could not load tasks: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTaskBar extends StatelessWidget {
  const _AddTaskBar({
    required this.controller,
    required this.priority,
    required this.onPriorityChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final TaskPriority priority;
  final ValueChanged<TaskPriority> onPriorityChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmitted(),
            decoration: const InputDecoration(labelText: 'New task'),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<TaskPriority>(
          value: priority,
          onChanged: (value) {
            if (value != null) {
              onPriorityChanged(value);
            }
          },
          items: TaskPriority.values
              .map((value) =>
                  DropdownMenuItem(value: value, child: Text(value.name)))
              .toList(),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          tooltip: 'Add task',
          onPressed: onSubmitted,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _TemplatePicker extends ConsumerWidget {
  const _TemplatePicker({required this.template});

  final WallpaperTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<WallpaperTemplate>(
      showSelectedIcon: false,
      segments: WallpaperTemplate.values
          .map((value) => ButtonSegment(value: value, label: Text(value.label)))
          .toList(),
      selected: {template},
      onSelectionChanged: (selected) {
        ref.read(wallpaperSettingsControllerProvider).update(
              (settings) => settings.copyWith(template: selected.single),
            );
      },
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CheckboxListTile(
      value: task.completed,
      onChanged: (_) =>
          ref.read(taskListControllerProvider).toggleComplete(task.id),
      title: Text(
        task.title,
        style: task.completed
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text(task.priority.name),
      secondary: IconButton(
        tooltip: 'Delete task',
        onPressed: () =>
            ref.read(taskListControllerProvider).deleteTask(task.id),
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(child: Text('No tasks yet')),
    );
  }
}
