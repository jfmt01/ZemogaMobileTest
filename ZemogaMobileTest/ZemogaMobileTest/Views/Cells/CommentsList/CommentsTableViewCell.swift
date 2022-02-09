//
//  CommentsTableViewCell.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 7/02/22.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentCell: UILabel!
    var viewModel: CommentCellViewModel!{
        didSet{
            viewModel.comment.bind{[weak self] comment in
                guard let self = self else{
                    return
                }
                self.commentCell.text = comment
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
