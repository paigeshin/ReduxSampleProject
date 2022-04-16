//
//  TestApp.swift
//  Test
//
//  Created by paige shin on 2022/04/16.
//

import SwiftUI
import ReduxStore

@main
struct TestApp: App {
    
    @StateObject private var store: Store = Store(reducer: appReducer, state: AppState(), middlewares: [
        logMiddleware(),
        incrementMiddleware()
    ])
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
