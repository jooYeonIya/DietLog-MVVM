//
//  ExerciseEditViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/02.
//

import Foundation
import RxSwift
import UIKit
import RealmSwift

enum ExerciseEditViewModelText: String {
    case error = "URL을 확인해 주세요"
    case OK = "사용 가능합니다"
}

class ExerciseEditViewModel {
    var URLTextField = BehaviorSubject<String>(value: "")
    var URLErrorLabel = BehaviorSubject<String>(value: "")
    var selectedCategoryId = BehaviorSubject<ObjectId?>(value: nil)
    var memoTextView = BehaviorSubject<String?>(value: nil)
    
    private var disposeBag = DisposeBag()
    private var isEnableURL: Bool = false
    private var manager = ExerciseManager.shared
    private var service = YoutubeService.shared
    
    init() {
        URLTextField
            .map { [weak self] url -> String in
                guard !url.isEmpty else { return "" }
                return self?.validateURL(url) ?? ""
            }
            .bind(to: URLErrorLabel)
            .disposed(by: disposeBag)
    }
    
    private func validateURL(_ url: String) -> String {
        var result = false
        
        if url.contains("youtube") || url.contains("youtu.be") || url.contains("youtube.com/shorts") {
            if let url = URL(string: url) {
                result = UIApplication.shared.canOpenURL(url as URL)
            }
        }
        
        isEnableURL = result
        return result ? ExerciseEditViewModelText.OK.rawValue : ExerciseEditViewModelText.error.rawValue
    }
    
    func saveData() -> Bool {
        let id = try? selectedCategoryId.value()
        
        if !isEnableURL || id == nil {
            return false
        }
        
        guard let memo = try? memoTextView.value(),
              let url = try? URLTextField.value() else { return false }
        
        service.getVideoInfo(for: url)
            .subscribe(onNext: { [weak self] result in
                let exercise = Exercise()
                exercise.URL = url
                exercise.categoryID = id!
                exercise.memo = memo
                exercise.thumbnailURL = result["thumbnailURL"] ?? ""
                exercise.title = result["title"] ?? ""
                self?.manager.create(exercise)
            }).disposed(by: disposeBag)
        
        return true
    }
    
    func updateData(_ exercise: Exercise) -> Bool {
        guard let id = try? selectedCategoryId.value(),
              let memo = try? memoTextView.value() else { return false }
        
        let newExericse = Exercise()
        newExericse.categoryID = id
        newExericse.memo = memo
        
        manager.update(exercise, newExercise: newExericse)
        
        return true
    }
}
