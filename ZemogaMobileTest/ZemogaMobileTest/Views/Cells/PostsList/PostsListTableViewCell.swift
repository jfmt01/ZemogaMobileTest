//
//  PostsListTableViewCell.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit

class PostsListTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var wasReadIcon: UIView!
    static let  reusableIdentifier = "PostCell"
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with post: Post){
        //print(title)
//        print(post.title)
//        let title: String = post.title
//        print(title)
        cellTitle.text = post.title
        wasReadIcon.translatesAutoresizingMaskIntoConstraints = false
        wasReadIcon.layer.cornerRadius = 7
        //wasReadIcon.isHidden = true
        
        //wasReadIcon.layer.cornerRadius = wasReadIcon.frame.height/2
    }
}
