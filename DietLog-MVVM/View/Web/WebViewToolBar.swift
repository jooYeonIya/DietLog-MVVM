//
//  WebViewToolBar.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import UIKit

class WebViewToolBar: UIToolbar {
    
    lazy var backwardButton = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: nil, action: nil)
    
    lazy var forwardButton = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: nil, action: nil)
    
    lazy var shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: nil, action: nil)
    
    lazy var safariButton = UIBarButtonItem(image: UIImage(named: "safari"), style: .plain, target: nil, action: nil)
        
    lazy var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    lazy var toolBarButtons = [backwardButton,
                               flexibleSpace,
                               forwardButton,
                               flexibleSpace,
                               shareButton,
                               flexibleSpace,
                               safariButton]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isTranslucent = false
        barTintColor = .customGray
        
        toolBarButtons.forEach {
            $0.tintColor = .black
        }
        
        setItems(toolBarButtons, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

