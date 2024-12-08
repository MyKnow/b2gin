import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:b2gin/presenter/diary_calendar_screen.dart';
import 'package:b2gin/provider/pedomiter_state_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../provider/diary_state_notifier_provider.dart';
import '../service/https_service.dart';

final pickedProvider = StateProvider<File?>((ref) => null);
final imageProvider = StateProvider<Image?>((ref) => null);

class DiaryViewScreen extends ConsumerStatefulWidget {
  final DiaryState diaryState;

  const DiaryViewScreen({super.key, required this.diaryState});

  @override
  DiaryViewScreenState createState() => DiaryViewScreenState();
}

class DiaryViewScreenState extends ConsumerState<DiaryViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('다이어리',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFFCB997E),
              )),
          iconTheme: IconThemeData(
            color: Color(0xFFCB997E), // 뒤로가기 이모티콘 색상 설정
          )),
      backgroundColor: Color(0xFFFEE6D7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 0, 16),
                    child: Text(
                      DateFormat('yyyy년 MM월 dd일')
                          .format(widget.diaryState.dateTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFFCB997E),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Divider(
                      thickness: 2,
                      color: Color(0xFFCB997E),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                      child: Column(
                    children: [
                      Center(
                        child: GestureDetector(
                          child: Container(
                            width: 180,
                            height: 180,
                            color: Colors.white,
                            child: widget.diaryState.image,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          thickness: 2,
                          color: Color(0xFFCB997E),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          '산책한 거리',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFFCB997E),
                          ),
                        ),
                        subtitle: Text(
                          '${widget.diaryState.distance} km',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFCB997E),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          thickness: 2,
                          color: Color(0xFFCB997E),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ListTile(
                        title: const Text(
                          '설명',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFFCB997E),
                          ),
                        ),
                        subtitle: Text(
                          widget.diaryState.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFCB997E),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
