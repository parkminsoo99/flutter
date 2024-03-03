import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  DateTime firstDay = DateTime.now();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor : Colors.pink[100],
      body:SafeArea(
        top : true,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(
              onHeartPressed : onHeartPressed,
              firstDay: firstDay,
            ),
            _CoupleImage(),
          ],
        ),
      ),
    );
  }
  void onHeartPressed(){
    showCupertinoDialog(
        context: (context),
        builder: (BuildContext context){
          return Align(
            alignment: Alignment.bottomCenter,
            child : Container(
              color : Colors.white,
              height: 300,
              child : CupertinoDatePicker(
                mode:CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  setState((){
                    firstDay = date;
                  });
                },
              ),
            ),
          );
        },
      barrierDismissible: true,
        );
  }
}


class _DDay extends StatelessWidget{
  @override
  //GestureTapCallback은 material package에서 제공하는 Typedef로,
  //버튼의 onPressed or onTap 콜백 함수들의 GestureTapCallback 타입으로 정의돼있다.
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;
  _DDay({
    required this.onHeartPressed,
    required this.firstDay
});
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    return Column(
      children: [
        const SizedBox(height:16),
        Text(
          'U&I',
          style: textTheme.displayLarge,
        ),
        const SizedBox(height: 16),
        Text(
          '우리 처음 만난 날',
          style: textTheme.bodyLarge,
        ),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        IconButton(
          iconSize:60,
          onPressed: onHeartPressed,
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          //inDays는 difference()함수에 Duration값의 기간을 날짜로 반환하는 getter이다
          'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays+1}',
          style: textTheme.displayMedium,
        )
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Center(
        child : Image.asset(
          'asset/img/middle_image.png',
          //MediaQuery.of(context)를 사용하여 화면 크기와 관련된 각종 기능 사용 가능
          //특히나size getter를 불러오면 화면 전체의 너비/높이 가져올 수 있다.
          height: MediaQuery.of(context).size.height/2,
        ),
      )
    );
  }
}