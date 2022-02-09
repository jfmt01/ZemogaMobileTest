//
//  CommentCellViewModel.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 7/02/22.
//

import Foundation

protocol CommentCellViewModelProtocol: AnyObject{
    //Mark: - Protocol Properties
    
    var comment: Observable<String>{get}
    
}

class CommentCellViewModel: CommentCellViewModelProtocol{
    var comment: Observable<String> = Observable("")
    
    //MARK: - Initializers
    init(comment: String){
        self.comment.value = comment
    }
}
