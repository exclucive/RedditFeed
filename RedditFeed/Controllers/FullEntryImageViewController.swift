//
//  FullEntryImageViewController.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-30.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class FullEntryImageViewController: UIViewController {
    var imageURL: URL?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    private let imageDownloader = RedditImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        setupImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Private
    func setupImage() {
        imageDownloader.setImage(toImageView: imageView, withURL: imageURL, placeholder: UIImage(named: "placeholder")) {[unowned self] (success) in
            self.saveButton.isEnabled = true
        }
    }
    
    // MARK: Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        
    }
}
