import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimalState {
  final String name;
  final DateTime birthDate;
  final List<Map<DateTime, double>> bmiData;
  final List<Map<DateTime, double>> weightData;
  final List<Map<DateTime, double>> heightData;
  final List<Map<DateTime, int>> keratitis;
  final List<Map<DateTime, int>> conjunctivits;
  final List<String> imagePaths;

  AnimalState({
    required this.name,
    required this.birthDate,
    required this.bmiData,
    required this.weightData,
    required this.heightData,
    required this.keratitis,
    required this.conjunctivits,
    this.imagePaths = const [],
  });
}

final animalStateNotifier =
    StateNotifierProvider<AnimalStateNotifier, List<AnimalState>>((ref) {
  return AnimalStateNotifier();
});

class AnimalStateNotifier extends StateNotifier<List<AnimalState>> {
  AnimalStateNotifier()
      : super([
          AnimalState(
            name: "금이",
            birthDate: DateTime(2017, 8, 24),
            bmiData: [
              {
                DateTime.now().subtract(Duration(days: 28)):
                    calculateBMI(13.4, 42.4),
                DateTime.now().subtract(Duration(days: 21)):
                    calculateBMI(13.6, 42.3),
                DateTime.now().subtract(Duration(days: 14)):
                    calculateBMI(13.0, 42.5),
                DateTime.now().subtract(Duration(days: 7)):
                    calculateBMI(13.2, 42.4),
                DateTime.now(): calculateBMI(13.0, 42.3),
              },
            ],
            weightData: [
              {DateTime.now().subtract(Duration(days: 28)): 13.4},
              {DateTime.now().subtract(Duration(days: 21)): 13.6},
              {DateTime.now().subtract(Duration(days: 14)): 13.0},
              {DateTime.now().subtract(Duration(days: 7)): 13.2},
              {DateTime.now(): 13.0},
            ],
            heightData: [
              {DateTime.now().subtract(Duration(days: 28)): 42.4},
              {DateTime.now().subtract(Duration(days: 21)): 42.3},
              {DateTime.now().subtract(Duration(days: 14)): 42.5},
              {DateTime.now().subtract(Duration(days: 7)): 42.4},
              {DateTime.now(): 42.3},
            ],
            keratitis: [
              {DateTime.now().subtract(Duration(days: 28)): 23},
            ],
            conjunctivits: [
              {DateTime.now().subtract(Duration(days: 28)): 52},
            ],
            imagePaths: [
              "assets/images/FullSizeRender 2.HEIC",
              "assets/images/FullSizeRender 3.HEIC",
              "assets/images/FullSizeRender.HEIC",
              "assets/images/IMG_0658.HEIC",
              "assets/images/IMG_0998.HEIC",
              "assets/images/IMG_1090.HEIC",
              // "assets/images/IMG_1425.JPG",
              "assets/images/IMG_1426.JPG",
              "assets/images/IMG_1430.JPG",
              "assets/images/IMG_1435.JPG",
              "assets/images/IMG_1436.JPG",
              "assets/images/IMG_7279.HEIC",
              "assets/images/IMG_7420.HEIC",
              "assets/images/IMG_8406.HEIC",
              "assets/images/IMG_8424.HEIC",
              "assets/images/IMG_8628.HEIC",
              "assets/images/IMG_9115.HEIC",
              "assets/images/IMG_9123.HEIC",
              "assets/images/IMG_9222.HEIC",
              "assets/images/IMG_9226.HEIC",
            ],
          ),
        ]);

  // 동물을 추가하는 메서드
  void addAnimalState({
    required String name,
    required DateTime birthDate,
    required Map<DateTime, double> bmiData,
    required Map<DateTime, double> weightData,
    required Map<DateTime, double> heightData,
    required Map<DateTime, int>? keratitis,
    required Map<DateTime, int>? conjunctivits,
  }) {
    final newState = AnimalState(
      name: name,
      birthDate: birthDate,
      bmiData: [bmiData],
      weightData: [weightData],
      heightData: [heightData],
      keratitis: [],
      conjunctivits: [],
    );
    state = [...state, newState];
  }

  // 이름이 동일한 동물의 정보를 수정하는 메서드
  void modifyAnimalState({
    required String name,
    DateTime? birthDate,
    Map<DateTime, double>? bmiData,
    Map<DateTime, double>? weightData,
    Map<DateTime, double>? heightData,
    Map<DateTime, int>? keratitis,
    Map<DateTime, int>? conjunctivits,
  }) {
    // 이름이 동일한 동물이 없으면 그냥 종료
    if (state.where((element) => element.name == name).isEmpty) {
      return;
    }
    // 이름이 동일한 동물의 정보를 수정하고, 추가하지 않은 정보는 기존 정보를 그대로 사용
    else {
      final prevData = state.firstWhere((element) => element.name == name);
      final newState = AnimalState(
        name: name,
        birthDate: birthDate ?? prevData.birthDate,
        bmiData:
            bmiData != null ? [...prevData.bmiData, bmiData] : prevData.bmiData,
        weightData: weightData != null
            ? [...prevData.weightData, weightData]
            : prevData.weightData,
        heightData: heightData != null
            ? [...prevData.heightData, heightData]
            : prevData.heightData,
        keratitis: keratitis != null
            ? [...prevData.keratitis, keratitis]
            : prevData.keratitis,
        conjunctivits: conjunctivits != null
            ? [...prevData.conjunctivits, conjunctivits]
            : prevData.conjunctivits,
      );
      state[state.indexWhere((element) => element.name == name)] = newState;
    }
  }

  static double calculateBMI(double weight, double height) {
    // 강아지용 BMI 계산기
    return weight / (height * height) * 10000;
  }
}
