//
//  MoneyMateApp.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI
import SwiftData

@main
struct MoneyMateApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .modelContainer(for: Transaction.self)
        }
    }
}
