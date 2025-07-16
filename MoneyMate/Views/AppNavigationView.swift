//
//  MainView.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/16.
//


import SwiftUI

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
}

let sampleTransactions: [Transaction] = [
    Transaction(title: "超市购物", amount: 120.50, date: Date()),
    Transaction(title: "外卖午餐", amount: 45.00, date: Date().addingTimeInterval(-86400)),
    Transaction(title: "公交充值", amount: 30.00, date: Date().addingTimeInterval(-172800)),
    Transaction(title: "公交", amount: 32.00, date: Date().addingTimeInterval(-172000)),
    Transaction(title: "咖啡", amount: 22.00, date: Date().addingTimeInterval(-259200))
]

enum AppRoute: Hashable {
    case recordHistory
    case accountStats
    case addBill
}

struct AppNavigationView: View {
//    @State private var path: [AppRoute] = []
//    @State private var selectedTab: selectedTab = .history
//    @State private var isPresentingAddBill = false
//    @State private var searchText: String = ""
    @State private var expandMiniPlayer: Bool = false
    @Namespace private var animation
    
    enum selectedTab {
        case history
        case stats
        case add
    }

    var body: some View {
        Group {
            NativeTabView()
                .tabBarMinimizeBehavior(.onScrollUp)
                .tabViewBottomAccessory {
                    MiniView()
                        .matchedTransitionSource(id: "MINIVIEW", in: animation)
                        .background(Color.primary.opacity(0))
                        .onTapGesture {
                            expandMiniPlayer.toggle()
                }
               
                }
        }
        .fullScreenCover(isPresented: $expandMiniPlayer) {
//            ScrollView {
                List {
                    ForEach(sampleTransactions.filter { Calendar.current.isDateInToday($0.date) }) { transaction in
                        HStack {
                            Text(transaction.title)
                                .font(.headline)
                            Spacer()
                            Text("¥\(transaction.amount, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
//                .listStyle(.plain)
//            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 10) {
                    ///
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
      
    @ViewBuilder
    func NativeTabView() -> some View {
        TabView {
            Tab.init("账单", systemImage: "text.page.fill") {
                NavigationStack {
                    //TODO: Add data structure
                    List {
                        // 按天分组账单
                        ForEach(Dictionary(grouping: sampleTransactions) { Calendar.current.startOfDay(for: $0.date) }
                            .sorted(by: { $0.key > $1.key }), id: \.key) { date, transactions in
                            Section(header: Text(date.formatted(date: .abbreviated, time: .omitted))) {
                                ForEach(transactions) { transaction in
                                    HStack(alignment: .center) {
                                        Text(transaction.title)
                                            .font(.headline)
                                        Spacer(minLength: 0)
                                        Text("金额: ¥\(transaction.amount, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
//                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .navigationTitle("账单")
                }
            }
            
//            Spacer(minLength: 0)
            
            Tab.init("分析", systemImage: "chart.bar.xaxis") {
                NavigationStack {
                    List{
                        }
                    .navigationTitle("分析")
                }
            }
            
//            Spacer(minLength: 0)
            
            Tab.init("资产", systemImage: "creditcard.fill") {
                NavigationStack {
                    List{
                        }
                    .navigationTitle("分析")
                }
            }
            
            Tab.init("添加", systemImage: "plus.circle",  role: .search) {
                NavigationStack {
                    List{
                        }
                    .navigationTitle("账单")
//                    .searchable(text: $searchText, prompt: Text("Searching"))
                }
            }
        }
    }
    
    @ViewBuilder
    func MiniInfo(_ size: CGSize, fontWidth: Font, fontWeight: Font.Weight) -> some View {
        VStack{
            Text("今日支出")
                .font(fontWidth)
                .fontWeight(fontWeight)
            //TODO: Add value
        }
    }
    
    @ViewBuilder
    func MiniView() -> some View {
        HStack(spacing: 15) {
            MiniInfo(.init(width: 30, height: 30), fontWidth: .body, fontWeight: .bold)
            
            Spacer(minLength: 0)
            
            Button{
                //TODO: Add view
                
            } label: {
                Image(systemName: "plus.circle.fill")
                    .contentShape(.rect)
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal, 15)
    }
    
    
//    /// 路由跳转方法
//    func navigate(to route: AppRoute) {
//        path.append(route)
//    }
}

#Preview {
    AppNavigationView()
}
