//
//  ViewController.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        // Creating Objects for UINavigationController which will later be added to tab bar view Controllers tab
        // Root viewControllers of the UINavigationController will be the controller we have made
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        //BElow is the process of assigning  the Images to the tab bar item of the tab bar controller and Title is also being added
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        //title for the Navigation controller will be the title for the Tab bar item
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Search"
        vc4.title = "Downloads"
        
        //Function which sets up the Navigation controller objects which we have Made above to the tabbar controller it takes inputArray of
        //setViewControllers([UIViewCOntrollers?],animation)
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }


}

