//
//  DateFormmater+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/29.
//

import Foundation

extension DateFormatter {
    func toString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}

