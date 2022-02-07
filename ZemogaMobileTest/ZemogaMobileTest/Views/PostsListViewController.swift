//
//  PostsListViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit
import Combine
class PostsListViewController: UIViewController{

    //MARK: - UI Components reference
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var tableView: UITableView!
    
    private enum Constants{
        static let cellIdentifier: String = PostsListTableViewCell.reusableIdentifier
    }
    var anyCancellable = Set<AnyCancellable>()
    let viewModel = PostListViewModel()
    
    public let refreshControl = UIRefreshControl()
    let stopRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        configSegmentedControlAppearance()
        tableViewConfig()
        setNeedsStatusBarAppearanceUpdate()
        fetchPosts()
        
 
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        configBackBtnNavBar()
    }
 
    
    

  
    // MARK: - Private Functions
    
    //Table view configuration
    func tableViewConfig(){
        tableView.register(UINib(nibName: "PostsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        CreateRefreshControl()
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
    public func CreateRefreshControl(){
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.mainGreenColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Posts")
        refreshControl.addTarget(self, action: #selector(refreshPostList(_:)), for: .valueChanged)
    }
    
    func configBackBtnNavBar(){
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem.appearance()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
  
    @objc private func refreshPostList(_ sender: Any) {
        // Fetch Weather Data
        fetchPosts(fromRefresh: true)
    }
    private func fetchPosts(fromRefresh: Bool = false){
        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                self?.tableView.reloadData()
                if fromRefresh{
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &anyCancellable)
        
        
      
    }
}

//Mark: - Tableview delegate
extension PostsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //viewModel.selectedPost(post: viewModel.posts[indexPath.row])
    }
}

//Mark: - Table View Datasource
extension PostsListViewController: UITableViewDataSource{
    //1 metodo: Numero de filas de la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(viewModel.posts.count)
        return viewModel.posts.count
    }
    
    //2 metodo: Para saber qué celdas se deben mostrar
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsListTableViewCell", for: indexPath) as! PostsListTableViewCell
        
        cell.setupCell(with: viewModel.posts[indexPath.row])

        
        return cell
    }
}

