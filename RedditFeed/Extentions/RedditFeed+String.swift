//
//  RedditFeed+String.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-30.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

extension String {
    public func isImageType() -> Bool {
        let imageFormats = ["jpg", "png", "gif"]
        
        if URL(string: self) != nil  {
            let pathExtension = (self as NSString).pathExtension
            return imageFormats.contains(pathExtension)
        }
        
        return false
    }

}
