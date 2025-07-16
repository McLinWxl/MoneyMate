//
//  AddEditView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI
import SwiftData

struct AddEditView: View {
    @Environment(\.modelContext) var context
    @Binding var transaction: Transaction?
    @Environment(\.presentationMode) private var presentationMode

    @State private var title = ""
    @State private var amountText = ""
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("内容") {
                    TextField("标题", text: $title)
                }
                Section("金额") {
                    TextField("¥0.00", text: $amountText)
                        .keyboardType(.decimalPad)
                }
                Section("日期") {
                    DatePicker("", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle(transaction == nil ? "新增账单" : "编辑账单")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveAndDismiss()
                    }
                    .disabled(title.isEmpty || Double(amountText) == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .onAppear(perform: load)
    }

    private func load() {
        if let t = transaction {
            title = t.title
            amountText = String(format: "%.2f", t.amount)
            date = t.date
        }
    }

    private func saveAndDismiss() {
        let amt = Double(amountText) ?? 0
        if let t = transaction {
            t.title = title
            t.amount = amt
            t.date = date
        } else {
            let newT = Transaction(title: title, amount: amt, date: date)
            context.insert(newT)
        }

        do {
            try context.save()
            presentationMode.wrappedValue.dismiss() // 保存后返回账单列表
        } catch {
            print("⚠️ 保存失败: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Transaction.self, configurations: .init(isStoredInMemoryOnly: true))
    return AddEditView(transaction: .constant(nil)).modelContainer(container)
}
