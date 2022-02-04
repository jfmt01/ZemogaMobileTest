//
//  NavigationViewController.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 4/02/22.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        statusBarAppearance()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Functions
    
    private func statusBarAppearance(){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.mainGreenColor()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        
    }


}
