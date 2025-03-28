//
//  ThemeManager.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") private var storedIsDarkMode: Bool = false
    
    var isDarkMode: Bool {
        get {
            storedIsDarkMode
        }
        set {
            storedIsDarkMode = newValue
        }
    }
    
    static let shared = ThemeManager()
    
    private init() {
        // Инициализация при создании
        storedIsDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDarkMode.toggle()
        }
    }
} 
