import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class PayPalPurchaseService {
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'asia-east1');

  Future<void> buyWebProduct(String productId) async {
    final callable = _functions.httpsCallable('createPayPalOrder');

    final result = await callable.call({
      'productId': productId,
    });

    final String approveUrl = result.data['approveUrl'];
    final uri = Uri.parse(approveUrl);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_self',
    );
  }
}