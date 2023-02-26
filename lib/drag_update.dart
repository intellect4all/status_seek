import 'package:flutter/material.dart';

class DragUpdate<T> {
  final T value;

  DragUpdate({
    required this.value,
  });

  bool isDragStart() => value is DragStartDetails;
  bool isDragUpdate() => value is DragUpdateDetails;
  bool isDragEnd() => value is DragEndDetails;

  int getCurrentItemIndex(int length, double width) {
    if (isDragUpdate()) {
      final dragUpdateDetails = value as DragUpdateDetails;
      final globalPosition = dragUpdateDetails.globalPosition.dx;
      final horizontalDragRatio = globalPosition / width;
      final currentItemIndex = horizontalDragRatio * length;
      return currentItemIndex.toInt();
    }

    return -1;
  }

  double getHorizontalRatio(double width) {
    if (isDragUpdate()) {
      final dragUpdateDetails = value as DragUpdateDetails;
      final globalPosition = dragUpdateDetails.globalPosition.dx;
      final horizontalDragRatio = globalPosition / width;
      return horizontalDragRatio;
    }

    return -1;
  }
}
