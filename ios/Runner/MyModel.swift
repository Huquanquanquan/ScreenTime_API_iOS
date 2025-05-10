import Foundation
import FamilyControls
import ManagedSettings
import SwiftUI
import UIKit

// 使用单例模式管理应用锁定功能
private let _MyModel = MyModel()

class MyModel: ObservableObject {
    // 管理应用屏蔽设置的存储对象
    let store = ManagedSettingsStore()
    
    // 用户选择的应用列表（这些应用将不被禁止）
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    // 单例访问器
    class var shared: MyModel {
        return _MyModel
    }
    
    // 检查当前是否有应用被屏蔽
    func isAppShielded() -> Bool {
        // 检查应用屏蔽设置
        if store.shield.applications != nil {
            return true
        }
        
        // 检查应用类别屏蔽设置
        if let categories = store.shield.applicationCategories {
            switch categories {
            case .none:
                return false
            default:
                return true
            }
        }
        return false
    }
    
    // 清除所有屏蔽设置
    func clearAllShields() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        store.shield.webDomainCategories = nil
        print("已清除所有应用限制")
    }
    
    // 实现应用锁定功能：选中的应用不被禁止，其他应用被禁止
    func setAllowedApps() {
        // 1. 清除现有设置
        clearAllShields()
        
        // 2. 获取用户选择的应用
        let allowedApps = MyModel.shared.selectionToDiscourage
        selectionToDiscourage = allowedApps  // 保存选择
        
        // 3. 如果没有选择应用，则屏蔽所有应用
        if allowedApps.applicationTokens.isEmpty && allowedApps.categoryTokens.isEmpty {
            // 屏蔽所有应用
            store.shield.applicationCategories = .all()
            print("未选择任何应用 - 屏蔽所有应用")
            return
        }
        
        // 4. 设置应用限制
        if !allowedApps.applicationTokens.isEmpty {
            // 使用all(except:)方法：屏蔽所有应用，除了选中的应用
            store.shield.applicationCategories = .all(except: allowedApps.applicationTokens)
            print("已设置应用限制: 允许选中的 \(allowedApps.applicationTokens.count) 个应用，禁止其他所有应用")
        } else {
            // 如果没有选择具体应用但有选择类别，则屏蔽所有应用
            store.shield.applicationCategories = .all()
            print("未选择具体应用 - 屏蔽所有应用")
        }
    }
    
    // 兼容现有代码的方法
    func setShieldRestrictions() {
        // 直接调用新的方法
        setAllowedApps()
    }
}
