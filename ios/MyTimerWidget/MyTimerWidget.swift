//
//  MyTimerWidget.swift
//  MyTimerWidget
//
//  Created by Kang Hyeon Oh on 10/28/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct MyTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            MyTimerWidget()
        }
    }
}

// We need to redefined live activities pipe
// ActivityAttributes는 정적인 Properties
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    
    public struct ContentState: Codable, Hashable { }
    
    var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.ohkang.dynisland")!

// View Reference : https://nsios.tistory.com/194
@available(iOSApplicationExtension 16.1, *)
struct MyTimerWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            let timerName = sharedDefault.string(forKey: context.attributes.prefixedKey("timerName"))!
            
            let matchStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchStartDate")) / 1000)
            let matchEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchEndDate")) / 1000)
            let matchRemainingTime: ClosedRange<Date> = matchStartDate...matchEndDate
            
            ZStack {
                LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottom)
                
                HStack {
                    Text(timerName)
                    Text("\(matchStartDate)")
                    Text("\(matchEndDate)")
                    Text(timerInterval: matchRemainingTime, countsDown: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                        .monospacedDigit()
                        .font(.footnote)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 2.0)
            }
            .frame(height: 160)
        } dynamicIsland: { context in
            let timerName = sharedDefault.string(forKey: context.attributes.prefixedKey("timerName"))!
            
            let matchStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchStartDate")) / 1000)
            let matchEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchEndDate")) / 1000)
            let matchRemainingTime: ClosedRange<Date> = matchStartDate...matchEndDate
            
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .center, spacing: 2.0) {
                        Text("시작점")
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .center, spacing: 2.0) {
                        Text("끝")
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .center, spacing: 6.0) {
                        HStack {
                            Text(timerName)
                            Text("\(matchStartDate)")
                            Text("\(matchEndDate)")
                            Text(timerInterval: matchRemainingTime, countsDown: true)
                                .multilineTextAlignment(.center)
                                .frame(width: 50)
                                .monospacedDigit()
                                .font(.footnote)
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .center, spacing: 1.0) {
                            Link(destination: URL(string: "la://my.app/stats")!) {
                                Text("See stats 📊")
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 5)
                        }
                    }
                    .padding(.vertical, 6.0)
                }
            } compactLeading: {
                HStack {
                    Text("시작 부분")
                        .font(.title)
                        .fontWeight(.bold)
                }
            } compactTrailing: {
                HStack {
                    Text("끝 부분")
                        .font(.title)
                        .fontWeight(.bold)
                }
            } minimal: {
                ZStack {
                    Text("Hide")
                }
            }
        }
    }
}

extension LiveActivitiesAppAttributes {
    func prefixedKey(_ key: String) -> String {
        return "\(id)_\(key)"
    }
}

