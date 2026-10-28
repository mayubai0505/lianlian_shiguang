import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 舊版本將內建頭像路徑存為 PNG；壓縮素材後兼容既有玩家資料。
// 僅處理 avatar1～avatar13，不影響使用者上傳的網路或本機圖片。
String normalizeAvatarAssetPath(String path) {
  final trimmed = path.trim();
  if (RegExp(r'^assets/images/avatar(?:[1-9]|1[0-3])\.png$')
      .hasMatch(trimmed)) {
    return trimmed.replaceFirst(RegExp(r'\.png$'), '.webp');
  }
  return trimmed;
}

// 全域共用：取得 Avatar ImageProvider
ImageProvider getAvatarImageProvider(String path) {
  final normalizedPath = normalizeAvatarAssetPath(path);

  // 空字串
  if (normalizedPath.isEmpty) {
    return const AssetImage('assets/images/avatar1.webp');
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
  return const AssetImage('assets/images/avatar1.webp');
}