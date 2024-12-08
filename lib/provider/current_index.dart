import 'package:b2gin/presenter/diary_calendar_screen.dart';
import 'package:b2gin/presenter/health_screen.dart';
import 'package:b2gin/presenter/walk_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presenter/feed_screen.dart';
import '../presenter/home_screen.dart';
import '../presenter/tflite_example_screen.dart';

enum CurrentIndex {
  walk,
  info,
  home,
  diary,
  feed,
}

extension CurrentIndexExtension on CurrentIndex {
  int get index {
    switch (this) {
      case CurrentIndex.walk:
        return 0;
      case CurrentIndex.info:
        return 1;
      case CurrentIndex.home:
        return 2;
      case CurrentIndex.diary:
        return 3;
      case CurrentIndex.feed:
        return 4;
    }
  }

  Widget get icon {
    switch (this) {
      case CurrentIndex.walk:
        return const Icon(Icons.pets); // TODO : 발바닥
      case CurrentIndex.info:
        return const Icon(Icons.favorite);
      case CurrentIndex.home:
        return const Icon(Icons.home);
      case CurrentIndex.diary:
        return const Icon(Icons.library_books);
      case CurrentIndex.feed:
        return const Icon(Icons.share);
    }
  }

  Widget get screen {
    switch (this) {
      case CurrentIndex.walk:
        return const WalkScreen();
      case CurrentIndex.info:
        return const HealthScreen();
      case CurrentIndex.home:
        return const HomeScreen();
      case CurrentIndex.diary:
        return const DiaryCalendarScreen();
      case CurrentIndex.feed:
        return const FeedScreen();
    }
  }

  CurrentIndex setIndex(int index) {
    switch (index) {
      case 0:
        return CurrentIndex.walk;
      case 1:
        return CurrentIndex.info;
      case 2:
        return CurrentIndex.home;
      case 3:
        return CurrentIndex.diary;
      case 4:
        return CurrentIndex.feed;
      default:
        return CurrentIndex.walk;
    }
  }

  String get title {
    switch (this) {
      case CurrentIndex.walk:
        return '산책';
      case CurrentIndex.feed:
        return '피드';
      case CurrentIndex.home:
        return '홈';
      case CurrentIndex.diary:
        return '다이어리';
      case CurrentIndex.info:
        return '건강';
    }
  }
}

final currentIndexProvider =
    StateNotifierProvider<CurrentIndexProvider, CurrentIndex>((ref) {
  return CurrentIndexProvider();
});

class CurrentIndexProvider extends StateNotifier<CurrentIndex> {
  CurrentIndexProvider() : super(CurrentIndex.home);

  void setIndex(int index) {
    state = state.setIndex(index);
  }
}
