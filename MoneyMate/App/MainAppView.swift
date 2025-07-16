//
//  MainAppView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//

import SwiftUI
import SwiftData

struct MainAppView: View {
    @State private var isShowingAddSheet = false
    @State private var selectedTab = 0
    @State private var expandMiniPlayer: Bool = false
    @Namespace private var animation
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab.init("总览", systemImage: "chart.bar.xaxis", value: 0) {
                NavigationStack {
                    StatsView()
                }
            }

            Tab.init("账单", systemImage: "text.page.fill", value: 1) {
                NavigationStack {
                    BillListView()
                }
            }

            Tab.init("资产", systemImage: "creditcard.fill", value: 2) {
                NavigationStack {
                    AssetsView()
                }
            }

            Tab.init("添加", systemImage: "plus.circle", value: 3, role: .search) {
                Color.clear
                    .onAppear {
                        isShowingAddSheet = true
                    }
                    .sheet(isPresented: $isShowingAddSheet, onDismiss: {
                        selectedTab = 1 // Switch to "账单" tab after dismiss
                    }) {
                        AddEditView(transaction: .constant(nil))
                            .presentationDetents([.medium, .large])
                    }
            }
        }
        .tabViewBottomAccessory {
            MiniPlayerView()
                .onTapGesture {
                    expandMiniPlayer.toggle()
                }
        }
        .fullScreenCover(isPresented: $expandMiniPlayer) {
            ExpandMiniView()
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Transaction.self, configurations: .init(isStoredInMemoryOnly: true))
    return MainAppView().modelContainer(container)
}
