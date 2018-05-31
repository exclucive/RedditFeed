//
//  ViewController.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class EntriesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var entries = [RedditEntry]()
    private let imageDownloader = RedditImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configrueTableView()
        
        RedditEntriesFetcher.fetchInitialEntries(10) { [unowned self] (error, entries) in
            guard error == nil else {
                // TODO: Show error alert
                return
            }
            
            guard let entries = entries else {
                return
            }
            
            self.entries += entries
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Helpers
    func configrueTableView() {
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
}

extension EntriesListViewController: UITableViewDataSource {
    private func configure(_ cell: RedditEntryTableViewCell, indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        cell.delegate = self
        
        // image
        imageDownloader.setImage(toImageView:cell.thumbnailImageView,
                                 withURL: entry.thumbnailURL,
                                 placeholder: UIImage(named: "placeholder"))
        
        // text labels
        cell.titleLabel.text = entry.title
        cell.timeLabel.text = "submitted \(Date.numberOfHoursUntilNow(timeStamp: entry.created)) hours ago"
        cell.authorLabel.text = entry.author
        cell.commentsLabel.text = "\(entry.numberOfComments) comments"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RedditEntryTableViewCell.cellIdentifier,
                                                       for: indexPath) as? RedditEntryTableViewCell else {
            return UITableViewCell()
        }
        
        configure(cell, indexPath: indexPath)
        return cell
    }
}

extension EntriesListViewController: RedditEntryTableViewCellDelegate {
    func didTapOnThumbnailImage(cell: RedditEntryTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let entry = entries[indexPath.row]
        
        let fullImageControllerIdentifier = String(describing: FullEntryImageViewController.self)
        let fullImageController = storyboard?.instantiateViewController(withIdentifier: fullImageControllerIdentifier) as? FullEntryImageViewController
        fullImageController?.imageURL = entry.fullImageURL
        
        if let controller = fullImageController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

