//
//  NotificationBanner.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 9/02/22.
//

import Foundation
import NotificationBannerSwift

public extension NotificationBanner{
    
    static func addedToFavBanner() {
        let banner = NotificationBanner(title: "⭐️ Post Was Added To Favorites", style: .success)
        banner.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            banner.dismiss()
        }
    }
    
    static func postDeletedBanner() {
        let banner = NotificationBanner(title: "❕ One Post Was Deleted", style: .warning)
        banner.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            banner.dismiss()
        }
    }
    
    static func allDeletedBanner() {
        let banner = NotificationBanner(title: "⚠️ All Posts Were Deleted", style: .danger)
        banner.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            banner.dismiss()
        }
    }
    
    
}
