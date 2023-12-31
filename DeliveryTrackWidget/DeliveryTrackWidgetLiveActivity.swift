//
//  DeliveryTrackWidgetLiveActivity.swift
//  DeliveryTrackWidget
//
//  Created by kimleak on 2023/06/27.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct DeliveryTrackWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            DeliveryTrackWidgetLiveActivity()
        }
    }
}

@available(iOSApplicationExtension 16.1, *)
struct DeliveryTrackWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryTrackWidgetAttributes.self) { context in
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
               
                DynamicIslandExpandedRegion(.leading) {
                    dynamicIslandExpandedLeadingView(context: context)
                 }
                 
                 DynamicIslandExpandedRegion(.trailing) {
                     dynamicIslandExpandedTrailingView(context: context)
                 }
                 
                 DynamicIslandExpandedRegion(.center) {
                     dynamicIslandExpandedCenterView(context: context)
                 }
                 
                DynamicIslandExpandedRegion(.bottom) {
                    dynamicIslandExpandedBottomView(context: context)
                }
                
              } compactLeading: {
                  compactLeadingView(context: context)
              } compactTrailing: {
                  compactTrailingView(context: context)
              } minimal: {
                  minimalView(context: context)
              }
              .keylineTint(.cyan)
        }
    }
    
    
    //MARK: Expanded Views
    func dynamicIslandExpandedLeadingView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        VStack {
            Label {
                Text("\(context.attributes.numberOfItem)")
                    .font(.title2)
            } icon: {
                Text("🍕")
                    .foregroundColor(.green)
            }
            Text("items")
                .font(.title2)
        }
    }
    
    func dynamicIslandExpandedTrailingView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        Label {
            Text(timerInterval: context.state.deliveryTime,countsDown: true)
                .multilineTextAlignment(.trailing)
                .frame(width: 50)
                .monospacedDigit()
        } icon: {
            Image(systemName: "timer")
                .foregroundColor(.green)
        }
        .font(.title2)
    }
    
    func dynamicIslandExpandedBottomView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        let url = URL(string: "LiveActivities://?panda=29555555")
        return Link(destination: url!) {
            Label("Call courier", systemImage: "phone")
        }.foregroundColor(.green)
    }
    
    func dynamicIslandExpandedCenterView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        Text("\(context.state.courierName) is on the way!")
            .lineLimit(1)
            .font(.caption)
    }
    
    
    //MARK: Compact Views
    func compactLeadingView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        VStack {
            Label {
                Text("\(context.attributes.numberOfItem) items")
            } icon: {
                Text("🍕")
                    .foregroundColor(.green)
            }
            .font(.caption2)
        }
    }
    
    func compactTrailingView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        Text(timerInterval: context.state.deliveryTime,countsDown: true)
            .multilineTextAlignment(.center)
            .frame(width: 40)
            .font(.caption2)
    }
    
    func minimalView(context: ActivityViewContext<DeliveryTrackWidgetAttributes>) -> some View {
        VStack(alignment: .center) {
            Image(systemName: "timer")
            Text(timerInterval: context.state.deliveryTime,countsDown: true)
                .multilineTextAlignment(.center)
                .monospacedDigit()
                .font(.caption2)
        }
    }
}

@available(iOSApplicationExtension 16.1, *)
struct LockScreenView: View {
    var context: ActivityViewContext<DeliveryTrackWidgetAttributes>
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .center) {
                    Text(context.state.courierName + " is on the way!").font(.headline)
                    Text("You ordered \(context.attributes.numberOfItem)🍕 paid\(context.attributes.totalAmount)+$0.2 Delivery Fee💸")
                        .font(.subheadline)
                    BottomLineView(time: context.state.deliveryTime)
                   
                }
            }
        }.padding(15)
    }
}

struct BottomLineView: View {
    var time: ClosedRange<Date>
    var body: some View {
        HStack {
            Divider().frame(width: 50,
                            height: 10)
            .overlay(.gray).cornerRadius(5)
            Image("delivery")
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 1,
                                               dash: [4]))
                    .frame(height: 10)
                    .overlay(Text(timerInterval: time,countsDown: true).font(.system(size: 8)).multilineTextAlignment(.center))
            }
            Image("home-address")
        }
    }
}
