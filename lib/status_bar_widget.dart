import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animated_bar.dart';
import 'drag_update.dart';
import 'status_item.dart';
import 'triangular_clipper.dart';

class StatusBarWidget extends StatefulWidget {
  final List<StatusItem> items;
  final ValueNotifier<StatusItem> currentItem;
  final VoidCallback resetAnimation;
  final Animation<double> animation;
  final ValueNotifier<DragUpdate> dragUpdateNotifier;
  const StatusBarWidget({
    Key? key,
    required this.items,
    required this.currentItem,
    required this.resetAnimation,
    required this.animation,
    required this.dragUpdateNotifier,
  }) : super(key: key);

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DragUpdate>(
      valueListenable: widget.dragUpdateNotifier,
      key: widget.key,
      builder: (context, dragUpdate, child) {
        final int currentDragIndex = dragUpdate.getCurrentItemIndex(
            widget.items.length, MediaQuery.of(context).size.width);
        final double horizontalRatio =
            dragUpdate.getHorizontalRatio(MediaQuery.of(context).size.width);

        return LayoutBuilder(builder: (context, constraint) {
          final width = constraint.maxWidth;
          final itemWidth = (width * 0.9) / widget.items.length;
          const containerWidth = 50.0;
          final offset =
              _calculateOffset(currentDragIndex, horizontalRatio, 5, width);
          final offSetForBigContainer = _getContainerOffSetFromPointerOfset(
              offset, width, containerWidth);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.items.map(
                  (e) {
                    final index = widget.items.indexOf(e);
                    final indexOfCurrentItem =
                        widget.items.indexOf(widget.currentItem.value);
                    final isBeforeCurrentItem = index < indexOfCurrentItem;
                    final isCurrentItem = index == indexOfCurrentItem;
                    final isCurrentDragItem = index == currentDragIndex;
                    final gap = width * 0.1;
                    final itemWidth = (width - gap) / widget.items.length;

                    if (isCurrentItem) {
                      return SizedBox(
                        width: itemWidth,
                        child: AnimatedBar(
                          animation: widget.animation,
                        ),
                      );
                    }

                    return Container(
                      height: isCurrentDragItem ? 4 : 3,
                      width: itemWidth,
                      decoration: BoxDecoration(
                        color: isCurrentDragItem
                            ? Colors.white
                            : Colors.white
                                .withOpacity(isBeforeCurrentItem ? 1 : 0.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    );
                  },
                ).toList(),
              ),
              Visibility(
                visible: currentDragIndex != -1,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: offset,
                            ),
                            ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                height: 5,
                                width: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: offSetForBigContainer,
                            ),
                            Container(
                              height: 70,
                              width: containerWidth,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: currentDragIndex < 0
                                  ? const SizedBox.shrink()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: widget.items[currentDragIndex]
                                          .renderThumbnail(
                                        context: context,
                                        size: Size(itemWidth, 70),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  double _calculateOffset(int currentDragIndex, double horizontalRatio,
      double itemWidth, double width) {
    if (currentDragIndex == -1) {
      return 0;
    } else {
      var offset = horizontalRatio * width;
      if (offset + (itemWidth / 2) > width) {
        final diff = offset - (width - itemWidth);
        final maxOffset = width - itemWidth;
        return math.min(offset - diff, maxOffset);
      }

      return math.max(
        0,
        offset - (itemWidth / 2),
      );
    }
  }

  double _getContainerOffSetFromPointerOfset(
      double offset, double width, double containerWidth) {
    return math.max(
      0,
      math.min(
        offset - (containerWidth / 2),
        width - containerWidth,
      ),
    );
  }
}
