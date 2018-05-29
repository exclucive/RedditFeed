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

struct RedditEntry: Decodable {
    let thingName: String
    let title: String
    let author: String
    let date: String
    let thumbnailURL: URL?
    let numberOfComments: Int
}
