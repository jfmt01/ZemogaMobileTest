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
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    weak var delegate: PostInformationControllerDelegate?
    var descriptionTxt: String = "",
        userNameTxt: String = "",
        userEmailTxt: String = "",
        userPhoneTxt: String = "",
        userWebsiteTxt: String = ""
    
    
    
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
        configTableView()
        setViewData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.infoViewDidUpfate(post: viewModel as! PostInformationViewModel)
    }
    
    private func configTableView(){
        view.backgroundColor = .grayBackground()
        commentsTableView.dataSource = self
        self.commentsTableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
    }
    
    private func setViewData(){
        descriptionLabel.text = descriptionTxt
        userNameLabel.text = userNameTxt
        emailLabel.text = userEmailTxt
        userPhoneLabel.text = userPhoneTxt
        webSiteLabel.text = userWebsiteTxt
        commentsTableView.reloadData()
    }
    
    
}

extension PostInformationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commentsViewModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell: CommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        
        
        newCell.viewModel = viewModel.commentsViewModel.value[indexPath.row]
        return newCell
    }
    
}

