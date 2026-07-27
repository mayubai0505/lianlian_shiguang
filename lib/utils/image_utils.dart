import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 全域共用：取得 Avatar ImageProvider
ImageProvider getAvatarImageProvider(String path) {
  final normalizedPath = path.trim();

  // 空字串
  if (normalizedPath.isEmpty) {
    return const AssetImage('assets/images/avatar1.png');
  }

  // 網路圖片（使用磁碟快取）
  if (normalizedPath.startsWith('http://') ||
      normalizedPath.startsWith('https://')) {
    return CachedNetworkImageProvider(normalizedPath);
  }

  // Assets
  if (normalizedPath.startsWith('assets/')) {
    return AssetImage(normalizedPath);
  }

  // 本機圖片
  if (!kIsWeb) {
    final file = File(normalizedPath);

    if (file.existsSync()) {
      return FileImage(file);
    }
  }

  // 預設圖片
  return const AssetImage('assets/images/avatar1.png');
}