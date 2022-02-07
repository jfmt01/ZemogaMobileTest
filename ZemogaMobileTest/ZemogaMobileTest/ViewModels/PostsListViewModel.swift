//
//  PostsListViewModel.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 6/02/22.
//

import Foundation
import Combine
import RealmSwift

protocol PostsListViewModelProtocol{
    
    //MARK: - Protocol Properties
    
    var modelPost: Observable<[Post]>{get}
    var postCellViewModel: Observable<[PostCellViewModel]>{get set}
    var favoritesPostModel: Observable<[Post]>{get}
    var goToPostInfo: ((PostInformationViewModel) -> ())? { get set}
    var postInfoVievData: ((PostInformation) -> ())? { get set }
    var refreshControl: ( () -> ())? { get set }
    
    var stopRefreshControl: (() -> ())? { get set }
    
    func viewModelDidLoad()
    func getAllPosts()
    func postSelected(postViewModel: PostInformationViewModel, post: Post)
    func showFavoritesPost(onlyFavorites: Bool)
    func deleteAllPost()
    func deleteIndividualPost(post: Post, index: Int)
    func checkPostAsFavorite(post: Post)
    
   
    
}

class PostsListViewModel: PostsListViewModelProtocol{
    var modelPost: Observable<[Post]> = Observable([])
    
    var postCellViewModel: Observable<[PostCellViewModel]> = Observable([])
    
    var favoritesPostModel: Observable<[Post]> = Observable([])
    
    var goToPostInfo: ((PostInformationViewModel) -> ())?
    
    var postInfoVievData: ((PostInformation) -> ())?
    
    var refreshControl: (() -> ())?

    var stopRefreshControl: (() -> ())?
    

    
    private var anyCancellable = Set<AnyCancellable>()

    //Initialize the data origin
    func viewModelDidLoad() {
        let allPostDataModel = DBManager.shared.fetchPostsDB()
        if !allPostDataModel.isEmpty || allPostDataModel.count > 0 {
            print("from db")
            populateViewModelFromDB()
            
        } else {
            print("From Server")
            getAllPosts()
            
            
        }
    }
    //Sort posts by wasRead & isFavorite properties
    func postsSorted(posts: [Post]) -> [Post]{
        let sortedPosts = posts.sorted{!$0.wasRead && $1.wasRead}
        let newSortedPosts = sortedPosts.sorted{$0.isFavorite && !$1.isFavorite}
        return newSortedPosts
    }
    
    //Get all post from api
    func getAllPosts(){
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
                guard let self = self else{return}
                self.stopRefreshControl?()
                let sortedPosts = self.postsSorted(posts: posts)

                self.configModel(model: sortedPosts)
                self.castingToRealmObject(model: sortedPosts)

            }.store(in: &anyCancellable)
    }

    // When a post list cell is selected
    func postSelected(postViewModel: PostInformationViewModel, post: Post) {
        checkPostAsRead(post: post)
        goToPostInfo?(postViewModel)
    }
    
    // Show all the favorites post only
    func showFavoritesPost(onlyFavorites: Bool) {
        var temporalPost: [Post] = []
        
        if onlyFavorites{
            temporalPost = modelPost.value.filter{
                post in post.isFavorite
            }
        }else{
            temporalPost = modelPost.value
            
        }
        
        postCellViewModel.value = temporalPost.compactMap{PostCellViewModel(model: $0, postInfoViewModel: PostInformationViewModel(model: $0.postInformation))}
    }

    // Delete all post from DB
    func deleteAllPost() {
        modelPost.value.removeAll()
        postCellViewModel.value.removeAll()
        let realmPost = DBManager.shared.fetchPostsDB()
        DBManager.shared.deleteAllDB(posts: realmPost)
    }

    // Delete individual post
    func deleteIndividualPost(post: Post, index: Int) {
        let realmPost = DBManager.shared.fetchPostsDB()
        if let deletePost = realmPost.filter({$0.id == post.id}).first{
            DBManager.shared.deletePostDB(post: deletePost)
            self.modelPost.value.remove(at: index)
            self.postCellViewModel.value = modelPost.value.compactMap{
                PostCellViewModel(model: $0, postInfoViewModel: PostInformationViewModel(model: $0.postInformation))
            }
        }
    }

    //Mark a post as favorite
    func checkPostAsFavorite(post: Post) {
        let realmPost = DBManager.shared.fetchPostsDB()
        if let updatePost = realmPost.filter({$0.id == post.id}).first{
            DBManager.shared.addPostToFavoritesDB(post: updatePost, isFavorite: post.isFavorite)
        }
    }

    // Mark a post as read
    
    func checkPostAsRead(post: Post){
        let realmPost = DBManager.shared.fetchPostsDB()
        if let updatePost = realmPost.filter({$0.id == post.id}).first{
            DBManager.shared.checkPostAsReadDB(post: updatePost)
        }
    }
    
    func populateViewModelFromDB() {
           let postsRealm = DBManager.shared.fetchPostsDB()
           let posts = postsRealm.map { Post(postReal: $0) }
           configModel(model: posts)
       }


    func storagePosts(model: [RealmPost]) {
           DispatchQueue.main.async {
               let realmPost = DBManager.shared.fetchPostsDB()
               if !realmPost.isEmpty {
                   DBManager.shared.deleteAllDB(posts: realmPost)
               }
               
               DBManager.shared.addPostDB(posts: model)
           }
       }
       
       private func configModel(model: [Post]) {
           DispatchQueue.main.async { [weak self] in
               guard let self = self else {
                   return
               }
               
               self.postCellViewModel.value = model.compactMap { PostCellViewModel(model: $0, postInfoViewModel: PostInformationViewModel(model: $0.postInformation)) }
           }
       }
        
        func castingToRealmObject(model: [Post])  {
            let sortedModel = postsSorted(posts: model)
            let postsObj: [RealmPost] = sortedModel.map { RealmPost(post: $0) }
            storagePosts(model: postsObj)
        }
    
    init() {}
//        func castingToRealmObject(model: [Post])  {
//            let postsObj: [RealmPost] = model.map { RealmPost(post: $0) }
//            storagePosts(model: postsObj)
//        }
       
   //    func selectedPost(post:Post){
   //        markPostLikeRead(post: post)
   //
   //    }
   //
   //    func markPostLikeRead(post: Post) {
   //        let postsRealm = DBManager.shared.fetchPostsDB()
   //        if let postToUpdate = postsRealm.filter({ $0.id == post.id}).first {
   //            DBManager.shared.checkPostAsReadDB(post: postToUpdate)
   //        }
   //    }
}
