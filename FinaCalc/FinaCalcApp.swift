//
//  FinaCalcApp.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//

import SwiftUI

@main
struct FinaCalcApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
                .animation(.easeInOut(duration: 0.3), value: themeManager.isDarkMode)
                .onAppear {
                    // Убедимся, что тема применяется при запуске
                    UserDefaults.standard.synchronize()
                }
        }
    }
}
