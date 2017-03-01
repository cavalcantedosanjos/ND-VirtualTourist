//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    let kSelectedPinSegue = "selectedPinSegue"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestureInMapView()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Helpers
    func addGestureInMapView() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotations(gestureRecognizer:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    func addAnnotations(gestureRecognizer:UIGestureRecognizer) {
        
        if(gestureRecognizer.state == .began)
        {

            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let newCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = newCoordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
}

// MARK: - MKMapViewDelegate
extension TravelLocationsController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.performSegue(withIdentifier: kSelectedPinSegue, sender: nil)
    }
}
