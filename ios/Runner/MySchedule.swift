import Foundation
import DeviceActivity

// 设备活动名称是我如何在我的扩展中引用活动的方式
extension DeviceActivityName {
    // 将活动的名称设置为“每日”
    static let daily = Self("daily")
}

// 当孩子为一组监护人选择的鼓励应用程序累积足够的使用量时，我想移除应用程序屏蔽限制
extension DeviceActivityEvent.Name {
    // 将事件的名称设置为“鼓励”
    static let encouraged = Self("encouraged")
}

// 设备活动计划表示我的扩展将监控活动的时间范围
let schedule = DeviceActivitySchedule(
    // 我已将我的计划设置为在特定时间开始和结束
    intervalStart: DateComponents(hour: 15, minute: 08),
    intervalEnd: DateComponents(hour: 16, minute: 08),
    // 我还将计划设置为不重复
    repeats: false,
    warningTime: nil
)

class MySchedule {
    static public func unsetSchedule() {
        let center = DeviceActivityCenter()
        print("center.avtivities:\(center.activities)")
        if center.activities.isEmpty {
            return
        }
        center.stopMonitoring(center.activities)
        print("center.avtivities:\(center.activities)")
    }
    
    static public func setSchedule() {
        let applications = MyModel.shared.selectionToEncourage
        if applications.applicationTokens.isEmpty {
            print("empty applicationTokens")
        }
        if applications.categoryTokens.isEmpty {
            print("empty categoryTokens")
        }
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: applications.applicationTokens,
                categories: applications.categoryTokens,
                threshold: DateComponents(minute: 1)
            )
        ]
        
        // 创建一个设备活动中心
        let center = DeviceActivityCenter()
        do {
            // 使用活动名称、计划和事件调用startMonitoring
            print("center.avtivities:\(center.activities)")
            print("Try to start monitoring...")
            try center.startMonitoring(.daily, during: schedule, events: events)
            print("monitoring...")
        } catch {
            print("Error monitoring schedule: ", error)
        }
    }
}

// 屏蔽应用程序的另一个要素是找出监护人想要阻止的内容
// 家庭控制框架为此提供了一个SwiftUI元素：家庭活动选择器
