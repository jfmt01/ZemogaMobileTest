//
//  PostDescriptionViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 5/02/22.
//

import UIKit


protocol PostInformationControllerDelegate: AnyObject {
    func infoViewDidUpfate(post: PostInformationViewModel)
}
class PostInformationViewController: UIViewController {
    
    private enum Constants{
        static let nameTitle = "Name",
                   emailTitle = "Email",
                   phoneTitle = "Phone",
                   websiteTitle = "Website"
    }
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var webSiteLabel:UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    
    weak var delegate: PostInformationControllerDelegate?
    var descriptionTxt: String = ""
    var userNameTxt: String = ""
    var userEmailTxt: String = ""
    var userPhoneTxt: String = ""
    var userWebsiteTxt: String = ""
    
    
    
    var viewModel: PostInformationViewModelProtocol! {
        didSet {
            
            viewModel?.modelPost.bind { [weak self] postInfo in
                guard let self = self else {
                    return
                }
                self.descriptionTxt = postInfo.description
                self.userNameTxt = "\(Constants.nameTitle) : \(postInfo.user.name)"
                self.userEmailTxt = "\(Constants.emailTitle) : \(postInfo.user.email)"
                self.userPhoneTxt = "\(Constants.phoneTitle) : \(postInfo.user.phone)"
                //self.commentsTableView.reloadData()
            }
        }
        
        
    }
    //MARK : - Initializer
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewData()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        
        delegate?.infoViewDidUpfate(post: viewModel as! PostInformationViewModel)
    }

    private func setViewData(){
        descriptionLabel.text = descriptionTxt
        userNameLabel.text = userNameTxt
        emailLabel.text = userEmailTxt
        userPhoneLabel.text = userPhoneTxt
        webSiteLabel.text = userWebsiteTxt
    }
    
    
}
