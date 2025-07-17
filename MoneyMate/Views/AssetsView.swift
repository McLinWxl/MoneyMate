//
//  AssetsView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI
import SwiftData

struct AssetsView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @State private var accountRefreshToken = UUID()
    
    private var accountSummaries: [String: Double] {
        let _ = accountRefreshToken // trigger recomputation when token changes
        guard !transactions.isEmpty else { return [:] }
        var balances: [String: Double] = [:]
        for transaction in transactions {
            let name = transaction.account.name
            let balance = transaction.account.balance
            balances[name] = balance
        }
        return balances
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AccountSummaryView(refreshToken: $accountRefreshToken)
                }
                .padding()
            }
            .navigationTitle("资产概览")
        }
    }
}

struct AssetSectionView: View {
    let accounts: [AccountType]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let sortedAccounts = accounts.sorted(by: { $0.name < $1.name })
            ForEach(sortedAccounts) { account in
                NavigationLink(destination: AccountDetailView(account: account)) {
                    HStack{
                        VStack(alignment: .leading, spacing: 4) {
                            Text(account.name)
                                .font(.headline)
                            Text(String(format: "余额：%.2f CNY", account.balance))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 15)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .glassEffect(.regular.tint(.orange).interactive(), in: .rect(cornerRadius: 10))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                
            }
        }
    }
}

struct AccountSummaryView: View {
    @Query private var accounts: [AccountType]
    @Query var transactions: [Transaction]
    @Binding var refreshToken: UUID
    
    @State private var showAddAccountSheet = false
    @State private var selectedAccountName: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if accounts.isEmpty {
                    VStack{
                        HStack(alignment: .bottom) {
                            Text("中国银行-示例")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer(minLength: 0)
                            Text(String(format: "¥ %.2f", 999.99))
                                .font(.title2)
                                .italic()
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding(.trailing)
                        }
                        .padding(.leading)
                        .padding(.top)
                        Spacer(minLength: 20)
                        HStack(alignment: .bottom) {
                            Text("工资卡")
                            Spacer(minLength: 0)
                        }
                        .padding(.leading)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(.regular.tint(.red.opacity(0.5)), in: .rect(cornerRadius: 10))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                } else {
                    AssetSectionView(accounts: accounts)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .sheet(isPresented: $showAddAccountSheet) {
                AddAccountView(
                    onDismiss: { showAddAccountSheet = false },
                    onRefresh: { refreshToken = UUID() }
                )
                .presentationDetents([.medium])
            }
            .safeAreaInset(edge: .bottom) {
                Button{
                    showAddAccountSheet = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.background)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .frame(width: 70, height: 70)
                }
                .glassEffect(.regular.tint(.orange).interactive())
            }
        }
    }
}

struct AccountDetailView: View {
    var account: AccountType

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("账户名：\(account.name)")
                .font(.title2)
            Text(String(format: "账户余额：%.2f", account.balance))
                .font(.title3)

            Spacer()
        }
        .padding()
        .navigationTitle("账户详情")
    }
}

struct AddAccountView: View {
    @Environment(\.modelContext) private var context
    @Query private var accounts: [AccountType]
    @State private var accountName: String = ""
    @State private var initialBalanceText: String = ""
    @State private var desc: String = ""
    var onDismiss: () -> Void
    var onRefresh: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("账户名称")) {
                    TextField("请输入账户名称", text: $accountName)
                }
                
                Section(header: Text("初始余额")) {
                    TextField("请输入初始余额", text: $initialBalanceText)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("账户描述")) {
                    TextField("请输入账户描述", text: $desc)
                }

                Section {
                    Button("保存") {
                        let baseName = accountName.trimmingCharacters(in: .whitespaces)
                        var finalName = baseName
                        var suffix = 2
                        while accounts.contains(where: { $0.name == finalName }) {
                            finalName = "\(baseName)\(suffix)"
                            suffix += 1
                        }

                        let balance = Double(initialBalanceText) ?? 0
                        let newAccount = AccountType(name: finalName, balance: balance, desc: desc)
                        context.insert(newAccount)
                        try? context.save()
                        onRefresh()
                        onDismiss()
                    }
                    .disabled(accountName.trimmingCharacters(in: .whitespaces).isEmpty)

                    Button("取消", role: .cancel) {
                        onDismiss()
                    }
                }
            }
            .navigationTitle("添加账户")
        }
    }
}

#Preview {
    AssetsView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
