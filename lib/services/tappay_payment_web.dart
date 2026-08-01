import 'dart:js_interop';

/// 呼叫 web/index.html 裡的 TapPay JavaScript Bridge。
@JS('LianLianTapPay.showCardDialog')
external JSPromise<JSString?> _showTapPayCardDialog();

/// 顯示 TapPay 信用卡輸入視窗。
///
/// 成功取得 Prime 時回傳 Prime；
/// 使用者取消時回傳 null。
Future<String?> showTapPayCardDialog() async {
  try {
    final JSString? result = await _showTapPayCardDialog().toDart;
    return result?.toDart;
  } catch (error) {
    throw Exception('TapPay 信用卡視窗開啟失敗：$error');
  }
}