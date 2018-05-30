//
//  EntriesResponse.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

struct EntriesResponse {
    let entries: [RedditEntry]
}

extension EntriesResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum EntriesResponseChildren: String, CodingKey {
        case entries = "children"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: EntriesResponseChildren.self, forKey: .data)
        
        entries = try additionalInfo.decode([RedditEntry].self, forKey: .entries)
    }
}
