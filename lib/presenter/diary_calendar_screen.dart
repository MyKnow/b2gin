import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../provider/diary_state_notifier_provider.dart';
import 'diary_edit_screen.dart';
import 'diary_view_screen.dart';

class DiaryCalendarScreen extends ConsumerStatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  DiaryCalendarScreenState createState() => DiaryCalendarScreenState();
}

class DiaryCalendarScreenState extends ConsumerState<DiaryCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<DateTime> highlightedDays = [];

  @override
  void initState() {
    super.initState();
  }

  List<String> _getEventsForDay(DateTime day) {
    return ref.read(diaryStateNotifier).fold<List<String>>([],
        (previousValue, element) {
      if (isSameDay(element.dateTime, day)) {
        return [...previousValue, element.description];
      }
      return previousValue;
    });
  }

  bool _isHighlighted(DateTime day) {
    return highlightedDays
        .any((highlightedDay) => isSameDay(highlightedDay, day));
  }

  @override
  Widget build(BuildContext context) {
    final diaryState = ref.watch(diaryStateNotifier);
    final _selectedEvents =
        diaryState.fold<List<String>>([], (previousValue, element) {
      if (isSameDay(element.dateTime, _selectedDay)) {
        return [...previousValue, element.description];
      }
      return previousValue;
    });
    highlightedDays = diaryState.map((e) => e.dateTime).toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, events) {
                    final textColor = date.weekday == DateTime.saturday
                        ? Colors.blue
                        : date.weekday == DateTime.sunday
                            ? Colors.red
                            : Colors.black;
                    return Center(
                      child: Text(
                        DateFormat('d').format(date),
                        style: TextStyle(color: textColor),
                      ),
                    );
                  },
                  selectedBuilder: (context, date, events) {
                    return Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('d').format(date),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, date, events) {
                    return Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('d').format(date),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, date, events) {
                    return Center(
                      child: Text(
                        DateFormat('d').format(date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                  markerBuilder: (context, date, events) {
                    if (_isHighlighted(date)) {
                      return Positioned(
                        top: 5,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                eventLoader: _getEventsForDay,
                locale: 'ko_KR',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _selectedEvents[index],
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFCB997E),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              // 선택한 날짜에 다이어리가 있는 경우이므로, 수정하는 버튼을 보여준다.
              if (_isHighlighted(_selectedDay))
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiaryViewScreen(
                            diaryState: ref
                                .read(diaryStateNotifier.notifier)
                                .getDiaryState(_selectedDay),
                          ),
                        ),
                      );
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
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 24),
                        Text(
                          '다이어리 보기',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              // 선택한 날짜에 다이어리가 없는 경우이므로, 추가하는 버튼을 보여준다.
              else
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiaryNewScreen(
                            dateTime: _selectedDay,
                          ),
                        ),
                      );
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
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 24),
                        Text(
                          '다이어리 작성하기',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
