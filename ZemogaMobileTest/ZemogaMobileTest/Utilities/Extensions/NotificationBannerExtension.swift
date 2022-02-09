//
//  NotificationBanner.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 9/02/22.
//

import Foundation
import NotificationBannerSwift

public extension NotificationBanner{
    static func allDeleteBanner() -> NotificationBanner{
        let banner = NotificationBanner(title: "⚠️ All Posts Were Deleted", style: .danger)
        return banner
    }
    
    static func addedToFavBanner() -> NotificationBanner{
        let banner = NotificationBanner(title: "", style: .success)
        return banner
    }
}
