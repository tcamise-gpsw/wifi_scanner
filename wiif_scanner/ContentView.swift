//
//  ContentView.swift
//  wiif_scanner
//
//  Created by Tim Camise on 4/25/24.
//

import SwiftUI
import Foundation
import CoreWLAN
import CoreLocation
import SecurityFoundation

func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:  // Location services are available.
        print("Location services are available")
        break
        
    case .restricted, .denied:  // Location services currently unavailable.
        print("Location services are unavailable")
        break
        
    case .notDetermined:        // Authorization not determined yet.
       print("Requesting location authorization")
       manager.requestWhenInUseAuthorization()
       break
        
    default:
        break
    }
}

class WifiScanner {
    var manager: CLLocationManager
    
    init() {
        manager = CLLocationManager()
    }
    
    func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }
    
    func scan() {
        let client = CWWiFiClient.shared()
        guard let interface = client.interface() else {
            print("Not able to find default interface")
            return
        }
        print(interface)
        do {
            let networks = try interface.scanForNetworks(withName: nil)
            for network in networks {
                print("\(network.ssid ?? "Unknown")")
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    let scanner = WifiScanner()
    var body: some View {
        Button(action: scanner.requestAuthorization) {
            Text("Request Location Authorization")
        }
        Button(action: scanner.scan) {
            Text("Scan for WiFi networks")
        }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


