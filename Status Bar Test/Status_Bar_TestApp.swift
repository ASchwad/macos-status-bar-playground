//
//  Status_Bar_TestApp.swift
//  Status Bar Test
//
//  Created by Alexander Schoenenwald on 01.11.24.
//

import SwiftUI

@main
struct Status_Bar_TestApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
