import ManagedSettings

class ShieldActionExtension: ShieldActionDelegate {
    
    // 处理应用屏蔽界面按钮点击
    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // 简单地关闭当前应用
        completionHandler(.close)
    }
    
    // 处理网站屏蔽界面按钮点击
    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // 简单地关闭当前网站
        completionHandler(.close)
    }
    
    // 处理类别屏蔽界面按钮点击
    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // 简单地关闭当前应用
        completionHandler(.close)
    }
}
