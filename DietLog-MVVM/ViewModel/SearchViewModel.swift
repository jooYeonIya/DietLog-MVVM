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
    
    func addRecentSearchWord(with word: String) {
        manager.add(to: word)
    }
    
    func getRecentSearchWords() {
        recentSearchWords.onNext(manager.getAllRecentSearchWord())
    }
    
    func deleteAllRecenteSearchWords() {
        manager.deleteAllRecentSearchWord()
    }
    
    func deleteRecenteSearchWord(at index: Int) {
        manager.deleteSearch(at: index)
    }
}
