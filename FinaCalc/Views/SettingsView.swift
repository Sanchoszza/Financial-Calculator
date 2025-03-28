//
//  SettingsView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency = "USD"
    @AppStorage("useBiometricAuth") private var useBiometricAuth = false
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showingExportSheet = false
    @State private var showingDeleteConfirmation = false
    
    private let currencies = ["USD", "EUR", "RUB", "GBP"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Основные настройки")) {
                    Picker("Валюта", selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    
                    Toggle("Темная тема", isOn: $themeManager.isDarkMode)
                    
                    Toggle("Face ID / Touch ID", isOn: $useBiometricAuth)
                }
                
                Section(header: Text("Данные")) {
                    Button("Экспорт данных") {
                        showingExportSheet = true
                    }
                    
                    Button("Резервное копирование") {
                        
                    }
                    
                    Button("Очистить все данные") {
                        showingDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("О приложении")) {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Политика конфиденциальности",
                         destination: URL(string: "https://example.com/privacy")!)
                    
                    Link("Условия использования",
                         destination: URL(string: "https://example.com/terms")!)
                }
            }
            .navigationTitle("Настройки")
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportView()
        }
        .alert("Подтверждение удаления", isPresented: $showingDeleteConfirmation) {
            Button("Отмена", role: .cancel) { }
            Button("Удалить", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("Вы уверены, что хотите удалить все данные? Это действие нельзя отменить.")
        }
    }
    
    private func clearAllData() {
        // Clear all UserDefaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        // Reset current settings to defaults
        selectedCurrency = "USD"
        useBiometricAuth = false
        
        // TODO: Clear any Core Data or other persistent storage if used
    }
}

struct ExportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Экспорт в CSV") {
                        // TODO: Implement CSV export
                    }
                    
                    Button("Экспорт в JSON") {
                        // TODO: Implement JSON export
                    }
                }
            }
            .navigationTitle("Экспорт данных")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
}

#Preview {
    SettingsView()
} 
