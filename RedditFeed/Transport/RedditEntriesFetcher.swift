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

    // MARK: Public methods
    private class func parse(_ data: Data?, completionHandler: @escaping (Error?, [RedditEntry]?) -> ()) {
        // unwrap optional response
        guard let responseData = data else {
            // TODO: Generate error
            completionHandler(nil, nil)
            return
        }
        
        // parse response into model objects
        do {
            let response = try JSONDecoder().decode(EntriesResponse.self, from: responseData)
            completionHandler(nil, response.entries)
        }
        catch let error {
            completionHandler(error, nil)
        }
    }
    
    // MARK: Public methods
    class func fetchInitialEntries(_ limit: Int, completionHandler: @escaping (Error?, [RedditEntry]?) -> ()) {
        let initialFetchParams = ["count": "0",
                                  "limit": "\(limit)"]
        
        RedditNetworking.getRequest(fetchEntriesEndpoint, parameters: initialFetchParams) { (error, data) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            
            //
            parse(data, completionHandler: completionHandler)
        }
    }
    
    class func fetchEntries(_ count: Int, limit: Int, after: String, completionHandler: @escaping (Error?, [RedditEntry]?) -> ()) {
        let paginationLoadingFetchParams = ["count": "\(count)",
                                            "limit": "\(limit)",
                                            "after": after]
        
        RedditNetworking.getRequest(fetchEntriesEndpoint, parameters: paginationLoadingFetchParams) { (error, data) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            
            //
            parse(data, completionHandler: completionHandler)
        }
    }
}
