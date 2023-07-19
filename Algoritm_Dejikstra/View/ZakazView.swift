//
//  ZakazView.swift
//  Algoritm_Dejikstra
//
//  Created by Yaroslav Zagumennikov on 16.07.2023.
//

import SwiftUI

struct NewZakaz: View {
    @Binding var button: Bool
    
    var body: some View {
        ZStack () {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .ignoresSafeArea(.all)
            
            HStack ( ) {
                Button("Принять заказ") {
                    withAnimation {
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
