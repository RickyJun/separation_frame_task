import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:separation_frame_task/separation_frame_task.dart';

void main() {
  test('adds one to input values', () {
    Widget image = Image.network(
      "something url",
      width: 100,
      height: 100,
    );
    //just wrap the widget that need to render on next frame
    image =
        FrameTaskWidget(image, placeHolderWidth: 100, placeHolderHeight: 100);
  });
}
