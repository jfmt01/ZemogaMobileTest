//
//  Realm.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 6/02/22.
//

import Foundation
import RealmSwift

//Mark: - Realm post full data object

class RealmPost: Object{
    @Persisted var id: Int = 0
    @Persisted var title: String = ""
    @Persisted var wasRead: Bool = false
    @Persisted var isFavorite: Bool = false
    @Persisted var postInformation: RealmPostInfo = RealmPostInfo()
    
    
    //Mark: - RealmPost Initializers
    
    init(title: String, wasRead: Bool, isFavorite: Bool, postInformation: RealmPostInfo){
        self.title = title
        self.wasRead = wasRead
        self.isFavorite = isFavorite
        self.postInformation = postInformation
    }
    
    override init(){}
    
    init(post: Post){
        let user = post.postInformation.user
        let allComments: String = post.postInformation.comments.joined(separator: ",")
        
        id = post.id
        wasRead = post.wasRead
        isFavorite = post.isFavorite
        postInformation = RealmPostInfo(fullDescription: post.postInformation.description,
                                        user: RealmUser(name: user?.name ?? "",
                                                        phone: user?.phone ?? "",
                                                        email: user?.email ?? "",
                                                        webSite: user?.webSite ?? ""),
                                        comments: allComments)
    }
}


//Mark: - Realm post information object

class RealmPostInfo: Object {
    @Persisted var id: Int = 0
    @Persisted var fullDescription: String = ""
    @Persisted var user: RealmUser! = RealmUser()
    @Persisted var comments: String = ""
    
    //Mark: - RealmPostInfo Initializers
    
    init(fullDescription: String, user: RealmUser, comments: String){
        self.fullDescription = fullDescription
        self.user = user
        self.comments = comments
    }
}


//Mark: - Realm user data object

class RealmUser: Object, Codable{
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var phone: String = ""
    @Persisted var email: String = ""
    @Persisted var webSite: String = ""
    
    //Mark: - RealmUser Initializers
    init(name: String, phone: String, email: String, webSite: String){
        self.name = name
        self.phone = phone
        self.email = email
        self.webSite = webSite
    }
    
    override init(){}
}

