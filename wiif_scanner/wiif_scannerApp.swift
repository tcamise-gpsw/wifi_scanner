//
//  wiif_scannerApp.swift
//  wiif_scanner
//
//  Created by Tim Camise on 4/25/24.
//

import SwiftUI

@main
struct wiif_scannerApp: App {
    let viewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
