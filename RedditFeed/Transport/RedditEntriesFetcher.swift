//
//  FeedFetcher.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

// https://www.reddit.com/r/popular/top/.json?count=4&limit=2&after=t3_8mqwok

class RedditEntriesFetcher: NSObject {
    private static let fetchEntriesEndpoint = "/r/popular/top/.json"

    class func fetchInitialEntries(completionHandler: @escaping (Error?, [RedditEntry]?) -> ()) {
        let params = ["count": "0", "limit": "\(Constants.loadingBunchSize)"]
        
        RedditNetworking.getRequest(RedditEntriesFetcher.fetchEntriesEndpoint, parameters: params) { (error, responseData) in
            // Check for error
            guard error == nil else {
                completionHandler(error, nil)
                
                return
            }
            
            // unwrap optional response
            guard let response = responseData else {
                // TODO: Generate error
                completionHandler(nil, nil)
                
                return
            }
            
            // parse response into model objects
            do {
                let response = try JSONDecoder().decode(EntriesResponse.self, from: response)
                print(response.entries)
            }
            catch let error {
                print(error)
                return
            }
        }
    }
}
