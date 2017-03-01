//
//  LocationViewController.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var photoAlbumColletionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Helpers
    func setup() {
        let space:CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}

// MARK: - MKMapViewDelegate
extension PhotoAlbumViewController: MKMapViewDelegate {
    
}

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PhotoAlbumViewCollectionViewCell
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

}
