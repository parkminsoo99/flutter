import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
class SchedulBottomSheet extends StatefulWidget{
  SchedulBottomSheet({Key? key}) : super(key:key);

  @override
  State<SchedulBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<SchedulBottomSheet>{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          color:Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8,right:8,top:8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                          label:'시작 시간',
                          isTime: true,
                        ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label:'종료 시간',
                        isTime: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomTextField(
                    label:'내용',
                    isTime: false,
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child : ElevatedButton(
                        onPressed: onSavePressed,
                        style : ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                        ),
                        child: Text('저장'),
                    ),
                ),
              ],
            )
          )
        ),
    );
  }
  void onSavePressed(){

  }
}