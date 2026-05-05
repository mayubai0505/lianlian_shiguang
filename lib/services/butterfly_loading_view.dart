import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class ButterflyLoadingView extends StatefulWidget {
  const ButterflyLoadingView({super.key});

  @override
  State<ButterflyLoadingView> createState() => _ButterflyLoadingViewState();
}

class _ButterflyLoadingViewState extends State<ButterflyLoadingView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // 🌟 設定妳的蝴蝶影片路徑
    _controller = VideoPlayerController.asset('assets/animations/butterfly_splash.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true); // 讓蝴蝶一直飛，直到載入完成
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // 關掉對話框時，記得釋放記憶體
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 蝴蝶影片容器
        Sparate(
          width: 200, // 總裁可以自己調整蝴蝶的大小
          height: 200,
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : const CircularProgressIndicator(color: Color(0xFF9C27B0)), // 影片還沒好之前先用舊的頂一下
        ),
        const SizedBox(height: 40),
        const Text(
          "正在與時光連結...",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7B1FA2),
            fontWeight: FontWeight.w400,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 20), // 最下面再留一點點呼吸空間
      ],
    );
  }
}

// 簡單的間距組件，方便調整
class Sparate extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const Sparate({super.key, required this.width, required this.height, required this.child});
  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height, child: child);
}