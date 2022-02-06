//
//  Post.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 5/02/22.
//

import Foundation

//Mark: - Model Definition
class Post: Codable{
    var id: Int = 0
    var title: String = ""
    var wasRead: Bool = false
    var isFavorite: Bool = false
    var postInformation: PostInformation = PostInformation()

    //Mark: - Model Definition
    init(id: Int, title: String, wasRead: Bool, isFavorite: Bool, postInformation: PostInformation){
        self.id = id
        self.title = title
        self.wasRead = wasRead
        self.isFavorite = isFavorite
        self.postInformation = postInformation
    }
    
    init(){}
}
