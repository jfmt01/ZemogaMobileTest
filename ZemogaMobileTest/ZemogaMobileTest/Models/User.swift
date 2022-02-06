//
//  User.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 5/02/22.
//

import Foundation

//Mark: - Model Definition

class User: Codable{
    var id: Int = 0
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var webSite: String = ""
    
    //Mark: - Intializers
    init(id: Int, name: String, phone: String, email: String, webSite: String){
        
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.webSite = webSite
    }
    
    init(){}
}

