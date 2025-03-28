//
//  TransactionManager.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import Foundation

class TransactionManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    private let transactionsKey = "savedTransactions"
    
    init() {
        loadTransactions()
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            saveTransactions()
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }
    
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    var totalBalance: Decimal {
        transactions.reduce(0) { result, transaction in
            result + (transaction.isIncome ? transaction.amount : -transaction.amount)
        }
    }
    
    func transactionsByCategory(_ category: Category) -> [Transaction] {
        transactions.filter { $0.category == category }
    }
    
    func totalForCategory(_ category: Category) -> Decimal {
        transactionsByCategory(category).reduce(0) { result, transaction in
            result + (transaction.isIncome ? transaction.amount : -transaction.amount)
        }
    }
    
    // Группировка транзакций по месяцам
    func groupedTransactions() -> [(String, [Transaction])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { transaction in
            let components = calendar.dateComponents([.year, .month], from: transaction.date)
            let year = components.year ?? 0
            let month = components.month ?? 0
            let currentYear = calendar.component(.year, from: Date())
            
            if year == currentYear {
                return calendar.monthSymbols[month - 1]
            } else {
                return "\(calendar.monthSymbols[month - 1]) \(year)"
            }
        }
        
        return grouped.sorted { $0.key > $1.key }
    }
    
    // Получение статистики за месяц
    func monthlyStats(for transactions: [Transaction]) -> (income: Decimal, expenses: Decimal) {
        let income = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        return (income, expenses)
    }
} 
