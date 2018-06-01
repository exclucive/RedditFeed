//
//  RFError.swift
//  RedditFeed
//
//  Created by Igor Novik on 5/31/18.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

protocol RFErrorType {
    var code: Int {get}
    var title: String? {get}
    var description: String {get}
}

struct RFError: LocalizedError {
    var title: String?
    var code: Int
    var errorDescription: String? { return internalDescription }
    var failureReason: String? { return internalDescription }
    
    private var internalDescription: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self.internalDescription = description
        self.code = code
    }
    
    init(errorType: RFErrorType) {
        self.title = errorType.title
        self.internalDescription = errorType.description
        self.code = errorType.code
    }
    
    var printableDescription: String {
        get {
            return "\(title ?? ""): \(code)\n\(errorDescription ?? "")"
        }
    }
}
