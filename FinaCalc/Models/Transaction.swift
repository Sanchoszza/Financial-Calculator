//
//  Transaction.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    var amount: Decimal
    var category: Category
    var date: Date
    var note: String?
    
    init(id: UUID = UUID(), amount: Decimal, category: Category, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.amount = try container.decode(Decimal.self, forKey: .amount)
        self.category = try container.decode(Category.self, forKey: .category)
        self.date = try container.decode(Date.self, forKey: .date)
        self.note = try container.decode(String?.self, forKey: .note)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case amount
        case category
        case date
        case note
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.note, forKey: .note)
    }
}

// MARK: - Helper Methods
extension Transaction {
    var isExpense: Bool {
        category.type == .expense
    }
    
    var isIncome: Bool {
        category.type == .income
    }
    
    var formattedAmount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        
        let number = NSDecimalNumber(decimal: amount)
        return numberFormatter.string(from: number) ?? "\(amount)"
    }
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter.string(from: date)
    }
}
