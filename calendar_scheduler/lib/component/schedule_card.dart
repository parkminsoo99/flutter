import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/colors.dart';


class ScheduleCard extends StatelessWidget{
  final int startTime;
  final int endTime;
  final String content;

  ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
});
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color : PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime : startTime,
                endTime: endTime,
              ),
              SizedBox(width: 16),
              _Content(content: content),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
class _Time extends StatelessWidget{
  final int startTime;
  final int endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key
}) : super(key:key);

  Widget build(BuildContext context){
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2,'0')}:00',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2,'0')}:00',
          style:textStyle.copyWith(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
class _Content extends StatelessWidget{
  final String content;

  const _Content({
    required this.content,
    Key? key
  });
  @override
  Widget build(BuildContext context){
    return Expanded(
        child: Text(
          content,
        )
    );
  }

}