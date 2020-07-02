//
//  DateUtilities.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 7/2/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation

extension Date {
    var formattedString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E d MMM yyyy h:mm a"
            let dateString = dateFormatter.string(from: self)
            
            return dateString
        }
    }
    
    var timeAgo: String {
        get {
            let relativeDateFormatter = RelativeDateTimeFormatter()
            relativeDateFormatter.dateTimeStyle = .numeric
            relativeDateFormatter.unitsStyle = .abbreviated
            var relativeDate = relativeDateFormatter.localizedString(for: self, relativeTo: Date())
            relativeDate = relativeDate.replacingOccurrences(of: " ago", with: "")
            
            return relativeDate.capitalized
        }
    }
}
