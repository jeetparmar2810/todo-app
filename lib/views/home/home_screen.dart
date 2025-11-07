import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_jitendra/core/widgets/no_data.dart';

import '../../routes/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';

import '../auth/widgets/logout_sheet.dart';
import '../tasks/widgets/add_task_sheet.dart';
import '../tasks/widgets/task_actions_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showLogoutSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: LogoutSheet(
          onConfirm: () async {
            Navigator.pop(context);

            await ref.read(authViewModelProvider).signOut();

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (_) => false,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskVM = ref.watch(taskViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logoutTooltip,
            onPressed: () => _showLogoutSheet(context, ref),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: taskVM.loading
                ? const Center(child: CircularProgressIndicator())
                : taskVM.tasks.isEmpty
                ? const Center(
              child: NoDataWidget(
                icon: Icons.task,
                message: AppStrings.noTasks,
              ),
            )
                : ListView.builder(
              itemCount: taskVM.tasks.length,
              itemBuilder: (context, i) {
                final task = taskVM.tasks[i];
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(
                        task.completed
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: task.completed
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: Text(
                        task.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(task.description),
                      onTap: () =>
                          showTaskActionsSheet(context, ref, task),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddTaskSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addTask),
      ),
    );
  }
}