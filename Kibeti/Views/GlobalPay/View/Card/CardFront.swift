//
//  CardFront.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct CardFront: View {
    @ObservedObject var globalVM: GlobalVM
    @Binding var degree: Double
    var width: CGFloat = 350
    var height: CGFloat = 220
    
    var body: some View {
        if globalVM.imageOrColor {
            // MARK: COLOR
            VStack(alignment: .leading, spacing: 20) {
                Text("Kibeti")
                    .font(.title2.bold())
                    .foregroundStyle(.kibetiGreen)
                    
                HStack(alignment: .center, spacing: 20) {
                    Text("1234")
                    Text("****")
                    Text("****")
                    Text("****")
                }
                    .foregroundStyle(.white)
                
                Image("visa")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .offset(y: 42)
            }
            .padding(.horizontal)
            .frame(width: width, height: height)
            .background( Color(globalVM.backgroundColor.isEmpty ? globalVM.starterColor : globalVM.backgroundColor) )
            .cornerRadius(10)
            .rotation3DEffect(
                Angle(
                    degrees: degree
                ),
                axis: (
                    x: 0.0,
                    y: 1.0,
                    z: 0.0
                )
            )
            
        } else {
            // MARK: IMAGE
            VStack(alignment: .leading, spacing: 20) {
                Text("Kibeti")
                    .font(.title3)
                    .foregroundStyle(.kibetiGreen)
                    .padding(.top, 4)
                
                HStack(alignment: .center, spacing: 20) {
                    Text("1234")
                    Text("****")
                    Text("****")
                    Text("****")
                }
                    .foregroundStyle(.white)
                Image("visa")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .offset(y: 42)
            }
            .padding(.horizontal)
            .frame(width: width, height: height)
            .background(
                Image(globalVM.backgroundSelected.isEmpty ? globalVM.starterBackground : globalVM.backgroundSelected)
                    .resizable()
            )
            .cornerRadius(10)
            .rotation3DEffect(
                Angle(
                    degrees: degree
                ),
                axis: (
                    x: 0.0,
                    y: 1.0,
                    z: 0.0
                )
            )
        }
    }
}

#Preview {
    CardFront(globalVM: GlobalVM(), degree: .constant(0.0))
}
