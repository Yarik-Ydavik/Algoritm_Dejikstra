//
//  RoutePoint.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 17.07.2023.
//

import Foundation
import MapKit

struct RoutePoint: Hashable, Comparable {
    let coordinate: CLLocationCoordinate2D
    let name: String
    
    static func == (lhs: RoutePoint, rhs: RoutePoint) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    static func < (lhs: RoutePoint, rhs: RoutePoint) -> Bool {
        if lhs.coordinate.latitude == rhs.coordinate.latitude {
            return lhs.coordinate.longitude < rhs.coordinate.longitude
        }
        return lhs.coordinate.latitude < rhs.coordinate.latitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}

