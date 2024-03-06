import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}) : super(key:key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: (){
          showModalBottomSheet(
              context: context,
              isDismissible: true,
              builder: (_) => SchedulBottomSheet(),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child:Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8),
            TodayBanner(
                selectedDate: selectedDate,
                count: 0
            ),
            SchedulCard(
                startTime: 12,
                endTime: 14,
                content: '프로그래밍 공부',
            ),
          ],
        ),
      ),
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}