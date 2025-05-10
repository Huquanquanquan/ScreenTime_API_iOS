import DeviceActivity
import FamilyControls
import Flutter
import ManagedSettings
import SwiftUI
import UIKit

var globalMethodCall = ""
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        // 方法通道名称
        let METHOD_CHANNEL_NAME = "flutter_screentime"
        // Flutter方法通道
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller as! FlutterBinaryMessenger)

        let model = MyModel.shared
        let store = ManagedSettingsStore()
                
        // 使用setMethodCallHandler注册回调
        methodChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            Task {
                print("Task")
                do {
                    if #available(iOS 16.0, *) {
                        print("try requestAuthorization")
                        try await AuthorizationCenter.shared.requestAuthorization(for: FamilyControlsMember.individual)
                        print("requestAuthorization success")
                        switch AuthorizationCenter.shared.authorizationStatus {
                        case .notDetermined:
                            print("not determined")
                        case .denied:
                            print("denied")
                        case .approved:
                            print("approved")
                        @unknown default:
                            break
                        }
                    } else {
                        // 在较早版本上的后备方案
                    }
                } catch {
                    print("Error requestAuthorization: ", error)
                }
            }
            switch call.method {
            case "selectApps":
                // 显示应用选择器界面，只选择应用但不应用限制
                globalMethodCall = call.method
                
                // 显示应用选择器界面
                let presentContentView = {
                    let vc = UIHostingController(rootView: ContentView()
                        .environmentObject(model)
                        .environmentObject(store))
                    controller.present(vc, animated: false, completion: nil)
                }
                
                // 如果已经有界面在展示，先关闭再打开新界面
                if controller.presentedViewController != nil {
                    controller.dismiss(animated: false) {
                        presentContentView()
                    }
                } else {
                    presentContentView()
                }
                
                print("显示应用选择界面 - 用户将选择要允许的应用")
                result(nil)
                
            case "applyRestrictions":
                // 应用限制：选中的应用不被禁止，其他应用被禁止
                model.setAllowedApps()
                print("应用限制已生效")
                result(nil)
                
            case "removeRestrictions":
                // 解除所有限制
                model.clearAllShields()
                print("所有限制已解除")
                result(nil)
                
            default:
                print("no method")
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

}
