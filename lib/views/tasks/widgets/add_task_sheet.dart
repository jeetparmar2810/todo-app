import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../viewmodels/task_viewmodel.dart';

void showAddTaskSheet(BuildContext context, WidgetRef ref) {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final taskVM = ref.read(taskViewModelProvider);

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [


                Center(
                  child: Text(
                    AppStrings.addNewTask,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 10),


                TextField(
                  controller: titleCtrl,
                  decoration:
                  const InputDecoration(labelText: AppStrings.title),
                ),

                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: AppStrings.description,
                  ),
                ),

                const SizedBox(height: 20),

                CustomButton(
                  text: AppStrings.save,
                  onPressed: () async {
                    if (titleCtrl.text.trim().isNotEmpty) {
                      await taskVM.addTask(
                        context,
                        titleCtrl.text.trim(),
                        descCtrl.text.trim(),
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
