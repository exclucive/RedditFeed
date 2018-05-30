//
//  RedditEntryTableViewCell.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-29.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class RedditEntryTableViewCell: UITableViewCell {
    static let cellIdentifier = "RedditEntryTableViewCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
