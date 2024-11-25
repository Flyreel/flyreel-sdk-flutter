import Flutter
import UIKit
@_spi(FlyreelInternal) import Flyreel

public class FlyreelSdkFlutterPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flyreel_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = FlyreelSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "flyreel_sdk_stream", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(AnalyticsHandler())
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            let arguments = call.arguments as! [String: Any]
            let organizationId = arguments["organizationId"] as! String
            let settingsVersion = arguments["settingsVersion"] as! Int
            let environmentString = arguments["environment"] as! String
            
            let configuration = FlyreelConfiguration(
                settingsVersion: String(settingsVersion),
                organizationId: organizationId,
                environment: mapEnvironment(environment: environmentString)
            )
            
            FlyreelSDK.shared.set(configuration: configuration)
            result(nil)
        case "open":
            let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
            let arguments = call.arguments as! [String: Any]
            let deeplink = arguments["deeplinkUrl"] as? String
            let shouldSkipLoginPage = arguments["shouldSkipLoginPage"] as! Bool
            
            if let deeplinkURL = URL(string: deeplink ?? "") {
                FlyreelSDK.shared.presentFlyreel(on: rootView, deepLinkURL: deeplinkURL, shouldSkipLoginPage: shouldSkipLoginPage)
            } else {
                FlyreelSDK.shared.presentFlyreel(on: rootView)
            }
            result(nil)
        case "openWithCredentials":
            let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
            let arguments = call.arguments as! [String: Any]
            let zipCode = arguments["zipCode"] as! String
            let accessCode = arguments["accessCode"] as! String
            let shouldSkipLoginPage = arguments["shouldSkipLoginPage"] as! Bool
            FlyreelSDK.shared.presentFlyreel(on: rootView, zipCode: zipCode, accessCode: accessCode, shouldSkipLoginPage: shouldSkipLoginPage)
            
            result(nil)
        case "enableLogs":
            FlyreelSDK.shared.enableLogs()
            result(nil)
        case "checkStatus":
            let arguments = call.arguments as! [String: Any]
            let zipCode = arguments["zipCode"] as! String
            let accessCode = arguments["accessCode"] as! String
            FlyreelSDK.shared.fetchFlyreelStatus(zipCode: zipCode, accessCode: accessCode) { statusResult in
                switch statusResult {
                case .success(let flyreelStatus):
                    result(["status": flyreelStatus.status, "expiration": flyreelStatus.expiration])
                case .failure(let error):
                    if case FlyreelError.apiError(let message, let code) = error {
                        result(FlutterError(code: String(code), message: message, details: nil))
                    } else {
                        result(FlutterError(code: "500", message: "Unexpected error", details: nil))
                    }
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
 
    func mapEnvironment(environment: String) -> FlyreelEnvironment {
        switch environment {
        case "production":
            return .production
        case "sandbox":
            return .sandbox
        case "staging":
            return .staging
        default:
            return .production
        }
    }
}

class AnalyticsHandler: NSObject, FlutterStreamHandler {

       private var eventSink: FlutterEventSink?
       
       func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
           self.eventSink = eventSink
   
           FlyreelSDK.shared.observeAnalyticEvents { event in
               eventSink(event.toFlutterMap())
           }
           
       
           return nil
       }
       
       func onCancel(withArguments arguments: Any?) -> FlutterError? {
           eventSink = nil
           return nil
       }
}

extension FlyreelAnalyticEvent {
    func toFlutterMap() -> [String: Any?] {
        return [
            "user": user?.toFlutterMap(),
            "name": eventName,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "activeTime": activeTimeFromTrigger(),
            "coordination": coordinationFromTrigger()?.toFlutterMap(),
            "deviceData": deviceDataFromTrigger()?.toFlutterMap(),
            "messageDetails": messageDetailsFromTrigger()?.toFlutterMap()
        ]
    }

    private func activeTimeFromTrigger() -> TimeInterval? {
        switch trigger {
        case .questionAsked(let activeTime, _),
             .questionAnswered(let activeTime, _, _),
             .flyreelCompleted(let activeTime):
            return activeTime
        case .userLoggedIn:
            return nil
        }
    }

    private func coordinationFromTrigger() -> FlyreelCoordinate? {
        switch trigger {
        case .questionAnswered(_, let location, _),
             .userLoggedIn(_, _, let location, _):
            return location
        default:
            return nil
        }
    }

    private func deviceDataFromTrigger() -> FlyreelDeviceData? {
        switch trigger {
        case .userLoggedIn(_, let deviceData, _, _):
            return deviceData
        default:
            return nil
        }
    }

    private func messageDetailsFromTrigger() -> AnalyticMessageDetails? {
        switch trigger {
        case .questionAsked(_, let message),
             .questionAnswered(_, _, let message):
            return message
        default:
            return nil
        }
    }
}

extension FlyreelDeviceData {
    func toFlutterMap() -> [String: String?] {
        return [
            "phoneModel": phoneModel,
            "appVersion": appVersion,
            "appName": appName
        ]
    }
}

extension FlyreelCoordinate {
    func toFlutterMap() -> [String: Any] {
        return [
            "lat": lat,
            "lng": lng
        ]
    }
}

extension AnalyticMessageDetails {
    func toFlutterMap() -> [String: Any] {
        return [
            "message": message,
            "messageType": messageType,
            "moduleKey": moduleKey,
            "messageKey": messageKey,
            "phase": phase
        ]
    }
}

extension FlyreelAnalyticUser {
    func toFlutterMap() -> [String: Any?] {
        return [
            "id": flyreelID,
            "name": name,
            "email": email,
            "botId": botId,
            "botName": botName,
            "organizationId": organizationId,
            "status": status
        ]
    }
}
