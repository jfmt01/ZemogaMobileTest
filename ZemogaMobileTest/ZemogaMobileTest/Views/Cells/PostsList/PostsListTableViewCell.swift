//
//  PostsListTableViewCell.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit
import SwiftUI

class PostsListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wasReadIconView: UIView!
    @IBOutlet weak var isFavoriteImage: UIImageView!
    static let  reusableIdentifier = "PostsListTableViewCell"
    
    var viewModel: PostCellViewModel!{
        didSet{
            
            //MARK: - Set cell text title
            viewModel.title.bind {[weak self] title in
                guard let self = self else {
                    return
                }
                self.titleLabel.text = title
                
            }
            
            //MARK: - Post was read icon
            viewModel.wasRead.bind { [weak self] wasRead in
                guard let self = self else {
                    return
                }
                self.configWasReadIcon()
                self.wasReadIconView.isHidden = wasRead
            }
            
            //MARK: - Post is favorite icon
            viewModel.isFavorite.bind {  [weak self] isFavorite in
                guard let self = self else {
                    return
                }
                
                if isFavorite{
                    self.wasReadIconView.isHidden = isFavorite
                }
                
                self.isFavoriteImage.isHidden = !isFavorite
            }
           
        }
    }
    
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configWasReadIcon(){

        wasReadIconView.translatesAutoresizingMaskIntoConstraints = false
        wasReadIconView.layer.cornerRadius = 7
   }
}
