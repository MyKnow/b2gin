import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'provider/current_index.dart';

void main() {
  initializeDateFormatting()
      .then((_) => runApp(const ProviderScope(child: MainApp())));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(currentIndexProvider);
    final Widget svgIcon = SvgPicture.asset(
      'assets/images/logo.svg',
      semanticsLabel: '뚜벅뚜멍',
      width: 60, // TODO
      height: 60, // TODO
    );

    String getTitle(int index) {
      switch (index) {
        case 0:
          return '산책 일지';
        case 1:
          return '건강 일지';
        case 2:
          return '뚜벅뚜멍';
        case 3:
          return '다이어리';
        case 4:
          return '주변이야기';
        default:
          return '뚜벅뚜멍';
      }
    }

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primaryColor: Colors.deepOrange[100],
          ),
          home: child,
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFEE6D7), // TODO
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: svgIcon,
                  ),
                  SizedBox(width: 8), // 로고와 타이틀 사이의 간격 조정
                  Text(
                    getTitle(selected.index),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xFFCB997E),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFFCB997E),
                ),
                onPressed: () {},
              ),
            ],
          ),
          // toolbarHeight: 68, // TODO
        ),
        body: selected.screen,
        bottomNavigationBar: StylishBottomBar(
          option: BubbleBarOptions(
            barStyle: BubbleBarStyle.vertical,
            bubbleFillStyle: BubbleFillStyle.fill,
            // opacity: 0.3, // TODO
          ),
          items: [
            for (int i = 0; i < CurrentIndex.values.length; i++)
              BottomBarItem(
                icon: CurrentIndex.values[i].icon,
                title: Text(CurrentIndex.values[i].title),
                selectedColor: Color(0xFFCB997E), // TODORR
                unSelectedColor: const Color(0xFFFEE6D7), // TODO
              ),
          ],
          currentIndex: selected.index,
          onTap: (index) {
            ref.read(currentIndexProvider.notifier).setIndex(index);
          },
        ),
      ),
    );
  }
}
