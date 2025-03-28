//
//  TransactionsListView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct TransactionsListView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingDeleteAlert = false
    @State private var transactionToDelete: Transaction?
    @State private var showingEditSheet = false
    @State private var transactionToEdit: Transaction?
    
    var body: some View {
        List {
            ForEach(dataManager.transactions) { transaction in
                TransactionListRow(transaction: transaction)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        transactionToEdit = transaction
                        showingEditSheet = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            transactionToDelete = transaction
                            showingDeleteAlert = true
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                        
                        Button {
                            transactionToEdit = transaction
                            showingEditSheet = true
                        } label: {
                            Label("Изменить", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        .alert("Удалить транзакцию?", isPresented: $showingDeleteAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Удалить", role: .destructive) {
                if let transaction = transactionToDelete {
                    dataManager.deleteTransaction(id: transaction.id)
                }
            }
        } message: {
            if let transaction = transactionToDelete {
                Text("Вы уверены, что хотите удалить транзакцию на сумму \(transaction.formattedAmount)?")
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            if let transaction = transactionToEdit {
                EditTransactionView(transaction: transaction)
            }
        }
    }
}

struct TransactionListRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.category.icon)
                .foregroundColor(Color(hex: transaction.category.color))
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category.name)
                    .font(.headline)
                
                HStack {
                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let note = transaction.note {
                        Text("• \(note)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Text(transaction.formattedAmount)
                .foregroundColor(transaction.isIncome ? .green : .red)
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
} 
