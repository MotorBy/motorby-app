import UIKit
import Flutter
import UserNotifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
     let dict = NSDictionary(contentsOfFile: path),
   
    let apiKey = dict["GOOGLE_MAPS_API_KEY"] as? String {
            GMSServices.provideAPIKey(apiKey)
        }
      // Lets scheduled reminders present while Motorby is open.
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
