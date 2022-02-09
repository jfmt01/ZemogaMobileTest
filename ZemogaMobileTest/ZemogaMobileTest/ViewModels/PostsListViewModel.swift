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
    var goToPostInfoView: ((PostInformationViewModel) -> ())? { get set}
    var postInfoData: ((PostInformation) -> ())? { get set }
    var refreshControl: ( () -> ())? { get set }
    
    var stopRefreshControl: (() -> ())? { get set }
    
    func viewModelDidLoad()
    func getAllPosts()
    func postSelected(postViewModel: PostInformationViewModel, post: Post)
    func showFavoritesPost(showFavs: Bool)
    func deleteAllPost()
    func deleteIndividualPost(post: Post, index: Int)
    func checkPostAsFavorite(postInfo: PostInformation, segmentedIndex: Int)
    
    
    
    
}

class PostsListViewModel: PostsListViewModelProtocol{
    var modelPost: Observable<[Post]> = Observable([])
    
    var postCellViewModel: Observable<[PostCellViewModel]> = Observable([])
    
    var favoritesPostModel: Observable<[Post]> = Observable([])
    
    var goToPostInfoView: ((PostInformationViewModel) -> ())?
    
    var postInfoData: ((PostInformation) -> ())?
    
    var refreshControl: (() -> ())?
    
    var stopRefreshControl: (() -> ())?
    
    
    
    private var anyCancellable = Set<AnyCancellable>()
    
    init() {}
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
    //MARK: Sort posts by wasRead & isFavorite properties
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
    
    // Post list cell selected
    func postSelected(postViewModel: PostInformationViewModel, post: Post) {
        checkPostAsRead(post: post)
        goToPostInfoView?(postViewModel)
    }
    func postSelected(postInfo: PostInformation) {
        postInfoData?(postInfo)
    }
    
    // MARK: - Show all the favorites post only
    func showFavoritesPost(showFavs: Bool) {
        switch showFavs{
        case true:
            populateFromFavsDb()
        default:
            populateViewModelFromDB()
        }
    }
    
    //MARK: - Delete all post from DB
    func deleteAllPost() {
        modelPost.value.removeAll()
        postCellViewModel.value.removeAll()
        let realmPost = DBManager.shared.fetchPostsDB()
        DBManager.shared.deleteAllDB(posts: realmPost)
    }
    
    // MARK: -  Delete individual post
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
    
    //MARK: - Mark a post as favorite
    func checkPostAsFavorite(postInfo: PostInformation, segmentedIndex: Int) {
        let realmPost = DBManager.shared.fetchPostsDB()
        if let updatePost = realmPost.filter({$0.id == postInfo.id}).first{
            DBManager.shared.addPostToFavoritesDB(post: updatePost, isFavorite: postInfo.isFavInfo)
        }
        if segmentedIndex == 0{
            populateViewModelFromDB()
        }else if segmentedIndex == 1{
            populateFromFavsDb()
        }
    }
    
    //MARK: - Mark a post as read
    
    func checkPostAsRead(post: Post){
        let realmPost = DBManager.shared.fetchPostsDB()
        if let updatePost = realmPost.filter({$0.id == post.id}).first{
            DBManager.shared.checkPostAsReadDB(post: updatePost)
        }
        if UserDefaults.standard.integer(forKey: "segmentSelected") == 1{
            populateFromFavsDb()
        }
        else
        {
            populateViewModelFromDB()
        }
    }
    //MARK: - Get posts list from realm DB
    func populateViewModelFromDB() {
        let postsRealm = DBManager.shared.fetchPostsDB()
        let posts = postsRealm.map { Post(postReal: $0) }
        configModel(model: posts)
    }
    //MARK: - Get favorites list from realm DB
    func populateFromFavsDb(){
        let postFavsRealm = DBManager.shared.fetchFavsDB()
        let posts = postFavsRealm.map{Post(postReal: $0)}
        configModel(model: posts)
    }
    
    //MARK: - Save posts in realm db
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
            let newModel = self.postsSorted(posts: model)
            self.modelPost.value = newModel
            self.postCellViewModel.value = newModel.compactMap { PostCellViewModel(model: $0, postInfoViewModel: PostInformationViewModel(model: $0.postInformation)) }
        }
    }
    
    func castingToRealmObject(model: [Post])  {
        let sortedModel = postsSorted(posts: model)
        let postsObj: [RealmPost] = sortedModel.map { RealmPost(post: $0) }
        storagePosts(model: postsObj)
    }
    
    
}
