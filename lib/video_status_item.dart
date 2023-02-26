import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_status/status_item.dart';

class VideoStatusItem extends StatusItem {
  final String url;

  VideoStatusItem({
    required super.statusId,
    required this.url,
  });

  File? _tempVideo;
  File? _thumbnail;

  @override
  Duration duration() {
    return const Duration(seconds: 30);
  }

  @override
  Widget render(
      {required BuildContext context,
      required Size size,
      VideoPlayerController? controller}) {
    if (controller == null) {
      throw Exception('VideoPlayerController is null');
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: size.height,
          child: VideoPlayer(controller),
        ),
        Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: VideoPlayer(controller),
          ),
        ),
      ],
    );
  }

  @override
  Widget renderThumbnail({required BuildContext context, required Size size}) {
    return FutureBuilder(
      future: _getThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data as File,
            fit: BoxFit.fill,
            height: size.height,
          );
        }

        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return const Center(
            child: Text("Error"),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<File> _getTempVideo() async {
    if (_tempVideo != null && await _tempVideo!.exists()) {
      return _tempVideo!;
    }

    final byteData = await rootBundle.load(url);
    Directory tempDir = await getTemporaryDirectory();

    _tempVideo = File("${tempDir.path}/$url")
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return _tempVideo!;
  }

  Future<File?> _getThumbnail() async {
    if (_thumbnail != null && await _thumbnail!.exists()) {
      return _thumbnail;
    }

    final video = await _getTempVideo();

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: video.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );

    _thumbnail = File(thumbnailPath ?? "");

    return _thumbnail;
  }
}
