//
//  StocksApp.swift
//  StocksApp
//
//  Created by Alfian Losari on 01/10/22.
//

import SwiftUI

@main
struct StocksApp: App {
    
    @StateObject var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainListView()
            }
            .environmentObject(appVM)
        }
    }
}
