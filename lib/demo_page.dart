import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status/status.dart';
import 'package:whatsapp_status/status_item.dart';
import 'package:whatsapp_status/video_status_item.dart';

import 'drag_update.dart';
import 'status_background.dart';
import 'status_bar_widget.dart';

class StatusDemo extends StatefulWidget {
  final Status status;
  const StatusDemo({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusDemo> createState() => _StatusDemoState();
}

class _StatusDemoState extends State<StatusDemo>
    with SingleTickerProviderStateMixin {
  final List<StatusItem> statusItems = [];

  /// The current item that is being viewed
  late final ValueNotifier<StatusItem> currentItem;

  /// The progress of the current item
  late final ValueNotifier<double> currentItemProgress;

  /// notify widget downstream of a drag update
  final ValueNotifier<DragUpdate> _dragUpdateNotifier =
      ValueNotifier(DragUpdate(value: null));

  /// The controller for the video media
  late VideoPlayerController _controller;

  /// The index of the last item on drag
  int lastIndexOfDragEnd = -1;

  late AnimationController animationController;
  late Animation<double> animation;

  InputBorder get _border => const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        ),
      );

  @override
  void initState() {
    super.initState();
    statusItems.addAll(widget.status.items);

    currentItem = ValueNotifier(statusItems.first)
      ..addListener(_onCurrentItemChanged);

    _initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ValueListenableBuilder<StatusItem>(
          valueListenable: currentItem,
          builder: (context, currentStatusItem, child) {
            return GestureDetector(
              onTapDown: (details) {
                final index = statusItems.indexOf(currentStatusItem);
                if (details.localPosition.dx <
                    MediaQuery.of(context).size.width / 2) {
                  if (index > 0) {
                    currentItem.value = statusItems[index - 1];
                  }
                } else {
                  if (index < statusItems.length - 1) {
                    currentItem.value = statusItems[index + 1];
                  }
                }
                _resetAnimation();
              },
              onHorizontalDragStart: (details) {
                _dragUpdateNotifier.value = DragUpdate<DragStartDetails>(
                  value: details,
                );
              },
              onHorizontalDragUpdate: (details) {
                _dragUpdateNotifier.value = DragUpdate<DragUpdateDetails>(
                  value: details,
                );

                final currentItemIndex = _dragUpdateNotifier.value
                    .getCurrentItemIndex(
                        statusItems.length, MediaQuery.of(context).size.width);

                lastIndexOfDragEnd = currentItemIndex;
              },
              onHorizontalDragEnd: (details) {
                _dragUpdateNotifier.value = DragUpdate<DragEndDetails>(
                  value: details,
                );

                if (lastIndexOfDragEnd != -1) {
                  currentItem.value = statusItems[lastIndexOfDragEnd];
                  _resetAnimation();
                }
              },
              child: Stack(
                children: [
                  StatusBackground(
                    child: currentStatusItem.render(
                      context: context,
                      size: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            kBottomNavigationBarHeight -
                            80,
                      ),
                      controller: _controller,
                    ),
                  ),
                  _buildUpperLayer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUpperLayer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          _buildHeader(),
          const Spacer(),
          _buildReplySection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // this try/catch is to catch an animation uninitialized error
    try {
      // ignore: unused_local_variable
      final val = animation.value;
    } catch (e) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusBarWidget(
            items: statusItems,
            currentItem: currentItem,
            animation: animation,
            resetAnimation: _resetAnimation,
            dragUpdateNotifier: _dragUpdateNotifier,
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: _dragUpdateNotifier,
            builder: (context, value, child) {
              if (value.isDragUpdate()) {
                return const SizedBox.shrink();
              }
              return _buildUserData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReplySection() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: _border,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                enabledBorder: _border,
                focusedBorder: _border,
                hintText: 'Send',
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(bottom: 10),
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(bottom: 10),
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.white,
              size: 35,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage(widget.status.profilePicture),
          ),
          const SizedBox(width: 10),
          Text(
            widget.status.username,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onCurrentItemChanged() async {
    if (currentItem.value is VideoStatusItem) {
      // remove all listeners
      animationController.removeStatusListener(_animationStatusListener);

      final currentItemValue = currentItem.value as VideoStatusItem;
      _controller = VideoPlayerController.asset(currentItemValue.url);

      await _controller.initialize().then((_) {
        setState(() {});
      });

      final duration = _controller.value.duration;

      animationController.duration = duration;

      animation = Tween<double>(begin: 0, end: 1).animate(animationController);
      _resetAnimation();

      _controller.play();
      return;
    }
    _controller.pause();

    animationController.duration = currentItem.value.duration();

    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _goToNextItem();
      return;
    }
  }

  void _goToNextItem() {
    final indexOfCurrentItem = widget.status.items.indexOf(currentItem.value);
    final indexOfNextItem = indexOfCurrentItem + 1;
    if (indexOfNextItem >= widget.status.items.length) {
      // go to first item
      currentItem.value = widget.status.items.first;
      return;
    }
    final nextItem = widget.status.items[indexOfNextItem];
    currentItem.value = nextItem;
    // animationController.forward(from: 0);
  }

  void _resetAnimation() {
    animationController.reset();
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initControllers() async {
    if (currentItem.value is VideoStatusItem) {
      final currentItemValue = currentItem.value as VideoStatusItem;
      _controller = VideoPlayerController.asset(currentItemValue.url);

      await _controller.initialize().then((_) {
        setState(() {});
      });

      final duration = _controller.value.duration;

      animationController = AnimationController(
        vsync: this,
        duration: duration,
      )..addStatusListener(_animationStatusListener);

      animation = Tween<double>(begin: 0, end: 1).animate(animationController);
      animationController.forward();
      _controller.play();
      return;
    }

    animationController = AnimationController(
      vsync: this,
      duration: currentItem.value.duration(),
    )..addStatusListener(_animationStatusListener);

    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();
  }
}
