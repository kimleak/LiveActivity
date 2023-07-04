//
//  DeliveryTrackWidgetAttributes.swift
//  PizzaDelivery
//
//  Created by kimleak on 2023/06/28.
//

import SwiftUI
import ActivityKit

struct DeliveryTrackWidgetAttributes: ActivityAttributes,Identifiable {
    
    public typealias LiveDeliveryData = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var courierName     : String
        var deliveryTime    : ClosedRange<Date>
    }

    // Fixed non-changing properties about your activity go here!
    var numberOfItem    : Int
    var totalAmount     : String
    var id              = UUID()
}
