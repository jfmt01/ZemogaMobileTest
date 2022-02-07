//
//  PostCellViewModel.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 7/02/22.
//

import Foundation

//Mark: - Class protocol definition
protocol PostCellViewModelProtocol: AnyObject{
    var postCellModel: Observable<Post>{get}
    var title: Observable<String>{get}
    var wasRead: Observable<Bool>{get}
    var isFavorite: Observable<Bool>{get}
    var postInformation: Observable<PostInformation>{get}
    var postInfoViewModel: Observable<PostInformationViewModel>{get set}
}

class PostCellViewModel: PostCellViewModelProtocol{
   
    var postCellModel: Observable<Post> = Observable(Post())
    
    var title: Observable<String> = Observable("test")
    
    var wasRead: Observable<Bool> = Observable(false)
    
    var isFavorite: Observable<Bool> = Observable(false)
    
    var postInformation: Observable<PostInformation> = Observable(PostInformation())
    
    var postInfoViewModel: Observable<PostInformationViewModel> = Observable(PostInformationViewModel(model: PostInformation()))
    
    init(model: Post, postInfoViewModel: PostInformationViewModel){
        print(model)
        postCellModel.value = model
        title.value = model.title
        wasRead.value = model.wasRead
        isFavorite.value = model.isFavorite
        postInformation.value = model.postInformation
        self.postInfoViewModel.value = postInfoViewModel
    }
    
    
}
