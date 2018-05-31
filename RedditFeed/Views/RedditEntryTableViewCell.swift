//
//  RedditEntryTableViewCell.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-29.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

protocol RedditEntryTableViewCellDelegate: class {
    func didTapOnThumbnailImage(cell: RedditEntryTableViewCell)
}

class RedditEntryTableViewCell: UITableViewCell {
    static let cellIdentifier = "RedditEntryTableViewCell"
    
    weak var delegate: RedditEntryTableViewCellDelegate?
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupTapAction() {
        thumbnailImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailImageTapAction(_:)))
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    @IBAction func thumbnailImageTapAction(_ sender: Any) {
        delegate?.didTapOnThumbnailImage(cell: self)
    }
}
