//
//  ContentViewModel.swift
//  wiif_scanner
//
//  Created by Tim Camise on 4/25/24.
//

import Foundation
import CoreWLAN
import CoreLocation

class WifiScanner : NSObject, CLLocationManagerDelegate{
    var manager: CLLocationManager
    private(set) var isReady = false
    private var onLocationServicesAuthorized: () -> ()
    
    init(onLocationServicesAuthorized: @escaping () -> ()) {
        self.manager = CLLocationManager()
        self.onLocationServicesAuthorized = onLocationServicesAuthorized
        super.init()
        manager.delegate = self
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:  // Location services are available.
            print("Location services are available")
            onLocationServicesAuthorized()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            print("Location services are unavailable")
            break
            
        case .notDetermined:        // Authorization not determined yet.
            print("Requesting location authorization")
            manager.requestAlwaysAuthorization()
            isReady = true
            break
            
        default:
            break
        }
    }
    
    func scan() -> [String] {
        guard let interface = CWWiFiClient.shared().interface() else {
            print("Not able to find shared WiFi interface")
            return [""]
        }
        do {
            let ssids = try interface.scanForNetworks(withName: nil).map({$0.ssid ?? "Unknown"})
            ssids.forEach({print($0)})
            return ssids
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return [""]
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var text: String = "Awaiting location service authorization"
    var scanner: WifiScanner? = nil
    
    func onInitWifiScanner() {
        scanner = WifiScanner() { self.text="Location services have been authorized"}
    }
    
    func onScanForNetworks() {
        guard let scanner = scanner else { return }
        if !(scanner.isReady) {
            text = "Location Services have not been authorized"
        }
        text = scanner.scan().joined(separator: "\n")
    }
}
