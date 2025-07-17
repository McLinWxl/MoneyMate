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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState

    @State private var currency = "¥" // 默认人民币
    @State private var title = ""
    @State private var amountText = ""
    @State private var date = Date()
    @Query var accountTypes: [AccountType]
    @State private var account: AccountType?
    @State private var isExpense = true
    @State private var time = Date()
    @State private var desc = ""
    @State private var isAddingAccountType = false
    @State private var newAccountTypeDesc = ""
    @State private var newAccountBalance: String = ""
    @State private var newAccountDesc: String = ""
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                billInfoSection()

                
                AccountPickerView(account: $account,
                                  accountTypes: accountTypes,
                                  isAddingAccountType: $isAddingAccountType,
                                  newAccountTypeDesc: $newAccountTypeDesc,
                                  newAccountBalance: $newAccountBalance,
                                  newAccountDesc: $newAccountDesc,
                                  addNewAccountType: addNewAccountType)
                
                dateSection()
                noteSection()
            }
            .navigationTitle(transaction == nil ? "新增账单" : "编辑账单")
        }
        .presentationDetents([.large])
        .safeAreaInset(edge: .bottom) {
            deleteAndSaveView(isEnabled: !(title.isEmpty || amountText.isEmpty || isAddingAccountType ))
        }
        .safeAreaPadding(.bottom)
        .onAppear {
            if account == nil, let first = accountTypes.first {
                account = first
            }
            
            if let t = transaction {
                title = t.title
                amountText = String(format: "%.2f", abs(t.amount))
                date = t.date
                account = t.account
                isExpense = t.isExpense
                time = t.time
                desc = t.desc
                currency = t.currency
            }
        }
    }
    
    private func triggerFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    @ViewBuilder
    private func deleteAndSaveView(isEnabled: Bool) -> some View {
        HStack {
            Button(role: .destructive) {
                triggerFeedback()  // 添加震动
                showDeleteConfirmation = true
            } label: {
                Text("删除账单")
                    .foregroundStyle(.background)
                    .fontWeight(.black)
                    .font(.body)
                    .padding()
                    .glassEffect(.regular.tint(isEnabled ? .red.opacity(0.9) : .red).interactive())
            }
            .alert("确认删除？", isPresented: $showDeleteConfirmation) {
                deleteAlert()
            } message: {
                Text("此操作无法撤销。")
            }
            .padding(.leading, 35)
            
            Spacer(minLength: 0)
            
            saveButton(isEnabled: isEnabled)
                .padding(.trailing, 35)
        }
    }
    
    private func deleteAlert() -> some View {
        Group {
            Button("删除", role: .destructive) {
                if let tx = transaction {
                    context.delete(tx)
                    try? context.save()
//                    appState.selectedTab = 1
                }
                dismiss()
            }
            Button("取消", role: .cancel) { }
        }
    }
    
    private func billInfoSection() -> some View {
        Section() {
            Picker("账单类型", selection: $isExpense) {
                Text("支出").tag(true)
                Text("收入").tag(false)
            }
            .pickerStyle(.segmented)
            
            
            HStack {
                Text("账单内容")
                Spacer()
                TextField("请输入", text: $title)
                    .multilineTextAlignment(.trailing)
                    .submitLabel(.done)
            }
            .contentShape(Rectangle())
            
            HStack {
                Text("账单金额")
                Spacer()
                HStack {
                    if !amountText.isEmpty {
                        Text("¥")
                            .foregroundColor(.secondary)
                    }
                    TextField("请输入金额", text: $amountText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .submitLabel(.done)
                    Text("CNY")
                        .fontWeight(.bold)
                        .font(.footnote)
                }
            }
            .contentShape(Rectangle())
        }
    }
    
    private func dateSection() -> some View {
        Section("日期和时间") {
            HStack(alignment: .center) {
                Text(relativeDayDescription)
                    .foregroundColor(.primary)
                    .frame(minWidth: 60, alignment: .leading)
                Spacer(minLength: 0)
                DatePicker("", selection: $date, displayedComponents: .date)
                    .environment(\.locale, Locale(identifier: "zh_CN"))
                    .labelsHidden()

                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "zh_CN"))
                    .labelsHidden()
            }
        }
    }
    
    private func noteSection() -> some View {
        Section("备注") {
            TextField("备注", text: $desc)
                .submitLabel(.done)
        }
    }
    
    private func saveButton(isEnabled: Bool) -> some View {
        Button() {
            saveAndDismiss()
            triggerFeedback()  // 添加震动
        } label: {
            Text("保存账单")
                .foregroundStyle(.background)
                .fontWeight(.black)
                .font(.body)
                .padding()
                .glassEffect(.regular.tint(isEnabled ? .orange : .gray).interactive())
        }
        .disabled(!isEnabled)
    }

    private func saveAndDismiss() {
        if let t = transaction, let account = account {
            updateExistingTransaction(t, with: account)
        } else if let account = account {
            createNewTransaction(with: account)
        }

        do {
            try context.save()
            dismiss() // 保存后返回账单列表
        } catch {
            print("⚠️ 保存失败: \(error.localizedDescription)")
        }
    }

    private func updateExistingTransaction(_ t: Transaction, with account: AccountType) {
        let oldSignedAmount = t.isExpense ? -t.amount : t.amount
        t.account.balance -= oldSignedAmount

        let amt = Double(amountText) ?? 0
        t.title = title
        t.amount = isExpense ? -amt : amt
        t.date = date
        t.account = account
        t.isExpense = isExpense
        t.time = time
        t.desc = desc
        t.account.balance += t.amount
    }

    private func createNewTransaction(with account: AccountType) {
        let amt = Double(amountText) ?? 0
        let signedAmount = isExpense ? -amt : amt
        let newT = Transaction(title: title, amount: signedAmount, date: date, account: account, isExpense: isExpense, time: time, desc: desc)
        context.insert(newT)
        account.balance += signedAmount
        transaction = newT
    }

    private func addNewAccountType() {
        guard !newAccountTypeDesc.isEmpty else { return }

        // 自动重命名：防止重复
        var finalName = newAccountTypeDesc
        var suffix = 1
        while accountTypes.contains(where: { $0.name == finalName }) {
            finalName = "\(newAccountTypeDesc)\(suffix)"
            suffix += 1
        }

        let balance = Double(newAccountBalance) ?? 0
        let customType = AccountType(name: finalName, balance: balance, desc: desc)
        context.insert(customType)
        account = customType
        newAccountTypeDesc = ""
        newAccountBalance = ""

        do {
            try context.save()
        } catch {
            print("⚠️ 保存账户失败: \(error.localizedDescription)")
        }
    }
    

    private var relativeDayDescription: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "今天"
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else if calendar.isDateInTomorrow(date) {
            return "明天"
        } else if let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: calendar.startOfDay(for: Date())).day {
            if days > 0 {
                return "\(days)天前"
            } else {
                return "\(-days)天后"
            }
        } else {
            return ""
        }
    }
}

