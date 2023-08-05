//
//  DirectEdge.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 06.08.2023.
//

import Foundation

class DirectedEdge<Element: Equatable> {
    var source: Vertex<Element>
    var destination: Vertex<Element>
    var weight: Double
    
    init(source: Vertex<Element>, destination: Vertex<Element>, weight: Double) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

extension DirectedEdge: Equatable {
    static func ==(lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == rhs.weight
    }
}

extension DirectedEdge: CustomStringConvertible {
    var description: String {
        return "\n[Edge] [Destination]: \(destination.value) - [Weight]: \(weight)"
    }
}
