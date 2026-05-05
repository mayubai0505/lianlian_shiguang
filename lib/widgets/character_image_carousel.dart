import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class CharacterImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  const CharacterImageCarousel({super.key, required this.imagePaths});

  @override
  State<CharacterImageCarousel> createState() => _CharacterImageCarouselState();
}

class _CharacterImageCarouselState extends State<CharacterImageCarousel> {
  int _currentPage = 0;

  // --- MODIFIED: 升級了圖片顯示邏輯 ---
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final publicImages = widget.imagePaths.take(5).toList();

    if (publicImages.isEmpty) {
      return AspectRatio(
        aspectRatio: 1.0, // 改成 1:1 的比例
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20), // 配合卡片圓角
          ),
          child: const Icon(Icons.hide_image_outlined,
              size: 50, color: Colors.grey),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.0, // 改成 1:1 的比例，讓卡片上半部是正方形
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            itemCount: publicImages.length,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemBuilder: (context, index) {
              return Ink.image(
                image: _getImageProvider(publicImages[index]),
                fit: BoxFit.cover,
              );
            },
          ),
          if (publicImages.length > 1)
            Positioned(
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(publicImages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
