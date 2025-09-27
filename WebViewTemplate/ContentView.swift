import SwiftUI

// This wraps your UIKit ViewController so it can be used in SwiftUI
struct ContentView: UIViewControllerRepresentable {
   func makeUIViewController(context: Context) -> ViewController {
       return ViewController()
   }

   func updateUIViewController(_ uiViewController: ViewController, context: Context) {
       // No updates needed for now
   }
}
