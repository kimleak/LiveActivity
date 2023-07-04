//
//  PizzaDeliveryApp.swift
//  PizzaDelivery
//
//  Created by kimleak on 2023/06/27.
//

import SwiftUI

@main
struct PizzaDeliveryApp: App {
    
    @State var showDeepLinkAction   : Bool = false
    @State var driver               : String = ""
    let center = UNUserNotificationCenter.current()
    
    init() {
        registerForNotification()
    }
    
    func registerForNotification() {
        UIApplication.shared.registerForRemoteNotifications()
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
            else {
                
            }
        })
    }
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.1, *) {
                ContentView()
                    .onOpenURL { url in
                        guard let url = URLComponents(string: url.absoluteString) else { return }
                        if let courierNumber = url.queryItems?.first(where: { $0.name == "panda" })?.value {
                            driver              = courierNumber
                            showDeepLinkAction  = true
                        }
                    }
                    .confirmationDialog("Call Driver", isPresented: $showDeepLinkAction) {
                        Link("(010)29555555", destination: URL(string: "tel:010\(driver)")!)
                        Button("Cancel",role: .cancel) {
                            showDeepLinkAction = false
                        }
                    } message: {
                        Text("Are you sure to call 010\(driver)?")
                        
                    }
            }
        }
    }
}
