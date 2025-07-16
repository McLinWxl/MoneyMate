//
//  BillListView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI
import SwiftData

struct BillListView: View {
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]
    @Environment(\.modelContext) private var context
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { day in
                    Section(header: Text(day.formatted(date: .abbreviated, time: .omitted))) {
                        ForEach(groupedTransactions[day]!) { t in
                            Button {
                                selected = t
                                showingAdd = true
                            } label: {
                                HStack {
                                    Text(t.title)
                                    Spacer()
                                    Text("¥\(t.amount, specifier: "%.2f")")
                                }
                            }
                        }
                        .onDelete { delete(at: $0, in: groupedTransactions[day]!) }
                    }
                }
            }
            .navigationTitle("账单")
        }
    }

    @State private var selected: Transaction?

    private var groupedTransactions: [Date:[Transaction]] {
        Dictionary(grouping: transactions) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }

    private func delete(at offsets: IndexSet, in section: [Transaction]) {
        offsets.map { section[$0] }.forEach(context.delete)
    }
}

#Preview {
    let container = try! ModelContainer(for: Transaction.self, configurations: .init(isStoredInMemoryOnly: true))
    try! container.mainContext.insert(Transaction(title: "测试", amount: 50))
    return BillListView().modelContainer(container)
}
