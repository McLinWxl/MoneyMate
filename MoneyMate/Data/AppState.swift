//
//  AppState.swift
//  MoneyMate
//
//  Created by McLin on 2025/7/17.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var selectedTab: Int = 1
}
