//
//  HistoryView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//
import SwiftUI

struct RecordHistoryView: View {
    let navigate: (AppRoute) -> Void

    var body: some View {
        VStack {
            Text("📜 记录历史")
                .font(.largeTitle)
        }
        .background(.blue)
    }
}

#Preview {
    RecordHistoryView(navigate: { _ in })
}
