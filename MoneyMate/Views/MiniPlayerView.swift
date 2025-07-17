//
//  MiniPlayerView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI

struct MiniPlayerView: View {
    var body: some View {
        HStack {
            Text("今日支出: ¥300.00")
            Spacer()

        }
        .padding().background(.ultraThinMaterial).cornerRadius(12)
    }
}

//#Preview { MiniPlayerView().padding() }
