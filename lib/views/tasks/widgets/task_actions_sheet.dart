import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../viewmodels/task_viewmodel.dart';
import 'delete_confirm_sheet.dart';
import 'edit_task_sheet.dart';
import 'share_task_sheet.dart';

void showTaskActionsSheet(BuildContext context, WidgetRef ref, dynamic task) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                AppStrings.taskActionsTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 10),

            _actionTile(
              icon: Icons.check_circle,
              label: task.completed
                  ? AppStrings.markIncomplete
                  : AppStrings.markComplete,
              onTap: () {
                Navigator.pop(context);
                ref.read(taskViewModelProvider).toggleComplete(
                  context,
                  task.id,
                  !task.completed,
                );
              },
            ),

            _actionTile(
              icon: Icons.edit,
              label: AppStrings.editTask,
              onTap: () {
                Navigator.pop(context);
                showEditTaskSheet(context, ref, task);
              },
            ),

            _actionTile(
              icon: Icons.share,
              label: AppStrings.share,
              onTap: () {
                Navigator.pop(context);
                showShareTaskSheet(context, ref, task.id);
              },
            ),


            _actionTile(
              icon: Icons.delete,
              label: AppStrings.delete,
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                showDeleteConfirmSheet(context, ref, task.id);
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}


Widget _actionTile({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color iconColor = Colors.black87,
  Color textColor = Colors.black87,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 4),
    leading: Icon(icon, color: iconColor, size: 24),
    title: Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: onTap,
  );
}
