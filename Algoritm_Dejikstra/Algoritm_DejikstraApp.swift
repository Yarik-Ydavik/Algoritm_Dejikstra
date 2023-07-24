//
//  Algoritm_DejikstraApp.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 16.07.2023.
//

import SwiftUI

@main
struct Algoritm_DejikstraApp: App {
    @StateObject private var vm = AlgoritmViewModel()
    
    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(vm)
        }
    }
}
