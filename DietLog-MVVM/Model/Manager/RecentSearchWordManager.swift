//
//  RecentSearchWordManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import Foundation

class RecentSearchWordManager {
    static let shared = RecentSearchWordManager()
    
    var keyNmae: String {
        return String(describing: self)
    }
    
    func add(to recentSearchWord: String) {
        var allRecentSearchWord = getAllRecentSearchWord()
        
        if allRecentSearchWord.count == 20 {
            allRecentSearchWord.removeLast()
        }
        
        allRecentSearchWord.insert(recentSearchWord, at: 0)
        UserDefaults.standard.set(allRecentSearchWord, forKey: keyNmae)
    }
    
    func getAllRecentSearchWord() -> [String] {
        return UserDefaults.standard.stringArray(forKey: keyNmae) ?? []
    }
    
    func deleteAllRecentSearchWord() {
        UserDefaults.standard.removeObject(forKey: keyNmae)
    }
    
    func deleteSearch(at index: Int) {
        var allRecentSearchWord = getAllRecentSearchWord()
        allRecentSearchWord.remove(at: index)
        UserDefaults.standard.set(allRecentSearchWord, forKey: keyNmae)
    }
}
