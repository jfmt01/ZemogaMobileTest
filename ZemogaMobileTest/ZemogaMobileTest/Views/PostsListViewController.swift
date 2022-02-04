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
    
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        configSegmentedControlAppearance()
        // Do any additional setup after loading the view.
    }
    

  
    // MARK: - Private Functions
    
    private func configSegmentedControlAppearance(){
        //Config the segmented control border appeareance
        segmentedControl.selectedSegmentTintColor = UIColor.mainGreenColor()
        
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.mainGreenColor().cgColor
        segmentedControl.layer.masksToBounds = true
      
        segmentedControl.setTitleTextAttributes([.foregroundColor:UIColor.white], for: .selected)
        
        segmentedControl.setTitleTextAttributes([.foregroundColor:UIColor.mainGreenColor()], for: .normal)
        
        
    }
    

 

}
