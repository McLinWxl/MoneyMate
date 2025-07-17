//
//  Transaction.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class AccountType: Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var balance: Double
    var desc: String

    init(name: String, balance: Double = 0.0, desc: String) {
        self.id = UUID()
        self.name = name
        self.balance = balance
        self.desc = desc
    }




    static func == (lhs: AccountType, rhs: AccountType) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

@Model
final class Transaction: Identifiable {
    @Attribute(.unique) var id: UUID
    @Attribute var title: String
    @Attribute var amount: Double
    @Attribute var date: Date
    @Relationship var account: AccountType
    @Attribute var isExpense: Bool // 支出或收入
    @Attribute var time: Date
    @Attribute var desc: String
    @Attribute var currency: String // 货币符号，例如 "¥"

    init(title: String, amount: Double, date: Date = .now, account: AccountType, isExpense: Bool = true, time: Date = .now, desc: String = "", currency: String = "¥") {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.account = account
        self.isExpense = isExpense
        self.time = time
        self.desc = desc
        self.currency = currency
    }

//    @Query(sort: \Transaction.date, order: .forward)
//    static var transactions: [Transaction]
}
