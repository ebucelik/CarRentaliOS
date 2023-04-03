//
//  GoogleMapsViewController.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 03.04.23.
//

import UIKit
import GoogleMaps
import GoogleMapsBase

class GoogleMapsViewController: UIViewController {

    let camera: GMSCameraPosition
    var mapView: GMSMapView
    let latitude = 48.158031
    let longitude = 16.382370

    init() {
        self.camera = GMSCameraPosition(
            latitude: latitude,
            longitude: longitude,
            zoom: 15.0
        )
        self.mapView = GMSMapView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubView()
    }

    private func addSubView() {
        mapView = GMSMapView(
            frame: view.frame,
            camera: camera
        )

        view.addSubview(mapView)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        marker.title = "FH Campus"
        marker.snippet = "Vienna, Austria"
        marker.map = mapView
    }
}
