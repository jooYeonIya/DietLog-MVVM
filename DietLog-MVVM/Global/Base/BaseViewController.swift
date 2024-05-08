//
//  BaseViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var topView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGray
        
        setupTopView()
        
        setupNavigationBar()
        setupUI()
        setupLayout()
        setupDelegate()
        setupEvent()
        setupBinding()
    }
    
    func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupBinding() {}
    
    func setupUI() {}
    
    func setupLayout() {}
    
    func setupDelegate() {}
    
    func setupEvent() {}
}

extension BaseViewController {
    func setupTopView() {
        topView.backgroundColor = .customYellow
        
        view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
    }
    
    func displayTopView(_ display: Bool) {
        topView.isHidden = !display
    }
}

extension BaseViewController {
    func showAlertWithOKButton(title: String?,
                               message: String?,
                               OKTitle: String = "확인",
                               completion: (() -> Void)? = nil) {
        let OKAction = UIAlertAction(title: OKTitle, style: .default) { _ in
            completion?()
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(OKAction)
        
        present(alert, animated: true)
    }
    
    func showAlertTwoButton(title: String?,
                            message: String?,
                            actionTitle: String = "확인",
                            actionCompletion: (() -> Void)? = nil,
                            cancelTitle: String = "취소",
                            cancelCompletion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelCompletion?()
        }
        
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            actionCompletion?()
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showOptionMenuSheet(modifyCompletion: (() -> Void)?,
                             deleteCompletion: (() -> Void)?) {
        let modify = UIAlertAction(title: "수정", style: .default) { _ in
            modifyCompletion?()
        }
        
        let delete = UIAlertAction(title: "삭제", style: .default) { _ in
            deleteCompletion?()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(modify)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}
