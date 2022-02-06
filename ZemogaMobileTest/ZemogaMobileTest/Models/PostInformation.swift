//
//  PostDescription.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 5/02/22.
//

import Foundation

//Mark: - Model Definition
class PostInformation: Codable{
    var id: Int = 0
    var description: String = ""
    var user: User!
    var comments: [String] = []
    
    //Mark: - Intializers
    init(id: Int, description: String, user: User, comments: [String]){
        self.id = id
        self.description = description
        self.user = user
        self.comments = comments
    }
    
    init(){}
}
