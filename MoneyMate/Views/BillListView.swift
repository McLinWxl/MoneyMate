//
//  BillListView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI
import SwiftData



struct BillListView: View {
    @Query var transactions: [Transaction]
    @State private var editingTransaction: Transaction?
    @State private var transactionToDelete: Transaction?
    @State private var showDeleteConfirmation = false
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                    transactionSection(for: date)
                }
            }
            .padding()
        }
        .navigationTitle("账单")
        .sheet(item: $editingTransaction) { transaction in
            NavigationStack {
                AddEditView(transaction: .constant(transaction))
                    .navigationTitle("编辑账单")
            }
        }
    }

    @ViewBuilder
    private func transactionSection(for date: Date) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
                .padding(.horizontal, 4)

            ForEach(groupedTransactions[date] ?? []) { transaction in
                Button {
                    editingTransaction = transaction
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(transaction.title)
                            .font(.body)
                        Text("\(transaction.currency)\(transaction.amount, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
//                            .shadow(radius: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var groupedTransactions: [Date: [Transaction]] {
        Dictionary(grouping: transactions) { Calendar.current.startOfDay(for: $0.date) }
    }

    @Environment(\.modelContext) private var context
}
