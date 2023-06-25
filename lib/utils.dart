import 'dart:io';

import 'package:id3_codec/id3_codec.dart';

Future<File> updateAudioID3MetaData(
    String filePath, MetadataV1Body metadata) async {
  var file = File(filePath);
  var bytes = await file.readAsBytes();

  final encoder = ID3Encoder(bytes);
  // ignore: prefer_const_constructors
  final resultBytes = encoder.encodeSync(metadata);

  var updatedFile = await file.writeAsBytes(resultBytes);
  return updatedFile;
}

Future<List<ID3MetataInfo>> getAudioID3MetaData(String filePath) async {
  var file = File(filePath);
  var bytes = await file.readAsBytes();

  final decoder = ID3Decoder(bytes);
  var meta = await decoder.decodeAsync();
  return meta;
}
