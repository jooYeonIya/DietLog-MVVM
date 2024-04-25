//
//  CategoryViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class CategoryViewController: BaseViewController {

    // MARK: - Component

    
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
    
    // MARK: - Setup Layout
    override func setupLayout() {
        
    }
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
