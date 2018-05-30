//
//  Dates.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-29.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

extension Date {
    static func numberOfHoursUntilNow(timeStamp: TimeInterval) -> Int {
        let createdDate = Date(timeIntervalSince1970: timeStamp)
        guard let diffInHours = Calendar.current.dateComponents([.hour], from: createdDate, to: Date()).hour else {
            return 0
        }
        
        return diffInHours
    }
}
