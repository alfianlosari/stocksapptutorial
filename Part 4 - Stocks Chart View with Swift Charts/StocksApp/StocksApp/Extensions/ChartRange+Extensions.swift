//
//  ChartRange+Extensions.swift
//  StocksApp
//
//  Created by Alfian Losari on 16/10/22.
//

import Foundation
import XCAStocksAPI

extension ChartRange: Identifiable {
    
    public var id: Self { self }
    
    var title: String {
        switch self {
        case .oneDay: return "1D"
        case .oneWeek: return "1W"
        case .oneMonth: return "1M"
        case .threeMonth: return "3M"
        case .sixMonth: return "6M"
        case .oneYear: return "1Y"
        case .twoYear: return "2Y"
        case .fiveYear: return "5Y"
        case .tenYear: return "10Y"
        case .ytd: return "YTD"
        case .max: return "ALL"
        }
    }
    
    var dateFormat: String {
        switch self {
        case .oneDay: return "H"
        case .oneWeek, .oneMonth: return "d"
        case .threeMonth, .sixMonth, .ytd: return "MMM"
        case .oneYear, .twoYear: return "MMMM"
        case .fiveYear, .tenYear, .max: return "yyyy"
        }
    }
    
    func getDateComponents(startDate: Date, endDate: Date, timezone: TimeZone) -> Set<DateComponents> {
        let component: Calendar.Component
        let value: Int
        switch self {
        case .oneDay:
            component = .hour
            value = 1
        case .oneWeek:
            component = .day
            value = 1
        case .oneMonth:
            component = .weekOfYear
            value = 1
        case .threeMonth, .sixMonth:
            component = .month
            value = 1
        case .ytd:
            component = .month
            value = 2
        case .oneYear:
            component = .month
            value = 4
        case .twoYear:
            component = .month
            value = 6
        case .fiveYear, .tenYear:
            component = .year
            value = 2
        case .max:
            component = .year
            value = 8
        }
        
        var set  = Set<DateComponents>()
        var date = startDate
        if self != .oneDay {
            set.insert(startDate.dateComponents(timeZone: timezone, rangeType: self))
        }
        
        while date <= endDate {
            date = Calendar.current.date(byAdding: component, value: value, to: date)!
            set.insert(date.dateComponents(timeZone: timezone, rangeType: self))
        }
        return set
    }
    
}
