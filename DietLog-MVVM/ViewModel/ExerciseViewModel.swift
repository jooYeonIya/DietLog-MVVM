//
//  ExerciseViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/04.
//

import Foundation
import RxSwift
import RealmSwift
import UIKit
import RxAlamofire

class ExerciseViewModel {
    
    var exerciseData: BehaviorSubject<[Exercise]> = BehaviorSubject(value: [])
    
    private var manager = ExerciseManager()
    private var service = YoutubeService.shared
    private var disposeBag = DisposeBag()
    
    func getExerciseData(categoryId: ObjectId) {
        if let result = manager.getAllExercise(for: categoryId) {
            exerciseData.onNext(Array(result))
        }
    }
    
    func getExerciseData(at column:SearchSegmentOption, with serchWord: String?) {
        if let result = manager.getAllExercise(at: column, with: serchWord) {
            exerciseData.onNext(Array(result))
        }
    }
    
    func getThumbnailImage(with url: String) -> Observable<UIImage?> {
        return RxAlamofire.requestData(.get, url)
            .map ({ (response, data) -> UIImage? in
                return UIImage(data: data)
            })
    }
    
    func deleteExercise(_ exercise: Exercise) {
        manager.deleteExercise(exercise)
    }
}

