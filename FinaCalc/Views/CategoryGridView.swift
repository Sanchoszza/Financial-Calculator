//
//  CategoryGridView.swift
//  FinaCalc
//
//  Created by Александра on 11.03.2025.
//


import SwiftUI

struct CategoryGridView: View {
    @Binding var selectedCategory: Category?
    let categories: [Category]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(categories) { category in
                CategoryButton(
                    category: category,
                    isSelected: selectedCategory?.id == category.id
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if selectedCategory?.id == category.id {
                            selectedCategory = nil
                        } else {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : Color(hex: category.color))
                
                Text(category.name)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: category.color) : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: category.color), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
