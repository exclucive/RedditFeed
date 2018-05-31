//
//  RedditImageDownloader.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-30.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class RedditImageDownloader: NSObject {
    let imageCache = NSCache<NSString, AnyObject>()
    
    private func downloadImage(withURL url: URL, completionHandler: @escaping (Bool, UIImage?, URL?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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

    // MARK: Public
    func setImage(toImageView imageView: UIImageView, withURL url: URL?, placeholder: UIImage?) {
        setImage(toImageView: imageView, withURL: url, placeholder: placeholder, completion: nil)
    }
    
    func setImage(toImageView imageView: UIImageView, withURL url: URL?, placeholder: UIImage?, completion: ((Bool) -> ())?) {
        guard let url = url else {
            imageView.imageKey = nil
            imageView.image = placeholder
            completion?(false)
            return
        }
        
        if let existingImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            imageView.image = existingImage
            completion?(true)
        }
        else {
            imageView.imageKey = url
            imageView.image = placeholder
            
            downloadImage(withURL: url) { [unowned self] (success, image, responseUrl) in
                guard let image = image, let url = responseUrl else {
                    completion?(false)
                    return
                }
                
                print(image)
                print(url.absoluteString)
                
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                if responseUrl == imageView.imageKey && success {
                    imageView.image = image
                }
                
                completion?(success)
            }
        }
    }
    
}
