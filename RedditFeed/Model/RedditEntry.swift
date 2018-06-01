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

class RedditEntry: NSObject, NSCoding, Decodable {
    let name: String
    let title: String
    let author: String
    let created: Double
    let thumbnailURL: URL?
    let fullImageURL: URL?
    let numberOfComments: Int

    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum RedditEntryDataKeys: String, CodingKey {
        case name
        case title
        case author
        case created = "created_utc"
        case thumbnailURL = "thumbnail"
        case fullImageURL = "url"
        case numberOfComments = "num_comments"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: RedditEntryDataKeys.self, forKey: .data)
        
        name = try additionalInfo.decode(String.self, forKey: .name)
        title = try additionalInfo.decode(String.self, forKey: .title)
        author = try additionalInfo.decode(String.self, forKey: .author)
        created = try additionalInfo.decode(TimeInterval.self, forKey: .created)
        thumbnailURL = try additionalInfo.decode(URL.self, forKey: .thumbnailURL)
        fullImageURL = try additionalInfo.decode(URL.self, forKey: .fullImageURL)
        numberOfComments = try additionalInfo.decode(Int.self, forKey: .numberOfComments)
    }
    
    //MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.author = aDecoder.decodeObject(forKey: "author") as! String
        self.thumbnailURL = aDecoder.decodeObject(forKey: "thumbnailURL") as? URL
        self.fullImageURL = aDecoder.decodeObject(forKey: "fullImageURL") as? URL
        self.created = aDecoder.decodeDouble(forKey: "created")
        self.numberOfComments = aDecoder.decodeInteger(forKey: "numberOfComments")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(author, forKey: "author")
        aCoder.encode(thumbnailURL, forKey: "thumbnailURL")
        aCoder.encode(fullImageURL, forKey: "fullImageURL")
        aCoder.encode(created, forKey: "created")
        aCoder.encode(numberOfComments, forKey: "numberOfComments")
    }
}
