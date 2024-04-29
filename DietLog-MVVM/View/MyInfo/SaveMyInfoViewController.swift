//
//  SaveMyInfoViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/29.
//

import UIKit

class SaveMyInfoViewController: BaseViewController {
    
    // MARK: - 변수
    private var myInfo: MyInfo?
    private var selectedDate: Date

    // MARK: - 변수
    override func viewDidLoad() {
        super.viewDidLoad()

        displayTopView(false)
    }
    
    // MARK: - 초기화
    init(myInfo: MyInfo?, selectedDate: Date) {
        self.myInfo = myInfo
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
        
        print(myInfo)
        print(selectedDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
