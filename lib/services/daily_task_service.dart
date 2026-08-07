import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DailyTaskLikeResult {
  final bool counted;
  final int progress;
  final bool completedNow;

  const DailyTaskLikeResult({
    required this.counted,
    required this.progress,
    required this.completedNow,
  });
}

class DailyTaskService {
  DailyTaskService._();

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  /// 記錄玩家今天按讚了一篇「不同的」動態。
  ///
  /// 回傳：
  /// counted：這次是否真的計入任務
  /// progress：目前社群巡禮進度
  /// completedNow：是否剛好在這次完成 3/3
  static Future<DailyTaskLikeResult> recordMomentLike({
    required String momentId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final String trimmedMomentId = momentId.trim();

    if (user == null || trimmedMomentId.isEmpty) {
      return const DailyTaskLikeResult(
        counted: false,
        progress: 0,
        completedNow: false,
      );
    }

    final userRef =
    _db.collection('users').doc(user.uid);

    try {
      return await _db.runTransaction<
          DailyTaskLikeResult>((transaction) async {
        final snapshot =
        await transaction.get(userRef);

        if (!snapshot.exists) {
          throw Exception('找不到玩家資料');
        }

        final data =
            snapshot.data() ?? <String, dynamic>{};

        final Timestamp? lastResetTimestamp =
        data['lastTasksResetDate']
        as Timestamp?;

        final bool isToday = lastResetTimestamp != null &&
            _isSameLocalDay(
              lastResetTimestamp.toDate(),
              DateTime.now(),
            );

        // 新的一天：重建今天的任務資料，
        // 並直接把本次按讚記為第 1 篇。
        if (!isToday) {
          transaction.set(
            userRef,
            {
              'lastTasksResetDate':
              FieldValue.serverTimestamp(),
              'dailyTasks': {
                'dailyChatProgress': 0,
                'dailyChatClaimed': false,
                'storyChatProgress': 0,
                'storyChatClaimed': false,
                'likeProgress': 1,
                'likeClaimed': false,
                'likedMomentIds': [
                  trimmedMomentId,
                ],
                'monthlyCardClaimed': false,
              },
            },
            SetOptions(merge: true),
          );

          return const DailyTaskLikeResult(
            counted: true,
            progress: 1,
            completedNow: false,
          );
        }

        final dailyTasks =
        Map<String, dynamic>.from(
          data['dailyTasks'] as Map? ?? {},
        );

        final List<String> likedMomentIds =
        (dailyTasks['likedMomentIds']
        as List<dynamic>? ??
            const [])
            .map((item) => item.toString())
            .toList();

        final int currentProgress =
            (dailyTasks['likeProgress'] as num?)
                ?.toInt() ??
                0;

        // 同一篇今天已經計算過
        if (likedMomentIds.contains(
          trimmedMomentId,
        )) {
          return DailyTaskLikeResult(
            counted: false,
            progress: currentProgress.clamp(
              0,
              3,
            ),
            completedNow: false,
          );
        }

        // 任務已經完成，不再繼續累積
        if (currentProgress >= 3) {
          return const DailyTaskLikeResult(
            counted: false,
            progress: 3,
            completedNow: false,
          );
        }

        final int nextProgress =
        (currentProgress + 1).clamp(0, 3);

        transaction.update(
          userRef,
          {
            'dailyTasks.likeProgress':
            nextProgress,
            'dailyTasks.likedMomentIds':
            FieldValue.arrayUnion([
              trimmedMomentId,
            ]),
          },
        );

        return DailyTaskLikeResult(
          counted: true,
          progress: nextProgress,
          completedNow:
          currentProgress < 3 &&
              nextProgress >= 3,
        );
      });
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 社群巡禮任務紀錄失敗：$e',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  static bool _isSameLocalDay(
      DateTime first,
      DateTime second,
      ) {
    final firstLocal = first.toLocal();
    final secondLocal = second.toLocal();

    return firstLocal.year == secondLocal.year &&
        firstLocal.month == secondLocal.month &&
        firstLocal.day == secondLocal.day;
  }
}