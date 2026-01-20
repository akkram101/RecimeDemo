//
//  ReciMeDemoApp.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI
import SwiftData

@main
struct ReciMeDemoApp: App {
    
    @State private var alert = AlertManager()
    @State private var showCase = ShowcaseManager()
   
    var body: some Scene {
        WindowGroup {
            RootView {
                MainTabView()
                    .environment(alert)
                    .environment(showCase)
            }
        }
    }
}
