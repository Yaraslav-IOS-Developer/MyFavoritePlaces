//
//  MapManager.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 24.03.2021.
//

import Foundation
import UIKit
import MapKit


class MapManager {
    
    
    // MARK: - Property 
    let locationManager = CLLocationManager()
    private let regionInMeters = 500.00
    private var  directionArray: [MKDirections] = []
    private var placeCoordinate: CLLocationCoordinate2D?
    
    
    
    // MARK: - Methods
    func setupPlacemark(place: Place, mapView: MKMapView) {
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // Проверка доступности сервисов геолокации
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location Services are Disabled", message: "To enable it go: Setting -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    // Проверка авторизации приложения для использования сервисов гелокации
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" { showUserLoaction(mapView: mapView) }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your Location is not Availeble",
                    message: "To give permission Go to: Setting -> MyFavoritePlaces -> Location"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
            
        @unknown default:
            break
        }
    }
    
    // Фокус карты на мемтоположение пользователя
    func showUserLoaction(mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    // Строим маршрут от местоположения пользователя до заведения
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let requst = createDirectionsRequst(from: location) else {
            
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let direction = MKDirections(request: requst)
        resetMapView(withNew: direction, mapView: mapView)
        
        direction.calculate { [unowned self](response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return
            }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format:  "%.1f", route.distance / 1000)
                _ = route.expectedTravelTime
                
                print("\(distance) km ")
            }
        }
    }
    
    // Настройка запроса для расчета маршрута
    func createDirectionsRequst(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // Меняем отображаемую зону области карты в соответствии с перемещением пользователя
    func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
        guard let location = location else { return }
        let center = getCentrLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return }
        
        
        closure(center)
    }
    
    // Сброс всех ранее построенных марщрутов перед поcтроением нового
    func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionArray.append(directions)
        
        let _ = directionArray.map { $0.cancel() }
        directionArray.removeAll()
    }
    
    // Определение центра отоброжения области карты
    func getCentrLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        let alertWimdow = UIWindow(frame: UIScreen.main.bounds)
        alertWimdow.rootViewController = UIViewController()
        alertWimdow.windowLevel = UIWindow.Level.alert + 1
        alertWimdow.makeKeyAndVisible()
        alertWimdow.rootViewController?.present(alert, animated: true)
    }
}


