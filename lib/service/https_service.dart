import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class HttpsService {
  static const String _defaultUrl = 'http://13.124.39.132:5000/predict/';

  static Uri getUri(String url) {
    return Uri.parse(_defaultUrl + url);
  }

  static Future<List<double>> postRequest(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    print(base64Image);
    final url = getUri('model2');
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, // this header is essential to send json data
      body: jsonEncode([
        {'file': '$base64Image'}
      ]),
    );
    print(response.body);
    return jsonDecode(response.body);
  }

  static Future<List<double>> postImageModel1(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    final url = getUri('model1');
    var request = http.MultipartRequest('POST', url);
    request.files.add(
      http.MultipartFile(
        'file',
        http.ByteStream.fromBytes(imageBytes),
        imageBytes.length,
        filename: 'file',
      ),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      // HTTP가 정상적으로 요청되었을 때
      print('요청이 성공하였습니다.');
      final respond = await response.stream.bytesToString();
      print("respond: ${respond}");
      return jsonDecode(respond)['output'][0].cast<double>();
    } else {
      '요청이 실패하였습니다. HTTP 상태 코드: ${response.statusCode}';
      return [];
    }
  }

  static Future<List<double>> postImageModel2(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    final url = getUri('model2');
    var request = http.MultipartRequest('POST', url);
    request.files.add(
      http.MultipartFile(
        'file',
        http.ByteStream.fromBytes(imageBytes),
        imageBytes.length,
        filename: 'file',
      ),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      // HTTP가 정상적으로 요청되었을 때
      print('요청이 성공하였습니다.');
      final respond = await response.stream.bytesToString();
      print("respond: ${respond}");
      return jsonDecode(respond)['output'][0].cast<double>();
    } else {
      '요청이 실패하였습니다. HTTP 상태 코드: ${response.statusCode}';
      return [];
    }
  }

  static Future<http.Response> getRequest(String url) async {
    print('get url: ${getUri(url)}');
    final response = await http.get(
      getUri(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}
