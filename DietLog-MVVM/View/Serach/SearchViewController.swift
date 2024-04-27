//
//  SearchViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class SearchViewController: BaseViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        
        setupSearchBarUI()
    }
    
    private func setupSearchBarUI() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}

// MARK: - SerachBar
extension SearchViewController: UISearchBarDelegate {
    
}
