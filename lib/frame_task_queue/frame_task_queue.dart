import 'frame_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Ticker {
  final Function(Duration) onTick;
  final String debugLabel;
  bool muted = false;
  Ticker(this.onTick, {this.debugLabel});
  void start() {
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      if (muted) return;
      SchedulerBinding.instance.scheduleTask(
          () => onTick(null), defaultFrameTaskPriority,
          debugLabel: "onTick");
    });
  }
}

class FrameTaskQueue {
  static Ticker _ticker;
  static bool _consumerRunning = false;
  static int _maxTaskLength = 200;
  static int _currentLength = 0;
  static int _trailingIndex = -1;
  static int _topIndex = -1;
  static get isTaskQueueOverflow => _currentLength == _maxTaskLength;
  static List<FrameTask> _taskQueue =
      List.generate(_maxTaskLength, (index) => null);
  static int appendFrameTask(VoidCallback task, {Priority priority}) {
    if (isTaskQueueOverflow) {
      task();
      return -1;
    }
    _appendFrameTaskAndScheduleTask(FrameTask(task, priority: priority));
    return 0;
  }

  static void _appendFrameTaskAndScheduleTask(FrameTask frameTask) {
    _currentLength += 1;
    _trailingIndex = (_trailingIndex + 1) % _maxTaskLength;
    _taskQueue[_trailingIndex] = frameTask;
    _startConsumeTask();
  }

  static get topIndex {
    _topIndex = (_topIndex + 1) % _maxTaskLength;
    return _topIndex;
  }

  static void _startConsumeTask() {
    if (_consumerRunning || _currentLength == 0) return;
    _consumerRunning = true;
    if (_ticker == null) {
      print("Ticker new");
      _ticker = Ticker(onTick, debugLabel: null);
      _ticker.start();
    }
    _ticker.muted = false;
  }

  static void onTick(Duration duration) {
    if (_taskQueueIsNotEmpty()) {
      _taskQueue[topIndex].task();
      _currentLength -= 1;
    }
  }

  static bool _taskQueueIsNotEmpty() {
    if (!_consumerRunning) return false;
    if (_currentLength == 0) {
      _consumerRunning = false;
      _ticker.muted = true;
      return false;
    } else {
      return true;
    }
  }
}
