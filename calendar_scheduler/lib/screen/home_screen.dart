import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';

class HomeScreen extends StatelessWidget{
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Widget build(BuildContext context){
    final provider = context.watch<ScheduleProvider>();
    final selectedDate =provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: (){
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => SchedulBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
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
            SizedBox(height: 8),
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, foucsedDate) => onDaySelected(selectedDate, foucsedDate, context),
            ),
            SizedBox(height: 8),
            TodayBanner(
                selectedDate: selectedDate,
                count: schedules.length
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction){
                          provider.deleteSchedule(date: selectedDate, id: schedule.id);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom:8, left: 8, right: 8),
                          child : ScheduleCard(
                            startTime : schedule.startTime,
                            endTime : schedule.endTime,
                            content : schedule.content,
                          ),
                        ),
                    );
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focusedDate, BuildContext context){
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
  }
}