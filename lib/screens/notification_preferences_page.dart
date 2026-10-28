import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

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
        ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.notification_preferences_save_failed1, isError: true);
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
    final l10n = AppLocalizations.of(context)!;
    final options = <(String, String, String)>[
      ('chat', l10n.notification_preferences_chat_title1, l10n.notification_preferences_chat_subtitle1),
      ('moments', l10n.notification_preferences_moments_title1, l10n.notification_preferences_moments_subtitle1),
      ('social', l10n.notification_preferences_social_title1, l10n.notification_preferences_social_subtitle1),
      ('announcements', l10n.notification_preferences_announcements_title1, l10n.notification_preferences_announcements_subtitle1),
      ('events', l10n.notification_preferences_events_title1, l10n.notification_preferences_events_subtitle1),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notification_preferences_page_title1)),
      body: uid == null
          ? Center(child: Text(l10n.notification_preferences_login_required1))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(l10n.notification_preferences_load_failed1));
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
              for (final (key, title, subtitle) in options)
                SwitchListTile.adaptive(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  value: _pending[key] ?? (preferences[key] != false),
                  onChanged: _saving.contains(key)
                      ? null
                      : (value) => _setPreference(key, value),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.notification_preferences_footer1,
                  style: const TextStyle(fontSize: 12, height: 1.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
