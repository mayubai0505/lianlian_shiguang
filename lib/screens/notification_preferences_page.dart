import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/toast_utils.dart';

/// Notification preferences belong to the account, not the device.
/// Phone-level system notification permission is managed by iOS / Android.
class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  static const _options = <(String, String, String)>[
    ('chat', '角色聊天', '角色回覆訊息的推播'),
    ('moments', '新瞬間', '關注的創作者及角色發布新貼文'),
    ('social', '社交通知', '按讚、留言、追蹤與角色互動'),
    ('announcements', '官方公告', '一般官方公告推播'),
    ('events', '活動提醒', '活動即將結束的推播'),
  ];
  final Map<String, bool> _pending = <String, bool>{};
  final Set<String> _saving = <String>{};

  Future<void> _setPreference(String key, bool enabled) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || _saving.contains(key)) return;
    setState(() {
      _pending[key] = enabled;
      _saving.add(key);
    });
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'notificationPreferences.$key': enabled,
        'notificationPreferencesUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      if (mounted) {
        ToastUtils.showCenterToast(context, '通知設定儲存失敗，請稍後重試', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _pending.remove(key);
          _saving.remove(key);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('通知偏好')),
      body: uid == null
          ? const Center(child: Text('請先登入帳號'))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('無法讀取通知偏好，請稍後再試'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final raw = snapshot.data!.data()?['notificationPreferences'];
          final preferences = raw is Map
              ? Map<String, dynamic>.from(raw)
              : <String, dynamic>{};
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              for (final (key, title, subtitle) in _options)
                SwitchListTile.adaptive(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  value: _pending[key] ?? (preferences[key] != false),
                  onChanged: _saving.contains(key)
                      ? null
                      : (value) => _setPreference(key, value),
                ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '此處設定同步至同一玩家帳號的所有裝置。'
                      '手機系統通知權限需在各裝置分別設定。'
                      '關閉推播不會刪除遊戲內信箱或已收到的通知。',
                  style: TextStyle(fontSize: 12, height: 1.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
