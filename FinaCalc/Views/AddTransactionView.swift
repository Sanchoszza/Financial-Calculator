//
//  AddTransactionView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    
    @State private var amount: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    @State private var date = Date()
    @State private var transactionType: CategoryType = .expense
    @State private var showDateAlert = false
    
    private var isCurrentMonth: Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        return calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    private var isSaveDisabled: Bool {
        selectedCategory == nil || amount.isEmpty || !isCurrentMonth
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Тип транзакции")) {
                    Picker("Тип", selection: $transactionType) {
                        Text("Расход").tag(CategoryType.expense)
                        Text("Доход").tag(CategoryType.income)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: transactionType) {
                        selectedCategory = nil
                    }
                }
                
                Section(header: Text("Детали")) {
                    TextField("Сумма", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Дата", selection: $date, displayedComponents: [.date])
                        .onChange(of: date) {
                            if !isCurrentMonth {
                                showDateAlert = true
                                date = Date() 
                            }
                        }
                    
                    TextField("Заметка", text: $note)
                }
                
                Section(header: Text("Категория")) {
//                    if let selected = selectedCategory {
//                        HStack {
//                            Image(systemName: selected.icon)
//                                .foregroundColor(Color(hex: selected.color))
//                            Text("Выбрано: \(selected.name)")
//                                .foregroundColor(.secondary)
//                        }
//                    }
                    
                    CategoryGridView(
                        selectedCategory: Binding(
                            get: { selectedCategory },
                            set: { newValue in
                                withAnimation {
                                    selectedCategory = newValue
                                }
                            }
                        ),
                        categories: transactionType == .expense ? Category.expenseCategories : Category.incomeCategories
                    )
                }
            }
            .navigationTitle("Новая транзакция")
            .navigationBarItems(
                leading: Button("Отмена") {
                    dismiss()
                },
                trailing: Button("Сохранить") {
                    saveTransaction()
                }
                .disabled(isSaveDisabled)
            )
            .alert("Ограничение даты", isPresented: $showDateAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Транзакции можно добавлять только в текущем месяце")
            }
        }
    }
    
    private func saveTransaction() {
        guard let category = selectedCategory,
              let amountDecimal = Decimal(string: amount.replacingOccurrences(of: ",", with: ".")),
              isCurrentMonth
        else { return }
        
        let transaction = Transaction(
            amount: amountDecimal,
            category: category,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        dataManager.addTransaction(transaction)
        dismiss()
    }
}

//struct CategoryGridView: View {
//    @Binding var selectedCategory: Category?
//    let categories: [Category]
//    @State private var localSelectedCategory: Category?
//    
//    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
//    
//    var body: some View {
//        LazyVGrid(columns: columns, spacing: 16) {
//            ForEach(categories) { category in
//                CategoryButton(
//                    category: category,
//                    isSelected: localSelectedCategory?.name == category.name && localSelectedCategory?.type == category.type
//                ) {
//                    localSelectedCategory = category
//                    selectedCategory = category
//                }
//            }
//        }
//        .padding(.vertical, 8)
//        .onAppear {
//            localSelectedCategory = selectedCategory
//        }
//        .onChange(of: selectedCategory) { newValue in
//            localSelectedCategory = newValue
//        }
//    }
//}
//
//struct CategoryButton: View {
//    let category: Category
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack {
//                Image(systemName: category.icon)
//                    .font(.system(size: 24))
//                    .foregroundColor(isSelected ? .white : Color(hex: category.color))
//                    .frame(width: 44, height: 44)
//                    .background(
//                        Circle()
//                            .fill(isSelected ? Color(hex: category.color) : Color(.systemBackground))
//                    )
//                    .overlay(
//                        Circle()
//                            .stroke(Color(hex: category.color), lineWidth: 2)
//                    )
//                
//                Text(category.name)
//                    .font(.caption)
//                    .foregroundColor(.primary)
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.8)
//            }
//        }
//    }
//}

#Preview {
    AddTransactionView()
} 
