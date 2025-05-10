//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by HU on 2025/5/8.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    private func setShieldConfig(
        _ tokenName: String,
        hasSecondaryButton: Bool = false) -> ShieldConfiguration {
        
        // 自定义图片 - 随机选择一个图片
        let imageNames = ["dont_use_lxy1"]
        let randomIndex = Int.random(in: 0..<imageNames.count)
        let CUSTOM_ICON = UIImage(named: imageNames[randomIndex])
        
        // 自定义标题、副标题和按钮
        let CUSTOM_TITLE = ShieldConfiguration.Label(
            text: "专注中禁止使用",
            color: UIColor(red: 28/255.0, green: 51/255.0, blue: 68/255.0, alpha: 1.0)
        )
        let CUSTOM_SUBTITLE = ShieldConfiguration.Label(
            text: "专注完成或提前结束，即可解除禁用",
            color: UIColor(red: 136/255.0, green: 145/255.0, blue: 154/255.0, alpha: 1.0)
        )
        let CUSTOM_PRIMARY_BUTTON_LABEL = ShieldConfiguration.Label(
            text: "好的",
            color: UIColor(red: 255/255.0, green: 240/255.0, blue: 176/255.0, alpha: 1.0)
        )
        let CUSTOM_PRIAMRY_BUTTON_BACKGROUND: UIColor = UIColor(red: 88/255.0, green: 63/255.0, blue: 67/255.0, alpha: 1.0) // #583F43 半透明
        
        // 创建浅蓝色纯色背景的配置
        let SHIELD_CONFIG = ShieldConfiguration(
            backgroundBlurStyle: .extraLight, // 使用超浅模糊效果，避免背景变暗
            backgroundColor: UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0), // 更浅更亮的蓝色背景
            icon: CUSTOM_ICON,
            title: CUSTOM_TITLE,
            subtitle: CUSTOM_SUBTITLE,
            primaryButtonLabel: CUSTOM_PRIMARY_BUTTON_LABEL,
            primaryButtonBackgroundColor: CUSTOM_PRIAMRY_BUTTON_BACKGROUND
        )
        
        return SHIELD_CONFIG
    }
    
    // 应用被屏蔽时的界面配置 - 不显示应用名称
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return setShieldConfig("")
    }
    
    override func configuration(
        shielding application: Application,
        in category: ActivityCategory) -> ShieldConfiguration {
        return setShieldConfig("")
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return setShieldConfig("")
    }
    
    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory) -> ShieldConfiguration {
        return setShieldConfig("")
    }
}
