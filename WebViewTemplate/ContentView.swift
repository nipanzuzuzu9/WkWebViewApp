import UIKit
import WebKit
import UserNotifications

class ViewController: UIViewController, WKScriptMessageHandler {

   var webView: WKWebView!

   override func viewDidLoad() {
       super.viewDidLoad()

       // Configure WebView
       let contentController = WKUserContentController()
       contentController.add(self, name: "scheduleNotification")

       let config = WKWebViewConfiguration()
       config.userContentController = contentController

       webView = WKWebView(frame: self.view.bounds, configuration: config)
       webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       self.view.addSubview(webView)

       // Load local HTML from nested folder
       if let indexURL = Bundle.main.url(forResource: "html/index",
                                         withExtension: "html",
                                         subdirectory: "WebViewTemplate/WebResources") {
           webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL.deletingLastPathComponent())
       } else {
           print("Failed to load index.html")
       }

       // Request notification permissions
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
           if granted {
               print("Notifications allowed")
           } else if let error = error {
               print("Notification permission error: \(error.localizedDescription)")
           }
       }
   }

   // Handle messages from JS
   func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       if message.name == "scheduleNotification",
          let body = message.body as? [String: Any] {
           scheduleNotification(body: body)
       }
   }

   // Schedule local notification
   func scheduleNotification(body: [String: Any]) {
       guard let title = body["title"] as? String,
             let bodyText = body["body"] as? String,
             let time = body["time"] as? Double else {
           print("Invalid notification data")
           return
       }

       let content = UNMutableNotificationContent()
       content.title = title
       content.body = bodyText
       content.sound = .default

       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
       let request = UNNotificationRequest(identifier: UUID().uuidString,
                                           content: content,
                                           trigger: trigger)

       UNUserNotificationCenter.current().add(request) { error in
           if let error = error {
               print("Notification error: \(error.localizedDescription)")
           } else {
               print("Notification scheduled in \(time) seconds")
           }
       }
   }
}
