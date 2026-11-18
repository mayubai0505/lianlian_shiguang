import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'toast_utils.dart';

/// Private feedback to administrators, not a public dislike counter.
Future<void> showWorkDislikeDialog(BuildContext context, {
  required String workId,
  required bool isWorld,
  required String workName,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    ToastUtils.showCenterToast(context, l10n.profilePagePleaseSignIn, isError: true);
    return;
  }
  String draft = '';
  final reason = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(isWorld ? '${l10n.dislike_label} · $workName' : l10n.dislike_dialog_title),
      content: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.dislike_dialog_subtitle, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            maxLength: 500,
            onChanged: (value) => draft = value,
            decoration: InputDecoration(hintText: l10n.dislike_hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ],
      )),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancelButton)),
        FilledButton(onPressed: () {
          final value = draft.trim();
          if (value.isNotEmpty) Navigator.pop(dialogContext, value);
        }, child: Text(l10n.dislike_submit)),
      ],
    ),
  );
  if (reason == null || !context.mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
  try {
    await FirebaseFirestore.instance.collection('admin_feedback').add({
      'type': isWorld ? 'world_dislike' : 'character_dislike',
      if (isWorld) 'worldId': workId else 'characterId': workId,
      'reporterId': uid,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
    });
    if (context.mounted) ToastUtils.showCenterToast(context, l10n.dislike_thanks);
  } catch (error) {
    debugPrint('作品負面回饋送出失敗：$error');
    if (context.mounted) ToastUtils.showCenterToast(context, l10n.common_operation_failed_retry, isError: true);
  }
}
