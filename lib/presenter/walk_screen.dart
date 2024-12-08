import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b2gin/provider/pedomiter_state_notifier_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:lottie/lottie.dart';

final alreadyGetRewardProvider = StateProvider<bool>((ref) => false);

class WalkScreen extends ConsumerWidget {
  const WalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedometerState = ref.watch(pedometerProvider);
    final alreadyGetReward = ref.watch(alreadyGetRewardProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 날짜 및 구분선
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTime.now().toString().substring(0, 10),
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFFCB997E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(
                      thickness: 2,
                      color: Color(0xFFCB997E),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 퍼센테이지 원
              CircularPercentIndicator(
                radius: 100.0, // TODO
                lineWidth: 25.0, // TODO
                animation: true,
                percent: PedometerNotifier.getPercent(pedometerState), // TODO
                center: Text(
                  PedometerNotifier.getPercentString(pedometerState),
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFCB997E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Color(0xFFFEE6D7),
                progressColor: Color(0xFFCB997E),
              ),
              Spacer(),
              Text(
                '오늘 총 걸은 거리 : ${PedometerNotifier.getDistance(pedometerState)}',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFCB997E),
                  fontWeight: FontWeight.bold,
                ), // TODO
              ),
              SizedBox(height: 8),
              Text(
                '총 걸음 수 : ${pedometerState.steps}',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFCB997E),
                  fontWeight: FontWeight.bold,
                ), // TODO
              ),
              Divider(
                height: 30,
                thickness: 0,
                color: Colors.white,
              ),
              Spacer(),
              // 버튼
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(alreadyGetRewardProvider.notifier).state = true;
                    Dialogs.materialDialog(
                      color: Colors.white,
                      msg: '산책 리워드로 100포인트를 받았습니다!',
                      title: '축하합니다!!',
                      lottieBuilder: Lottie.asset(
                        'assets/Animation - 1717200471748.json',
                        fit: BoxFit.contain,
                      ),
                      // customView: MySuperWidget(),
                      customViewPosition: CustomViewPosition.BEFORE_ACTION,
                      context: context,
                      actions: [
                        IconsButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: '멍이득!',
                          iconData: Icons.done,
                          color: Color(0xFFCB997E),
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: alreadyGetReward
                        ? Color(0xFFFEE6D7)
                        : Color(0xFFCB997E), // 버튼 색상 주황색으로 설정
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 모서리 둥글게 설정
                    ),
                  ),
                  child: alreadyGetReward
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '이미 리워드를 받았습니다!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 24),
                            Text(
                              '리워드 받기',
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
    );
  }
}
