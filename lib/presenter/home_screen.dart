import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/animal_state_notifier_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalState = ref.watch(animalStateNotifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${animalState.first.name}의 성장 일기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFFCB997E),
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFFCB997E)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Divider(
                      thickness: 2,
                      color: Color(0xFFCB997E),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        Text(
                          "생일 : ${animalState.first.birthDate.year}년 ${animalState.first.birthDate.month}월 ${animalState.first.birthDate.day}일",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFCB997E),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Text(
                      "키 / 몸무게 : ${animalState.first.heightData.last.values.first}cm / ${animalState.first.weightData.last.values.first}kg",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFCB997E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
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
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '반려 동물 추가',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: animalState.first.imagePaths.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Image.asset(
                      animalState.first.imagePaths[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
