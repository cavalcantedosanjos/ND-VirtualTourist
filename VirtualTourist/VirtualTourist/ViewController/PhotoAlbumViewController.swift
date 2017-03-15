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
    
    fileprivate let photoCellIdentifier = "photoCell"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentPage = 1
    private var numberOfPages = 0
    private var maxPhotosPerPage = 20
    
    var pointPin = PinPointAnnotation()
    var photoList = [Photo]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView flow layout for 3 cells in each row
        setupCollectionView()
        
        // Setup Map Properties
        setupMap()
        
        // Start download photos
        if pointPin.pin!.photo?.count == 0 {
            getPhotos()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            photoList = Array(pointPin.pin!.photo!) as! [Photo]
            collectionView.reloadData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func btnNewCollection_Clicked(_ sender: UIButton) {
        for photo in photoList {
            pointPin.pin!.removeFromPhoto(photo)
        }
        
        photoList.removeAll()
        collectionView.reloadData()
        getPhotos()
        
    }
    
    // MARK: - Services
    
    func getPhotos() {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        let pin = pointPin.pin!
        
        FlickrService.sharedInstance().getPhotosByLocation(latitude: pin.latitude, longitude: pin.longitude) { (data, reponse, error) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            
            guard error == nil, let data = data, let responsePayload = self.deserialize(data: data) else {
                self.displayGenericAlert()
                return
            }
            
            DispatchQueue.main.async {
                
                self.getPhotosId(dict: responsePayload)
                
                if self.photoList.count == 0 {
                    self.collectionView.isHidden = true
                } else {
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Misc
    
    func displayGenericAlert() {
        
        let alert: UIAlertController = UIAlertController(title: "Error", message: "Something wrong happens... try again in a few seconds", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.navigationController!.popViewController(animated: true)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupMap() {
        
        // Add pin to map
        mapView.addAnnotation(pointPin)
        
        // Set map zoom region
        let center = CLLocationCoordinate2D(latitude: pointPin.coordinate.latitude, longitude: pointPin.coordinate.longitude)
        let span = MKCoordinateSpanMake(1, 1)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }	
    
    func setupCollectionView() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func getPhotosId(dict: [String: Any]) {
        
        guard (dict["stat"] as? String) == "ok", let photos = dict["photos"] as? [String: Any] else {
            self.displayGenericAlert()
            return
        }
        
        currentPage = photos["page"] as! Int
        numberOfPages = photos["pages"] as! Int
        
        guard let total = photos["total"] as? Int, total > 0 else {
            return
        }
        
        for item in photos["photo"] as! [[String: Any]] {
            
            if self.photoList.count == self.maxPhotosPerPage || self.photoList.count == total {
                break
            }
            
            
            let photo = Photo(context: CoreDataStack.sharedInstance!.context)
            photo.url = item["url_m"] as? String
            photo.pin = self.pointPin.pin!
            
            self.photoList.append(photo)
        }
        
        CoreDataStack.sharedInstance?.save()
        
    }
    
    func deserialize(data: Data) -> [String: Any]? {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonDict as? [String: Any]
        } catch {
            return nil
        }
    }
}

// MARK: - MKMapViewDelegate

extension PhotoAlbumViewController: MKMapViewDelegate {
    // nothing
}

// MARK: - UICollectionViewDataSource

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        
        cell.setup(photo: photoList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete the image?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
            let photo = (collectionView.cellForItem(at: indexPath) as! PhotoAlbumCollectionViewCell).photo!
            self.pointPin.pin!.removeFromPhoto(photo)
            CoreDataStack.sharedInstance?.context.delete(photo)
            self.photoList.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                CoreDataStack.sharedInstance?.save()
            }
            
            self.collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
