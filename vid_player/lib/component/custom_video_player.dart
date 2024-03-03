import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
class CustomVideoPlayer extends StatefulWidget{
  final XFile video;
  const CustomVideoPlayer({
    required this.video,
    Key? key,
}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  @override
  void initState(){
    super.initState();
    initializeController();
  }
  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController.initialize();
    setState(() {
      this.videoController = videoController;
    });
  }
  @override
  Widget build(BuildContext context){
    if (videoController == null) {
      return Center(
          child: CircularProgressIndicator(
            color:Colors.white,
          ),
      );
    }
    return AspectRatio(
      //videoController선언시 입력된 동영상의 비율을 value.aspectRatio 게터로 받아올 수 있다.
      aspectRatio: videoController!.value.aspectRatio,
      child:VideoPlayer(
        videoController!,
      ),
    );
  }
}