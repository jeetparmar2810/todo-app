import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_jitendra/routes/app_routes.dart';

import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../services/connectivity_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskVM = ref.watch(taskViewModelProvider);

    final isOnline = ref
        .watch(connectivityProvider)
        .maybeWhen(data: (value) => value, orElse: () => true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            tooltip: AppStrings.logoutTooltip,
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),

      body: Column(
        children: [
          if (!isOnline)
            Container(
              width: double.infinity,
              color: Colors.redAccent,
              padding: const EdgeInsets.all(8),
              child: const Text(
                AppStrings.offlineMessage,
                style: TextStyle(color: Colors.white),
              ),
            ),

          Expanded(
            child: taskVM.loading
                ? const Center(child: CircularProgressIndicator())
                : taskVM.tasks.isEmpty
                ? const Center(child: Text(AppStrings.noTasks))
                : ListView.builder(
              itemCount: taskVM.tasks.length,
              itemBuilder: (context, i) {
                final task = taskVM.tasks[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(task.description),
                    trailing: PopupMenuButton<String>(
                      onSelected: (val) async {
                        if (val == AppStrings.delete) {
                          await taskVM.deleteTask(context, task.id);
                        } else if (val == AppStrings.share) {
                          _showShareDialog(context, ref, task.id);
                        } else if (val == AppStrings.completed) {
                          final updated = task.copyWith(
                            completed: !task.completed,
                          );
                          await taskVM.updateTask(context, updated);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: AppStrings.completed,
                          child: Text(AppStrings.completed),
                        ),
                        PopupMenuItem(
                          value: AppStrings.share,
                          child: Text(AppStrings.share),
                        ),
                        PopupMenuItem(
                          value: AppStrings.delete,
                          child: Text(AppStrings.delete),
                        ),
                      ],
                    ),
                    leading: Icon(
                      task.completed
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: task.completed
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        tooltip: AppStrings.fabTooltip,
        onPressed: () => _showAddTaskDialog(context, ref),
        label: const Text(AppStrings.addTask),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final taskVM = ref.read(taskViewModelProvider);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.addNewTask),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: AppStrings.title),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.description,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          CustomButton(
            text: AppStrings.save,
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty) {
                await taskVM.addTask(context, titleCtrl.text, descCtrl.text);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, WidgetRef ref, String taskId) {
    final emailCtrl = TextEditingController();
    final taskVM = ref.read(taskViewModelProvider);
    final authVM = ref.read(authViewModelProvider);
    final currentUserEmail = authVM.currentUser?.email ?? "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.shareTaskTitle),
        content: TextField(
          controller: emailCtrl,
          decoration: const InputDecoration(
            labelText: AppStrings.shareEmailHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          CustomButton(
            text: AppStrings.share,
            onPressed: () async {
              final enteredEmail = emailCtrl.text.trim();

              if (enteredEmail.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.enterEmailError)),
                );
                return;
              }
              if (enteredEmail == currentUserEmail) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.cannotShareWithSelf)),
                );
                return;
              }
              await taskVM.shareTaskWithEmail(
                context,
                taskId,
                enteredEmail,
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.logoutTooltip),
        content: const Text(AppStrings.logoutMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final authVM = ref.read(authViewModelProvider);
              await authVM.signOut();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                      (_) => false,
                );
              }
            },
            child: const Text(AppStrings.logoutTooltip),
          ),
        ],
      ),
    );
  }
}
