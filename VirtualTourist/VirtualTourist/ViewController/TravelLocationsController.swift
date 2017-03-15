//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class TravelLocationsController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    let kSelectedPinSegue = "selectedPinSegue"
    
    var pins = [Pin]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureInMapView()
        loadLocations()
        loadLastRegion()
        
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
        if segue.identifier == kSelectedPinSegue {
            let vc = segue.destination as! PhotoAlbumViewController
            vc.pointPin = sender as! PinPointAnnotation
        }
    }
    
    // MARK: - Helpers
    func addGestureInMapView() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = PinPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        mapView.addAnnotation(annotation)
        
        let pin = Pin(context: CoreDataStack.sharedInstance!.context)
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude
        
        annotation.pin = pin
        
        DispatchQueue.main.async {
            CoreDataStack.sharedInstance?.save()
        }
    }
    
    func loadLocations() {
        var annotations = [MKAnnotation]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let results = try CoreDataStack.sharedInstance?.context.fetch(fetchRequest)
            pins.append(contentsOf: (results as! [Pin]))
        } catch {
            return
        }
        
        for pin in pins {
            let annotation = PinPointAnnotation()
            annotation.pin = pin
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude),longitude: CLLocationDegrees(pin.longitude))
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)

        
    }
    
    func loadLastRegion() {
        
        if Map.latitude == 0 && Map.longitude == 0 && Map.latitudeDelta == 0 && Map.longitudeDelta == 0 {
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: Map.latitude, longitude: Map.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Map.latitudeDelta, longitudeDelta: Map.longitudeDelta)
        
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }
    
    
}

// MARK: - MKMapViewDelegate
extension TravelLocationsController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        Map.latitude = mapView.region.center.latitude
        Map.longitude = mapView.region.center.longitude
        Map.latitudeDelta = mapView.region.span.latitudeDelta
        Map.longitudeDelta = mapView.region.span.longitudeDelta
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard mapView.selectedAnnotations.count > 0, let pin = mapView.selectedAnnotations[0] as? PinPointAnnotation else {
            return
        }
        
        // Only one pin can be selected at time
        mapView.selectedAnnotations.removeAll()
        
        performSegue(withIdentifier: kSelectedPinSegue, sender: pin)
    }

}
