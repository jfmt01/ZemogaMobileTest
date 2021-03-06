//
//  UIColorExtension.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import Foundation
import UIKit

public extension UIColor { 
    static func mainGreenColor() -> UIColor{
        UIColor(red: 8/255, green: 175/255, blue: 15/255, alpha: 1.0)
    }
    
    static func postsListGrayLabel() -> UIColor{
        UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1.0)
    }
    
    static func grayBackground() -> UIColor{
        UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }
    
    static func deleteButtonColor() -> UIColor{
        UIColor(red: 208/255, green: 2/255, blue: 26/255, alpha: 1.0)
    }
}
