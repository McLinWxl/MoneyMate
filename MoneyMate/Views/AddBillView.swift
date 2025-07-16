//
//  Untitled.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI

struct AddBillView: View {
    let navigate: (AppRoute) -> Void
    
    var body: some View {
        VStack {
            Text("➕ 添加账单")
                .font(.largeTitle)
        }
        .navigationTitle("添加账单")
    }
}

#Preview {
    AddBillView(navigate: { _ in })
}
