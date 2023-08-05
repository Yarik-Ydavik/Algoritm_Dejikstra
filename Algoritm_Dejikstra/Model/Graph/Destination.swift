//
//  Destination.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 06.08.2023.
//

import Foundation

class Destination<Element: Equatable> {
    let vertex: Vertex<Element>
    var previousVertex: Vertex<Element>?
    var totalWeight: Double = Double.greatestFiniteMagnitude
    var isReachable: Bool {
        return totalWeight < Double.greatestFiniteMagnitude
    }
    
    init(_ vertex: Vertex<Element>) {
        self.vertex = vertex
    }
}
