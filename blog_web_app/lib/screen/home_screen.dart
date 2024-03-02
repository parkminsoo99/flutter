import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class HomeScreen extends StatelessWidget{

  WebViewController webViewController = WebViewController()
  ..loadRequest(Uri.parse('https://blog.codefactory.ai'))
  ..setJavaScriptMode(JavaScriptMode.unrestricted);

  HomeScreen({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
            'Code Factory'
        ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: (){
              webViewController.loadRequest(Uri.parse('https://blog.codefactory.ai'));
            },
            icon : Icon(
              Icons.home,
            )
          ),

        ],
      ),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}