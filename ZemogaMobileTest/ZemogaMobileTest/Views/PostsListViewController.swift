//
//  PostsListViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit



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
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PostsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsListTableViewCell")
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.mainGreenColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Posts Data...", attributes: nil)
        
        
        
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
        
        switch sender.selectedSegmentIndex{
        case 1:
            viewModel?.showFavoritesPost(showFavs: true)
        default:
            viewModel?.showFavoritesPost(showFavs: false)
        }
    }
    
    
    //MARK: - Delete all posts
    @IBAction func touchUpDeleteAll(_ sender: Any) {
        viewModel?.deleteAllPost()
    }
}

//Mark: - Tableview delegate

//Mark: - Table View Datasource
extension PostsListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cell: PostsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostsListTableViewCell", for: indexPath) as! PostsListTableViewCell
        cell.viewModel = viewModel.postCellViewModel.value[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.postCellViewModel.value.count
    }
    
    
    
}

extension PostsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewModel = viewModel{
            
            viewModel.modelPost.value[indexPath.row].wasRead = true
            
            viewModel.postSelected(postViewModel: viewModel.postCellViewModel.value[indexPath.row].postInfoViewModel.value,
                                   post: viewModel.modelPost.value[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let viewModel = viewModel else { return }
            // Delete the row from the data source
            tableView.beginUpdates()
            viewModel.deleteIndividualPost(post: viewModel.modelPost.value[indexPath.row], index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}




