//
//  RedditEntry.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

//- Title (at its full length, so take this into account when sizing your cells)
//- Author
//- entry date, following a format like “x hours ago”
//- A thumbnail for those who have a picture.
//- Number of comments

struct RedditEntry {
    let name: String
    let title: String
    let author: String
    let created: Double
    let thumbnailURL: URL?
    let numberOfComments: Int
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum RedditEntryDataKeys: String, CodingKey {
        case name
        case title
        case author
        case created
        case thumbnailURL = "thumbnail"
        case numberOfComments = "num_comments"
    }
}

extension RedditEntry: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: RedditEntryDataKeys.self, forKey: .data)
        
        name = try additionalInfo.decode(String.self, forKey: .name)
        title = try additionalInfo.decode(String.self, forKey: .title)
        author = try additionalInfo.decode(String.self, forKey: .author)
        created = try additionalInfo.decode(Double.self, forKey: .created)
        thumbnailURL = try additionalInfo.decode(URL.self, forKey: .thumbnailURL)
        numberOfComments = try additionalInfo.decode(Int.self, forKey: .numberOfComments)
    }
}

