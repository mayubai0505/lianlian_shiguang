import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class CharacterImageCarousel extends StatefulWidget {
  final List<String> imagePaths;

  const CharacterImageCarousel({
    super.key,
    required this.imagePaths,
  });

  @override
  State<CharacterImageCarousel> createState() => _CharacterImageCarouselState();
}

class _CharacterImageCarouselState extends State<CharacterImageCarousel> {
  int _currentPage = 0;

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }

    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }

    // 如果未來有本機圖片路徑，避免直接壞掉
    if (!kIsWeb && path.isNotEmpty) {
      return FileImage(File(path));
    }

    return const AssetImage('assets/images/blank_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    final publicImages = widget.imagePaths
        .where((path) => path.trim().isNotEmpty)
        .take(5)
        .toList();

    if (publicImages.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.hide_image_outlined,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: publicImages.length,
          onPageChanged: (value) {
            if (!mounted) return;
            setState(() {
              _currentPage = value;
            });
          },
          itemBuilder: (context, index) {
            final imagePath = publicImages[index];

            return Image(
              image: _getImageProvider(imagePath),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/blank_avatar.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                );
              },
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
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
