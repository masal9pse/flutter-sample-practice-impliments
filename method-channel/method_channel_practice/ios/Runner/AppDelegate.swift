import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        // メソッドチャンネル名
        let METHOD_CHANNEL_NAME = "mukku.com/battery"
        // FlutterMethodChannel
        let batteryChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller as! FlutterBinaryMessenger)
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall,result: @escaping FlutterResult)->Void in
            //                  if methodCall
            switch call.method {
            case "getBatteryLevel":
                guard let args = call.arguments as? [String: String] else {return}
                let name = args["name"]!
                result("\(name) says \(self.receiveBatteryLevel())")
            case "printy":
                result("Hi from twitter")
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        //        batteryChannel.setMethodCallHandler {[unowned self] (methodCall,result) in
        //            if methodCall.method == "printy" {
        //                result("Hi from twitter")
        //            }
        //            if methodCall.method == "getBatteryLevel" {
        //                guard let args = methodCall.arguments as? [String: String] else {return}
        //                let name = args["name"]!
        //                result("\(name) says \(self.receiveBatteryLevel())")
        //            }
        //        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel() -> Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        if (device.batteryState == UIDevice.BatteryState.unknown) {
            return -1
        } else {
            return Int(device.batteryLevel * 100)
        }
    }
}
