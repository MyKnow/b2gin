import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:io';
import 'package:image/image.dart' as img;

final tfliteNotifierProvider =
    StateNotifierProvider<TFLiteNotifier, String?>((ref) {
  return TFLiteNotifier();
});

class TFLiteNotifier extends StateNotifier<String?> {
  late tfl.Interpreter _interpreter;

  TFLiteNotifier() : super(null) {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await tfl.Interpreter.fromAsset('assets/models/ptaram_gak.tflite');
      var inputShape = _interpreter.getInputTensor(0).shape;
      var inputType = _interpreter.getInputTensor(0).type;
      print('Model input shape: $inputShape');
      print('Model input type: $inputType');
    } catch (e) {
      state = 'Failed to load model: $e';
    }
  }

  List<double> softmax(List<double> logits) {
    final expLogits = logits.map((e) => exp(e)).toList();
    final sumExpLogits = expLogits.reduce((a, b) => a + b);
    return expLogits.map((e) => e / sumExpLogits).toList();
  }

  Future<void> classifyImage(File image) async {
    try {
      final input = _preprocessImage(image);
      var output = List.filled(1 * 2, 0).reshape([1, 2]);

      _interpreter.run(input, output);

      print(output);

      List<double> probabilities = softmax(output.first as List<double>);

      // 예측된 클래스
      int predictedClass = probabilities.indexOf(
          probabilities.reduce((curr, next) => curr > next ? curr : next));

      print("Predicted class: $predictedClass"); // Predicted class: 1

      print("Probabilities: $probabilities");

      state = 'Prediction: $predictedClass';
    } catch (e) {
      state = 'Error during inference: $e';
    }
  }

  List<List<List<List<double>>>> _preprocessImage(File image) {
    final bytes = image.readAsBytesSync();
    final img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('Cannot decode image');
    }

    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);

    final input = List.generate(
        1,
        (b) => List.generate(
            3,
            (c) => List.generate(
                224,
                (i) => List.generate(224, (j) {
                      final pixel = resizedImage.getPixel(j, i);
                      return [
                        img.getRed(pixel) / 255.0,
                        img.getGreen(pixel) / 255.0,
                        img.getBlue(pixel) / 255.0,
                      ][c];
                    }))));

    return input;
  }
}

class TFLiteScreen extends ConsumerStatefulWidget {
  const TFLiteScreen({super.key});

  @override
  TFLiteScreenState createState() => TFLiteScreenState();
}

class TFLiteScreenState extends ConsumerState<TFLiteScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });
      await ref.read(tfliteNotifierProvider.notifier).classifyImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(tfliteNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Classification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
            const SizedBox(height: 16),
            result == null
                ? const Text('No result')
                : Text(
                    result,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}
