import Flutter
import UIKit
import PushKit
import CallKit
import flutter_callkit_incoming

// VoIP push 只在真正的「角色約定來電」使用；所有扣花仍由 Dart + 美國後端驗證。
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PKPushRegistryDelegate {
  private var voipRegistry: PKPushRegistry?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 保持原本的 Flutter 引擎初始化方式，避免破壞既有 Firebase/登入插件。
    let success = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    let registry = PKPushRegistry(queue: DispatchQueue.main)
    registry.delegate = self
    registry.desiredPushTypes = [.voIP]
    voipRegistry = registry   // 強參照，否則 PushKit delegate 可能被釋放
    return success
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  func pushRegistry(_ registry: PKPushRegistry,
                    didUpdate credentials: PKPushCredentials,
                    for type: PKPushType) {
    guard type == .voIP else { return }
    let token = credentials.token.map { String(format: "%02x", $0) }.joined()
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
    // Dart 將透過 getDevicePushTokenVoIP() 取得並送到後端；不在本機儲存 Apple 金鑰。
  }

  func pushRegistry(_ registry: PKPushRegistry,
                    didInvalidatePushTokenFor type: PKPushType) {
    guard type == .voIP else { return }
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
  }

  func pushRegistry(_ registry: PKPushRegistry,
                    didReceiveIncomingPushWith payload: PKPushPayload,
                    for type: PKPushType,
                    completion: @escaping () -> Void) {
    guard type == .voIP else { completion(); return }
    let data = payload.dictionaryPayload
    // 使用後端發送的 UUID，對照既有 agreementId 映射。
    guard let agreementId = data["agreementId"] as? String,
          agreementId.range(of: "^[a-f0-9]{64}$", options: .regularExpression) != nil,
          let characterId = data["characterId"] as? String,
          characterId.range(of: "^[A-Za-z0-9_-]{1,160}$", options: .regularExpression) != nil
    else { completion(); return }
    let chars = Array(agreementId.prefix(32))
    let id = String(chars[0..<8]) + "-" + String(chars[8..<12]) + "-" +
             String(chars[12..<16]) + "-" + String(chars[16..<20]) + "-" + String(chars[20..<32])
    let caller = (data["characterName"] as? String ?? "角色")
    let sessionId = (data["sessionId"] as? String ?? "")
    let call = flutter_callkit_incoming.Data(id: id, nameCaller: caller, handle: "拾光約定", type: 0)
    call.extra = ["type": "role_agreement_call", "agreementId": agreementId,
                  "characterId": characterId, "sessionId": sessionId]
    // iOS 13+ 必須立即交給 CallKit，否則系統可能終止 App。
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(call, fromPushKit: true)
    completion()
  }
}
