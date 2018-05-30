//
//  RedditNetworkingBaseClass.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class RedditNetworking: NSObject {
    // MARK: Private
    private class func session() -> URLSession {
        return URLSession.shared
    }
    
    private class func request(_ endpoint: String, parameters: [String: String]) -> URLRequest? {
        guard let url = URL(string: Constants.apiBaseURL + endpoint) else {
            return nil
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = parameters.map { (parameter) -> URLQueryItem in
            return URLQueryItem(name: parameter.key, value: parameter.value)
        }
        guard let requestUrl = urlComponents?.url else {
            return nil
        }
        
        return URLRequest(url: requestUrl)
    }
    
    // MARK: Public
    class func getRequest(_ endpoint: String,
                          parameters: [String: String],
                          completionHandler: @escaping (Error?, Data?) -> ()) {
        
        guard let request = request(endpoint, parameters: parameters) else {
            // TODO: Generate error for this case
            DispatchQueue.main.async {
                completionHandler(nil, nil)
            }
            return
        }
        
        session().dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(error, data)
            }
        }.resume()
    }
}
