//
//  LocationViewController.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 20.02.2022.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tatlı su kaynağı mı keşfettin? Göl, ırmak, akarsu... Konumunu içeren linki arkadaşlarınla paylaşmak istersen paylaş butonuna dokun"
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let locationManager = CLLocationManager()
    
    var lat: Double?
    var lon: Double?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "DarkModeColor")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Paylaş", style: .done, target: self,
                                                            action: #selector(shareLocationTapped))

        view.addSubview(descriptionLabel)
        view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        //mapView.frame = view.bounds
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
    }
    
    //present activityViewController to share url
    //we can paste url to browser and see location on the map
    @objc private func shareLocationTapped() {
        guard let latitude = lat, let longitude = lon else {
            return
        }
        
        let URLString = "https://maps.apple.com?ll=\(latitude),\(longitude)"
        
        guard let url = URL(string: URLString) else {return}
        
        let actionSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(actionSheetVC, animated: true)
    }
    
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            //get values to share
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            
            //render on the map
            render(location)
        }
    }
    
    
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) //zoom level
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
}
