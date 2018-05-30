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
    
//    private struct AssociatedKeys {
//        static var imageCache = NSCache<NSString, AnyObject>()
//    }
//
//    var imageCache: NSCache<NSString, AnyObject>? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.imageCache) as? NSCache<NSString, AnyObject>
//        }
//
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, &AssociatedKeys.imageCache, newValue as NSCache<NSString, AnyObject>?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
    
    func downloadImage(withURL url: URL, completionHandler: @escaping (Bool, UIImage?, URL?) -> ()) {
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            sleep(1)
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(false, nil, nil)
                    return
                }
                
                guard let responseData = data else {
                    completionHandler(false, nil, nil)
                    return
                }
                
                let image = UIImage(data: responseData)
                completionHandler(true, image, response?.url)
            }
        }.resume()
    }
    
    func setImage(withURL url: URL?, placeholder: UIImage?) {
        image = placeholder
        
        if let url = url {
            self.imageKey = url
        
            downloadImage(withURL: url) { [unowned self] (success, image, responseUrl) in
                if responseUrl == self.imageKey && success {
                    self.image = image
                }
            }
        }
    }
}
