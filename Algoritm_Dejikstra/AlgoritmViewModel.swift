//
//  AlgoritmViewModel.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 16.07.2023.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class AlgoritmViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var mapLocation : CLLocationCoordinate2D {
        didSet{
            updateLocation(location: mapLocation)
        }
    }
    @Published var mapRegion = MKCoordinateRegion()
    
    // Список точек, которые должны появляться на карте
    @Published var routePoints: [RoutePoint] = []
    // Список точек, которые передаются на карту
    @Published var zakazGeo: [RoutePoint] = []
    
    // Список кэшированных маршрутов, для разгрузки приложения
    private var routeCache = [String: MKRoute]()

    override init() {
        mapLocation = CLLocationCoordinate2D(
            latitude: 37.331516,
            longitude: -121.891054
        )
        
        routePoints = [
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.714159, longitude: 55.112155), name: "Оренбург, Центральная улица, 11"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.777194, longitude: 55.221507), name: "Оренбург, посёлок Ростоши, Школьный переулок, 1"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7672000, longitude: 55.0940404), name: "SHUTTLE"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7719819, longitude: 55.1029237), name: "4 Городская больница"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7767340, longitude: 55.0849285), name: "Степная 21"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.8180255, longitude: 55.1355361), name: "Проспект Победы 157/3"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.8188918, longitude: 55.1440318), name: "Красное & Белое"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.8226699, longitude: 55.1673459), name: "Салмышская улица 43/1"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7870687, longitude: 55.1477990), name: "Ижевский переулок 62"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7844386, longitude: 55.1533055), name: "Нико банк"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7773641, longitude: 55.1562622), name: "Омская улица 16"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7857304, longitude: 55.1652328), name: "Карагандинская улица 110"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7652415, longitude: 55.1236817), name: "ОКСЭИ Оренбургский Колледж Экономики и Информатики"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7606353, longitude: 55.1085162), name: "Miss Wedding"),
            RoutePoint(coordinate: CLLocationCoordinate2D(latitude: 51.7672000, longitude: 55.0940404), name: "Яицкая улица 42"),
        ]
        super.init()
        
        locationManager.delegate = self
        updateLocation(location: mapLocation)
    }

    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapLocation = location.coordinate
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                self.userLocation = location.coordinate
            }
        }
        
    }
    
    func addRoute(from pointStart: RoutePoint, to point: RoutePoint, on mapView: MKMapView) {
        let startPoint = MKPlacemark(coordinate: pointStart.coordinate)
        
        // Святая корова
        let endPoint = MKPlacemark(coordinate: point.coordinate)
        
        let key = "\(userLocation.latitude),\(userLocation.longitude)-\(point.coordinate.latitude),\(point.coordinate.longitude)"
        
        if let route = routeCache[key] {
            mapView.addOverlay(route.polyline)
        } else {
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startPoint)
            request.destination = MKMapItem(placemark: endPoint)
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else {
                    if let error = error {
                        print("Error calculating directions: \(error.localizedDescription)")
                    }
                    return
                }
                
                mapView.addOverlay(route.polyline)
                self.routeCache[key] = route
            }
        }
    }

    // Функция для поиска короткого маршрута от точки до точки
    func findShortRoute ( points: [RoutePoint] , to point: RoutePoint, on mapView: MKMapView) {
        var routesCache = [RoutePoint : Double]()

        var pointsO = points
        pointsO.insert(RoutePoint(coordinate: userLocation, name: "Ваше местоположение"), at: 0)
        pointsO.removeAll{ $0 == point }
        
        // Итерируемся по всем точкам и вычисляем расстояние до нужной точки
        for p in pointsO {
            let loc1 = CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
            
            let distance = loc1.distance(from: CLLocation(latitude: p.coordinate.latitude, longitude: p.coordinate.longitude))
            routesCache[p] = distance
        }
        
        if !routesCache.isEmpty, let indexShortRoute = routesCache.keys.sorted(by: { routesCache[$0]! < routesCache[$1]! }).firstIndex(of: routesCache.keys.min()!){
            
            for i in 0..<pointsO.count {
                print(pointsO[i])
                
            }
            print("")
            print("Близкая точка: \(pointsO[indexShortRoute])")
            print("Точка назначения: \(point)")
            print("")
            print("--------------------------")
            print("")
            addRoute(from: pointsO[indexShortRoute], to: point, on: mapView)
            

        }
        
//        var minDistance = Double.infinity
//        var minPoint: RoutePoint?
//
//        for (currentPoint, currentDistance) in routesCache {
//            if currentDistance < minDistance {
//                minDistance = currentDistance
//                minPoint = currentPoint
//            }
//        }


    }
    
    // Обновление карты при изменении геолокации и другой хрени
    func updateLocation(location: CLLocationCoordinate2D) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: mapLocation,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.1,
                    longitudeDelta: 0.1
                )
            )
        }
    }

    
    // Функция проверки включения доступа определения местоположения
    func checkIFLocationServicesIsEnabled () {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                updateLocation(location: locationManager.location?.coordinate ?? CLLocationCoordinate2D(
                    latitude: 59.7677,
                    longitude: 59.0978)
                )
                
            case .restricted:
                print("Доступ к вашему местоположению был ограничен, возможно родительским контролем")
            case .denied:
                print("Доступ к вашему местоположению был отклонён")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
        }
    }
}
