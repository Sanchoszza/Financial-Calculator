//
//  Category.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import Foundation

enum CategoryType: String, Codable {
    case income
    case expense
}

struct Category: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let type: CategoryType
    let icon: String
    let color: String
    
    init(id: UUID = UUID(), name: String, type: CategoryType, icon: String, color: String) {
        self.id = id
        self.name = name
        self.type = type
        self.icon = icon
        self.color = color
    }
    
    // MARK: - Hashable & Equatable
    static func == (lhs: Category, rhs: Category) -> Bool {
//        print("Comparing categories:")
//        print("LHS: name=\(lhs.name), type=\(lhs.type)")
//        print("RHS: name=\(rhs.name), type=\(rhs.type)")
        let result = lhs.name == rhs.name && lhs.type == rhs.type
//        print("Result: \(result)")
        return result
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
    }
    
    // MARK: - Helper Methods
    static func findPredefinedCategory(name: String, type: CategoryType) -> Category? {
        print("Finding predefined category: name=\(name), type=\(type)")
        let result: Category?
        if type == .expense {
            result = expenseCategories.first { $0.name == name }
        } else {
            result = incomeCategories.first { $0.name == name }
        }
        print("Found: \(String(describing: result?.name))")
        return result
    }
}

// MARK: - Predefined Categories
extension Category {
    static let expenseCategories: [Category] = [
        Category(name: "Дом", type: .expense, icon: "house.fill", color: "#FF6B6B"),
        Category(name: "Здоровье", type: .expense, icon: "heart.fill", color: "#4ECDC4"),
        Category(name: "Развлечения", type: .expense, icon: "gamecontroller.fill", color: "#45B7D1"),
        Category(name: "Счета", type: .expense, icon: "doc.text.fill", color: "#96CEB4"),
        Category(name: "Животные", type: .expense, icon: "pawprint.fill", color: "#FFEEAD"),
        Category(name: "Спорт", type: .expense, icon: "figure.run", color: "#D4A5A5"),
        Category(name: "Автомобиль", type: .expense, icon: "car.fill", color: "#9B9B9B"),
        Category(name: "Подарки", type: .expense, icon: "gift.fill", color: "#FF9999"),
        Category(name: "Транспорт", type: .expense, icon: "bus.fill", color: "#66B2B2"),
        Category(name: "Такси", type: .expense, icon: "car.circle.fill", color: "#FFCC00"),
        Category(name: "Одежда", type: .expense, icon: "tshirt.fill", color: "#FF99CC"),
        Category(name: "Связь", type: .expense, icon: "phone.fill", color: "#99FF99"),
        Category(name: "Путешествия", type: .expense, icon: "airplane", color: "#9999FF"),
        Category(name: "Продукты", type: .expense, icon: "cart.fill", color: "#FFCC99"),
        Category(name: "Образование", type: .expense, icon: "book.fill", color: "#CC99FF"),
        Category(name: "Бизнес", type: .expense, icon: "briefcase.fill", color: "#99CCFF"),
        Category(name: "Другое", type: .expense, icon: "ellipsis.circle.fill", color: "#CCCCCC")
    ]
    
    static let incomeCategories: [Category] = [
        Category(name: "Зарплата", type: .income, icon: "dollarsign.circle.fill", color: "#50C878"),
        Category(name: "Премии", type: .income, icon: "star.fill", color: "#FFD700"),
        Category(name: "Подработки", type: .income, icon: "briefcase.fill", color: "#87CEEB"),
        Category(name: "Инвестиции", type: .income, icon: "chart.line.uptrend.xyaxis", color: "#20B2AA"),
        Category(name: "Другое", type: .income, icon: "plus.circle.fill", color: "#B8860B")
    ]
} 
