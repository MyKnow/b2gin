import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryState {
  final DateTime dateTime;
  final Image image;
  final int distance;
  final String description;

  DiaryState({
    required this.dateTime,
    required this.image,
    required this.distance,
    required this.description,
  });
}

final diaryStateNotifier =
    StateNotifierProvider<DiaryStateNotifier, List<DiaryState>>((ref) {
  return DiaryStateNotifier();
});

class DiaryStateNotifier extends StateNotifier<List<DiaryState>> {
  DiaryStateNotifier()
      : super([
          DiaryState(
            dateTime: DateTime.now().subtract(const Duration(days: 5)),
            image: Image.asset('assets/images/IMG_1426.JPG'),
            distance: 1444,
            description: '금이랑 카페탐방 갔다옴',
          ),
          DiaryState(
            dateTime: DateTime.now().subtract(const Duration(days: 4)),
            image: Image.asset('assets/images/IMG_1435.JPG'),
            distance: 2155,
            description: '금이가 사자가 되.',
          ),
          DiaryState(
            dateTime: DateTime.now().subtract(const Duration(days: 2)),
            image: Image.asset('assets/images/IMG_1430.JPG'),
            distance: 1532,
            description: '금이랑 동네산책 한바퀴',
          ),
        ]);

  void updateDiaryState({
    required DateTime dateTime,
    required Image image,
    required int distance,
    required String description,
  }) {
    final newState = DiaryState(
      dateTime: dateTime,
      image: image,
      distance: distance,
      description: description,
    );
    state = [...state, newState];
  }

  void modifyDiaryState({
    DateTime? dateTime,
    Image? image,
    int? distance,
    String? description,
  }) {
    // DateTime이 동일하면 수정
    // DateTime이 동일하지 않으면 추가
    final newState = DiaryState(
      dateTime: dateTime ?? DateTime.now(),
      image: image ?? Image.asset('assets/images/diary_default_image.png'),
      distance: distance ?? 0,
      description: description ?? '',
    );
    final index =
        state.indexWhere((element) => element.dateTime == newState.dateTime);
    if (index != -1) {
      state[index] = newState;
    } else {
      state = [...state, newState];
    }
  }

  DiaryState getDiaryState(DateTime dateTime) {
    return state.firstWhere(
      (element) {
        final elementDate = DateTime(element.dateTime.year,
            element.dateTime.month, element.dateTime.day);
        final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        return elementDate == inputDate;
      },
      orElse: () => DiaryState(
        dateTime: DateTime.now(),
        image: Image.asset('assets/images/diary_default_image.png'),
        distance: 0,
        description: '',
      ),
    );
  }
}
