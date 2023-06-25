import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

var yt = YoutubeExplode();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Sync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Music Sync'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Youtube Link',
            ),
            onSubmitted: (String value) async {
              StreamManifest streamManifest =
                  await yt.videos.streamsClient.getManifest("UrUJyKsLQeU");
              AudioOnlyStreamInfo streamInfo =
                  streamManifest.audioOnly.withHighestBitrate();
              String audioQuality = streamInfo.qualityLabel;
              double audioBitrateKbps = streamInfo.bitrate.kiloBitsPerSecond;
              String audioCodec = streamInfo.audioCodec;
              String audioMIMEType = streamInfo.codec.type;
              String audioMIMESubType = streamInfo.codec.subtype;
              double audioSize = streamInfo.size.totalMegaBytes;
              int audioId = streamInfo.tag;
              String streamUrl = streamInfo.url.toString();
              if (streamInfo != null) {
                var stream = yt.videos.streamsClient.get(streamInfo);

                var file = File("$audioId.$audioMIMESubType");
                var fileStream = file.openWrite();

                await stream.pipe(fileStream);

                await fileStream.flush();
                await fileStream.close();
              }
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Checking...'),
                    content: Text(
                        'Your youtube Audio meta, $audioQuality, $audioBitrateKbps, $audioCodec, $audioMIMEType, $audioMIMESubType, size - $audioSize, tag - $audioId, url - $streamUrl'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
