import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

abstract class StatusItem {
  final String statusId;

  const StatusItem({
    required this.statusId,
  });

  Widget render({
    required BuildContext context,
    required Size size,
    VideoPlayerController? controller,
  });

  Widget renderThumbnail({
    required BuildContext context,
    required Size size,
  });

  Duration duration();
}
