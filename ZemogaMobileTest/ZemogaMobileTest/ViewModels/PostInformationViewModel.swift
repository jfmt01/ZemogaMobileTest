//
//  PostInformationViewModel.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 7/02/22.
//

import Foundation

protocol PostInformationViewModelProtocol: AnyObject{
    
    //Mark: - Protocol Properties
    
    var modelPost: Observable<PostInformation>{get set}
    var commentsViewModel: Observable<[CommentCellViewModel]>{get}
    var starPostInformation: ((PostInformation) -> ())? {get set}
}

class PostInformationViewModel: PostInformationViewModelProtocol{
    
    var modelPost: Observable<PostInformation> = Observable(PostInformation())
    
    var commentsViewModel: Observable<[CommentCellViewModel]> = Observable([])
    
    var starPostInformation: ((PostInformation) -> ())?
    
    //MARK: - Initializers
    
    init(model: PostInformation){
        modelPost.value = model
        commentsViewModel.value = model.comments.compactMap{
            CommentCellViewModel(comment: $0)
        }
    }
}
