//
//  FSCalendarView+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import FSCalendar

extension FSCalendar {
    func configure() {
        scope = .month
        
        scrollEnabled = true
        scrollDirection = .vertical
        
        // 헤더
        appearance.headerTitleFont = .title
        appearance.headerTitleColor = .black
        appearance.headerDateFormat = "YYYY년 MM월"
        appearance.headerTitleAlignment = .left
        appearance.headerTitleOffset = CGPoint(x: 12, y: 0)
        appearance.headerMinimumDissolvedAlpha = 0.0
        
        headerHeight = 60
        
        // 요일
        locale = Locale(identifier: "ko_KR")
        firstWeekday = 1
        weekdayHeight = 12
        
        appearance.weekdayFont = .smallBody
        appearance.weekdayTextColor = .systemGray
        
        // 날짜
        appearance.titleFont = .body
        appearance.todayColor = .clear
        appearance.titleTodayColor = .black
        
        appearance.selectionColor = .customGreen
        
        placeholderType = .none
        
        select(Date.now)
    }
}
