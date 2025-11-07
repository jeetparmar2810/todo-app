import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/task_viewmodel.dart';

void showShareTaskSheet(BuildContext context, WidgetRef ref, String taskId) {
  final emailCtrl = TextEditingController();

  final taskVM = ref.read(taskViewModelProvider);
  final authVM = ref.read(authViewModelProvider);

  final currentUserEmail = authVM.currentUser?.email ?? "";

  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (_) => AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Text(
                AppStrings.shareTaskTitle,
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
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.shareEmailHint,
              ),
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: AppStrings.share,
              onPressed: () async {
                final email = emailCtrl.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.enterEmailError),
                    ),
                  );
                  return;
                }

                if (email == currentUserEmail) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.cannotShareWithSelf),
                    ),
                  );
                  return;
                }

                await taskVM.shareTaskWithEmail(context, taskId, email);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}