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
    init(title: String, wasRead: Bool, isFavorite: Bool, postInformation: PostInformation){
        self.title = title
        self.wasRead = wasRead
        self.isFavorite = isFavorite
        self.postInformation = postInformation
    }
    
    init(){}
    
    init(postReal: RealmPost) {
        id = postReal.id
        title = postReal.title
        wasRead = postReal.wasRead
        isFavorite = postReal.isFavorite
       
        
        let postInfoObj = postReal.postInformation
        let user = postReal.postInformation.user
        postInformation = PostInformation(id: postReal.id,
                                          description:postInfoObj?.fullDescription ?? "",
                                          user: User(id: user?.id ?? 0, name: user?.name ?? "",
                                                       phone: user?.phone ?? "",
                                                       email: user?.email ?? "",
                                                       webSite: user?.webSite ?? ""),
                                          comments:postInfoObj?.comments.components(separatedBy: ",") ?? [""]
                                            )
    }
}
