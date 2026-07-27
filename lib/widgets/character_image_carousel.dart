import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';

class CharacterImageCarousel extends StatefulWidget {
  final List<String> imagePaths;

  const CharacterImageCarousel({
    super.key,
    required this.imagePaths,
  });

  @override
  State<CharacterImageCarousel> createState() => _CharacterImageCarouselState();
}

class _CharacterImageCarouselState
    extends State<CharacterImageCarousel> {
  int _currentPage = 0;

  final Set<String> _preloadedUrls = {};

  ImageProvider _getImageProvider(String path) {
    final normalizedPath = path.trim();

    if (normalizedPath.startsWith('http://') ||
        normalizedPath.startsWith('https://')) {
      return CachedNetworkImageProvider(normalizedPath);
    }

    if (normalizedPath.startsWith('assets/')) {
      return AssetImage(normalizedPath);
    }

    if (!kIsWeb && normalizedPath.isNotEmpty) {
      return FileImage(File(normalizedPath));
    }

    return const AssetImage(
      'assets/images/blank_avatar.png',
    );
  }

  void _precacheNearbyImages(
      BuildContext context,
      List<String> images,
      int currentIndex,
      ) {
    final indexes = <int>{
      currentIndex,
      currentIndex + 1,
    };

    for (final index in indexes) {
      if (index < 0 || index >= images.length) continue;

      final imagePath = images[index].trim();

      if (!imagePath.startsWith('http') ||
          _preloadedUrls.contains(imagePath)) {
        continue;
      }

      _preloadedUrls.add(imagePath);

      precacheImage(
        CachedNetworkImageProvider(imagePath),
        context,
      ).catchError((error) {
        _preloadedUrls.remove(imagePath);
        debugPrint(
          '預載角色圖片失敗：$imagePath，$error',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final publicImages = widget.imagePaths
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _precacheNearbyImages(
        context,
        publicImages,
        _currentPage,
      );
    });

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

            _precacheNearbyImages(
              context,
              publicImages,
              value,
            );
          },
          itemBuilder: (context, index) {
            final imagePath = publicImages[index];

            return Image(
              image: _getImageProvider(imagePath),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Image.asset(
                  'assets/images/blank_avatar.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
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
              children: List.generate(
                publicImages.length,
                    (index) {
                  return AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white54,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}