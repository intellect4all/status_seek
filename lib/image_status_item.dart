import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status/status_item.dart';

class ImageStatusItem extends StatusItem {
  final String url;

  const ImageStatusItem({
    required this.url,
    required super.statusId,
  });

  @override
  Widget render(
      {required BuildContext context,
      required Size size,
      VideoPlayerController? controller}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          url,
          fit: BoxFit.cover,
          height: size.height,
          // colorBlendMode: BlendMode.darken,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Image.asset(
            url,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }

  @override
  Widget renderThumbnail({required BuildContext context, required Size size}) {
    return Image.asset(
      url,
      fit: BoxFit.fill,
      height: size.height,
    );
  }

  @override
  Duration duration() {
    return const Duration(seconds: 3);
  }
}
