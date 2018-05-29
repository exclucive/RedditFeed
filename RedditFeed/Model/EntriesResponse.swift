//
//  EntriesResponse.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

struct EntriesResponse: Decodable {
    let entries: [RedditEntry]
    
    enum CodingKeys: String, CodingKey {
        case entries = "children"
    }
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        entries = try [keyedContainer.decode(RedditEntry.self, forKey: .entries)]
    }
}
