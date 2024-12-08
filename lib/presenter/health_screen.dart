import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b2gin/provider/pedomiter_state_notifier_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../provider/animal_state_notifier_provider.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalState = ref.watch(animalStateNotifier);

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${animalState.first.name}의 건강 상태",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFFCB997E),
                ),
                textAlign: TextAlign.start),
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "생일 : ${animalState.first.birthDate.year}년 ${animalState.first.birthDate.month}월 ${animalState.first.birthDate.day}일",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFCB997E),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                            "키 / 몸무게 : ${animalState.first.heightData.last.values.first}cm / ${animalState.first.weightData.last.values.first}kg",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFCB997E),
                            ),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // 비만도 계산
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFCB997E),
                            ),
                            child: Icon(
                              Icons.monitor_weight,
                              size: 40,
                              color: Colors.white,
                            ),
                          )),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "비만도 계산",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFCB997E),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${animalState.last.bmiData.last.values.first.toInt()}", // TODO : 비만도
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFCB997E),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "정상",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 8),
            // 안구 질환
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFCB997E),
                            ),
                            child: Icon(
                              Icons.remove_red_eye,
                              size: 40,
                              color: Colors.white,
                            ),
                          )),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "안구 질환",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFCB997E),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "각막염 : ${animalState.last.keratitis.last.values}%", // TODO : 각막염 비율
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFCB997E),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: _getConjunctivitisColor(
                                              animalState.last.keratitis.last
                                                  .values.first),
                                        ),
                                        Text(
                                          _getConjunctivitisStatus(animalState
                                              .last
                                              .keratitis
                                              .last
                                              .values
                                              .first),
                                          style: TextStyle(
                                            color: _getConjunctivitisColor(
                                                animalState.last.keratitis.last
                                                    .values.first),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "결막염 : ${animalState.last.conjunctivits.last.values}%", // TODO : 결막염 비율
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFCB997E),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: _getConjunctivitisColor(
                                              animalState.last.conjunctivits
                                                  .last.values.first),
                                        ),
                                        Text(
                                          _getConjunctivitisStatus(animalState
                                              .last
                                              .conjunctivits
                                              .last
                                              .values
                                              .first),
                                          style: TextStyle(
                                            color: _getConjunctivitisColor(
                                                animalState.last.conjunctivits
                                                    .last.values.first),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 8),
            // 플라그
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFCB997E),
                            ),
                            child: Icon(
                              Icons.health_and_safety,
                              size: 40,
                              color: Colors.white,
                            ),
                          )),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "플라그",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFCB997E),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "22%", // TODO : 플라그 비율
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFCB997E),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "정상",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "가까운 예방 접종 일정", // TODO : 예방접종
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFCB997E),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  Text(
                                    "혼합예방주사 4차",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFCB997E),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.vaccines,
                                color: Color(0xFFCB997E),
                                size: 60,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 76,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "태어난지", // TODO : 디데이
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFCB997E),
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              "${DateTime.now().difference(animalState.first.birthDate).inDays}일",
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFFCB997E),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ));
  }
}

_getConjunctivitisColor(int conjunctivits) {
  if (conjunctivits < 30) {
    return Colors.green;
  } else if (conjunctivits < 60) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

String _getConjunctivitisStatus(int conjunctivits) {
  if (conjunctivits < 30) {
    return "정상";
  } else if (conjunctivits < 60) {
    return "주의";
  } else {
    return "위험";
  }
}
