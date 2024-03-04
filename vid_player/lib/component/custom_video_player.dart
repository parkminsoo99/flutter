// 필요한 패키지들을 임포트합니다.
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:vid_player/component/custom_icon_button.dart'; // 사용자 정의 아이콘 버튼 위젯

// 사용자 정의 비디오 플레이어 위젯의 정의
class CustomVideoPlayer extends StatefulWidget {
  final XFile video; // 비디오 파일
  final GestureTapCallback onNewVideoPressed; // 새 비디오 버튼을 눌렀을 때 실행할 콜백 함수

  // 생성자: 필수 인자로 video와 onNewVideoPressed를 받습니다.
  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool showControls = false; // 컨트롤 버튼을 보여줄지 말지 결정하는 플래그
  VideoPlayerController? videoController; // 비디오를 제어하기 위한 컨트롤러

  // 위젯이 업데이트될 때 실행되는 메소드 (예: 새 비디오 선택)
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      initializeController(); // 비디오 경로가 변경되었다면 컨트롤러를 다시 초기화합니다.
    }
  }

  // 위젯이 생성될 때 실행되는 초기화 메소드
  @override
  void initState() {
    super.initState();
    initializeController(); // 비디오 컨트롤러를 초기화합니다.
  }

  // 비디오 컨트롤러를 초기화하는 메소드
  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController.initialize(); // 비디오를 비동기적으로 초기화합니다.
    videoController.addListener(videoControllerListener); // 컨트롤러의 상태 변화를 감지하는 리스너를 추가합니다.
    setState(() {
      this.videoController = videoController; // 상태를 업데이트하여 UI를 재구성합니다.
    });
  }

  // 비디오 컨트롤러의 리스너 메소드
  void videoControllerListener() {
    setState(() {
      // 비디오 컨트롤러의 상태 변화가 있을 때마다 UI를 재구성합니다.
    });
  }

  // 위젯이 파괴될 때 실행되는 메소드
  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener); // 리스너를 제거합니다.
    super.dispose();
  }

  // 위젯의 UI를 구성하는 메소드
  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      // 비디오 컨트롤러가 초기화되지 않았다면 로딩 인디케이터를 보여줍니다.
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls; // 화면을 탭할 때 컨트롤 버튼의 표시 여부를 토글합니다.
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio, // 비디오의 비율에 맞게 화면을 조절합니다.
        child: Stack(
          children: [
            VideoPlayer(
              videoController!, // 비디오 플레이어 위젯
            ),
            if (showControls)
            // 컨트롤 버튼을 보여주기 위한 반투명 오버레이
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            // 비디오 재생 시간과 슬라이더를 보여주는 바
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(
                      videoController!.value.position,
                    ),
                    Expanded(
                      child: Slider(
                        onChanged: (double val) {
                          // 슬라이더의 위치를 변경하여 비디오 재생 위치를 조정합니다.
                          videoController!.seekTo(
                            Duration(seconds: val.toInt()),
                          );
                        },
                        value: videoController!.value.position.inSeconds.toDouble(),
                        min: 0,
                        max: videoController!.value.duration.inSeconds.toDouble(),
                      ),
                    ),
                    renderTimeTextFromDuration(
                      videoController!.value.duration,
                    ),
                  ],
                ),
              ),
            ),
            // 컨트롤 버튼이 보여질 때의 UI 구성
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back,
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 비디오의 현재 시간을 포맷에 맞추어 보여주는 위젯
  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  // 되감기 버튼을 눌렀을 때의 동작
  void onReversePressed() {
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  // 빨리감기 버튼을 눌렀을 때의 동작
  void onForwardPressed() {
    final currentPosition = videoController!.value.position;
    final maxPosition = videoController!.value.duration;
    Duration position = maxPosition;
    if ((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  // 재생/일시정지 버튼을 눌렀을 때의 동작
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
