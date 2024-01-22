import Flutter
import UIKit
import Flyreel

public class FlyreelSdkFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flyreel_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = FlyreelSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            
            let arguments = call.arguments as [String: Any]
            let organizationId = arguments["organizationId"] as String
            let settingsVersion = arguments["settingsVersion"] as Int
            let environmentString = arguments["environment"] as String
            
            let configuration = FlyreelConfiguration(
                settingsVersion: String(settingsVersion),
                organizationId: organizationId,
                environment: mapEnvironment(environment: environmentString)
            )
            
            FlyreelSDK.shared.set(configuration: configuration)
            result(nil)
        case "open":
            FlyreelSDK.presentFlyreel(on: rootViewController)
            result(nil)
        case "enableDebugLogging":
            FlyreelSDK.shared.enableLogs()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func mapEnvironment(environment: String) throws -> FlyreelEnvironment {
        switch environment {
        case "production":
            return .Production
        case "sandbox":
            return .Sandbox
        default:
            throw NSError(domain: "FlyreelSDK", code: 1, userInfo: [NSLocalizedDescriptionKey: "Wrong Flyreel environment"])
        }
    }
}
