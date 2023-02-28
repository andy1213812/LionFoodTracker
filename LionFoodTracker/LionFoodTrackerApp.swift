//
//  LionFoodTrackerApp.swift
//  LionFoodTracker
//
//  Created by yuan chen on 2/15/23.
//

import SwiftUI

@main
struct MyApp: App {
    @State var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                FancyLoadingView()
                    .onAppear {
                        // Put loading logic here
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isLoading = false
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
