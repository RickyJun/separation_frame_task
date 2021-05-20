import 'package:flutter/scheduler.dart';

final Priority defaultFrameTaskPriority = Priority.animation + 1;

class FrameTask {
  final Priority priority;
  final VoidCallback task;
  FrameTask(this.task, {this.priority});
}
