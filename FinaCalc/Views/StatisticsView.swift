//
//  StatisticsView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedMonth = Date()
    @State private var selectedChartType: ChartType = .expenses
    
    enum ChartType {
        case expenses
        case income
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    MonthSelector(selectedMonth: $selectedMonth)
                    
                    ChartTypeSelector(selectedType: $selectedChartType)
                    
                    ChartView(
                        data: categoryData(),
                        selectedType: selectedChartType
                    )
                    
                    CategoryList(
                        data: categoryData(),
                        selectedType: selectedChartType
                    )
                }
                .padding()
            }
            .navigationTitle("Статистика")
        }
    }
    
    private func categoryData() -> [(Category, Decimal)] {
        let data = dataManager.transactionsByCategory(for: selectedMonth)
        return data.map { ($0.key, $0.value) }
            .filter { selectedChartType == .expenses ? $0.0.type == .expense : $0.0.type == .income }
            .sorted { $0.1 > $1.1 }
    }
}

struct MonthSelector: View {
    @Binding var selectedMonth: Date
    
    var body: some View {
        DatePicker("Выберите месяц",
                  selection: $selectedMonth,
                  displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
    }
}

struct ChartTypeSelector: View {
    @Binding var selectedType: StatisticsView.ChartType
    
    var body: some View {
        Picker("Тип", selection: $selectedType) {
            Text("Расходы").tag(StatisticsView.ChartType.expenses)
            Text("Доходы").tag(StatisticsView.ChartType.income)
        }
        .pickerStyle(.segmented)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ChartView: View {
    let data: [(Category, Decimal)]
    let selectedType: StatisticsView.ChartType
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(selectedType == .expenses ? "Расходы по категориям" : "Доходы по категориям")
                .font(.headline)
                .padding(.bottom)
            
            if #available(iOS 16.0, *) {
                Chart(data, id: \.0.id) { item in
                    SectorMark(
                        angle: .value("Amount", NSDecimalNumber(decimal: item.1).doubleValue),
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .foregroundStyle(Color(hex: item.0.color))
                }
                .frame(height: 200)
            } else {
                Text("Charts доступны только в iOS 16 и выше")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct CategoryList: View {
    let data: [(Category, Decimal)]
    let selectedType: StatisticsView.ChartType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Детализация")
                .font(.headline)
            
            ForEach(data, id: \.0.id) { item in
                HStack {
                    Circle()
                        .fill(Color(hex: item.0.color))
                        .frame(width: 12, height: 12)
                    
                    Text(item.0.name)
                    
                    Spacer()
                    
                    Text(formatAmount(item.1))
                        .foregroundColor(.secondary)
                }
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

#Preview {
    StatisticsView()
} 
