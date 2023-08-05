//
//  Vertex.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 06.08.2023.
//

import Foundation

class Vertex<Element: Equatable> {
    var value: Element
    private(set) var adjacentEdges: [DirectedEdge<Element>] = []
    
    init(_ value: Element) {
        self.value = value
    }
    
    func addEdge(_ edge: DirectedEdge<Element>) {
        self.adjacentEdges.append(edge)
    }
    
    func edgeForDestination(_ destination: Vertex<Element>) -> DirectedEdge<Element>? {
        return adjacentEdges.filter { $0.destination == destination }.first
    }
}

extension Vertex: Equatable {
    static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "\n[Vertex]: \(value) | [Adjacent Edges]: [\(adjacentEdges)]"
    }
}
