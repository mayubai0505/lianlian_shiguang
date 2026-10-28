import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme_notifier.dart';
import 'locale_notifier.dart';

/// 同帳號外觀 / 語言同步。僅使用 users/{uid}.accountPreferences，
/// 不修改聊天、花花或其他既有 user 欄位。
class AccountPreferencesSync {
  AccountPreferencesSync(this.theme, this.locale) {
    theme.addListener(_onChanged);
    locale.addListener(_onChanged);
  }

  final ThemeNotifier theme;
  final LocaleNotifier locale;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;
  String? _uid;
  bool _applying = false;
  bool _remoteReady = false;
  bool _disposed = false;
  int _generation = 0;
  Timer? _debounce;
  String? _lastJson;

  Map<String, dynamic> _values() => {
    ...theme.syncedAppearance,
    'locale': locale.syncedLocaleTag,
  };

  String _encode(Map<String, dynamic> data) => jsonEncode(data);

  Future<void> bindAccount(String? uid) async {
    final generation = ++_generation;
    _uid = uid;
    _remoteReady = false;
    _lastJson = null;
    _debounce?.cancel();
    await _subscription?.cancel();
    _subscription = null;
    if (_disposed || uid == null || uid.isEmpty) return;

    await Future.wait([theme.localReady, locale.localReady]);
    if (_disposed || generation != _generation) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    _subscription = ref.snapshots(includeMetadataChanges: true).listen(
          (snap) async {
        if (_disposed || generation != _generation) return;
        final root = snap.data() ?? <String, dynamic>{};
        final remotePhoto = root['customBackgroundUrl'];
        if (remotePhoto is String) {
          await theme.applyRemoteBackgroundUrl(remotePhoto);
        }
        final remote = root['accountPreferences'];
        if (remote is Map && remote.isNotEmpty) {
          final data = Map<String, dynamic>.from(remote);
          final normalized = {
            'theme': data['theme'] ?? theme.currentThemeEnum.name,
            'font': data['font'] ?? theme.currentFont.name,
            'fontScale': data['fontScale'] ?? theme.fontScale,
            'customColor': data['customColor'] ?? theme.customColor.toARGB32(),
            'locale': data['locale'] ?? locale.syncedLocaleTag,
          };
          final encoded = _encode(normalized);
          if (encoded != _lastJson) {
            _applying = true;
            try {
              await theme.applySyncedAppearance(normalized);
              await locale.applySyncedLocale(normalized['locale'].toString());
              _lastJson = _encode(_values());
            } finally {
              _applying = false;
            }
          }
          _remoteReady = true;
          return;
        }

        // 僅在伺服器確認欄位不存在時，將舊裝置的本地偏好遷入雲端。
        // 快取未命中時絕不能寫入預設值，以免覆蓋原有設定。
        if (snap.metadata.isFromCache || _remoteReady) return;
        try {
          final seed = _values();
          await FirebaseFirestore.instance.runTransaction((tx) async {
            final latest = await tx.get(ref);
            final existing = latest.data()?['accountPreferences'];
            if (existing is Map && existing.isNotEmpty) return;
            tx.set(ref, {
              'accountPreferences': seed,
              'accountPreferencesUpdatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          });
        } catch (e) {
          debugPrint('⚠️ 首次同步帳號偏好失敗：$e');
        }
      },
      onError: (Object e) => debugPrint('⚠️ 帳號偏好同步監聽失敗：$e'),
    );
  }

  void _onChanged() {
    if (_disposed || _applying || !_remoteReady || _uid == null) return;
    final current = _encode(_values());
    if (current == _lastJson) return;
    _debounce?.cancel();
    final generation = _generation;
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      if (_disposed || !_remoteReady || generation != _generation) return;
      final data = _values();
      final encoded = _encode(data);
      if (_lastJson == encoded) return;
      try {
        await FirebaseFirestore.instance.collection('users').doc(_uid!).set({
          'accountPreferences': data,
          'accountPreferencesUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        _lastJson = encoded;
      } catch (e) {
        debugPrint('⚠️ 儲存帳號偏好失敗：$e');
      }
    });
  }

  void dispose() {
    _disposed = true;
    _generation++;
    _debounce?.cancel();
    _subscription?.cancel();
    theme.removeListener(_onChanged);
    locale.removeListener(_onChanged);
  }
}
