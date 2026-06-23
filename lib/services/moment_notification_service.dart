import 'package:cloud_functions/cloud_functions.dart';
import 'app_constants.dart';

class MomentNotificationService {
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'asia-east1');

  Future<void> createMomentNotification({
    required String momentId,
    required String type,
    String? commentId,
  }) async {
    final callable = _functions.httpsCallable('createMomentNotification');

    await callable.call({
      'appId': AppConfig.appId,
      'momentId': momentId,
      'type': type,
      if (commentId != null) 'commentId': commentId,
    });
  }
}