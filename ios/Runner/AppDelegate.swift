import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    //google map Api key for ios running
    GMSServices.provideAPIKey("AIzaSyB2E_kHKnJsTdyd7y4JalHRRBUT-5mGm74")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
