//
//  LocationCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photo: Photo?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - Setup
    
    func setup(photo: Photo) {
        
        // Remove delegate from last Photo Object
        self.photo?.delegate = nil
        
        // Set the new Photo Object
        self.photo = photo
        self.photo?.delegate = self
        
        DispatchQueue.main.async {
            if photo.isDownloading || photo.image == nil {
                
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                    self.photoImageView.image = nil
                }
                
                photo.downloadPhoto()
                
            } else {
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    guard let image = photo.downloadedImage else {
                        self.photoImageView.image = UIImage(data: photo.image as! Data)
                        return
                    }
                    
                    self.photoImageView.image = image
                }
            }
        }
    }
}

// MARK: PhotoDelegate
extension PhotoAlbumCollectionViewCell: PhotoDelegate {
    func didFinishDownloadPhoto(photo: Photo) {
        setup(photo: photo)
    }
}
