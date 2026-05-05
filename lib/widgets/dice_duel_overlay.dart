import 'package:flutter/material.dart';
import 'dart:math';

// ✨ 全螢幕骰子對決動畫 (無限角色支援版)
class DiceDuelOverlay extends StatefulWidget {
  final String playerName;
  final String aiName;
  final String aiTitle; // ✨ 1. 新增：動態接收對象的稱號 (如總裁、醫生、對象)
  final int playerRoll; // ✨ 2. 秘書修復：這裡必須是 int 才能正確計算點數圖示喔！
  final int aiRoll;     // ✨ 同上，改為 int

  const DiceDuelOverlay({
    super.key,
    required this.playerName,
    required this.aiName,
    required this.aiTitle,
    required this.playerRoll,
    required this.aiRoll,
  });

  @override
  State<DiceDuelOverlay> createState() => _DiceDuelOverlayState();
}

class _DiceDuelOverlayState extends State<DiceDuelOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFinalResult = false;
  final Random _random = Random();

  // 用來在動畫期間顯示隨機點數的變數
  int _tempPlayerRoll = 1;
  int _tempAiRoll = 1;

  @override
  void initState() {
    super.initState();
    // 動態時間設定為 2 秒
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // 動畫進行時，快速更新點數，營造「滾動」的感覺
    _controller.addListener(() {
      if (mounted && !_showFinalResult) {
        setState(() {
          _tempPlayerRoll = _random.nextInt(6) + 1;
          _tempAiRoll = _random.nextInt(6) + 1;
        });
      }
    });

    // 動畫結束後，顯示最終結果，然後自動關閉
    _controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _showFinalResult = true; // 鎖定最終結果
        });
        // 停留 1.5 秒讓玩家看清楚結果，然後關閉彈窗
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 輔助工具：根據點數回傳骰子圖示
  Widget _buildDiceIcon(int roll) {
    const diceEmojis = ['⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];
    return Text(
      diceEmojis[roll - 1],
      style: const TextStyle(fontSize: 100, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.85,
          height: 350,
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)
            ],
          ),
          child: Stack(
            children: [
              // 1. 中間的分割線
              Center(
                child: Container(
                  width: 2,
                  height: 200,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),

              // 2. 兩邊的內容
              Row(
                children: [
                  // 玩家側
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.playerName, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text('妳', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 30),
                        // 滾動中的骰子
                        _buildDiceIcon(_showFinalResult ? widget.playerRoll : _tempPlayerRoll),
                      ],
                    ),
                  ),

                  // 這裡是中間的線，已經用 Stack 做在上面了
                  const SizedBox(width: 2),

                  // 角色側
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.aiName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        // ✨ 3. 關鍵修改：再見了學長！歡迎通用稱號！
                        Text(widget.aiTitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 30),
                        // 滾動中的骰子
                        _buildDiceIcon(_showFinalResult ? widget.aiRoll : _tempAiRoll),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. 底部文字提示 (VS 中 / 最終結果)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _showFinalResult
                        ? Container(
                      key: const ValueKey('result'),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: const Text('對決結果已封存！', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                        : const Text(
                      '🎲 宇宙能量匯聚中...',
                      key: ValueKey('rolling'),
                      style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}