struct AccountPickerView: View {
    @Binding var account: AccountType?
    let accountTypes: [AccountType] // from @Query
    @Binding var isAddingAccountType: Bool
    @Binding var newAccountTypeDesc: String
    @Binding var newAccountBalance: String
    @Binding var newAccountDesc: String
    let addNewAccountType: () -> Void

    var body: some View {
            if accountTypes.isEmpty {
                HStack{
                    Text("账户类型")
                    Spacer(minLength: 0)
                    Button("添加账户") {
                        isAddingAccountType = true
                    }
                    .alert("添加新账户", isPresented: $isAddingAccountType) {
                        TextField("账户名称", text: $newAccountTypeDesc)
                        TextField("初始余额", text: $newAccountBalance)
                        TextField("账户说明", text: $newAccountDesc)
                            .keyboardType(.decimalPad)
                        Button("保存", action: addNewAccountType)
                        Button("取消", role: .cancel) { }
                    }
                }
                
            } else if !accountTypes.isEmpty {
                Picker("账户类型", selection: Binding(get: {
                    account ?? accountTypes.first!
                }, set: { newValue in
                    self.account = newValue
                })) {
                    ForEach(accountTypes, id: \.self) { type in
                        Text(type.desc).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
        }
}

#Preview {
    let container = try! ModelContainer(for: Transaction.self, AccountType.self, configurations: .init(isStoredInMemoryOnly: true))
    return AddEditView(transaction: .constant(nil)).modelContainer(container)
}
