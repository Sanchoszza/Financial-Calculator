//
//  DataManager.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//

import CoreData
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var transactions: [Transaction] = []
    
    private let container: NSPersistentContainer
    private let containerName = "FinaCalc"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
        }
        fetchTransactions()
    }
    
    // MARK: - CRUD Operations
    
    func addTransaction(_ transaction: Transaction) {
        let entity = TransactionEntity(context: container.viewContext)
        entity.id = transaction.id
        entity.amount = transaction.amount as NSDecimalNumber
        entity.date = transaction.date
        entity.note = transaction.note
        entity.categoryName = transaction.category.name
        entity.categoryType = transaction.category.type.rawValue
        entity.categoryIcon = transaction.category.icon
        entity.categoryColor = transaction.category.color
        
        save()
        fetchTransactions()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let entity = fetchTransactionEntity(id: transaction.id) {
            entity.amount = transaction.amount as NSDecimalNumber
            entity.date = transaction.date
            entity.note = transaction.note
            entity.categoryName = transaction.category.name
            entity.categoryType = transaction.category.type.rawValue
            entity.categoryIcon = transaction.category.icon
            entity.categoryColor = transaction.category.color
            
            save()
            fetchTransactions()
        }
    }
    
    func deleteTransaction(id: UUID) {
        if let entity = fetchTransactionEntity(id: id) {
            container.viewContext.delete(entity)
            save()
            fetchTransactions()
        }
    }
    
    // MARK: - Helper Methods
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to CoreData: \(error)")
        }
    }
    
    private func fetchTransactions() {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)]
        
        do {
            let entities = try container.viewContext.fetch(request)
            transactions = entities.map { entity in
                let categoryType = CategoryType(rawValue: entity.categoryType ?? "") ?? .expense
                let categoryName = entity.categoryName ?? ""
                
                // Try to find predefined category first
                let category = Category.findPredefinedCategory(name: categoryName, type: categoryType) ??
                    Category(
                        id: UUID(),
                        name: categoryName,
                        type: categoryType,
                        icon: entity.categoryIcon ?? "questionmark.circle.fill",
                        color: entity.categoryColor ?? "#CCCCCC"
                    )
                
                return Transaction(
                    id: entity.id ?? UUID(),
                    amount: (entity.amount ?? 0) as Decimal,
                    category: category,
                    date: entity.date ?? Date(),
                    note: entity.note
                )
            }
        } catch {
            print("Error fetching from CoreData: \(error)")
        }
    }
    
    private func fetchTransactionEntity(id: UUID) -> TransactionEntity? {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let entities = try container.viewContext.fetch(request)
            return entities.first
        } catch {
            print("Error fetching entity from CoreData: \(error)")
            return nil
        }
    }
    
    // MARK: - Statistics
    
    func totalBalance() -> Decimal {
        transactions.reduce(0) { $0 + ($1.isIncome ? $1.amount : -$1.amount) }
    }
    
    func monthlyBalance(for date: Date = Date()) -> Decimal {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return transactions
            .filter {
                let components = calendar.dateComponents([.month, .year], from: $0.date)
                return components.month == month && components.year == year
            }
            .reduce(0) { $0 + ($1.isIncome ? $1.amount : -$1.amount) }
    }
    
    func transactionsByCategory(for date: Date = Date()) -> [Category: Decimal] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return transactions
            .filter {
                let components = calendar.dateComponents([.month, .year], from: $0.date)
                return components.month == month && components.year == year
            }
            .reduce(into: [:]) { result, transaction in
                result[transaction.category, default: 0] += transaction.amount
            }
    }
} 
