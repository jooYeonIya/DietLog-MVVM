//
//  ViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customYellow
        
        let mealView = MealViewController()
        let myInfoView = MyInfoViewController()
        let exerciseView = CategoryViewController()
        
        let tabBarItems = TabBarOption.allCases.map {
            UITabBarItem(title: $0.toTabTitle(), image: $0.toTabImage(), tag: $0.rawValue)
        }
        
        viewControllers = [mealView, myInfoView, exerciseView]
            .enumerated()
            .map { setupTabBarItem(for: $0.element, tabBarItem: tabBarItems[$0.offset])}
            .map { setupNavigationBar(for: $0) }
    
        selectedIndex = TabBarOption.myInfo.rawValue
    }
    
    private func setupTabBarItem(for view: UIViewController, tabBarItem: UITabBarItem) -> UIViewController {
        view.tabBarItem = tabBarItem
        return view
    }
    
    private func setupNavigationBar(for view: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: view)
    }
}

