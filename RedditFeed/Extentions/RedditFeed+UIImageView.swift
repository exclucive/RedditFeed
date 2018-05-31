//
//  UIImageView.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-29.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

extension UIImageView {
    private struct AssociatedKeys {
        static var imageKey = "imageKey"
    }
    
    var imageKey: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageKey) as? URL
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.imageKey, newValue as URL?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
