//
//  PostsListViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit

class PostsListViewController: UIViewController {

    //MARK: - UI Components reference
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var tableView: UITableView!
    
    public let refreshControl = UIRefreshControl()
    
    let stopRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        CreateRefreshControl()
        configSegmentedControlAppearance()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        configBackBtnNavBar()
    }
 
    
    

  
    // MARK: - Private Functions
    
    //Segmented control appeareance Function
    private func configSegmentedControlAppearance(){
        //Config the segmented control border appeareance
        segmentedControl.selectedSegmentTintColor = UIColor.mainGreenColor()
        
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.mainGreenColor().cgColor
        segmentedControl.layer.masksToBounds = true
      
        segmentedControl.setTitleTextAttributes([.foregroundColor:UIColor.white], for: .selected)
        
        segmentedControl.setTitleTextAttributes([.foregroundColor:UIColor.mainGreenColor()], for: .normal)
        
        
    }
    
    //Refresh control to reload the table view data
    public func CreateRefreshControl(){
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.mainGreenColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Posts")
    }
    
    func configBackBtnNavBar(){
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem.appearance()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
  
    

    
 

}
