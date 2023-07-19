//
//  MapView.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 16.07.2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapViewAlgoritm: UIViewRepresentable {
    @StateObject var vm = AlgoritmViewModel()
    var mapView: MKMapView = MKMapView(frame: .zero)

    var routePoints: [RoutePoint]
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        for point in routePoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = point.coordinate
            annotation.title = point.name
            
            view.addAnnotation(annotation)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            let userPoint = MKPlacemark(coordinate: vm.userLocation)
//            
//            let point = MKPointAnnotation()
//            point.title = vm.routePoints[12].name
//            point.coordinate = vm.routePoints[12].coordinate
//            
//            
//            let locationPoint1 = MKPlacemark(coordinate: vm.routePoints[12].coordinate)
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: userPoint)
//            request.destination = MKMapItem(placemark: locationPoint1)
//            request.transportType = .automobile
//            
//            let directions = MKDirections(request: request)
//            directions.calculate { response, error in
//                guard let route = response else {
//                    if let error = error {
//                        print("Error calculating directions: \(error.localizedDescription)")
//                    }
//                    return
//                }
//                mapView.addAnnotation(point)
//                mapView.addOverlay(route.routes.first!.polyline)
//                mapView.setVisibleMapRect(
//                    route.routes.first!.polyline.boundingMapRect,
//                    edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
//                    animated: true)
//            }
//        }
        
        // Настроить область отображения карты, чтобы вместить все точки маршрута
        if !routePoints.isEmpty {
            let region = regionForAnnotations(annotations: view.annotations)
            view.setRegion(region, animated: true)
        } else {
            let region = MKCoordinateRegion(center: vm.userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
            view.setRegion(region, animated: true)
        }
        
    }
    
    func showRoute(_ route: MKRoute) {
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(route.polyline, level: .aboveRoads)

        var zoomRect = route.polyline.boundingMapRect
        let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        zoomRect = mapView.mapRectThatFits(zoomRect, edgePadding: insets)
        mapView.setVisibleMapRect(zoomRect, animated: true)
    }

    func calculateShortRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completion: @escaping ([MKRoute]) -> Void) {
        var routes = [MKRoute]()

        // Экземпляр MKDirectionsRequest с начальной и конечной точками
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))

        // Создайте экземпляр MKDirections с использованием запроса
        let directions = MKDirections(request: request)

        // Вызовите метод calculate для расчета маршрута
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error)")
                }
                completion([])
                return
            }

            // Добавьте маршрут в массив маршрутов
            let route = response.routes[0]
            routes.append(route)
            completion(routes)
        }
    }
    
    // Функция для вычисления области отображения карты, чтобы вместить все маркеры
    private func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region = MKCoordinateRegion()
        guard let firstAnnotation = annotations.first else {
            return region
        }
        var minLat = firstAnnotation.coordinate.latitude
        var minLon = firstAnnotation.coordinate.longitude
        var maxLat = firstAnnotation.coordinate.latitude
        var maxLon = firstAnnotation.coordinate.longitude
        
        for annotation in annotations {
            minLat = min(minLat, annotation.coordinate.latitude)
            minLon = min(minLon, annotation.coordinate.longitude)
            maxLat = max(maxLat, annotation.coordinate.latitude)
            maxLon = max(maxLon, annotation.coordinate.longitude)
        }
        
        region.center.latitude = (minLat + maxLat) / 2
        region.center.longitude = (minLon + maxLon) / 2
        region.span.latitudeDelta = (maxLat - minLat) * 1.1
        region.span.longitudeDelta = (maxLon - minLon) * 1.1
        
        return region
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 3
            return renderer
        }
    }
    
}

struct MapView: View {
    @StateObject var vm = AlgoritmViewModel()
    
    @State var button: Bool = false
    
    var locationManager = CLLocationManager()

    var body: some View {
        
        ZStack{
//            Map(coordinateRegion: $vm.mapRegion, showsUserLocation: true)
            MapViewAlgoritm( routePoints: [] )
                .ignoresSafeArea(.all)
                .onAppear {
                    vm.checkIFLocationServicesIsEnabled()
                }
            
            Button(action: {
                withAnimation {
                    button.toggle()
                }
            }, label: {
                Text("Button")
            })
            NewZakaz(button: $button)
                .padding(.top, UIScreen.main.bounds.height * 0.6)
                .offset(y: button ? 0 : UIScreen.main.bounds.height)
            
        }
    }
    
    
}

#Preview {
    MapView()
}


