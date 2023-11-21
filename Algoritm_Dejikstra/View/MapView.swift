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
            vm.findShortRoute( points: routePoints, to: point, on: view )
            
        }
        
        // Настроить область отображения карты, чтобы вместить все точки маршрута
        if !routePoints.isEmpty {
            let region = regionForAnnotations(annotations: view.annotations)
            view.setRegion(region, animated: true)
        } else {
            let region = MKCoordinateRegion(center: vm.userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
            view.setRegion(region, animated: true)
        }
        
    }
    
    // Функция для вычисления области отображения карты, чтобы вместить все заказы
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
    @EnvironmentObject private var vm: AlgoritmViewModel
    
    @State var button: Bool = false
    let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack{
//            Map(coordinateRegion: $vm.mapRegion, showsUserLocation: true)
            MapViewAlgoritm( routePoints: vm.zakazGeo )
                .ignoresSafeArea(.all)
                .onAppear {
                    vm.checkIFLocationServicesIsEnabled()
                }
            
            NewZakaz(button: $button)
                .padding(.top, UIScreen.main.bounds.height * 0.6)
                .offset(y: button ? 0 : UIScreen.main.bounds.height)
            
        }
        .onReceive(timer) { _ in
            withAnimation {
                button = true
            }
        }
    }
    
    
}

#Preview {
    MapView()
}


