import Cocoa
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    var statusItem: NSStatusItem?
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up the status bar item and menu
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star", accessibilityDescription: "Status Bar Icon")
            button.title = "Test"
            // button.action = #selector(showMenu)
        }
        
        startRepeatingAPICall()
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        center.delegate = self  // Set the delegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
        
        // Create the menu and add an action to call the API
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Fetch Data", action: #selector(fetchData), keyEquivalent: "f"))
        menu.addItem(NSMenuItem(title: "Console log", action: #selector(printStuff), keyEquivalent: "f"))
        menu.addItem(NSMenuItem(title: "Send Notification", action: #selector(sendNotification), keyEquivalent: "n"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem?.menu = menu
    }
    
    // Function to send a notification
    @objc func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "This is a notification from your macOS status bar app!"
        content.sound = .default

        // Create a trigger to send the notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create the request and add it to the notification center
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error posting notification: \(error)")
            }
        }
    }
    
    // Function to start the repeating API call
    func startRepeatingAPICall() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(printStuff), userInfo: nil, repeats: true)
        timer?.tolerance = 1.0  // Adds some flexibility to reduce system load
    }
    
    @objc func printStuff(){
        print("hello")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let formattedDate = formatter.string(from: Date())

        statusItem?.button?.title = formattedDate
    }

    @objc func fetchData() {
        // Define the URL for the API request
        guard let url = URL(string: "https://api.restful-api.dev/objects") else { return }
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Process the received data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
        
        // Start the task
        task.resume()
    }

    @objc func showApp() {
        // Implement the functionality to show your app's main view
    }
    
    @objc func quitApp(){
        NSApp.terminate(nil)
    }
}
