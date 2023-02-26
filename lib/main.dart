import 'package:flutter/material.dart';
import 'package:whatsapp_status/assets.dart';
import 'package:whatsapp_status/image_status_item.dart';
import 'package:whatsapp_status/status.dart';
import 'package:whatsapp_status/video_status_item.dart';

import 'demo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seeking Status Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final status = _getStatus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatusDemo(
                  status: status,
                ),
              ),
            );
          },
          child: const Text('Open Status Demo'),
        ),
      ),
    );
  }

  Status _getStatus() {
    return Status(
      username: "intellect",
      profilePicture: AppAssets.firstImage,
      items: [
        VideoStatusItem(
          statusId: "32",
          url: AppAssets.video1,
        ),
        VideoStatusItem(
          statusId: "54",
          url: AppAssets.video2,
        ),
        const ImageStatusItem(
          url: AppAssets.secondImage,
          statusId: "1",
        ),
        const ImageStatusItem(
          url: AppAssets.thirdImage,
          statusId: "2",
        ),
        const ImageStatusItem(
          url: AppAssets.fourthImage,
          statusId: "3",
        ),
        const ImageStatusItem(
          url: AppAssets.secondImage,
          statusId: "4",
        ),
        const ImageStatusItem(
          url: AppAssets.thirdImage,
          statusId: "5",
        ),
        const ImageStatusItem(
          url: AppAssets.fourthImage,
          statusId: "6",
        ),
        VideoStatusItem(
          statusId: "7",
          url: AppAssets.video2,
        ),
        const ImageStatusItem(
          url: AppAssets.thirdImage,
          statusId: "9",
        ),
        const ImageStatusItem(
          url: AppAssets.fourthImage,
          statusId: "9",
        ),
        const ImageStatusItem(
          url: AppAssets.secondImage,
          statusId: "10",
        ),
        VideoStatusItem(
          statusId: "11",
          url: AppAssets.video1,
        ),
        const ImageStatusItem(
          url: AppAssets.fourthImage,
          statusId: "12",
        ),
      ],
    );
  }
}
