//
//  Transaction.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import Foundation
import SwiftData

@Model
class Transaction: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var date: Date

    init(title: String, amount: Double, date: Date = .now) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
    }
}
