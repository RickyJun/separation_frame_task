import 'package:flutter/material.dart';

import 'frame_task_queue.dart';

class FrameTaskWidget extends StatefulWidget {
  final Widget child;
  final double placeHolderWidth;
  final double placeHolderHeight;
  FrameTaskWidget(this.child,
      {Key key,
      @required this.placeHolderWidth,
      @required this.placeHolderHeight})
      : super(key: key);

  @override
  _FrameTaskWidgetState createState() => _FrameTaskWidgetState();
}

class _FrameTaskWidgetState extends State<FrameTaskWidget> {
  Widget _child;
  @override
  void initState() {
    super.initState();

    // _child = widget.child;
    //return;
    _child = Container(
      color: Colors.transparent,
      width: widget.placeHolderWidth,
      height: widget.placeHolderHeight,
    );
    FrameTaskQueue.appendFrameTask(() {
      if (mounted) {
        setState(() {
          _child = widget.child;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
