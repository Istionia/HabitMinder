//
//  HabitMinderApp.swift
//  HabitMinder
//
//  Created by Timothy on 24/06/2023.
//

import SwiftUI
import FirebaseCore
import UIKit

@available(macOS 13.0, *)
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    print("HabitMinder is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    FirebaseApp.configure()
    return true
  }
}

@main
struct HabitMinderApp: App {
    /// Store the data controller.
    ///
    /// This means our app will create and own the data controller, running it as long as the app runs.
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView(dataController: dataController)
            } content: {
                WelcomeView(dataController: dataController)
            } detail: {
                DetailView()
            }
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onChange(of: scenePhase) { phase in
                    if phase != .active {
                        dataController.save()
                    }
                }
        }
    }
}
