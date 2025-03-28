//
//  HomeView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct HomeView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedMonth = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    BalanceCard(balance: dataManager.totalBalance())
                    
                    MonthlyBalanceView(
                        selectedMonth: $selectedMonth,
                        monthlyBalance: dataManager.monthlyBalance(for: selectedMonth)
                    )
                    
                    NavigationLink {
                        TransactionsListView()
                            .navigationTitle("Транзакции")
                    } label: {
                        HStack {
                            Text("Все транзакции")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    RecentTransactionsView(transactions: Array(dataManager.transactions.prefix(3)))
                }
                .padding()
            }
            .navigationTitle("FinaCalc")
        }
    }
}

struct BalanceCard: View {
    let balance: Decimal
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Общий баланс")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(formatAmount(balance))
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(balance >= 0 ? .green : .red)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSNumber) ?? "\(amount)"
    }
}

struct MonthlyBalanceView: View {
    @Binding var selectedMonth: Date
    let monthlyBalance: Decimal
    
    var body: some View {
        VStack(spacing: 10) {
            DatePicker("Выберите месяц",
                      selection: $selectedMonth,
                      displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
            
            HStack {
                Text("Баланс за месяц:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatAmount(monthlyBalance))
                    .font(.headline)
                    .foregroundColor(monthlyBalance >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSNumber) ?? "\(amount)"
    }
}

struct RecentTransactionsView: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Последние транзакции")
                .font(.headline)
            
            ForEach(transactions.prefix(5)) { transaction in
                TransactionRow(transaction: transaction)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.category.icon)
                .foregroundColor(Color(hex: transaction.category.color))
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(transaction.category.name)
                    .font(.subheadline)
                if let note = transaction.note {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(transaction.formattedAmount)
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
        .padding(.vertical, 5)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HomeView()
} 
