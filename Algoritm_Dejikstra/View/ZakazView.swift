//
//  ZakazView.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 16.07.2023.
//

import SwiftUI

struct NewZakaz: View {
    @Binding var button: Bool
    @EnvironmentObject private var vm: AlgoritmViewModel
    
    func performBellmanFord() {
        let point = Vertex("Ваше местоположение")
        let bellmanFord = BellmanFordShortestPath(vm.graph, source: point)
        
        print(vm.graph.vertices.count)
        
        print("Has negative cycle: \(bellmanFord.hasNegativeCycle)")
        print("Negative cycle: \(String(describing: bellmanFord.negativeCycle))")
    }

    
    var body: some View {
        ZStack () {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .ignoresSafeArea(.all)
            
            HStack ( ) {
                
                
                Button("Принять заказ") {
                    withAnimation {
                        guard let element: RoutePoint = vm.routePoints.randomElement() else {
                            return
                        }
                        vm.routePoints.remove(at: vm.routePoints.firstIndex(where: { $0.coordinate.latitude == element.coordinate.latitude })!)
                        vm.zakazGeo.append(element)
                        performBellmanFord()
                        button.toggle()
                        

                    }
                }
                .foregroundStyle(.white)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                withAnimation {
                    button.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .padding(20)
            })
        })
    }
}


#Preview {
    NewZakaz(button: .constant(false))
    
}
