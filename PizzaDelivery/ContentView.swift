//
//  ContentView.swift
//  PizzaDelivery
//
//  Created by kimleak on 2023/06/27.
//

import SwiftUI
import ActivityKit
@available(iOS 16.1, *)
struct ContentView: View {
    
    @State var activities   = Activity<DeliveryTrackWidgetAttributes>.activities
    @State var showAlert    : Bool = false
    @State var alertMsg     : String = ""
   
    var body: some View {

        NavigationView {
            Form {
                Section {
                    Text("What a beautiful day!")
                    Button {
                        //Create activity
                        createActivity()
                        listActivity()
                    } label: {
                        Text("Start Ordering👨🏻‍🍳🤤").font(.headline)
                    }.tint(.green)
                    
                    Button {
                        //List all deliveries
                        listActivity()
                        
                    } label: {
                        Text("Show All Orders🍕").font(.headline)
                    }.tint(.green)
                    
                    Button {
                        //End all activities
                        endAllActivity()
                        listActivity()
                    } label: {
                        Text("Cancel Order🫠").font(.headline)
                    }.tint(.red)
                    
                }
                
                Section {
                    if !activities.isEmpty {
                        Text("Order Activities")
                    }
                    activitiesView()
                }
                
            }
            .navigationTitle("PizzaMate 🍕")
            .fontWeight(.ultraLight)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Text("Hello  Developers")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Pizza order event"),message: Text(alertMsg),dismissButton: .default(Text("OK")))
            }
        }
    }
    
    //Create Activity
    func createActivity() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            
            // Enable or disable features based on the authorization.
        }
        
        
        let attributes = DeliveryTrackWidgetAttributes(numberOfItem: 1, totalAmount: "$2")
        let contenState = DeliveryTrackWidgetAttributes.LiveDeliveryData(courierName: "panda", deliveryTime: Date()...Date().addingTimeInterval(5 * 60))
        do {
            let deliveryActivity = try Activity<DeliveryTrackWidgetAttributes>.request(
                attributes: attributes,
                contentState: contenState,
                pushType: .token)   // Enable Push Notification Capability First (from pushType: nil)
            print("Requested a pizza delivery Live Activity \(deliveryActivity.id)")

            // Send the push token to server
            Task {
                for await pushToken in deliveryActivity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                    print(pushTokenString)
                }
            }
        }catch (let error) {
            print(error.localizedDescription)
        }
    }
    //Update Activity
    func updateActivity(activity : Activity<DeliveryTrackWidgetAttributes>) {
        Task {
            let updateStatus = DeliveryTrackWidgetAttributes.LiveDeliveryData(courierName: "panda 🐼", deliveryTime: Date()...Date().addingTimeInterval(10 * 60))
            await activity.update(using: updateStatus)
        }
    }
    //End Activity
    func end(activity : Activity<DeliveryTrackWidgetAttributes>) {
        Task {
            await activity.end(dismissalPolicy: .immediate)
            self.activities.removeAll(where: {$0.id == activity.id})
        }
    }
    //End All Activity
    func endAllActivity() {
        Task {
            let activities = Activity<DeliveryTrackWidgetAttributes>.activities
            for activity in activities  {
                await activity.end(dismissalPolicy: .immediate)
            }
            self.activities.removeAll()
            print("Cancelled pizza delivery Live Activity")
            self.showAlert = true
            self.alertMsg  = "Your order will be cancelled"
        }
    }
    //List Activity
    func listActivity() {
        var activities = Activity<DeliveryTrackWidgetAttributes>.activities
        activities.sort{$0.id > $1.id}
        self.activities = activities
    }
}

@available(iOS 16.1, *)
extension ContentView {
    func activitiesView() -> some View {
        var body: some View {
            ScrollView {
                ForEach(activities,id: \.id) { activity in
                    let courierName = activity.contentState.courierName
                    let deliveryTime = activity.contentState.deliveryTime
                    HStack(alignment: .center) {
                        Text(courierName)
                        Text(timerInterval: deliveryTime,countsDown: true)
                        Text("Update")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                //Update Activity
                                //List all Deliveries
                                updateActivity(activity: activity)
                                listActivity()
                            }
                        Text("End")
                            .font(.headline)
                            .foregroundColor(.pink)
                            .onTapGesture {
                                //End Activity
                                //List all Deliveries
                                end(activity: activity)
                                listActivity()
                            }
                    }
                    
                }
            }
        }
        return body
    }
    
}

 @available(iOS 16.1, *)
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 
