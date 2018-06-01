//
//  FullEntryImageViewController.swift
//  RedditFeed
//
//  Created by Igor Novik on 2018-05-30.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class FullEntryImageViewController: UIViewController {
    private let kRestorationImageKey = "restorationImageKey"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageURL: URL?
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
        if let url = imageURL, url.absoluteString.isImageType()  {
            activityIndicator.startAnimating()
            imageDownloader.setImage(toImageView: imageView,
                                     withURL: imageURL,
                                     placeholder: UIImage(named: "placeholder")) {[unowned self] (success) in
                                        self.activityIndicator.stopAnimating()
                                        self.saveButton.isEnabled = success
            }
        }
        else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        if let image = imageView.image {
            activityIndicator.startAnimating()
            saveButton.isEnabled = false
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        activityIndicator.stopAnimating()
        saveButton.isEnabled = true
        
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    // MARK: preservation/restoration
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(imageView.image, forKey: kRestorationImageKey)
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let image = coder.decodeObject(forKey: kRestorationImageKey) as? UIImage {
            imageView.image = image
            saveButton.isEnabled = false
        }
        
        super.decodeRestorableState(with: coder)
    }
}
