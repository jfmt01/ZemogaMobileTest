//
//  PostsListViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit
import SwiftUI


class PostsListViewController: UIViewController{

    //MARK: - UI Components reference
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var tableView: UITableView!
    
    private enum Constants{
        static let cellIdentifier: String = PostsListTableViewCell.reusableIdentifier
    }
    
   

    
    var viewModel: PostsListViewModelProtocol?{
        didSet{
            loadViewIfNeeded()
            //MARK: - Table data bind
            viewModel?.modelPost.bind({[weak self] _ in
                guard let self = self else {
                      return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
            //MARK: - Cells data bind
            viewModel?.postCellViewModel.bind({ [weak self] _ in
                guard let self = self else {
                      return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            

            viewModel?.stopRefreshControl = {[weak self] in
                guard let self = self else{
                    return
                }
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    let refreshControl = UIRefreshControl()
    let stopRefresh = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableViewConfig()
        viewModel = PostsListViewModel()
        viewModel?.viewModelDidLoad()
        configSegmentedControlAppearance()
        
        setNeedsStatusBarAppearanceUpdate()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        configBackBtnNavBar()
    }
 
    
    

  
    // MARK: - Private Functions
    
    //Table view configuration
    private func tableViewConfig(){
        
        refreshControl.tintColor = UIColor.mainGreenColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Posts Data...", attributes: nil)
        self.tableView.register(UINib(nibName: "PostsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsListTableViewCell")
                self.tableView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
   
        tableView.refreshControl = refreshControl
    }
    
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
    
    func configBackBtnNavBar(){
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem.appearance()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    //MARK: Refresh controller table view fetch data
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        viewModel?.getAllPosts()
    }
    
    
    //MARK: - Switch between all elements and only favorites
    @IBAction func handlingSegmentedcontrolAction(_ sender: UISegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            viewModel?.showFavoritesPost(onlyFavorites: true)
        } else {
            viewModel?.showFavoritesPost(onlyFavorites: false)
        }
    }
    
    
    //MARK: - Delete all posts
    @IBAction func touchUpDeleteAll(_ sender: Any) {
        viewModel?.deleteAllPost()
    }
}

//Mark: - Tableview delegate

extension PostsListViewController: UITableViewDelegate{
   
}

//Mark: - Table View Datasource
extension PostsListViewController: UITableViewDataSource{
    //1 metodo: Numero de filas de la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.postCellViewModel.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cell: PostsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostsListTableViewCell", for: indexPath) as! PostsListTableViewCell
        cell.viewModel = viewModel.postCellViewModel.value[indexPath.row]
        return cell
        
    }
}


