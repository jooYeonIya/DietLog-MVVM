//
//  ExerciseEditViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/02.
//

import Foundation
import RxSwift
import UIKit

enum ExerciseEditViewModelText: String {
    case error = "URL을 확인해 주세요"
    case OK = "사용 가능합니다"
}

class ExerciseEditViewModel {
    var URLTextField = BehaviorSubject<String>(value: "")
    var URLErrorLabel = BehaviorSubject<String>(value: "")
    
    private var disposeBag = DisposeBag()

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
                print(url, result)
            }
        }
        
        return result ? ExerciseEditViewModelText.OK.rawValue : ExerciseEditViewModelText.error.rawValue
    }
}
