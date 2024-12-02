//
//  Date+Extensions.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//


import Foundation

extension Date {
    
    func relativeFormat() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let daysDifference = calendar.dateComponents([.day], from: self, to: now).day ?? 0
        
        if daysDifference == 0 {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: self, relativeTo: now)
        } else if daysDifference == 1 {
            return "ayer"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: self)
        }
    }
}
