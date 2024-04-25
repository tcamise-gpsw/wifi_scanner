//
//  ContentView.swift
//  wiif_scanner
//
//  Created by Tim Camise on 4/25/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    var body: some View {
        Button (action: viewModel.onScanForNetworks) {
            Text("Scan for WiFi networks")
        }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.text)
        }
        .padding()
        .onAppear() {viewModel.onInitWifiScanner()}
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}


