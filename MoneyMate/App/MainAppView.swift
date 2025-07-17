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
    @EnvironmentObject var appState: AppState
    @State private var expandMiniPlayer: Bool = false
    @Namespace private var animation
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
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

            Tab.init("添加", systemImage: "plus", value: 3, role: .search) {
                EmptyView()
            }
        }
        .onChange(of: appState.selectedTab, initial: false) { oldValue, newValue in
            if newValue == 3 {
                appState.selectedTab = 1
                isShowingAddSheet = true
            }
        }
        .sheet(isPresented: $isShowingAddSheet, onDismiss: {
            // 可选：在关闭弹窗后保留账单页面
        }) {
            AddEditView(transaction: .constant(nil))
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            MiniPlayerView()
                .matchedTransitionSource(id: "MINIVIEW", in: animation)
                .onTapGesture {
                    expandMiniPlayer.toggle()
                }
        }
        .fullScreenCover(isPresented: $expandMiniPlayer) {
            ExpandMiniView(anima: animation)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Transaction.self, configurations: .init(isStoredInMemoryOnly: true))
    return MainAppView().modelContainer(container)
}
