//
//  SearchSegmentOption.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import Foundation

enum SearchSegmentOption: Int {
    case title
    case memo

    var title: String {
        switch self {
        case .title: return "타이틀"
        case .memo: return "메모"
        }
    }

    var column: String {
        switch self {
        case .title: return "title"
        case .memo: return "memo"
        }
    }
}
