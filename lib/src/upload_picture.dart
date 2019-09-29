import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

Future<Uint8List> getFileData(String path) async {
  final picture = await rootBundle.load(path);
  return picture.buffer.asUint8List();
}

Future<void> analizePicture(String path) async {
  final picture = await getFileData(path);

  try {
    final response = await http.post(
      "https://ticsart.cognitiveservices.azure.com/customvision/v3.0/Prediction/f1891c1c-926b-4cfd-95ed-f9cb5c3c2e44/classify/iterations/ticsart_recognition_v1.1/image",
      headers: {
        "Prediction-Key": "3024c008e3db4072b0194d5ba202dd0e",
        "Content-Type": "application/octet-stream"
      },
      body: picture,
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    final predictions = data["predictions"] as List;
    final mainPrediction = predictions[0] as Map<String, dynamic>;
    final tag = mainPrediction["tagName"];
    print("[body] $tag");
  } catch (e) {
    print("-----------------------");
    print("There was an error");
    print(e);
    print("-----------------------");
  }
}
