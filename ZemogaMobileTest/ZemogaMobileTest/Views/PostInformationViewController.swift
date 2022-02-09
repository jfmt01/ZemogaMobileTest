//
//  PostDescriptionViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 5/02/22.
//

import UIKit
import Foundation
import NotificationBannerSwift

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
    @IBOutlet private var descriptionTitle: UILabel!
    @IBOutlet private var userTitle: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var userPhoneLabel: UILabel!
    @IBOutlet private var webSiteLabel:UILabel!
    
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    private let favIconButton: UIButton = {
        let iconButton = UIButton(frame: CGRect(x:0, y:0, width:35, height: 35))
        iconButton.setImage(UIImage(systemName: "star.fill")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal), for: .selected)
        iconButton.setImage(UIImage(systemName: "star")?.withTintColor(.white), for: .normal)
        
        return iconButton
    }()
    
    
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
                self.userPhoneTxt = "\(Constants.phoneTitle) : \(postInfo.user.phone)"
                self.userEmailTxt = "\(Constants.emailTitle) : \(postInfo.user.email)"
                self.userWebsiteTxt = "\(Constants.phoneTitle) : \(postInfo.user.webSite)"
                self.checkAsFavOnInit(postInfo: postInfo)
            }
        }
        
        
    }
    
    //MARK : - Initializer
    override func viewDidLoad() {
        super.viewDidLoad()
        addFavIconToNavBar()
        configView()
        print(favIconButton)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.infoViewDidUpfate(post: viewModel as! PostInformationViewModel)
    }
    //MARK: - Config UITableView
    private func configTableView(){
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        self.commentsTableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        if self.traitCollection.userInterfaceStyle == .dark{
            commentsTableView.separatorColor = .grayBackground()
        }
    }
    
    
    private func setViewData(){
        descriptionLabel.text = descriptionTxt
        userNameLabel.text = userNameTxt
        emailLabel.text = userEmailTxt
        userPhoneLabel.text = userPhoneTxt
        webSiteLabel.text = userWebsiteTxt
        commentsTableView.reloadData()
        
    }
    
    private func addFavIconToNavBar(){
        let rightNavBarBtn = UIBarButtonItem()
        rightNavBarBtn.customView = favIconButton
        favIconButton.addTarget(self, action: #selector(touchInFavButton), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = rightNavBarBtn
    }
    
    private func configView(){
        configTableView()
        setViewData()
    }
    
    private func checkAsFavOnInit(postInfo: PostInformation){
        favIconButton.isSelected = postInfo.isFavInfo
    }
    
    @objc func touchInFavButton() {
        favIconButton.isSelected = !favIconButton.isSelected
        let postInfo = viewModel.modelPost.value
        postInfo.isFavInfo = favIconButton.isSelected
        viewModel.modelPost.value = postInfo
        viewModel.modelPost = Observable(postInfo)
        if favIconButton.isSelected{
            NotificationBanner.addedToFavBanner()
        }
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"),
                                        object: nil,
                                        userInfo: ["postInfo": postInfo])
        
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

extension PostInformationViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

