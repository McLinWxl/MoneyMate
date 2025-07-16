//
//  ExpandMiniView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/17.
//

import SwiftUI
import SwiftData

struct ExpandMiniView: View {
    @Namespace private var animation
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]
    var body: some View {
        List {
            ForEach(transactions.filter { Calendar.current.isDateInToday($0.date) }) {
                transaction in
                HStack {
                    Text(transaction.title)
                        .font(.headline)
                    Spacer()
                    Text("¥\(transaction.amount, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            VStack(spacing: 10) {
                Capsule()
                    .fill(.primary.secondary)
                    .frame(width: 40, height: 3)
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("今日支出")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        //TODO : ADD VALUE
                        Text("$300.00")
                            .font(.title)
                            .fontWeight(.black)
                    }
                    Spacer(minLength: 0)
                    VStack(alignment: .trailing) {
                        Text("本月日均")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        //TODO : ADD VALUE
                        Text("$300.00")
                            .font(.title)
                            .fontWeight(.black)
                    }
                }
                .padding(.horizontal, 15)
                .navigationTransition(.zoom(sourceID: "MINIVIEW", in: animation))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .safeAreaInset(edge: .bottom) {
            Button{
                //TODO
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


#Preview { ExpandMiniView().padding() }
