import 'dart:ffi';

import 'package:calendar_scheduler/component/login_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key:key);
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context){
    final provider = context.watch<ScheduleProvider>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/img/logo.png',
                  width : MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              const SizedBox(height: 16),
              LoginTextField(
                onSaved: (String? val) {
                  email = val!;
                },
                validator: (String? val) {
                  if(val?.isEmpty ?? true){
                    return '이메일을 입력해주세요.';
                  }
                  RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!reg.hasMatch(val!)){
                    return '이메일 형식이 올바르지 않습니다.';
                  }
                  //입력값이 문제가 없다면!
                  return null;
                },
                hintText: "이메일",
              ),
              const SizedBox(height: 8),
              LoginTextField(
                obscureText: true,
                onSaved: (String? val){
                  password = val!;
                },
                validator: (String? val){
                  if(val?.isEmpty ?? true) {
                    return '비밀번호를 입력해주세요.';
                  }
                  if(val!.length < 4 || val.length > 8){
                    return '비밀번호는 4~8자 사이로 입력 해주세요!';
                  }
                  return null;
                },
                hintText: '비밀번호',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: SECONDARY_COLOR,
                  shape : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                ),
                onPressed: () {
                  onRegisterPress(provider);
                },
                child: Text("회원가입"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  onLoginPress(provider);
                },
                child: Text("로그인"),
              ),
            ],
          ),
        ),
      )
    );
  }
  bool saveAndValidateForm(){
    if(!formkey.currentState!.validate()){
      return false;
    }
    formkey.currentState!.save();
    return true;
  }
  onRegisterPress(ScheduleProvider provider) async{
    if(!saveAndValidateForm()){
      return;
    }
    String? message;
    try{
      await provider.register(
        email: email,
        password: password,
      );
    } on DioError catch(e){
      message = e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
    } catch (e){
      message = '알 수 없는 오류가 발생했습니다.';
    }finally{
      if(message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
        );
      }else(
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => HomeScreen()
        ),
      )
      );
    }
  }
  onLoginPress(ScheduleProvider provider) async{
    if(!saveAndValidateForm()){
      return;
    }
    String? message;
    try {
      await provider.login(
        email : email,
        password: password,
      );
    } on DioError catch (e) {
      message = e.response?.data['message'] ?? '알 수 없는 오류';
    }catch(e){
      message = '알 수 없는 오류';
    }finally{
      if(message != null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message))
        );
      }else{
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HomeScreen(),)
        );
      }
    }
  }
}