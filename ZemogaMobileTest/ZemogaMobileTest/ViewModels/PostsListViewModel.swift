//
//  PostsListViewModel.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 6/02/22.
//

import Foundation
import Combine
import RealmSwift

class PostListViewModel{
    
    @Published var posts = [Post]()
    private var anyCancellable = Set<AnyCancellable>()
    
    init(){}
    
    
    func viewDidLoad() {
        fetchAllPosts()
    }
    
    func fetchAllPosts(){
        APIManager.shared.getApiPostsList()
            .receive(on: DispatchQueue.main)
            .map{$0}
            .sink{completion in
                switch completion{
                
                case .finished:
                    print("Done")
                
                case .failure(let error):
                    print(error)
                }
            }receiveValue: {[weak self] posts in
                //print(posts.count)
                guard let self = self else{return}
                self.posts = posts
                //print("Posts: \(self.posts[0].postInformation.comments)")
            }.store(in: &anyCancellable)
    }

}
