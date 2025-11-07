import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_jitendra/core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../viewmodels/task_viewmodel.dart';

void showDeleteConfirmSheet(BuildContext context, WidgetRef ref, String taskId) {
  final taskVM = ref.read(taskViewModelProvider);

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 55, color: Colors.redAccent),

          const SizedBox(height: 10),

          const Text(
            "Delete Task?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Are you sure you want to delete this task?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await taskVM.deleteTask(context, taskId);
                    Navigator.pop(context);
                  },
                  child: Text(AppStrings.delete,style: TextStyle(color: AppColors.secondary),),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}