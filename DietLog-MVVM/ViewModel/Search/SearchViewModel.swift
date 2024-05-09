//
//  v.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import Foundation
import RxSwift

class SearchViewModel {

    var recentSearchWords = BehaviorSubject<[String]>(value: [])
    var searchBar = PublishSubject<Bool>()
    
    private var manager = RecentSearchWordManager.shared
    
    func saveRecentSearchWord(with word: String) {
        manager.add(to: word)
    }
    
    func findRecentSearchWords() {
        recentSearchWords.onNext(manager.getAllRecentSearchWord())
    }
    
    func removeAllRecenteSearchWords() {
        manager.deleteAllRecentSearchWord()
    }
    
    func removeRecenteSearchWord(at index: Int) {
        manager.deleteSearch(at: index)
    }
}
