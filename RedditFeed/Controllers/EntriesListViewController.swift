//
//  ViewController.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-28.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class EntriesListViewController: UIViewController {
    private let kTableViewRestorationContentKey = "kTableViewRestodationContentKey"
    private let kEstimatedRowHeight: CGFloat = 85.0
    private let kMaxCapacity: Int = 50
    private let kPageSize: Int = 5
    
    @IBOutlet weak var tableView: UITableView!
    
    private var entries = [RedditEntry]()
    private var isLoadingInProgress = false
    private var isControllerRestored = false
    private let imageDownloader = RedditImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configrueTableView()
        loadInitialEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Helpers
    private func loadInitialEntries() {
        let initialBunchSize = 10
        loadNewBunchOfEntries(count: initialBunchSize)
    }
    
    private func showActivityIndicator(_ show: Bool) {
        if show {
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
            let refreshBarButton = UIBarButtonItem(customView: activityIndicator)
            navigationItem.rightBarButtonItem = refreshBarButton
            activityIndicator.startAnimating()        
        }
        else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func loadNewBunchOfEntries(count: Int) {
        if entries.count < kMaxCapacity {
            let lastEntryName = entries.last?.name
            isLoadingInProgress = true
            showActivityIndicator(true)
            RedditEntriesFetcher.fetchEntries(entries.count, limit: count, after: lastEntryName, completionHandler: { [unowned self] (error, newEntries) in
                self.isLoadingInProgress = false
                self.showActivityIndicator(false)
                
                guard error == nil else {
                    let errorAlertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    self.present(errorAlertController, animated: true, completion: nil)

                    return
                }
                
                guard let newEntries = newEntries else {
                    return
                }
                
                if self.isControllerRestored == false {
                    self.entries += newEntries
                    self.tableView.reloadData()
                }
                self.isControllerRestored = false
            })
        }
    }
    
    private func configrueTableView() {
        tableView.estimatedRowHeight = kEstimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: preservation/restoration
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(entries, forKey: kTableViewRestorationContentKey)
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let restoredEntries = coder.decodeObject(forKey: kTableViewRestorationContentKey) as? [RedditEntry] {
            self.entries = restoredEntries
            tableView.reloadData()
            isControllerRestored = true
        }
        
        super.decodeRestorableState(with: coder)
    }
}

extension EntriesListViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

extension EntriesListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // indentify when user has reached the bottom of the list
        if isLoadingInProgress == false && 
            scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height - kEstimatedRowHeight {
            loadNewBunchOfEntries(count: kPageSize)
        }
    }
}

