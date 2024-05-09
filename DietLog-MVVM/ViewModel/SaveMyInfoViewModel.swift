//
//  SaveMyInfoViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/29.
//

import Foundation
import RxSwift

class SaveMyInfoViewModel {
    var weightTextField: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    var muscleTextField: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    var fatTextField: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    
    private var weight: String?
    private var muscle: String?
    private var fat: String?
    
    private let disposeBag = DisposeBag()
    private let manager = MyInfoManager.shared

    
    init() {
        weightTextField
            .subscribe(onNext: { [weak self] weight in
                self?.weight = weight
            })
            .disposed(by: disposeBag)
        
        muscleTextField
            .subscribe(onNext: { [weak self] muscle in
                self?.muscle = muscle
            })
            .disposed(by: disposeBag)
        
        fatTextField
            .subscribe(onNext: { [weak self] fat in
                self?.fat = fat
            })
            .disposed(by: disposeBag)
    }
    
    func saveMyInfo(for postedDate: Date) -> Bool {

        if weight == "" && muscle == "" && fat == "" {
            return false
        }
        
        if let result = manager.loadMyInfo(for: postedDate) {
            manager.delete(result)
        }
        
        let myInfo = MyInfo()
        myInfo.postedDate = postedDate
        myInfo.weight = weight
        myInfo.muscle = muscle
        myInfo.fat = fat
        
        manager.create(myInfo)
        
        return true
    }
}
