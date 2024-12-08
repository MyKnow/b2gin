import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:b2gin/presenter/diary_calendar_screen.dart';
import 'package:b2gin/presenter/health_screen.dart';
import 'package:b2gin/provider/animal_state_notifier_provider.dart';
import 'package:b2gin/provider/current_index.dart';
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

class DiaryNewScreen extends ConsumerStatefulWidget {
  final DateTime dateTime;

  const DiaryNewScreen({super.key, required this.dateTime});

  @override
  DiaryNewScreenState createState() => DiaryNewScreenState();
}

class DiaryNewScreenState extends ConsumerState<DiaryNewScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final steps = int.parse(ref.watch(pedometerProvider).steps);
    final distance = (steps * 0.0007).toInt();
    Image? image = ref.watch(imageProvider);
    File? pickedFile = ref.watch(pickedProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text('다이어리 추가하기',
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
                      DateFormat('yyyy년 MM월 dd일').format(widget.dateTime),
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
                            child: (image != null)
                                ? Image(image: image.image, fit: BoxFit.cover)
                                : SvgPicture.asset(
                                    'assets/images/logo.svg',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          onTap: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile == null) return;
                            final imageFile = File(pickedFile.path);
                            ref.read(pickedProvider.notifier).state = imageFile;
                            ref.read(imageProvider.notifier).state =
                                Image.file(imageFile);
                          },
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
                          '$distance km',
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
                        subtitle: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: '설명을 입력해주세요',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFCB997E),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Update description
                            });
                          },
                        ),
                      ),
                    ],
                  )),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (image == null) {
                          return;
                        }
                        ref.read(diaryStateNotifier.notifier).updateDiaryState(
                            dateTime: DateTime.now(),
                            image: image,
                            distance: distance,
                            description: _descriptionController.text);
                        final value = await HttpsService.postImageModel1(
                          ref.read(pickedProvider.notifier).state!.path,
                        );
                        final value2 = await HttpsService.postImageModel2(
                          ref.read(pickedProvider.notifier).state!.path,
                        );
                        print("각막염: ${value}");
                        // value의 값 중, first보다 last가 더 크면 각막염
                        final model1Rank = value[1] * 100;

                        print("결막염: ${value2}");
                        // value2의 값 중, first보다 last가 더 크면 결막염
                        final model2Rank = value2[1] * 100;

                        ref
                            .read(animalStateNotifier.notifier)
                            .modifyAnimalState(
                          name: '금이',
                          keratitis: {DateTime.now(): model1Rank.toInt()},
                          conjunctivits: {DateTime.now(): model2Rank.toInt()},
                        );

                        Navigator.pop(context);
                        ref.read(currentIndexProvider.notifier).state =
                            CurrentIndex.info;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCB997E), // 버튼 색상 주황색으로 설정
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // 모서리 둥글게 설정
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '등록하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
