//
//  BackgroundViewController.swift
//  ShareDL
//
//  Created by Jooyeon Kang on 2024/05/06.
//

import UIKit

class BackgroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        let grayView = UIView()
        grayView.backgroundColor = .systemGray

        view.insertSubview(grayView, at: 0)
    }
}
