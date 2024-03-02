import 'package:flutter/material.dart';
//상태바 아이콘들의 생상을 변경하는 패키지
import 'package:flutter/services.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  final PageController pageController = PageController();
  @override
  void initState(){
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      //1 => pageController.page 게터를 사용해 pageView의 현재 페이지를 가져온다
      //페이지가 변경 중인 경우 소수점이기에 정숫값으로 변환
      int? nextPage = pageController.page?.toInt();
      //페이지가 null이면 아무것도 안함
      if(nextPage == null){
        return;
      }
      //페이지 값이 4이면 다시 시작 아니면 1페이지를 더해서 다음 페이지로 이동
      if (nextPage == 4){
        nextPage =0;
      } else{
        nextPage++;
      }
      //pageController의 animateToPage()함수를 사용해 PageView의 현재
      //페이지 변경 가능, 첫 번째 매개변수로 이동할 페이지가 정수로 입력되며 duration
      // 매개변수는 이동할 때 소요될 시간, 마지막으로 curve 매개변수는 페이지가 변경된느
      // 애니메이션의 작동 방식을 정할 수 있다. 플러터에서는 수십개의 curve 기본 설정이 제공됨
      pageController.animateToPage(
        nextPage,
        duration: Duration(microseconds: 500),
        curve: Curves.ease,
      );
      },
    );
  }
  @override
  Widget build(BuildContext context){
    //상태바의 색상을 횐색이나 검정색으로 변경가능
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body:PageView(
        controller: pageController,
        children: [1,2,3,4,5]
            .map((number) => Image.asset(
          'lib/asset/img/image_$number.jpeg',
          fit: BoxFit.cover,
        )
        ).toList(),
      )
    );
  }
}