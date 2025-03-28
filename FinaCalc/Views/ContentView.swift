//
//  ContentView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedTab = 0
    @State private var showingAddTransaction = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Label("Статистика", systemImage: "chart.pie.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
                .tag(2)
        }
        .overlay(alignment: .bottom) {
            if selectedTab != 2 {
                AddTransactionButton(showingAddTransaction: $showingAddTransaction)
                    .padding(.bottom, 60)
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
    }
}

struct AddTransactionButton: View {
    @Binding var showingAddTransaction: Bool
    
    var body: some View {
        Button {
            showingAddTransaction = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 55, height: 55)
                .foregroundColor(.accentColor)
                .background(Color(.systemBackground))
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

#Preview {
    ContentView()
} 
