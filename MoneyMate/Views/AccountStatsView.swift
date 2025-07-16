//
//  StatisticsView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//
import SwiftUI

struct AccountStatsView: View {
    let navigate: (AppRoute) -> Void

    var body: some View {
        VStack {
            Text("📊 账户统计")
                .font(.largeTitle)
        }
        .navigationTitle("账户统计")
    }
}


#Preview {
    AccountStatsView(navigate: { _ in })
}
