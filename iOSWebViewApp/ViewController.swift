import UIKit
import WebKit
import UserNotifications

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UNUserNotificationCenterDelegate {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupNotifications()
    }

    func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "pushNotification")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Load local HTML file
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent().deletingLastPathComponent())
        } else {
            print("index.html not found")
        }
    }

    func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView failed to load with error: \(error.localizedDescription)")
    }

    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "pushNotification" {
            if let body = message.body as? [String: Any], let messageText = body["message"] as? String, let delayMinutes = body["delay"] as? Double {
                scheduleNotification(message: messageText, delayMinutes: delayMinutes)
            }
        }
    }

    func scheduleNotification(message: String, delayMinutes: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Notification from WebView"
        content.body = message
        content.sound = .default

        let trigger: UNNotificationTrigger
        if delayMinutes == 0 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger immediately
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: delayMinutes * 60, repeats: false)
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled: \(message) in \(delayMinutes) minutes")
            }
        }
    }
}


