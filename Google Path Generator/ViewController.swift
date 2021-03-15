//
//  ViewController.swift
//  Google Path Generator
//
//  Created by Kevin Rojas on 20/01/20.
//  Copyright © 2020 Kevin Rojas. All rights reserved.
//

import UIKit
import GoogleMaps

struct Point {
    let lat: Double
    let lng: Double
}

class ViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet var mapView: GMSMapView!
    
    let key = "<google map key>"
    var baseURL = "https://maps.googleapis.com/maps/api/directions/json?origin="

    /*
     blueRouteMorning devuelve un arreglo con todas las ubicaciones (latitud longitud) en orden de como la
     entregan luego lo paso para la linea 188. Se esta usando yellowRouteAfternoon para imprimir el Path
     */
    var blueRouteMorning: [Point] {
        let geoPoint1 = Point(lat: 6.15228, lng: -75.6234)
        let geoPoint2 = Point(lat: 6.16009, lng: -75.60559)
        let geoPoint3 = Point(lat: 6.16859, lng: -75.58883)
        let geoPoint4 = Point(lat: 6.1653, lng: -75.57575)
        let geoPoint5 = Point(lat: 6.16734, lng: -75.56909)
        let geoPoint6 = Point(lat: 6.17607, lng: -75.56723)
        let geoPoint7 = Point(lat: 6.18115, lng: -75.56582)
        let geoPoint8 = Point(lat: 6.19167, lng: -75.56009)
        let geoPoint9 = Point(lat: 6.19832, lng: -75.55643)
        let geoPoint10 = Point(lat: 6.21928, lng: -75.55942)
        
        return [geoPoint1, geoPoint2, geoPoint3, geoPoint4, geoPoint5, geoPoint6, geoPoint7, geoPoint8, geoPoint9, geoPoint10]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        googlePointGenerator()
    }
    
    func googleURLPointGenerator(routes: [Point]) -> String {
        
        mapView.clear()
        
        for geoMarker in routes {
            let position = CLLocationCoordinate2D(latitude: geoMarker.lat, longitude: geoMarker.lng)
            let marker = GMSMarker(position: position)
            marker.title = "lat \(geoMarker.lat) lng \(geoMarker.lng)"
            marker.map = mapView
        }
        
        let index = routes.count - 1
        
        let originBound = CLLocationCoordinate2D(latitude: routes[0].lat, longitude: routes[0].lng)
        let destiantionBound = CLLocationCoordinate2D(latitude: routes[index].lat, longitude: routes[index].lng)
        let bounds = GMSCoordinateBounds(coordinate: originBound, coordinate: destiantionBound)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.mapView.animate(with: update)
        })
        
        var points = routes
        var waypoint = String()
        let routesLength = points.count - 1
        let origin = routes[0]
        let destination = points[routesLength]
        
        let url = baseURL + "\(origin.lat),\(origin.lng)&destination=\(destination.lat),\(destination.lng)&waypoints="
        
        points.removeFirst()
        points.removeLast()
        
        for point in points {
            waypoint += "\(point.lat),\(point.lng)|"
        }
        
        waypoint.removeLast()
        
        let urlCompleted = url + waypoint + "&key=\(key)"
        
        return urlCompleted
    }

    func googlePointGenerator() {
        let url = googleURLPointGenerator(routes: yellowRouteAfternoon) //resive el arreglo de las locations
        
        GoogleMapsApiServices().getGooglePoints(URL: url) { (result) in
            self.addPolyLine(encodedString: result)
        }
    }
    
    func addPolyLine(encodedString: String) {
        let addressPathPolyline = GMSPolyline()
        addressPathPolyline.path = GMSMutablePath(fromEncodedPath: encodedString)
        addressPathPolyline.strokeWidth = 4
        addressPathPolyline.strokeColor = UIColor.red
        addressPathPolyline.map = mapView
        
        print("XXXXXX Path generated copy and sent to admin --------")
        print(encodedString)
        print("--------")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
    }
}
