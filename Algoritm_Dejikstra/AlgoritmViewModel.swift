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
