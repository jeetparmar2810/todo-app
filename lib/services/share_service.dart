import 'package:share_plus/share_plus.dart';
import '../models/task_model.dart';

class ShareService {
  static Future<void> shareTask(TaskModel task) async {
    final message = 'Task: ${task.title}\nDescription: ${task.description}';
    await Share.share(message, subject: 'Shared Task');
  }
}
