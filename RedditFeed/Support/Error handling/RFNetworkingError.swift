//
//  RFNetworkingError.swift
//  RedditFeed
//
//  Created by Igor Novik on 5/31/18.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

enum RFNetworkingError: RFErrorType {
    case entriesFetchingError
    
    var code: Int {
        switch self {
        case .entriesFetchingError:
            return -10
        }
    }
    
    var title: String? {
        switch self {
        case .entriesFetchingError:
            return "Entries downloading error"
        }
    }
    
    var description: String {
        switch self {
        case .entriesFetchingError:
            return "The error occured during entries fetching downloading"
        }
    }
}
