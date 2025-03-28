//
//  EditTransactionView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    
    let transaction: Transaction
    
    @State private var amount: String
    @State private var selectedCategory: Category?
    @State private var note: String
    @State private var date: Date
    @State private var transactionType: CategoryType
    @State private var showDateAlert = false
    
    init(transaction: Transaction) {
        self.transaction = transaction
        _amount = State(initialValue: transaction.amount.description)
        _selectedCategory = State(initialValue: transaction.category)
        _note = State(initialValue: transaction.note ?? "")
        _date = State(initialValue: transaction.date)
        _transactionType = State(initialValue: transaction.category.type)
    }
    
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
            .navigationTitle("Редактировать")
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
        
        let updatedTransaction = Transaction(
            id: transaction.id,
            amount: amountDecimal,
            category: category,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        dataManager.updateTransaction(updatedTransaction)
        dismiss()
    }
} 
